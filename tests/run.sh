#!/bin/bash

# Run designlens tests. Accepts optional bats arguments; defaults to the full tests/ directory.
# Usage:
#   bash tests/run.sh                     # run all tests (parallel)
#   bash tests/run.sh --no-parallel       # run all tests (single-threaded)
#   bash tests/run.sh tests/init.bats     # run a single file (parallel)

source "$(dirname "$0")/check-bats.sh"
check_bats

bash "$(dirname "$0")/shellcheck.sh"

if [ "$1" = "--no-parallel" ]; then
  shift
  bats "${@:-tests/}"
else
  bats --jobs "$(nproc 2>/dev/null || sysctl -n hw.logicalcpu 2>/dev/null || echo 4)" "${@:-tests/}"
fi
