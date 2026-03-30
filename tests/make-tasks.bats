#!/usr/bin/env bats
# Tests for spec_make_tasks (lib/make-tasks.sh)
# Requires bats-core: https://github.com/bats-core/bats-core
#   apt install bats        (Debian/Ubuntu)

LIB_DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")/../lib" && pwd)"

setup() {
  export NO_COLOR=1
  TEST_DIR="$(mktemp -d)"
  cd "$TEST_DIR"
  git init -q
  git config user.email "test@test.com"
  git config user.name "Test"
  source "$LIB_DIR/make-tasks.sh"
}

teardown() {
  cd /tmp
  rm -rf "$TEST_DIR"
}

# --- preconditions ---

@test "fails when specs/ directory does not exist" {
  run spec_make_tasks
  [ "$status" -ne 0 ]
}

@test "fails when no stages exist" {
  mkdir specs
  run spec_make_tasks
  [ "$status" -ne 0 ]
  [[ "$output" == *"No stages found"* ]]
}

@test "fails when plan.md is missing from latest stage" {
  mkdir -p specs/001-initial
  run spec_make_tasks
  [ "$status" -ne 0 ]
  [[ "$output" == *"plan.md"* ]]
}

# --- agent instructions ---

@test "prints agent instructions when plan.md exists" {
  mkdir -p specs/001-initial
  echo "# Plan" > specs/001-initial/plan.md
  run spec_make_tasks
  [ "$status" -eq 0 ]
  [[ "$output" == *"AGENT"* ]]
}

@test "agent instructions reference the correct stage task prefix" {
  mkdir -p specs/003-caching
  echo "# Plan" > specs/003-caching/plan.md
  run spec_make_tasks
  [[ "$output" == *"T003"* ]]
}

@test "agent instructions reference the correct plan.md path" {
  mkdir -p specs/001-initial
  echo "# Plan" > specs/001-initial/plan.md
  run spec_make_tasks
  [[ "$output" == *"specs/001-initial/plan.md"* ]]
}

@test "operates on the latest stage when multiple exist" {
  mkdir -p specs/001-initial specs/002-second
  echo "# Plan" > specs/001-initial/plan.md
  echo "# Plan" > specs/002-second/plan.md
  run spec_make_tasks
  [[ "$output" == *"T002"* ]]
}

# --- existing tasks.md ---

@test "warns when tasks.md already exists" {
  mkdir -p specs/001-initial
  echo "# Plan" > specs/001-initial/plan.md
  echo "- [x] T001-1: done" > specs/001-initial/tasks.md
  run spec_make_tasks <<< $'n\n'
  [[ "$output" == *"already exists"* ]]
}

@test "aborts when user declines overwrite of existing tasks.md" {
  mkdir -p specs/001-initial
  echo "# Plan" > specs/001-initial/plan.md
  echo "- [x] T001-1: done" > specs/001-initial/tasks.md
  run spec_make_tasks <<< $'n\n'
  [ "$status" -eq 0 ]
  [[ "$output" == *"Aborted"* ]]
}

@test "proceeds with agent instructions when user confirms overwrite" {
  mkdir -p specs/001-initial
  echo "# Plan" > specs/001-initial/plan.md
  echo "- [x] T001-1: done" > specs/001-initial/tasks.md
  run spec_make_tasks <<< $'y\n'
  [ "$status" -eq 0 ]
  [[ "$output" == *"AGENT"* ]]
}
