#!/bin/bash

# Update designlens to the latest version

lib_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$lib_dir/colors.sh"
source "$lib_dir/logo.sh"

REPO="ropensci-review-tools/designlens"
INSTALL_SCRIPT_URL="https://raw.githubusercontent.com/$REPO/main/install.sh"
METADATA_URL="https://raw.githubusercontent.com/$REPO/main/designlens.json"

spec_update() {
  show_logo

  info "Checking for updates..."
  echo ""

  # Get current installed version
  INSTALL_DIR=""
  if command -v designlens &>/dev/null; then
    DESIGNLENS_PATH=$(readlink -f "$(which designlens)")
    INSTALL_DIR=$(cd "$(dirname "$DESIGNLENS_PATH")/.." && pwd)
  fi

  if [ -z "$INSTALL_DIR" ] || [ ! -d "$INSTALL_DIR" ]; then
    error "Could not determine designlens installation directory."
    exit 1
  fi

  LOCAL_VERSION=""
  if [ -f "$INSTALL_DIR/designlens.json" ]; then
    LOCAL_VERSION=$(grep -o '"Version": *"[^"]*"' "$INSTALL_DIR/designlens.json" | cut -d'"' -f4)
  fi

  if [ -z "$LOCAL_VERSION" ]; then
    error "Could not determine installed version."
    exit 1
  fi

  # Get latest version from GitHub
  REMOTE_JSON=$(curl -fsSL "$METADATA_URL" 2>/dev/null)
  if [ -z "$REMOTE_JSON" ]; then
    error "Could not reach GitHub to check for updates."
    exit 1
  fi

  REMOTE_VERSION=$(echo "$REMOTE_JSON" | grep -o '"Version": *"[^"]*"' | cut -d'"' -f4)
  if [ -z "$REMOTE_VERSION" ]; then
    error "Could not parse remote version."
    exit 1
  fi

  info "Installed version : $LOCAL_VERSION"
  info "Latest version    : $REMOTE_VERSION"
  echo ""

  if [ "$LOCAL_VERSION" = "$REMOTE_VERSION" ]; then
    success "Already at the latest version."
    return 0
  fi

  info "Updating to $REMOTE_VERSION..."
  echo ""

  curl -fsSL "$INSTALL_SCRIPT_URL" | bash

  success "Updated from $LOCAL_VERSION to $REMOTE_VERSION."
}
