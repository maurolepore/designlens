#!/bin/bash
set -e

# Detect OS
OS="$(uname -s)"

case "$OS" in
  Darwin|Linux)
    echo "Installing designlens for $OS..."

    # Get the directory where install.sh is located
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

    # Try system-wide installation first, fall back to user local
    if [ -w "/usr/local/lib" ]; then
      INSTALL_DIR="/usr/local/lib/designlens"
      BIN_DIR="/usr/local/bin"
      SUDO=""
      SYSTEM_WIDE=true
    else
      INSTALL_DIR="$HOME/.local/lib/designlens"
      BIN_DIR="$HOME/.local/bin"
      SUDO=""
      SYSTEM_WIDE=false
      mkdir -p "$BIN_DIR"
    fi

    echo "Installation directory: $INSTALL_DIR"
    echo "Creating installation directory..."
    mkdir -p "$INSTALL_DIR"

    echo "Copying files..."
    cp -r "$SCRIPT_DIR"/bin "$INSTALL_DIR/"
    cp -r "$SCRIPT_DIR"/lib "$INSTALL_DIR/"
    cp -r "$SCRIPT_DIR"/docs "$INSTALL_DIR/"
    cp "$SCRIPT_DIR"/README.md "$INSTALL_DIR/"
    cp "$SCRIPT_DIR"/designlens.json "$INSTALL_DIR/"
    cp "$SCRIPT_DIR"/LICENSE "$INSTALL_DIR/"

    echo "Making scripts executable..."
    chmod +x "$INSTALL_DIR"/bin/designlens
    chmod +x "$INSTALL_DIR"/lib/*.sh

    echo "Creating symlink..."
    ln -sf "$INSTALL_DIR/bin/designlens" "$BIN_DIR/designlens"

    echo "✓ designlens installed successfully!"
    echo ""
    if [ "$SYSTEM_WIDE" = false ]; then
      # Check if ~/.local/bin is in PATH
      if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo "⚠️  $HOME/.local/bin is not in your PATH"
        echo "Add this line to ~/.bashrc, ~/.zshrc, or equivalent:"
        echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
        echo ""
      fi
    fi
    echo "Run 'designlens init' in your project directory to get started."
    ;;

  MINGW*|MSYS*|CYGWIN*)
    echo "Detected Windows environment with Git Bash/WSL..."
    echo "Please run install.ps1 in PowerShell instead:"
    echo "  irm https://raw.githubusercontent.com/ropensci-review-tools/designlens/main/install.ps1 | iex"
    exit 1
    ;;

  *)
    echo "Unsupported OS: $OS"
    exit 1
    ;;
esac
