#!/usr/bin/env bats
# Tests for lib/hooks/session_start.sh

HOOKS_DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")/../lib/hooks" && pwd)"

setup() {
  export NO_COLOR=1
  TEST_DIR="$(mktemp -d)"
  cd "$TEST_DIR"
  HASH="$(echo "$TEST_DIR" | md5sum | cut -c1-8)"
  SESSION_FILE="/tmp/designlens-sess-$HASH.json"
}

teardown() {
  cd /tmp
  rm -rf "$TEST_DIR"
  rm -f "$SESSION_FILE"
}

@test "creates SESSION_FILE" {
  bash "$HOOKS_DIR/session_start.sh" <<< '{"model":"claude-opus","session_id":"sess-abc"}'
  [ -f "$SESSION_FILE" ]
}

@test "stores model value" {
  bash "$HOOKS_DIR/session_start.sh" <<< '{"model":"claude-opus","session_id":"sess-abc"}'
  result=$(jq -r '.model' "$SESSION_FILE")
  [ "$result" = "claude-opus" ]
}

@test "stores session_id value" {
  bash "$HOOKS_DIR/session_start.sh" <<< '{"model":"claude-opus","session_id":"sess-abc"}'
  result=$(jq -r '.session_id' "$SESSION_FILE")
  [ "$result" = "sess-abc" ]
}

@test "sets transcript_offset to 0" {
  bash "$HOOKS_DIR/session_start.sh" <<< '{"model":"claude-opus","session_id":"sess-abc"}'
  result=$(jq -r '.transcript_offset' "$SESSION_FILE")
  [ "$result" = "0" ]
}

@test "exits 0 on empty input" {
  run bash "$HOOKS_DIR/session_start.sh" <<< ''
  [ "$status" -eq 0 ]
}

@test "exits 0 on malformed JSON" {
  run bash "$HOOKS_DIR/session_start.sh" <<< 'not json at all'
  [ "$status" -eq 0 ]
}
