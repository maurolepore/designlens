#!/bin/bash

# Uninstall designlog from the system

# Source colors and logo
lib_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$lib_dir/colors.sh"
source "$lib_dir/logo.sh"

spec_uninstall() {
  show_logo

  heading "Uninstalling designlog..."
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

    info "Removing symlink: $BIN_LINK"
    $SUDO rm -f "$BIN_LINK"

    info "Removing installation directory: $INSTALL_DIR"
    $SUDO rm -rf "$INSTALL_DIR"

    UNINSTALLED=true
  fi

  # Check user local installation
  if [ -d "$HOME/.local/lib/designlog" ]; then
    INSTALL_DIR="$HOME/.local/lib/designlog"
    BIN_LINK="$HOME/.local/bin/designlog"

    info "Removing symlink: $BIN_LINK"
    rm -f "$BIN_LINK"

    info "Removing installation directory: $INSTALL_DIR"
    rm -rf "$INSTALL_DIR"

    UNINSTALLED=true
  fi

  if [ "$UNINSTALLED" = false ]; then
    error "designlog not found in standard installation locations"
    return 1
  fi

  echo ""
  success "designlog uninstalled"
  echo ""
  info "Your project specs in /specs folders remain unchanged."
  info "To remove designlog from a project, delete the /specs folder and .designlog.json file."
}
