#!/bin/bash

# Uninstall designlog from the system

spec_uninstall() {
  echo "Uninstalling designlog..."
  echo ""

  INSTALL_DIR="/usr/local/lib/designlog"
  BIN_LINK="/usr/local/bin/designlog"

  # Check if we need sudo
  if [ ! -w "/usr/local/lib" ]; then
    SUDO="sudo"
  else
    SUDO=""
  fi

  # Remove symlink
  if [ -L "$BIN_LINK" ]; then
    echo "Removing symlink: $BIN_LINK"
    $SUDO rm "$BIN_LINK"
  fi

  # Remove installation directory
  if [ -d "$INSTALL_DIR" ]; then
    echo "Removing installation directory: $INSTALL_DIR"
    $SUDO rm -rf "$INSTALL_DIR"
  fi

  echo ""
  echo "✓ designlog uninstalled"
  echo ""
  echo "Your project specs in /specs folders remain unchanged."
  echo "To remove designlog from a project, delete the /specs folder and .specmeta.json file."
}
