#!/usr/bin/env bats
# Tests for spec_new_stage (lib/new-stage.sh)
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
  source "$LIB_DIR/new-stage.sh"
}

teardown() {
  cd /tmp
  rm -rf "$TEST_DIR"
}

# --- preconditions ---

@test "fails when specs/ directory does not exist" {
  run spec_new_stage "add authentication"
  [ "$status" -ne 0 ]
}

@test "exits 0 with agent message when no description provided" {
  mkdir specs
  run spec_new_stage
  [ "$status" -eq 0 ]
  [[ "$output" == *"AGENT"* ]]
}

# --- slug derivation ---

@test "derives slug from first two words of description" {
  mkdir specs
  spec_new_stage "add authentication layer"
  [ -d specs/001-add-authentication ]
}

@test "lowercases the slug" {
  mkdir specs
  spec_new_stage "Add Users"
  [ -d specs/001-add-users ]
}

@test "replaces non-alphanumeric characters with hyphens in slug" {
  mkdir specs
  spec_new_stage "add user/role support"
  [ -d specs/001-add-user ]
}

@test "uses provided stage name when given" {
  mkdir specs
  spec_new_stage "add authentication" "custom-name"
  [ -d specs/001-custom-name ]
}

# --- stage numbering ---

@test "creates first stage as 001" {
  mkdir specs
  spec_new_stage "add authentication"
  [ -d specs/001-add-authentication ]
}

@test "increments stage number correctly" {
  mkdir -p specs/001-initial
  echo "# Decisions" > specs/001-initial/design-decisions.md
  spec_new_stage "add caching"
  [ -d specs/002-add-caching ]
}

@test "pads stage number to three digits" {
  for i in $(seq 1 9); do
    mkdir -p "specs/00${i}-stage${i}"
    echo "# Decisions" > "specs/00${i}-stage${i}/design-decisions.md"
  done
  spec_new_stage "tenth stage"
  [ -d specs/010-tenth-stage ]
}

# --- plan.md creation ---

@test "creates plan.md in new stage directory" {
  mkdir specs
  spec_new_stage "add authentication"
  [ -f specs/001-add-authentication/plan.md ]
}

@test "plan.md contains the stage description" {
  mkdir specs
  spec_new_stage "add authentication layer"
  grep -q "add authentication layer" specs/001-add-authentication/plan.md
}

@test "plan.md contains required sections" {
  mkdir specs
  spec_new_stage "add caching"
  grep -q "## Overview" specs/001-add-caching/plan.md
  grep -q "## Design Goals" specs/001-add-caching/plan.md
  grep -q "## Proposed Approach" specs/001-add-caching/plan.md
}

@test "prints agent instructions after creating plan.md" {
  mkdir specs
  run spec_new_stage "add caching"
  [[ "$output" == *"AGENT"* ]]
  [[ "$output" == *"plan.md"* ]]
}

# --- previous stage retrospective check ---

@test "warns when previous stage has no design-decisions.md" {
  mkdir -p specs/001-initial
  run spec_new_stage "add caching" <<< $'n\n'
  [[ "$output" == *"design-decisions.md"* ]]
}

@test "continues when user declines retrospective" {
  mkdir -p specs/001-initial
  spec_new_stage "add caching" <<< $'n\n'
  [ -d specs/002-add-caching ]
}

@test "skips retrospective check when previous stage is complete" {
  mkdir -p specs/001-initial
  echo "# Decisions" > specs/001-initial/design-decisions.md
  run spec_new_stage "add caching"
  [[ "$output" != *"retrospective"* ]]
}
