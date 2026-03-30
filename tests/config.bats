#!/usr/bin/env bats
# Tests for config management (lib/config.sh)
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
  source "$LIB_DIR/config.sh"
  # Create a minimal .designlens.json as init would
  cat > .designlens.json << 'EOF'
{
  "tool": "designlens",
  "auto_commit": false
}
EOF
}

teardown() {
  cd /tmp
  rm -rf "$TEST_DIR"
}

# --- read_config ---

@test "read_config returns value for existing key" {
  result=$(read_config "auto_commit")
  [ "$result" = "false" ]
}

@test "read_config returns 1 when config file missing" {
  rm .designlens.json
  run read_config "auto_commit"
  [ "$status" -ne 0 ]
}

# --- write_config ---

@test "write_config updates existing key" {
  write_config "auto_commit" "true"
  grep -q '"auto_commit": true' .designlens.json
}

@test "write_config adds new key" {
  write_config "new_key" '"hello"'
  grep -q '"new_key": "hello"' .designlens.json
}

@test "write_config fails when config file missing" {
  rm .designlens.json
  run write_config "auto_commit" "true"
  [ "$status" -ne 0 ]
}

# --- spec_config_set ---

@test "spec_config_set sets auto_commit to true" {
  spec_config_set "auto_commit" "true"
  grep -q '"auto_commit": true' .designlens.json
}

@test "spec_config_set sets auto_commit to false" {
  write_config "auto_commit" "true"
  spec_config_set "auto_commit" "false"
  grep -q '"auto_commit": false' .designlens.json
}

@test "spec_config_set rejects invalid auto_commit value" {
  run spec_config_set "auto_commit" "yes"
  [ "$status" -ne 0 ]
}

@test "spec_config_set fails when config file missing" {
  rm .designlens.json
  run spec_config_set "auto_commit" "true"
  [ "$status" -ne 0 ]
}

# --- spec_config_reset ---

@test "spec_config_reset removes auto_commit" {
  spec_config_set "auto_commit" "true"
  spec_config_reset <<< $'y\n'
  run grep 'auto_commit' .designlens.json
  [ "$status" -ne 0 ]
}

@test "spec_config_reset does not modify file when user declines" {
  spec_config_set "auto_commit" "true"
  spec_config_reset <<< $'n\n'
  grep -q '"auto_commit": true' .designlens.json
}

@test "spec_config_reset exits cleanly when no config file" {
  rm .designlens.json
  run spec_config_reset <<< $'y\n'
  [ "$status" -eq 0 ]
}

# --- spec_config_show ---

@test "spec_config_show prints config file contents" {
  run spec_config_show
  [[ "$output" == *"auto_commit"* ]]
}

@test "spec_config_show reports missing config" {
  rm .designlens.json
  run spec_config_show
  [[ "$output" == *"not configured"* ]]
}
