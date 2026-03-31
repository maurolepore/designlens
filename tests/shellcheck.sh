#!/bin/bash

# Run shellcheck on all shell files in the project, with bats-style output.

command -v shellcheck >/dev/null 2>&1 || {
  echo ""
  echo "ERROR: shellcheck is not installed."
  echo ""
  echo "See https://github.com/koalaman/shellcheck#installing for installation instructions."
  echo ""
  exit 1
}

TITLE='\033[34;1m'
GREEN='\033[0;32m'
RED='\033[0;31m'
RESET='\033[0m'

cd "$(dirname "$0")/.." || exit 1

files=(bin/designlens lib/*.sh install.sh install-local.sh tests/*.sh)

passed=0
failed=0
failures=""

echo ""
echo -e "${TITLE}shellcheck${RESET}"

for file in "${files[@]}"; do
  [ -f "$file" ] || continue
  if output=$(shellcheck "$file" 2>&1); then
    echo -e " ${GREEN}✓${RESET} $file"
    (( passed++ )) || true
  else
    echo -e " ${RED}✗${RESET} $file"
    failures+="$output"$'\n'
    (( failed++ )) || true
  fi
done

echo ""

if [ "$failed" -eq 0 ]; then
  echo -e "${GREEN}${passed} files passed${RESET}"
else
  echo "$failures"
  echo -e "${RED}${passed} passed, ${failed} failed${RESET}"
  exit 1
fi
