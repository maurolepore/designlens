#!/usr/bin/env bats
# Tests for lib/hooks/designlens_stop.sh

HOOKS_DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")/../lib/hooks" && pwd)"

STOP_PAYLOAD='{"session_id":"sess-abc","transcript_path":""}'

setup() {
  export NO_COLOR=1
  TEST_DIR="$(mktemp -d)"
  cd "$TEST_DIR"
  mkdir -p specs/001-fake
  HASH="$(echo "$TEST_DIR" | md5sum | cut -c1-8)"
  TEMP_FILE="/tmp/designlens-$HASH.json"
  SESSION_FILE="/tmp/designlens-sess-$HASH.json"
  METADATA_FILE="$TEST_DIR/specs/001-fake/.metadata.json"
}

teardown() {
  cd /tmp
  rm -rf "$TEST_DIR"
  rm -f "$TEMP_FILE" "$SESSION_FILE"
}

# Helper: write a session file
write_session_file() {
  local model="$1" sid="$2"
  jq -n --arg m "$model" --arg s "$sid" --argjson o 0 \
    '{model: $m, session_id: $s, transcript_offset: $o}' > "$SESSION_FILE"
}

# Helper: write a temp file with line stats
write_temp_file() {
  local added="$1" deleted="$2"
  jq -n --argjson a "$added" --argjson d "$deleted" --argjson f '[]' \
    '{lines_added: $a, lines_deleted: $d, file_paths: $f}' > "$TEMP_FILE"
}

@test "creates .metadata.json with expected keys" {
  write_session_file "claude-opus" "sess-abc"
  bash "$HOOKS_DIR/designlens_stop.sh" <<< "$STOP_PAYLOAD"
  [ -f "$METADATA_FILE" ]
  for key in agents sessions created last_updated last_session_id; do
    result=$(jq --arg k "$key" 'has($k)' "$METADATA_FILE")
    [ "$result" = "true" ]
  done
}

@test "writes lines_added and lines_deleted from TEMP_FILE" {
  write_session_file "claude-opus" "sess-abc"
  write_temp_file 10 3
  bash "$HOOKS_DIR/designlens_stop.sh" <<< "$STOP_PAYLOAD"
  added=$(jq -r '.lines_added' "$METADATA_FILE")
  deleted=$(jq -r '.lines_deleted' "$METADATA_FILE")
  [ "$added" = "10" ]
  [ "$deleted" = "3" ]
}

@test "sessions increments from 0 to 1 on new session_id" {
  write_session_file "claude-opus" "sess-abc"
  bash "$HOOKS_DIR/designlens_stop.sh" <<< '{"session_id":"sess-abc","transcript_path":""}'
  sessions=$(jq -r '.sessions' "$METADATA_FILE")
  [ "$sessions" = "1" ]
}

@test "sessions does not increment on repeated session_id" {
  write_session_file "claude-opus" "sess-abc"
  bash "$HOOKS_DIR/designlens_stop.sh" <<< '{"session_id":"sess-abc","transcript_path":""}'
  bash "$HOOKS_DIR/designlens_stop.sh" <<< '{"session_id":"sess-abc","transcript_path":""}'
  sessions=$(jq -r '.sessions' "$METADATA_FILE")
  [ "$sessions" = "1" ]
}

@test "null+null yields null for lines_added when no TEMP_FILE" {
  write_session_file "claude-opus" "sess-abc"
  bash "$HOOKS_DIR/designlens_stop.sh" <<< "$STOP_PAYLOAD"
  result=$(jq -r '.lines_added' "$METADATA_FILE")
  [ "$result" = "null" ]
}

@test "null+N yields N when existing metadata has null lines_added" {
  write_session_file "claude-opus" "sess-abc"
  write_temp_file 5 0
  bash "$HOOKS_DIR/designlens_stop.sh" <<< "$STOP_PAYLOAD"
  result=$(jq -r '.lines_added' "$METADATA_FILE")
  [ "$result" = "5" ]
}

@test "N+M yields sum when both existing metadata and TEMP_FILE have values" {
  write_session_file "claude-opus" "sess-abc"
  write_temp_file 3 0
  bash "$HOOKS_DIR/designlens_stop.sh" <<< "$STOP_PAYLOAD"
  write_temp_file 5 0
  bash "$HOOKS_DIR/designlens_stop.sh" <<< '{"session_id":"sess-xyz","transcript_path":""}'
  result=$(jq -r '.lines_added' "$METADATA_FILE")
  [ "$result" = "8" ]
}

@test "agent from SESSION_FILE appears in agents array" {
  write_session_file "claude-opus" "sess-abc"
  bash "$HOOKS_DIR/designlens_stop.sh" <<< "$STOP_PAYLOAD"
  count=$(jq '[.agents[] | select(. == "claude-opus")] | length' "$METADATA_FILE")
  [ "$count" = "1" ]
}

@test "same agent model not duplicated in agents array" {
  write_session_file "claude-opus" "sess-abc"
  bash "$HOOKS_DIR/designlens_stop.sh" <<< "$STOP_PAYLOAD"
  bash "$HOOKS_DIR/designlens_stop.sh" <<< '{"session_id":"sess-xyz","transcript_path":""}'
  count=$(jq '.agents | length' "$METADATA_FILE")
  [ "$count" = "1" ]
}

@test "TEMP_FILE is deleted after successful run" {
  write_session_file "claude-opus" "sess-abc"
  write_temp_file 2 1
  bash "$HOOKS_DIR/designlens_stop.sh" <<< "$STOP_PAYLOAD"
  [ ! -f "$TEMP_FILE" ]
}

@test "exits 0 when no specs/NNN-*/ directory exists" {
  rm -rf specs
  run bash "$HOOKS_DIR/designlens_stop.sh" <<< "$STOP_PAYLOAD"
  [ "$status" -eq 0 ]
}
