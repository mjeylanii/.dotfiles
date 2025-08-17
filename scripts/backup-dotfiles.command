#!/bin/bash

# macOS Backup Dotfiles
# Double-click to create a backup of your current dotfiles

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${PURPLE}================================${NC}"
    echo -e "${PURPLE}$1${NC}"
    echo -e "${PURPLE}================================${NC}"
}

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

print_header "Dotfiles Backup Utility"
echo ""

# Check if we're in the right directory
if [[ ! -f "$SCRIPT_DIR/.stow-local-ignore" ]]; then
    print_error "This script must be run from the dotfiles directory"
    read -p "Press Enter to exit..."
    exit 1
fi

# Create backup directory with timestamp
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
print_status "Creating backup directory: $BACKUP_DIR"

if mkdir -p "$BACKUP_DIR"; then
    print_success "Backup directory created"
else
    print_error "Failed to create backup directory"
    read -p "Press Enter to exit..."
    exit 1
fi

echo ""

print_header "Backing Up Current Configuration"

# List of files to backup
BACKUP_FILES=(
    ".zshrc"
    ".p10k.zsh"
    ".tool-versions"
    ".config/yabai"
    ".config/skhd"
    ".config/zed"
    ".oh-my-zsh"
)

backup_count=0
error_count=0

for file in "${BACKUP_FILES[@]}"; do
    if [[ -e "$HOME/$file" ]]; then
        print_status "Backing up $file..."
        
        # Create parent directories if needed
        parent_dir=$(dirname "$BACKUP_DIR/$file")
        mkdir -p "$parent_dir"
        
        if cp -r "$HOME/$file" "$BACKUP_DIR/$file" 2>/dev/null; then
            print_success "  ✓ $file"
            ((backup_count++))
        else
            print_error "  ✗ $file (failed)"
            ((error_count++))
        fi
    else
        print_warning "  - $file (not found)"
    fi
done

echo ""

print_header "Backup Summary"

print_status "Backup location: $BACKUP_DIR"
print_status "Files backed up: $backup_count"
if [[ $error_count -gt 0 ]]; then
    print_warning "Errors: $error_count"
fi

# Show backup directory contents
echo ""
print_status "Backup contents:"
if [[ -d "$BACKUP_DIR" ]]; then
    find "$BACKUP_DIR" -type f | while read file; do
        relative_path=$(echo "$file" | sed "s|$BACKUP_DIR/||")
        file_size=$(du -h "$file" | cut -f1)
        print_status "  $relative_path ($file_size)"
    done
fi

echo ""

print_header "Backup Verification"

# Verify backup integrity
verification_errors=0
for file in "${BACKUP_FILES[@]}"; do
    if [[ -e "$HOME/$file" && -e "$BACKUP_DIR/$file" ]]; then
        if diff -r "$HOME/$file" "$BACKUP_DIR/$file" >/dev/null 2>&1; then
            print_success "$file - backup verified"
        else
            print_error "$file - backup differs from original"
            ((verification_errors++))
        fi
    fi
done

if [[ $verification_errors -eq 0 ]]; then
    print_success "All backups verified successfully"
else
    print_warning "$verification_errors backup(s) have differences"
fi

echo ""

print_header "Restore Instructions"

print_status "To restore from this backup:"
echo "  1. Unstow current dotfiles: stow -D ."
echo "  2. Copy from backup: cp -r $BACKUP_DIR/* ~/"
echo "  3. Restow dotfiles: stow ."
echo ""
print_status "Or use the restore command:"
echo "  cp -r $BACKUP_DIR/* ~/"

echo ""

print_header "Cleanup"

print_status "To remove old backups:"
echo "  rm -rf ~/.dotfiles_backup_*"
echo ""
print_status "To list all backups:"
echo "  ls -la ~/.dotfiles_backup_*"

echo ""
print_header "Backup Complete"
read -p "Press Enter to close..."
