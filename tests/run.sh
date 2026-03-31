#!/bin/bash

# Run designlens tests. Accepts optional bats arguments; defaults to the full tests/ directory.
# Usage:
#   bash tests/run.sh                     # run all tests
#   bash tests/run.sh tests/init.bats     # run a single file

source "$(dirname "$0")/check-bats.sh"
check_bats

bats "${@:-tests/}"
