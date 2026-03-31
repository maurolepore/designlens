#!/bin/bash

# Run shellcheck on all shell files in the project.

command -v shellcheck >/dev/null 2>&1 || {
  echo ""
  echo "ERROR: shellcheck is not installed."
  echo ""
  echo "See https://github.com/koalaman/shellcheck#installing for installation instructions."
  echo ""
  exit 1
}

shellcheck bin/designlens lib/*.sh install.sh install-local.sh tests/*.sh
