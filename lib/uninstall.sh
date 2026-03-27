#!/bin/bash

# Uninstall designlog from the system

spec_uninstall() {
  echo "Uninstalling designlog..."
  echo ""

  UNINSTALLED=false

  # Check system-wide installation
  if [ -d "/usr/local/lib/designlog" ]; then
    INSTALL_DIR="/usr/local/lib/designlog"
    BIN_LINK="/usr/local/bin/designlog"

    # Check if we need sudo
    if [ ! -w "/usr/local/lib" ]; then
      SUDO="sudo"
    else
      SUDO=""
    fi

    echo "Removing symlink: $BIN_LINK"
    $SUDO rm -f "$BIN_LINK"

    echo "Removing installation directory: $INSTALL_DIR"
    $SUDO rm -rf "$INSTALL_DIR"

    UNINSTALLED=true
  fi

  # Check user local installation
  if [ -d "$HOME/.local/lib/designlog" ]; then
    INSTALL_DIR="$HOME/.local/lib/designlog"
    BIN_LINK="$HOME/.local/bin/designlog"

    echo "Removing symlink: $BIN_LINK"
    rm -f "$BIN_LINK"

    echo "Removing installation directory: $INSTALL_DIR"
    rm -rf "$INSTALL_DIR"

    UNINSTALLED=true
  fi

  if [ "$UNINSTALLED" = false ]; then
    echo "designlog not found in standard installation locations"
    return 1
  fi

  echo ""
  echo "✓ designlog uninstalled"
  echo ""
  echo "Your project specs in /specs folders remain unchanged."
  echo "To remove designlog from a project, delete the /specs folder and .specmeta.json file."
}
