#!/usr/bin/env bats
# Tests for spec_status (lib/status.sh)
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
  source "$LIB_DIR/status.sh"
}

teardown() {
  cd /tmp
  rm -rf "$TEST_DIR"
}

# --- no specs directory ---

@test "fails when specs/ directory does not exist" {
  run spec_status
  [ "$status" -ne 0 ]
  [[ "$output" == *"specs"* ]]
}

# --- no stages ---

@test "reports no stages when specs/ is empty" {
  mkdir specs
  run spec_status
  [ "$status" -eq 0 ]
  [[ "$output" == *"No stages found"* ]]
}

@test "prompts to create first stage when no stages exist" {
  mkdir specs
  run spec_status
  [[ "$output" == *"new-stage"* ]]
}

# --- plan missing ---

@test "prompts to write plan when plan.md missing" {
  mkdir -p specs/001-initial
  run spec_status
  [[ "$output" == *"plan.md"* ]]
}

# --- tasks missing ---

@test "prompts to create tasks when plan exists but tasks.md missing" {
  mkdir -p specs/001-initial
  echo "# Plan" > specs/001-initial/plan.md
  run spec_status
  [[ "$output" == *"tasks.md"* ]]
}

# --- tasks incomplete ---

@test "shows task completion count" {
  mkdir -p specs/001-initial
  echo "# Plan" > specs/001-initial/plan.md
  cat > specs/001-initial/tasks.md << 'EOF'
- [x] task one
- [ ] task two
- [ ] task three
EOF
  run spec_status
  [[ "$output" == *"1/3"* ]]
}

@test "prompts to execute tasks when tasks are incomplete" {
  mkdir -p specs/001-initial
  echo "# Plan" > specs/001-initial/plan.md
  cat > specs/001-initial/tasks.md << 'EOF'
- [x] task one
- [ ] task two
EOF
  run spec_status
  [[ "$output" == *"remaining tasks"* ]]
}

# --- retrospective missing ---

# Helper: make a git commit
make_commit() {
  echo "$1" > "file_$RANDOM.txt"
  git add -A
  git commit -q -m "$1"
}

@test "prompts to run retrospective when all tasks complete, design-decisions.md missing, and enough commits exist" {
  for i in $(seq 1 10); do make_commit "commit-$i"; done
  mkdir -p specs/001-initial
  echo "# Plan" > specs/001-initial/plan.md
  cat > specs/001-initial/tasks.md << 'EOF'
- [x] task one
- [x] task two
EOF
  run spec_status
  [[ "$output" == *"/designlens.retrospective"* ]]
}

@test "skips the retrospective recommendation for a brand-new repo with fewer than threshold commits" {
  make_commit "only-commit"
  mkdir -p specs/001-initial
  echo "# Plan" > specs/001-initial/plan.md
  cat > specs/001-initial/tasks.md << 'EOF'
- [x] task one
- [x] task two
EOF
  run spec_status
  [[ "$output" != *"/designlens.retrospective"* ]]
  [[ "$output" == *"skipped"* ]]
  [[ "$output" == *"/designlens.new-stage"* ]]
}

# --- stage complete ---

@test "reports stage complete when all files present and tasks done" {
  mkdir -p specs/001-initial
  echo "# Plan" > specs/001-initial/plan.md
  cat > specs/001-initial/tasks.md << 'EOF'
- [x] task one
- [x] task two
EOF
  echo "# Decisions" > specs/001-initial/design-decisions.md
  run spec_status
  [[ "$output" == *"complete"* ]]
}

@test "prompts to start a new stage when current stage is complete" {
  mkdir -p specs/001-initial
  echo "# Plan" > specs/001-initial/plan.md
  cat > specs/001-initial/tasks.md << 'EOF'
- [x] task one
EOF
  echo "# Decisions" > specs/001-initial/design-decisions.md
  run spec_status
  [[ "$output" == *"new-stage"* ]]
}

# --- multiple stages ---

@test "reports on the latest stage when multiple exist" {
  mkdir -p specs/001-initial specs/002-second
  echo "# Plan" > specs/001-initial/plan.md
  echo "# Plan" > specs/002-second/plan.md
  run spec_status
  [[ "$output" == *"002-second"* ]]
}
