#!/bin/bash
set -e

# Detect OS
OS="$(uname -s)"

case "$OS" in
  Darwin|Linux)
    echo "Installing designlog for $OS..."

    INSTALL_DIR="/usr/local/lib/designlog"
    BIN_DIR="/usr/local/bin"

    # Check if we need sudo
    if [ ! -w "$BIN_DIR" ]; then
      SUDO="sudo"
    else
      SUDO=""
    fi

    # Get the directory where install.sh is located
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

    echo "Creating installation directory..."
    $SUDO mkdir -p "$INSTALL_DIR"

    echo "Copying files..."
    $SUDO cp -r "$SCRIPT_DIR"/bin "$INSTALL_DIR/"
    $SUDO cp -r "$SCRIPT_DIR"/lib "$INSTALL_DIR/"
    $SUDO cp -r "$SCRIPT_DIR"/docs "$INSTALL_DIR/"
    $SUDO cp "$SCRIPT_DIR"/README.md "$INSTALL_DIR/"
    $SUDO cp "$SCRIPT_DIR"/designlog.json "$INSTALL_DIR/"
    $SUDO cp "$SCRIPT_DIR"/LICENSE "$INSTALL_DIR/"

    echo "Making scripts executable..."
    $SUDO chmod +x "$INSTALL_DIR"/bin/designlog
    $SUDO chmod +x "$INSTALL_DIR"/lib/*.sh

    echo "Creating symlink..."
    $SUDO ln -sf "$INSTALL_DIR/bin/designlog" "$BIN_DIR/designlog"

    echo "✓ designlog installed successfully!"
    echo "Run 'designlog init' in your project directory to get started."
    ;;

  MINGW*|MSYS*|CYGWIN*)
    echo "Detected Windows environment with Git Bash/WSL..."
    echo "Please run install.ps1 in PowerShell instead:"
    echo "  irm https://raw.githubusercontent.com/ropensci-review-tools/designlog/main/install.ps1 | iex"
    exit 1
    ;;

  *)
    echo "Unsupported OS: $OS"
    exit 1
    ;;
esac
