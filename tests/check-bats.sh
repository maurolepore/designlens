#!/bin/bash

# check_bats: verify bats-core is installed, print install instructions and exit if not.
check_bats() {
  command -v bats >/dev/null 2>&1 && return 0

  echo ""
  echo "ERROR: bats is not installed."
  echo ""
  echo "See https://bats-core.readthedocs.io for installation instructions."
  echo ""
  exit 1
}
