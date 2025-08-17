#!/bin/bash

# Dotfiles update script for external SSD setup
# This script makes it easy to update dotfiles from an external drive

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in the right directory
if [[ ! -f ".stow-local-ignore" ]]; then
    print_error "This script must be run from the dotfiles directory"
    exit 1
fi

# Get current directory and home directory
DOTFILES_DIR="$(pwd)"
HOME_DIR="$HOME"

print_status "Updating dotfiles from: $DOTFILES_DIR"

# Check if dotfiles are on external drive
if [[ "$DOTFILES_DIR" != "$HOME_DIR/.dotfiles" ]]; then
    print_status "Using --target option for external drive setup"
    STOW_TARGET="--target=$HOME_DIR"
else
    STOW_TARGET=""
fi

# Update git repository
print_status "Updating git repository..."
git pull origin main

# Update submodules if they exist
if [[ -f ".gitmodules" ]]; then
    print_status "Updating git submodules..."
    git submodule update --init --recursive
fi

# Restow the dotfiles
print_status "Restowing dotfiles..."
if stow $STOW_TARGET --verbose .; then
    print_success "Dotfiles updated successfully!"
else
    print_error "Failed to update dotfiles"
    exit 1
fi

print_success "Update completed!"
print_status "You may need to restart your terminal or run 'source ~/.zshrc' to see changes"
