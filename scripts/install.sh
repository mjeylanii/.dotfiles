#!/bin/bash

# Dotfiles installation script for external SSD setup
# This script handles stowing dotfiles from an external drive to $HOME

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
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

# Check if stow is installed
if ! command -v stow &> /dev/null; then
    print_error "GNU Stow is not installed. Please install it first:"
    echo "  brew install stow"
    exit 1
fi

# Get current directory and home directory
DOTFILES_DIR="$(pwd)"
HOME_DIR="$HOME"

print_status "Dotfiles directory: $DOTFILES_DIR"
print_status "Home directory: $HOME_DIR"

# Check if dotfiles are on external drive
if [[ "$DOTFILES_DIR" != "$HOME_DIR/.dotfiles" ]]; then
    print_warning "Dotfiles are not in the standard location ($HOME_DIR/.dotfiles)"
    print_status "Using --target option to stow from external location"
    STOW_TARGET="--target=$HOME_DIR"
else
    STOW_TARGET=""
fi

# Backup existing dotfiles if they exist
print_status "Checking for existing dotfiles..."

# List of files that might conflict
CONFLICT_FILES=(
    ".zshrc"
    ".p10k.zsh"
    ".tool-versions"
    ".config/yabai"
    ".config/skhd"
    ".config/zed"
    ".oh-my-zsh"
)

BACKUP_DIR="$HOME_DIR/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

for file in "${CONFLICT_FILES[@]}"; do
    if [[ -e "$HOME_DIR/$file" && ! -L "$HOME_DIR/$file" ]]; then
        print_warning "Backing up existing $file"
        cp -r "$HOME_DIR/$file" "$BACKUP_DIR/"
    fi
done

# Install Oh My Zsh plugins if not already present
print_status "Setting up Oh My Zsh plugins..."

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME_DIR/.oh-my-zsh/custom}"

# Create custom plugins directory if it doesn't exist
mkdir -p "$ZSH_CUSTOM/plugins"

# Clone zsh-autosuggestions if not present
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
    print_status "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
    print_status "zsh-autosuggestions already installed"
fi

# Clone zsh-syntax-highlighting if not present
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
    print_status "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
    print_status "zsh-syntax-highlighting already installed"
fi

# Stow the dotfiles
print_status "Stowing dotfiles..."
if stow $STOW_TARGET --verbose .; then
    print_success "Dotfiles stowed successfully!"
else
    print_error "Failed to stow dotfiles"
    exit 1
fi

# Set up git submodules if they exist
if [[ -f ".gitmodules" ]]; then
    print_status "Setting up git submodules..."
    git submodule update --init --recursive
fi

print_success "Installation completed!"
print_status "Backup of existing files saved to: $BACKUP_DIR"

if [[ "$DOTFILES_DIR" != "$HOME_DIR/.dotfiles" ]]; then
    print_warning "Remember: Your dotfiles are on an external drive at: $DOTFILES_DIR"
    print_status "To update your dotfiles, run stow commands from that directory"
    print_status "Example: cd $DOTFILES_DIR && stow --target=$HOME_DIR ."
fi

print_status "You may need to restart your terminal or run 'source ~/.zshrc' to see changes"
