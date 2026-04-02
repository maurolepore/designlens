#!/usr/bin/env bats
# Tests for commits-since-stage.sh

LIB_DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")/../lib" && pwd)"
source "$LIB_DIR/commits-since-stage.sh"

setup() {
  export NO_COLOR=1
  TEST_DIR="$(mktemp -d)"
  cd "$TEST_DIR"
  git init -q
  git config user.email "test@test.com"
  git config user.name "Test"
}

teardown() {
  cd /tmp
  rm -rf "$TEST_DIR"
}

# Helper: make a git commit
make_commit() {
  echo "$1" > "file_$RANDOM.txt"
  git add -A
  git commit -q -m "$1"
}

# Helper: write a stage design-decisions.md with a given git_hash
make_stage_dd() {
  local stage_dir="$1"
  local git_hash="$2"
  mkdir -p "$stage_dir"
  cat > "$stage_dir/design-decisions.md" <<EOF
---
created: 2026-01-01T00:00:00Z
agent: test-agent
git_hash: $git_hash
---
# Design Decisions: test
EOF
}

@test "outputs count=0 and default threshold=10 when no specs directory exists" {
  make_commit "initial"
  run commits_since_stage
  [ "$status" -eq 0 ]
  echo "$output" | grep -q "count=0"
  echo "$output" | grep -q "threshold=10"
}

@test "outputs count=0 when no stage has design-decisions.md" {
  make_commit "initial"
  mkdir -p specs/001-foo
  run commits_since_stage
  [ "$status" -eq 0 ]
  echo "$output" | grep -q "count=0"
}

@test "outputs count=0 when design-decisions.md has no git_hash field" {
  make_commit "initial"
  mkdir -p specs/001-foo
  echo "# Design Decisions" > specs/001-foo/design-decisions.md
  run commits_since_stage
  [ "$status" -eq 0 ]
  echo "$output" | grep -q "count=0"
}

@test "reads threshold from .designlens.json" {
  make_commit "initial"
  echo '{"retrospective_threshold": 5}' > .designlens.json
  run commits_since_stage
  echo "$output" | grep -q "threshold=5"
}

@test "falls back to threshold=10 when .designlens.json missing" {
  make_commit "initial"
  run commits_since_stage
  echo "$output" | grep -q "threshold=10"
}

@test "falls back to threshold=10 when retrospective_threshold absent from config" {
  make_commit "initial"
  echo '{"auto_commit": false}' > .designlens.json
  run commits_since_stage
  echo "$output" | grep -q "threshold=10"
}

@test "counts commits since git_hash correctly" {
  make_commit "baseline"
  local baseline_hash
  baseline_hash=$(git rev-parse HEAD)
  make_stage_dd "specs/001-foo" "$baseline_hash"
  make_commit "after-stage-1"
  make_commit "after-stage-2"
  run commits_since_stage
  echo "$output" | grep -q "count=2"
}

@test "exits 0 when count is below threshold" {
  make_commit "baseline"
  local baseline_hash
  baseline_hash=$(git rev-parse HEAD)
  make_stage_dd "specs/001-foo" "$baseline_hash"
  echo '{"retrospective_threshold": 5}' > .designlens.json
  make_commit "after-1"
  make_commit "after-2"
  run commits_since_stage
  [ "$status" -eq 0 ]
  echo "$output" | grep -q "count=2"
}

@test "exits 1 when count meets threshold" {
  make_commit "baseline"
  local baseline_hash
  baseline_hash=$(git rev-parse HEAD)
  make_stage_dd "specs/001-foo" "$baseline_hash"
  echo '{"retrospective_threshold": 3}' > .designlens.json
  make_commit "after-1"
  make_commit "after-2"
  make_commit "after-3"
  run commits_since_stage
  [ "$status" -eq 1 ]
  echo "$output" | grep -q "count=3"
}

@test "exits 0 when count is zero (no commits since stage)" {
  make_commit "baseline"
  local baseline_hash
  baseline_hash=$(git rev-parse HEAD)
  make_stage_dd "specs/001-foo" "$baseline_hash"
  run commits_since_stage
  [ "$status" -eq 0 ]
  echo "$output" | grep -q "count=0"
}

@test "uses most recent stage with design-decisions.md as baseline" {
  make_commit "baseline"
  local old_hash
  old_hash=$(git rev-parse HEAD)
  make_stage_dd "specs/001-foo" "$old_hash"
  make_commit "between-stages"
  local new_hash
  new_hash=$(git rev-parse HEAD)
  make_stage_dd "specs/002-bar" "$new_hash"
  make_commit "after-stage-2"
  run commits_since_stage
  # Should count from 002-bar's hash, not 001-foo's
  echo "$output" | grep -q "count=1"
}
