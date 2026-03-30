#!/bin/bash

# Uninstall designlens from the system

# Source colors and logo
lib_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$lib_dir/colors.sh"
source "$lib_dir/logo.sh"

spec_uninstall() {
  show_logo

  heading "Uninstalling designlens..."
  echo ""

  UNINSTALLED=false

  # Resolve the real user's home when running under sudo
  if [ -n "$SUDO_USER" ]; then
    REAL_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
  else
    REAL_HOME="$HOME"
  fi

  # Check system-wide installation
  if [ -d "/usr/local/lib/designlens" ]; then
    INSTALL_DIR="/usr/local/lib/designlens"
    BIN_LINK="/usr/local/bin/designlens"

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

  # Check user local installation (real user's home, works under sudo)
  if [ -d "$REAL_HOME/.local/lib/designlens" ]; then
    INSTALL_DIR="$REAL_HOME/.local/lib/designlens"
    BIN_LINK="$REAL_HOME/.local/bin/designlens"

    info "Removing symlink: $BIN_LINK"
    rm -f "$BIN_LINK"

    info "Removing installation directory: $INSTALL_DIR"
    rm -rf "$INSTALL_DIR"

    UNINSTALLED=true
  fi

  if [ "$UNINSTALLED" = false ]; then
    error "designlens not found in standard installation locations"
    return 1
  fi

  echo ""
  success "designlens uninstalled"
  echo ""
  info "Your project specs in /specs folders remain unchanged."
  info "To remove designlens from a project, delete the /specs folder and .designlens.json file."
}
