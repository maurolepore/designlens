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

    INSTALL_DIR="$HOME/.local/share/designlens"
    BIN_DIR="$HOME/.local/bin"
    mkdir -p "$BIN_DIR"

    echo "Installation directory: $INSTALL_DIR"
    echo "Creating installation directory..."
    mkdir -p "$INSTALL_DIR"

    echo "Copying files..."
    cp -r "$SCRIPT_DIR"/bin "$INSTALL_DIR/"
    cp -r "$SCRIPT_DIR"/lib "$INSTALL_DIR/"
    cp -r "$SCRIPT_DIR"/docs "$INSTALL_DIR/"
    cp -r "$SCRIPT_DIR"/commands "$INSTALL_DIR/"
    cp "$SCRIPT_DIR"/README.md "$INSTALL_DIR/"
    cp "$SCRIPT_DIR"/designlens.json "$INSTALL_DIR/"
    cp "$SCRIPT_DIR"/LICENSE "$INSTALL_DIR/"

    echo "Making scripts executable..."
    chmod +x "$INSTALL_DIR"/bin/designlens
    find "$INSTALL_DIR/lib" -name "*.sh" -exec chmod +x {} \;

    echo "Creating symlink..."
    ln -sf "$INSTALL_DIR/bin/designlens" "$BIN_DIR/designlens"

    echo "✓ designlens installed successfully!"
    echo ""
    # Check if ~/.local/bin is in PATH
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
      echo "⚠️  $HOME/.local/bin is not in your PATH"
      echo "Add this line to ~/.bashrc, ~/.zshrc, or equivalent:"
      echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
      echo ""
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
