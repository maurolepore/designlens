"""Unit tests for lib/tools/designlens_get_session_stats.py."""

import json
import os
import sys

import pytest

# Insert lib/tools into path so the module can be imported directly.
_lib_tools = os.path.join(os.path.dirname(__file__), "..", "lib", "tools")
sys.path.insert(0, os.path.abspath(_lib_tools))

import designlens_get_session_stats as gss  # noqa: E402


# ---------------------------------------------------------------------------
# get_storage_path
# ---------------------------------------------------------------------------

def test_get_storage_path_returns_nonempty_string():
    result = gss.get_storage_path()
    assert isinstance(result, str)
    assert len(result) > 0


# ---------------------------------------------------------------------------
# get_session_id_fallback
# ---------------------------------------------------------------------------

def test_get_session_id_fallback_returns_most_recently_modified(tmp_path):
    msg_dir = tmp_path / "message"
    ses_old = msg_dir / "ses_old"
    ses_old.mkdir(parents=True)
    ses_new = msg_dir / "ses_new"
    ses_new.mkdir()
    # Pin mtimes so the test does not depend on wall-clock ordering.
    os.utime(str(ses_old), (1_000_000, 1_000_000))
    os.utime(str(ses_new), (2_000_000, 2_000_000))
    result = gss.get_session_id_fallback(str(tmp_path))
    assert result == "ses_new"


def test_get_session_id_fallback_raises_when_message_dir_absent(tmp_path):
    with pytest.raises(RuntimeError):
        gss.get_session_id_fallback(str(tmp_path))


def test_get_session_id_fallback_raises_when_no_ses_dirs(tmp_path):
    (tmp_path / "message").mkdir()
    with pytest.raises(RuntimeError):
        gss.get_session_id_fallback(str(tmp_path))


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _write_message(tmp_path, session_id, fname, data):
    d = tmp_path / "message" / session_id
    d.mkdir(parents=True, exist_ok=True)
    (d / fname).write_text(json.dumps(data))


def _write_part(tmp_path, msg_id, fname, data):
    d = tmp_path / "part" / msg_id
    d.mkdir(parents=True, exist_ok=True)
    (d / fname).write_text(json.dumps(data))


# ---------------------------------------------------------------------------
# get_session_stats — token accumulation
# ---------------------------------------------------------------------------

def test_get_session_stats_sums_input_and_output_tokens(tmp_path):
    _write_message(tmp_path, "ses_1", "msg1.json", {"role": "assistant", "tokens": {"input": 100, "output": 50}})
    _write_message(tmp_path, "ses_1", "msg2.json", {"role": "assistant", "tokens": {"input": 200, "output": 80}})
    stats = gss.get_session_stats(str(tmp_path), "ses_1")
    assert stats["input_tokens"] == 300
    assert stats["output_tokens"] == 130


# ---------------------------------------------------------------------------
# get_session_stats — user word count
# ---------------------------------------------------------------------------

def test_get_session_stats_counts_words_from_summary_title(tmp_path):
    _write_message(tmp_path, "ses_1", "msg1.json", {
        "role": "user",
        "summary": {"title": "hello world foo"},
    })
    stats = gss.get_session_stats(str(tmp_path), "ses_1")
    assert stats["user_word_count"] == 3


# ---------------------------------------------------------------------------
# get_session_stats — files_changed
# ---------------------------------------------------------------------------

def test_get_session_stats_reads_files_changed_from_session_summary(tmp_path):
    _write_message(tmp_path, "ses_1", "msg1.json", {"role": "user"})
    sess_dir = tmp_path / "session" / "global"
    sess_dir.mkdir(parents=True)
    (sess_dir / "ses_1.json").write_text(json.dumps({"summary": {"files": 7}}))
    stats = gss.get_session_stats(str(tmp_path), "ses_1")
    assert stats["files_changed"] == 7


# ---------------------------------------------------------------------------
# get_session_stats — lines from part entries
# ---------------------------------------------------------------------------

def test_get_session_stats_accumulates_lines_added_from_write_parts(tmp_path):
    _write_message(tmp_path, "ses_1", "msg1.json", {"role": "assistant"})
    _write_part(tmp_path, "msg1", "part1.json", {
        "tool": "write",
        "state": {"input": {"content": "line1\nline2\nline3"}},
    })
    stats = gss.get_session_stats(str(tmp_path), "ses_1")
    assert stats["lines_added"] == 3


def test_get_session_stats_accumulates_lines_from_edit_parts(tmp_path):
    _write_message(tmp_path, "ses_1", "msg1.json", {"role": "assistant"})
    _write_part(tmp_path, "msg1", "part1.json", {
        "tool": "edit",
        "state": {"input": {"oldString": "old1\nold2", "newString": "new1\nnew2\nnew3"}},
    })
    stats = gss.get_session_stats(str(tmp_path), "ses_1")
    assert stats["lines_added"] == 3
    assert stats["lines_deleted"] == 2


# ---------------------------------------------------------------------------
# get_session_stats — missing dirs / malformed files
# ---------------------------------------------------------------------------

def test_get_session_stats_returns_zeros_when_dirs_absent(tmp_path):
    stats = gss.get_session_stats(str(tmp_path), "ses_nonexistent")
    assert stats["input_tokens"] == 0
    assert stats["output_tokens"] == 0
    assert stats["lines_added"] == 0
    assert stats["lines_deleted"] == 0


def test_get_session_stats_skips_malformed_message_files(tmp_path):
    d = tmp_path / "message" / "ses_1"
    d.mkdir(parents=True)
    (d / "bad.json").write_text("not json {{{")
    stats = gss.get_session_stats(str(tmp_path), "ses_1")
    assert stats["input_tokens"] == 0


def test_get_session_stats_skips_malformed_part_files(tmp_path):
    _write_message(tmp_path, "ses_1", "msg1.json", {"role": "assistant"})
    d = tmp_path / "part" / "msg1"
    d.mkdir(parents=True)
    (d / "bad.json").write_text("not json {{{")
    stats = gss.get_session_stats(str(tmp_path), "ses_1")
    assert stats["lines_added"] == 0
