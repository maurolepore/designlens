#!/bin/bash

# Update designlog to the latest version
# Re-fetches and reinstalls from GitHub

# Source colors
lib_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$lib_dir/colors.sh"

spec_update() {
  info "Checking for updates..."
  echo ""

  # Determine installation directory
  INSTALL_DIR=""
  if command -v designlog &> /dev/null; then
    DESIGNLOG_PATH=$(which designlog)
    INSTALL_DIR=$(cd "$(dirname "$DESIGNLOG_PATH")/../.." && pwd)
  fi

  if [ -z "$INSTALL_DIR" ] || [ ! -d "$INSTALL_DIR" ]; then
    error "Could not determine designlog installation directory."
    info "Try reinstalling with: curl -fsSL https://raw.githubusercontent.com/[repo]/install.sh | bash"
    exit 1
  fi

  info "Current installation: $INSTALL_DIR"

  # For now, provide guidance
  echo ""
  heading "To update designlog:"
  echo ""
  echo "  1. Clone the latest from GitHub:"
  echo "     git clone https://github.com/[org]/designlog /tmp/designlog-new"
  echo ""
  echo "  2. Run the installer:"
  echo "     cd /tmp/designlog-new && bash install.sh"
  echo ""
  heading "Alternatively, reinstall from scratch:"
  echo "  curl -fsSL https://raw.githubusercontent.com/[repo]/install.sh | bash"
}
