#!/bin/bash

# Update speclog to the latest version
# Re-fetches and reinstalls from GitHub

spec_update() {
  echo "Checking for updates..."
  echo ""

  # Determine installation directory
  INSTALL_DIR=""
  if command -v speclog &> /dev/null; then
    SPECLOG_PATH=$(which speclog)
    INSTALL_DIR=$(cd "$(dirname "$SPECLOG_PATH")/../.." && pwd)
  fi

  if [ -z "$INSTALL_DIR" ] || [ ! -d "$INSTALL_DIR" ]; then
    echo "Error: Could not determine speclog installation directory."
    echo "Try reinstalling with: curl -fsSL https://raw.githubusercontent.com/[repo]/install.sh | bash"
    exit 1
  fi

  echo "Current installation: $INSTALL_DIR"

  # For now, provide guidance
  echo ""
  echo "To update speclog:"
  echo ""
  echo "  1. Clone the latest from GitHub:"
  echo "     git clone https://github.com/[org]/speclog /tmp/speclog-new"
  echo ""
  echo "  2. Run the installer:"
  echo "     cd /tmp/speclog-new && bash install.sh"
  echo ""
  echo "Alternatively, reinstall from scratch:"
  echo "  curl -fsSL https://raw.githubusercontent.com/[repo]/install.sh | bash"
}
