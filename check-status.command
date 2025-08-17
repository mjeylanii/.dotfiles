#!/bin/bash

# macOS Dotfiles Status Check
# Double-click to check the status of your dotfiles and system

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
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

print_header "Dotfiles Status Check"
echo ""

# Check if we're in the right directory
if [[ ! -f "$SCRIPT_DIR/.stow-local-ignore" ]]; then
    print_error "This script must be run from the dotfiles directory"
    read -p "Press Enter to exit..."
    exit 1
fi

print_header "System Information"
print_status "Script location: $SCRIPT_DIR"
print_status "Home directory: $HOME"
print_status "User: $(whoami)"
print_status "Shell: $SHELL"
print_status "Terminal: $TERM_PROGRAM"

echo ""

print_header "Required Tools Check"

# Check for required tools
TOOLS=("git" "stow" "zsh" "brew")
for tool in "${TOOLS[@]}"; do
    if command -v "$tool" &> /dev/null; then
        print_success "$tool is installed ($(which $tool))"
    else
        print_error "$tool is not installed"
    fi
done

echo ""

print_header "Dotfiles Status"

# Check git status
if [[ -d "$SCRIPT_DIR/.git" ]]; then
    cd "$SCRIPT_DIR"
    print_status "Git repository status:"
    git status --porcelain | while read line; do
        if [[ -n "$line" ]]; then
            print_warning "  $line"
        fi
    done
    
    if [[ -z "$(git status --porcelain)" ]]; then
        print_success "Working directory is clean"
    fi
    
    print_status "Current branch: $(git branch --show-current)"
    print_status "Last commit: $(git log -1 --format='%h - %s (%cr)')"
else
    print_error "Not a git repository"
fi

echo ""

print_header "Symlink Status"

# Check key symlinks
SYMLINKS=(
    ".zshrc"
    ".p10k.zsh"
    ".tool-versions"
    ".config/yabai"
    ".config/skhd"
    ".config/zed"
)

for symlink in "${SYMLINKS[@]}"; do
    if [[ -L "$HOME/$symlink" ]]; then
        target=$(readlink "$HOME/$symlink")
        if [[ -e "$HOME/$symlink" ]]; then
            print_success "$symlink → $target"
        else
            print_error "$symlink → $target (broken)"
        fi
    elif [[ -e "$HOME/$symlink" ]]; then
        print_warning "$symlink exists but is not a symlink"
    else
        print_error "$symlink does not exist"
    fi
done

echo ""

print_header "External Drive Status"

if [[ "$SCRIPT_DIR" == *"/Volumes/"* ]]; then
    print_status "Dotfiles are on external drive: $SCRIPT_DIR"
    
    # Check if drive is mounted
    drive_path=$(echo "$SCRIPT_DIR" | cut -d'/' -f1-3)
    if [[ -d "$drive_path" ]]; then
        print_success "External drive is mounted"
        
        # Check available space
        available_space=$(df -h "$drive_path" | tail -1 | awk '{print $4}')
        print_status "Available space: $available_space"
    else
        print_error "External drive is not mounted"
    fi
else
    print_status "Dotfiles are in standard location"
fi

echo ""

print_header "Services Status"

# Check if yabai and skhd are running
if pgrep -x "yabai" > /dev/null; then
    print_success "Yabai is running"
else
    print_error "Yabai is not running"
fi

if pgrep -x "skhd" > /dev/null; then
    print_success "SKHD is running"
else
    print_error "SKHD is not running"
fi

echo ""

print_header "Recommendations"

# Provide recommendations based on status
if [[ "$SCRIPT_DIR" == *"/Volumes/"* ]]; then
    print_status "External drive detected - consider using hybrid setup for reliability"
fi

if ! command -v stow &> /dev/null; then
    print_warning "Install GNU Stow: brew install stow"
fi

if ! command -v git &> /dev/null; then
    print_warning "Install Git: brew install git"
fi

echo ""
print_header "Status Check Complete"
read -p "Press Enter to close..."
