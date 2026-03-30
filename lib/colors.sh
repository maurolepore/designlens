#!/bin/bash

# ANSI color codes for terminal output
# Respects NO_COLOR environment variable (https://no-color.org/)

# Check if colors should be used
use_colors() {
  if [ -n "$NO_COLOR" ]; then
    return 1  # Don't use colors
  fi
  return 0  # Use colors
}

# Color definitions (only defined if colors are enabled)
if use_colors; then
  GREEN='\033[0;32m'
  RED='\033[0;31m'
  YELLOW='\033[1;33m'
  BLUE='\033[0;34m'
  CYAN='\033[0;36m'
  BOLD='\033[1m'
  NC='\033[0m'  # No Color (reset)
else
  GREEN=''
  RED=''
  YELLOW=''
  BLUE=''
  CYAN=''
  BOLD=''
  NC=''
fi

# Print success message (green with checkmark)
success() {
  echo -e "${GREEN}✓${NC} $*"
}

# Print error message (red)
error() {
  echo -e "${RED}✗${NC} $*" >&2
}

# Print warning message (yellow)
warning() {
  echo -e "${YELLOW}⚠${NC} $*"
}

# Print info message (blue)
info() {
  echo -e "${BLUE}ℹ${NC} $*"
}

# Print prompt (cyan with arrow)
prompt() {
  echo -e "${CYAN}→${NC} $*"
}

# Print heading (bold)
heading() {
  echo -e "${BOLD}$*${NC}"
}

# Print a horizontal rule
rule() {
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}
