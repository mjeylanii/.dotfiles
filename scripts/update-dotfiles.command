#!/bin/bash

# macOS Dotfiles Update Command
# Double-click this file to update your dotfiles from external drive

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

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

print_status "Starting dotfiles update..."
print_status "Script location: $SCRIPT_DIR"

# Check if we're in the right directory
if [[ ! -f "$SCRIPT_DIR/.stow-local-ignore" ]]; then
    print_error "This script must be run from the dotfiles directory"
    print_error "Please double-click this file from within your dotfiles folder"
    read -p "Press Enter to exit..."
    exit 1
fi

# Check if external drive is mounted
if [[ "$SCRIPT_DIR" == *"/Volumes/"* ]]; then
    print_status "Detected external drive setup"
    print_status "Using external drive update method"
    
    # Run the update script
    if [[ -f "$SCRIPT_DIR/update.sh" ]]; then
        print_status "Running update script..."
        cd "$SCRIPT_DIR"
        ./update.sh
    else
        print_error "Update script not found"
        read -p "Press Enter to exit..."
        exit 1
    fi
else
    print_status "Detected standard location setup"
    print_status "Using standard update method"
    
    # Run git pull and stow
    if command -v git &> /dev/null && command -v stow &> /dev/null; then
        print_status "Pulling latest changes..."
        cd "$SCRIPT_DIR"
        git pull origin main
        
        print_status "Updating dotfiles..."
        stow .
        print_success "Dotfiles updated successfully!"
    else
        print_error "Git or Stow is not installed"
        read -p "Press Enter to exit..."
        exit 1
    fi
fi

print_success "Update completed!"
print_status "You may need to restart your terminal or run 'source ~/.zshrc' to see changes"

# Keep terminal open so user can see the output
read -p "Press Enter to close..."
