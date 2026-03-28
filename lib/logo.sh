#!/bin/bash

# Display the designlog logo with colors
# Adapts to light vs. dark terminal backgrounds
# Sourced by other scripts to show at the start of commands

# Detect if terminal background is light or dark
is_dark_background() {
  local bg_color
  local is_dark=0

  # Try to query terminal background color using OSC 11
  # This works on most modern terminal emulators (iTerm2, GNOME Terminal, etc.)
  if command -v timeout &> /dev/null; then
    # Use timeout to avoid hanging if terminal doesn't respond
    bg_color=$(timeout 0.1 bash -c 'read -rs -d \\ -p $'"'"'\e]11;?\e\\'"'"' BG 2>/dev/null; echo "$BG"' 2>/dev/null)
  else
    # Fallback without timeout (might hang on some terminals)
    bg_color=$(bash -c 'read -rs -d \\ -p $'"'"'\e]11;?\e\\'"'"' BG 2>/dev/null; echo "$BG"' 2>/dev/null)
  fi

  if [ -n "$bg_color" ]; then
    # Parse RGB values from the OSC response
    # Format is typically: ]11;rgb:RRRR/GGGG/BBBB or ]11;rgb:RR/GG/BB
    local rgb="${bg_color#*rgb:}"

    if [ -n "$rgb" ]; then
      # Extract R, G, B values
      local r="${rgb%%/*}"
      local g="${rgb#*/}"
      g="${g%%/*}"
      local b="${rgb##*/}"

      # Convert from hex to decimal if needed (handle both formats)
      # If values are 4-digit hex (RRRR), divide by 256 to get 0-255 range
      if [ ${#r} -gt 2 ]; then
        r=$((16#${r:0:2}))
        g=$((16#${g:0:2}))
        b=$((16#${b:0:2}))
      fi

      # Calculate perceived brightness using standard luminance formula
      # L = 0.2126*R + 0.7152*G + 0.0722*B
      # If L > ~128, background is light
      local luminance=$(( (21 * r + 71 * g + 7 * b) / 100 ))
      [ "$luminance" -lt 128 ] && is_dark=1
    fi
  fi

  return "$is_dark"
}

show_logo() {
  # Source colors if not already loaded
  if [ -z "$GREEN" ]; then
    local lib_dir
    lib_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    source "$lib_dir/colors.sh"
  fi

  # Determine which color to use based on background
  local logo_color
  if is_dark_background; then
    logo_color='\033[0;33m'  # Yellow for dark backgrounds
  else
    logo_color='\033[0;36m'  # Cyan for light backgrounds (default)
  fi

  echo -e "${logo_color}  _           _            _           ${NC}"
  echo -e "${logo_color}_| | ___  ___[_] ___  _ _ | | ___  ___ ${NC}"
  echo -e "${logo_color}/ . |/ ._][_-[| |/ . || ' || |/ . \\/ . |${NC}"
  echo -e "${logo_color}\\___|\\___./__/|_|\\_. ||_|_||_|\\___/\\_. |${NC}"
  echo -e "${logo_color}                 [___|             [___|${NC}"
  echo ""
}
