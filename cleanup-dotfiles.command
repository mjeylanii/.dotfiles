#!/bin/bash

# macOS Cleanup Dotfiles
# Double-click to clean up broken symlinks and old backups

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

print_header "Dotfiles Cleanup Utility"
echo ""

# Check if we're in the right directory
if [[ ! -f "$SCRIPT_DIR/.stow-local-ignore" ]]; then
    print_error "This script must be run from the dotfiles directory"
    read -p "Press Enter to exit..."
    exit 1
fi

print_status "This utility will help you clean up:"
echo "  1. Broken symlinks"
echo "  2. Old dotfiles backups"
echo "  3. Temporary files"
echo ""

read -p "Do you want to continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_status "Cleanup cancelled"
    read -p "Press Enter to exit..."
    exit 0
fi

echo ""

print_header "1. Finding Broken Symlinks"

# Find broken symlinks in home directory
broken_symlinks=()
while IFS= read -r -d '' symlink; do
    broken_symlinks+=("$symlink")
done < <(find "$HOME" -maxdepth 2 -type l -name ".*" -print0 2>/dev/null | xargs -0 -I {} sh -c 'test ! -e "{}" && echo "{}"' 2>/dev/null)

if [[ ${#broken_symlinks[@]} -eq 0 ]]; then
    print_success "No broken symlinks found"
else
    print_warning "Found ${#broken_symlinks[@]} broken symlink(s):"
    for symlink in "${broken_symlinks[@]}"; do
        echo "  $symlink"
    done
    
    echo ""
    read -p "Remove broken symlinks? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        removed_count=0
        for symlink in "${broken_symlinks[@]}"; do
            if rm "$symlink" 2>/dev/null; then
                print_success "Removed: $symlink"
                ((removed_count++))
            else
                print_error "Failed to remove: $symlink"
            fi
        done
        print_status "Removed $removed_count broken symlink(s)"
    else
        print_status "Skipped broken symlink removal"
    fi
fi

echo ""

print_header "2. Finding Old Backups"

# Find old backup directories
backup_dirs=()
while IFS= read -r -d '' dir; do
    backup_dirs+=("$dir")
done < <(find "$HOME" -maxdepth 1 -type d -name ".dotfiles_backup_*" -print0 2>/dev/null)

if [[ ${#backup_dirs[@]} -eq 0 ]]; then
    print_success "No old backups found"
else
    print_warning "Found ${#backup_dirs[@]} old backup(s):"
    total_size=0
    for dir in "${backup_dirs[@]}"; do
        size=$(du -sh "$dir" 2>/dev/null | cut -f1)
        date=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M" "$dir" 2>/dev/null)
        echo "  $dir ($size, created: $date)"
        # Calculate total size (rough estimate)
        dir_size=$(du -sk "$dir" 2>/dev/null | cut -f1)
        total_size=$((total_size + dir_size))
    done
    
    total_size_human=$(numfmt --to=iec-i --suffix=B $((total_size * 1024)) 2>/dev/null || echo "${total_size}KB")
    print_status "Total backup size: $total_size_human"
    
    echo ""
    read -p "Remove old backups? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        removed_count=0
        for dir in "${backup_dirs[@]}"; do
            if rm -rf "$dir" 2>/dev/null; then
                print_success "Removed: $dir"
                ((removed_count++))
            else
                print_error "Failed to remove: $dir"
            fi
        done
        print_status "Removed $removed_count backup(s)"
    else
        print_status "Skipped backup removal"
    fi
fi

echo ""

print_header "3. Finding Temporary Files"

# Find temporary files in dotfiles directory
temp_files=()
while IFS= read -r -d '' file; do
    temp_files+=("$file")
done < <(find "$SCRIPT_DIR" -maxdepth 3 -type f \( -name "*.tmp" -o -name "*.temp" -o -name "*~" -o -name ".#*" \) -print0 2>/dev/null)

if [[ ${#temp_files[@]} -eq 0 ]]; then
    print_success "No temporary files found"
else
    print_warning "Found ${#temp_files[@]} temporary file(s):"
    for file in "${temp_files[@]}"; do
        relative_path=$(echo "$file" | sed "s|$SCRIPT_DIR/||")
        echo "  $relative_path"
    done
    
    echo ""
    read -p "Remove temporary files? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        removed_count=0
        for file in "${temp_files[@]}"; do
            if rm "$file" 2>/dev/null; then
                relative_path=$(echo "$file" | sed "s|$SCRIPT_DIR/||")
                print_success "Removed: $relative_path"
                ((removed_count++))
            else
                print_error "Failed to remove: $file"
            fi
        done
        print_status "Removed $removed_count temporary file(s)"
    else
        print_status "Skipped temporary file removal"
    fi
fi

echo ""

print_header "4. System Cleanup"

# Check for other cleanup opportunities
print_status "Checking for other cleanup opportunities..."

# Check for old Homebrew packages
if command -v brew &> /dev/null; then
    print_status "Homebrew cleanup available:"
    echo "  brew cleanup"
    echo "  brew autoremove"
fi

# Check for old log files
log_count=$(find /var/log -name "*.log.*" -mtime +30 2>/dev/null | wc -l | tr -d ' ')
if [[ $log_count -gt 0 ]]; then
    print_status "Old log files found: $log_count files older than 30 days"
    echo "  Consider: sudo find /var/log -name '*.log.*' -mtime +30 -delete"
fi

echo ""

print_header "Cleanup Summary"

# Show disk usage before and after
print_status "Current disk usage:"
df -h "$HOME" | tail -1

echo ""
print_header "Cleanup Complete"
print_status "Your dotfiles environment has been cleaned up!"
read -p "Press Enter to close..."
