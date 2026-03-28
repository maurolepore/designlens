#!/bin/bash

# Display the designlog logo with colors
# Sourced by other scripts to show at the start of commands

show_logo() {
  # Source colors if not already loaded
  if [ -z "$GREEN" ]; then
    local lib_dir
    lib_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    source "$lib_dir/colors.sh"
  fi

  echo -e "${CYAN}  _           _            _           ${NC}"
  echo -e "${CYAN}_| | ___  ___[_] ___  _ _ | | ___  ___ ${NC}"
  echo -e "${CYAN}/ . |/ ._][_-[| |/ . || ' || |/ . \\/ . |${NC}"
  echo -e "${CYAN}\\___|\\___./__/|_|\\_. ||_|_||_|\\___/\\_. |${NC}"
  echo -e "${CYAN}                 [___|             [___|${NC}"
  echo ""
}
