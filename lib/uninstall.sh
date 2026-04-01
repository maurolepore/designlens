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

  if [ -d "$HOME/.local/share/designlens" ]; then
    INSTALL_DIR="$HOME/.local/share/designlens"
    BIN_LINK="$HOME/.local/bin/designlens"

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
