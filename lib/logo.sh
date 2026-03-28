#!/bin/bash

# Display the designlog logo with colors
# Adapts to light vs. dark terminal backgrounds
# Sourced by other scripts to show at the start of commands

show_logo() {
  # Source colors if not already loaded
  if [ -z "$GREEN" ]; then
    local lib_dir
    lib_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    source "$lib_dir/colors.sh"
  fi

  # Determine terminal background and choose appropriate color
  local logo_color

  # Allow explicit override via environment variable
  if [ -n "$DESIGNLOG_TERM_BG" ]; then
    if [ "$DESIGNLOG_TERM_BG" = "dark" ]; then
      logo_color='\033[0;33m'  # Yellow for dark terminals
    else
      logo_color='\033[0;36m'  # Cyan for light terminals
    fi
  # Auto-detect based on COLORFGBG (set by some terminals)
  elif [ -n "$COLORFGBG" ]; then
    # COLORFGBG format is "foreground;background"
    local bg_color="${COLORFGBG##*;}"
    # Light backgrounds are typically 7, 15, or other light colors
    # Dark backgrounds are typically 0-6, 8-14
    if [ "$bg_color" = "7" ] || [ "$bg_color" = "15" ]; then
      logo_color='\033[0;36m'  # Cyan for light
    else
      logo_color='\033[0;33m'  # Yellow for dark
    fi
  else
    # Default to cyan (assume light terminal as most common)
    logo_color='\033[0;36m'
  fi

  echo -e "${logo_color}  _           _            _           ${NC}"
  echo -e "${logo_color}_| | ___  ___[_] ___  _ _ | | ___  ___ ${NC}"
  echo -e "${logo_color}/ . |/ ._][_-[| |/ . || ' || |/ . \\/ . |${NC}"
  echo -e "${logo_color}\\___|\\___./__/|_|\\_. ||_|_||_|\\___/\\_. |${NC}"
  echo -e "${logo_color}                 [___|             [___|${NC}"
  echo ""
}
