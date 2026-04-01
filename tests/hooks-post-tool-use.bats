#!/usr/bin/env bats
# Tests for lib/hooks/post_tool_use.sh

HOOKS_DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")/../lib/hooks" && pwd)"

setup() {
  export NO_COLOR=1
  TEST_DIR="$(mktemp -d)"
  cd "$TEST_DIR"
  HASH="$(echo "$TEST_DIR" | md5sum | cut -c1-8)"
  TEMP_FILE="/tmp/designlens-$HASH.json"
}

teardown() {
  cd /tmp
  rm -rf "$TEST_DIR"
  rm -f "$TEMP_FILE"
}

@test "non-Write/Edit tool produces no temp file" {
  bash "$HOOKS_DIR/post_tool_use.sh" <<< '{"tool_name":"Read","tool_input":{"file_path":"/tmp/foo.txt"}}'
  [ ! -f "$TEMP_FILE" ]
}

@test "Write payload creates temp file with correct lines_added" {
  bash "$HOOKS_DIR/post_tool_use.sh" <<< '{"tool_name":"Write","tool_input":{"file_path":"/tmp/foo.txt","content":"line1\nline2\nline3"}}'
  [ -f "$TEMP_FILE" ]
  result=$(jq -r '.lines_added' "$TEMP_FILE")
  [ "$result" = "3" ]
}

@test "Write payload sets lines_deleted to 0" {
  bash "$HOOKS_DIR/post_tool_use.sh" <<< '{"tool_name":"Write","tool_input":{"file_path":"/tmp/foo.txt","content":"line1\nline2"}}'
  result=$(jq -r '.lines_deleted' "$TEMP_FILE")
  [ "$result" = "0" ]
}

@test "Edit payload creates temp file with correct lines_added and lines_deleted" {
  bash "$HOOKS_DIR/post_tool_use.sh" <<< '{"tool_name":"Edit","tool_input":{"file_path":"/tmp/foo.txt","old_string":"old1\nold2","new_string":"new1\nnew2\nnew3"}}'
  added=$(jq -r '.lines_added' "$TEMP_FILE")
  deleted=$(jq -r '.lines_deleted' "$TEMP_FILE")
  [ "$added" = "3" ]
  [ "$deleted" = "2" ]
}

@test "successive Write calls accumulate lines_added" {
  bash "$HOOKS_DIR/post_tool_use.sh" <<< '{"tool_name":"Write","tool_input":{"file_path":"/tmp/foo.txt","content":"line1\nline2\nline3"}}'
  bash "$HOOKS_DIR/post_tool_use.sh" <<< '{"tool_name":"Write","tool_input":{"file_path":"/tmp/bar.txt","content":"line1\nline2"}}'
  result=$(jq -r '.lines_added' "$TEMP_FILE")
  [ "$result" = "5" ]
}

@test "same file_path appears only once in file_paths array" {
  bash "$HOOKS_DIR/post_tool_use.sh" <<< '{"tool_name":"Write","tool_input":{"file_path":"/tmp/foo.txt","content":"a\nb"}}'
  bash "$HOOKS_DIR/post_tool_use.sh" <<< '{"tool_name":"Write","tool_input":{"file_path":"/tmp/foo.txt","content":"c\nd"}}'
  count=$(jq '.file_paths | length' "$TEMP_FILE")
  [ "$count" = "1" ]
}

@test "different file_paths both appear in file_paths array" {
  bash "$HOOKS_DIR/post_tool_use.sh" <<< '{"tool_name":"Write","tool_input":{"file_path":"/tmp/foo.txt","content":"a"}}'
  bash "$HOOKS_DIR/post_tool_use.sh" <<< '{"tool_name":"Write","tool_input":{"file_path":"/tmp/bar.txt","content":"b"}}'
  count=$(jq '.file_paths | length' "$TEMP_FILE")
  [ "$count" = "2" ]
}

@test "exits 0 on empty input" {
  run bash "$HOOKS_DIR/post_tool_use.sh" <<< ''
  [ "$status" -eq 0 ]
}
