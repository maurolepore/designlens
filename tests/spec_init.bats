#!/usr/bin/env bats
# Tests for spec_init (lib/init.sh)
# Requires bats-core: https://github.com/bats-core/bats-core
#   brew install bats-core  (macOS)
#   apt install bats        (Debian/Ubuntu)

LIB_DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")/../lib" && pwd)"

setup() {
  export NO_COLOR=1
  TEST_DIR="$(mktemp -d)"
  cd "$TEST_DIR"
  git init -q
  git config user.email "test@test.com"
  git config user.name "Test"
  source "$LIB_DIR/init.sh"
}

teardown() {
  cd /tmp
  rm -rf "$TEST_DIR"
}

# --- filesystem ---

@test "creates specs/ directory" {
  spec_init <<< $'n\n'
  [ -d specs ]
}

@test "creates specs/README.md" {
  spec_init <<< $'n\n'
  [ -f specs/README.md ]
}

@test "creates .designlens.json" {
  spec_init <<< $'n\n'
  [ -f .designlens.json ]
}

@test "creates AGENTS.md when none exists" {
  spec_init <<< $'n\n'
  [ -f AGENTS.md ]
}

@test "fails if specs/ already exists" {
  mkdir specs
  run spec_init <<< $'n\n'
  [ "$status" -ne 0 ]
}

# --- config ---

@test "sets auto_commit false when user answers n" {
  spec_init <<< $'n\n'
  grep -q '"auto_commit": false' .designlens.json
}

@test "sets auto_commit true when user answers y" {
  spec_init <<< $'y\n'
  grep -q '"auto_commit": true' .designlens.json
}

# --- git staging ---

@test "stages .designlens.json" {
  spec_init <<< $'n\n'
  git diff --cached --name-only | grep -q '\.designlens\.json'
}

@test "stages specs/README.md" {
  spec_init <<< $'n\n'
  git diff --cached --name-only | grep -q 'specs/README.md'
}

@test "stages AGENTS.md" {
  spec_init <<< $'n\n'
  git diff --cached --name-only | grep -q 'AGENTS.md'
}

# --- git committing ---

@test "does not commit when auto_commit is false" {
  spec_init <<< $'n\n'
  run git rev-parse HEAD
  [ "$status" -ne 0 ]
}

@test "commits when auto_commit is true" {
  spec_init <<< $'y\n'
  run git log --oneline
  [ "$status" -eq 0 ]
  [[ "$output" == *"Initialize designlens"* ]]
}

# --- existing AGENTS.md ---

@test "appends to existing AGENTS.md when user confirms" {
  echo "# Existing" > AGENTS.md
  spec_init <<< $'n\ny\n'
  grep -q 'designlens' AGENTS.md
  grep -q 'Existing' AGENTS.md
}

@test "leaves existing AGENTS.md unchanged when user declines" {
  echo "# Existing" > AGENTS.md
  spec_init <<< $'n\nn\n'
  run grep 'designlens' AGENTS.md
  [ "$status" -ne 0 ]
}

# --- git history stub ---

@test "creates 000-design-history stub when repo exceeds history threshold" {
  git commit --allow-empty -m "initial" -q
  for i in $(seq 2 51); do
    git commit --allow-empty -m "commit $i" -q
  done
  spec_init <<< $'n\n'
  [ -f specs/000-design-history/design-decisions.md ]
  grep -q 'PENDING' specs/000-design-history/design-decisions.md
}

@test "does not create 000-design-history stub for small repos" {
  spec_init <<< $'n\n'
  [ ! -d specs/000-design-history ]
}
