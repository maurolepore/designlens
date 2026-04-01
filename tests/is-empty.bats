#!/usr/bin/env bats
# Tests for is-empty.sh (project emptiness detection)

LIB_DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")/../lib" && pwd)"
source "$LIB_DIR/is-empty.sh"

setup() {
  export NO_COLOR=1
  TEST_DIR="$(mktemp -d)"
  cd "$TEST_DIR"
}

teardown() {
  cd /tmp
  rm -rf "$TEST_DIR"
}

# Helper: set up designlens infrastructure only
setup_designlens_infra() {
  mkdir -p specs .git .claude .opencode
  echo '{"tool": "designlens"}' > .designlens.json
  echo "# Agent Instructions" > AGENTS.md
}

# Helper: add a non-designlens file
add_real_file() {
  echo "real content" > "$1"
}

# Helper: make a non-designlens commit
make_real_commit() {
  git init -q
  git config user.email "test@test.com"
  git config user.name "Test"
  echo "real content" > real_file.txt
  git add real_file.txt
  git commit -q -m "Add real file"
}

@test "is_designlens_path returns true for .designlens.json" {
  is_designlens_path ".designlens.json"
}

@test "is_designlens_path returns true for specs/" {
  is_designlens_path "specs/"
}

@test "is_designlens_path returns false for real_file.txt" {
  ! is_designlens_path "real_file.txt"
}

@test "is_designlens_path returns false for src/main.py" {
  ! is_designlens_path "src/main.py"
}

@test "check_git_history returns 0 when non-designlens commit exists" {
  make_real_commit
  run check_git_history
  [ "$status" -eq 0 ]
}

@test "check_git_history returns 1 when only designlens commits exist" {
  setup_designlens_infra
  git init -q
  git config user.email "test@test.com"
  git config user.name "Test"
  git add .
  git commit -q -m "Add designlens"
  run check_git_history
  [ "$status" -eq 1 ]
}

@test "check_filesystem returns 0 when real files exist" {
  echo "content" > real_file.txt
  run check_filesystem
  [ "$status" -eq 0 ]
}

@test "check_filesystem returns 1 when only designlens paths exist" {
  setup_designlens_infra
  run check_filesystem
  [ "$status" -eq 1 ]
}

@test "is_project_empty returns 1 (non-empty) for project with real files" {
  echo "content" > real_file.txt
  run is_project_empty
  [ "$status" -eq 1 ]
}

@test "is_project_empty returns 1 (non-empty) for project with real commits" {
  make_real_commit
  run is_project_empty
  [ "$status" -eq 1 ]
}

@test "is_project_empty returns 0 (empty) for designlens-only project" {
  setup_designlens_infra
  git init -q
  git config user.email "test@test.com"
  git config user.name "Test"
  git add -A
  git commit -q -m "Init designlens"
  run is_project_empty
  [ "$status" -eq 0 ]
}