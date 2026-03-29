#!/bin/bash
set -e

REPO="ropensci-review-tools/designlens"
BRANCH="main"
ARCHIVE_URL="https://github.com/$REPO/archive/refs/heads/$BRANCH.tar.gz"

# Detect OS
OS="$(uname -s)"

case "$OS" in
  Darwin|Linux)
    echo "Installing designlens for $OS..."

    # Download archive to a temp directory
    TMP_DIR="$(mktemp -d)"
    trap 'rm -rf "$TMP_DIR"' EXIT

    echo "Downloading designlens..."
    curl -fsSL "$ARCHIVE_URL" | tar -xz -C "$TMP_DIR" --strip-components=1

    SCRIPT_DIR="$TMP_DIR"

    source "$SCRIPT_DIR/lib/logo.sh"
    show_logo

    # Try system-wide installation first, fall back to user local
    if [ -w "/usr/local/lib" ]; then
      INSTALL_DIR="/usr/local/lib/designlens"
      BIN_DIR="/usr/local/bin"
      SYSTEM_WIDE=true
      SUDO=""
    elif command -v sudo &>/dev/null && sudo -v 2>/dev/null; then
      echo "System-wide installation requires sudo..."
      INSTALL_DIR="/usr/local/lib/designlens"
      BIN_DIR="/usr/local/bin"
      SYSTEM_WIDE=true
      SUDO="sudo"
    else
      INSTALL_DIR="$HOME/.local/lib/designlens"
      BIN_DIR="$HOME/.local/bin"
      SYSTEM_WIDE=false
      SUDO=""
      mkdir -p "$BIN_DIR"
    fi

    echo "Installation directory: $INSTALL_DIR"
    echo "Creating installation directory..."
    $SUDO mkdir -p "$INSTALL_DIR"

    echo "Copying files..."
    $SUDO cp -r "$SCRIPT_DIR"/bin "$INSTALL_DIR/"
    $SUDO cp -r "$SCRIPT_DIR"/lib "$INSTALL_DIR/"
    $SUDO cp -r "$SCRIPT_DIR"/docs "$INSTALL_DIR/"
    $SUDO cp "$SCRIPT_DIR"/README.md "$INSTALL_DIR/"
    $SUDO cp "$SCRIPT_DIR"/designlens.json "$INSTALL_DIR/"
    $SUDO cp "$SCRIPT_DIR"/LICENSE "$INSTALL_DIR/"

    echo "Making scripts executable..."
    $SUDO chmod +x "$INSTALL_DIR"/bin/designlens
    $SUDO chmod +x "$INSTALL_DIR"/lib/*.sh

    echo "Creating symlink..."
    $SUDO ln -sf "$INSTALL_DIR/bin/designlens" "$BIN_DIR/designlens"

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
