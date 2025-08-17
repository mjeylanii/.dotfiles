#!/bin/bash

# Hybrid dotfiles setup script
# Keeps essential configs on main drive, others on external

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

DOTFILES_DIR="/Volumes/vaultex/.dotfiles"
HOME_DIR="$HOME"

# Essential configs that should always be available (on main drive)
ESSENTIAL_CONFIGS=(
    ".zshrc"
    ".p10k.zsh"
    ".tool-versions"
    ".config/yabai"
    ".config/skhd"
)

# Non-essential configs (can be on external drive)
NON_ESSENTIAL_CONFIGS=(
    ".config/zed"
    ".oh-my-zsh"
)

print_status "Setting up hybrid dotfiles configuration..."

# Create essential configs directory on main drive
ESSENTIAL_DIR="$HOME_DIR/.dotfiles-essential"
mkdir -p "$ESSENTIAL_DIR"

# Copy essential configs to main drive
for config in "${ESSENTIAL_CONFIGS[@]}"; do
    if [[ -e "$DOTFILES_DIR/$config" ]]; then
        print_status "Copying essential config: $config"
        cp -r "$DOTFILES_DIR/$config" "$ESSENTIAL_DIR/"
    fi
done

# Create .stow-local-ignore for essential configs
cat > "$ESSENTIAL_DIR/.stow-local-ignore" << EOF
.DS_Store
._*
.git
.gitignore
README.*
scripts
EOF

# Stow essential configs from main drive
print_status "Stowing essential configs from main drive..."
cd "$ESSENTIAL_DIR"
stow .

# Stow non-essential configs from external drive (if available)
print_status "Stowing non-essential configs from external drive..."
cd "$DOTFILES_DIR"
for config in "${NON_ESSENTIAL_CONFIGS[@]}"; do
    if [[ -e "$config" ]]; then
        print_status "Stowing non-essential config: $config"
        stow --target="$HOME_DIR" "$(basename "$config")"
    fi
done

print_success "Hybrid setup completed!"
print_status "Essential configs are now on main drive: $ESSENTIAL_DIR"
print_status "Non-essential configs remain on external drive"
print_status "Your system will work even when external drive is unmounted"
