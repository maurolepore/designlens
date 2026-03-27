#!/bin/bash

# Update designlog to the latest version
# Re-fetches and reinstalls from GitHub

spec_update() {
  echo "Checking for updates..."
  echo ""

  # Determine installation directory
  INSTALL_DIR=""
  if command -v designlog &> /dev/null; then
    DESIGNLOG_PATH=$(which designlog)
    INSTALL_DIR=$(cd "$(dirname "$DESIGNLOG_PATH")/../.." && pwd)
  fi

  if [ -z "$INSTALL_DIR" ] || [ ! -d "$INSTALL_DIR" ]; then
    echo "Error: Could not determine designlog installation directory."
    echo "Try reinstalling with: curl -fsSL https://raw.githubusercontent.com/[repo]/install.sh | bash"
    exit 1
  fi

  echo "Current installation: $INSTALL_DIR"

  # For now, provide guidance
  echo ""
  echo "To update designlog:"
  echo ""
  echo "  1. Clone the latest from GitHub:"
  echo "     git clone https://github.com/[org]/designlog /tmp/designlog-new"
  echo ""
  echo "  2. Run the installer:"
  echo "     cd /tmp/designlog-new && bash install.sh"
  echo ""
  echo "Alternatively, reinstall from scratch:"
  echo "  curl -fsSL https://raw.githubusercontent.com/[repo]/install.sh | bash"
}
