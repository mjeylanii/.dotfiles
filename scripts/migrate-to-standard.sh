#!/bin/bash

# Migration script to move dotfiles from external drive to standard location

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

# Check if external drive is mounted
if [[ ! -d "/Volumes/vaultex" ]]; then
    print_error "External drive not mounted. Please mount it first."
    exit 1
fi

EXTERNAL_DOTFILES="/Volumes/vaultex/.dotfiles"
STANDARD_DOTFILES="$HOME/.dotfiles"

print_status "Migrating dotfiles from external drive to standard location..."

# Check if standard location already exists
if [[ -d "$STANDARD_DOTFILES" ]]; then
    print_warning "Standard dotfiles directory already exists: $STANDARD_DOTFILES"
    read -p "Do you want to backup and replace it? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
        print_status "Backing up existing dotfiles to: $BACKUP_DIR"
        mv "$STANDARD_DOTFILES" "$BACKUP_DIR"
    else
        print_error "Migration cancelled"
        exit 1
    fi
fi

# Unstow current external setup
print_status "Unstowing current external setup..."
cd "$EXTERNAL_DOTFILES"
stow --target="$HOME" -D .

# Copy dotfiles to standard location
print_status "Copying dotfiles to standard location..."
cp -r "$EXTERNAL_DOTFILES" "$STANDARD_DOTFILES"

# Remove ._ files from the copy
print_status "Cleaning up resource fork files..."
find "$STANDARD_DOTFILES" -name "._*" -delete

# Stow from standard location
print_status "Stowing from standard location..."
cd "$STANDARD_DOTFILES"
stow .

print_success "Migration completed!"
print_status "Your dotfiles are now at: $STANDARD_DOTFILES"
print_status "Your system will work regardless of external drive status"
print_warning "Remember to update your git remote if you want to continue using the external drive as backup"
