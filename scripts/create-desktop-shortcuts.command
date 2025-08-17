#!/bin/bash

# Create Desktop Shortcuts
# This script creates desktop shortcuts for easy access to dotfiles operations

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
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

print_header "Create Desktop Shortcuts"
echo ""

# Check if we're in the right directory
if [[ ! -f "$DOTFILES_DIR/.stow-local-ignore" ]]; then
    print_error "This script must be run from the dotfiles scripts directory"
    read -p "Press Enter to exit..."
    exit 1
fi

print_status "This script will create desktop shortcuts for easy access to dotfiles operations."
print_status "No manual work required - just double-click to run!"
echo ""

# Create shortcuts directory on desktop
DESKTOP_DIR="$HOME/Desktop"
SHORTCUTS_DIR="$DESKTOP_DIR/Dotfiles Shortcuts"

print_status "Creating shortcuts directory: $SHORTCUTS_DIR"

if [[ ! -d "$SHORTCUTS_DIR" ]]; then
    mkdir -p "$SHORTCUTS_DIR"
    print_success "Created shortcuts directory"
else
    print_status "Shortcuts directory already exists"
fi

print_header "Creating Desktop Shortcuts"

# Define shortcuts to create
declare -A SHORTCUTS=(
    ["Setup Dotfiles"]="cd \"$DOTFILES_DIR\" && ./scripts/setup-dotfiles.command"
    ["Update Dotfiles"]="cd \"$DOTFILES_DIR\" && ./scripts/update-dotfiles.command"
    ["Check Status"]="cd \"$DOTFILES_DIR\" && ./scripts/check-status.command"
    ["Start Services"]="cd \"$DOTFILES_DIR\" && ./scripts/start-services.command"
    ["Backup Dotfiles"]="cd \"$DOTFILES_DIR\" && ./scripts/backup-dotfiles.command"
    ["Cleanup Dotfiles"]="cd \"$DOTFILES_DIR\" && ./scripts/cleanup-dotfiles.command"
    ["Clean Repository"]="cd \"$DOTFILES_DIR\" && ./scripts/clean-dotfiles.command"
    ["Dotfiles Manager"]="cd \"$DOTFILES_DIR\" && ./dotfiles-manager.command"
)

# Create shortcuts
for shortcut_name in "${!SHORTCUTS[@]}"; do
    script_command="${SHORTCUTS[$shortcut_name]}"
    
    # Create .command file
    command_file="$SHORTCUTS_DIR/$shortcut_name.command"
    
    cat > "$command_file" << EOF
#!/bin/bash

# $shortcut_name
# Auto-generated shortcut for dotfiles management

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "\${BLUE}Running: $shortcut_name${NC}"
echo ""

$script_command

echo ""
echo -e "\${GREEN}Operation completed!${NC}"
read -p "Press Enter to close..."
EOF
    
    chmod +x "$command_file"
    print_success "Created: $shortcut_name"
done

print_header "Creating Advanced Shortcuts"

# Create a smart update shortcut (backup + update)
SMART_UPDATE_FILE="$SHORTCUTS_DIR/Smart Update Dotfiles.command"

cat > "$SMART_UPDATE_FILE" << 'EOF'
#!/bin/bash

# Smart Update Dotfiles
# Backup and update in one operation

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}Smart Update: Backup + Update${NC}"
echo ""

# Get dotfiles directory
DOTFILES_DIR="/Volumes/vaultex/.dotfiles"

if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo -e "${YELLOW}Warning: External drive not mounted${NC}"
    echo "Attempting to use local dotfiles..."
    DOTFILES_DIR="$HOME/.dotfiles"
fi

if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo -e "${YELLOW}Error: Dotfiles directory not found${NC}"
    read -p "Press Enter to close..."
    exit 1
fi

echo -e "${BLUE}Step 1: Creating backup...${NC}"
cd "$DOTFILES_DIR" && ./scripts/backup-dotfiles.command

echo ""
echo -e "${BLUE}Step 2: Updating dotfiles...${NC}"
cd "$DOTFILES_DIR" && ./scripts/update-dotfiles.command

echo ""
echo -e "${GREEN}Smart update completed!${NC}"
read -p "Press Enter to close..."
EOF

chmod +x "$SMART_UPDATE_FILE"
print_success "Created: Smart Update Dotfiles"

# Create a quick status check shortcut
QUICK_STATUS_FILE="$SHORTCUTS_DIR/Quick Status Check.command"

cat > "$QUICK_STATUS_FILE" << 'EOF'
#!/bin/bash

# Quick Status Check
# Fast system status check

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}Quick Status Check${NC}"
echo ""

# Get dotfiles directory
DOTFILES_DIR="/Volumes/vaultex/.dotfiles"

if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo -e "${YELLOW}External drive not mounted${NC}"
    DOTFILES_DIR="$HOME/.dotfiles"
fi

if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo -e "${RED}Error: Dotfiles directory not found${NC}"
    read -p "Press Enter to close..."
    exit 1
fi

# Quick checks
echo -e "${BLUE}Checking essential components...${NC}"

# Check if git is available
if command -v git &> /dev/null; then
    echo -e "${GREEN}✓ Git is available${NC}"
else
    echo -e "${RED}✗ Git not found${NC}"
fi

# Check if stow is available
if command -v stow &> /dev/null; then
    echo -e "${GREEN}✓ Stow is available${NC}"
else
    echo -e "${RED}✗ Stow not found${NC}"
fi

# Check if zsh is available
if command -v zsh &> /dev/null; then
    echo -e "${GREEN}✓ Zsh is available${NC}"
else
    echo -e "${RED}✗ Zsh not found${NC}"
fi

# Check if brew is available
if command -v brew &> /dev/null; then
    echo -e "${GREEN}✓ Homebrew is available${NC}"
else
    echo -e "${RED}✗ Homebrew not found${NC}"
fi

# Check external drive
if [[ -d "/Volumes/vaultex" ]]; then
    echo -e "${GREEN}✓ External drive is mounted${NC}"
else
    echo -e "${YELLOW}! External drive not mounted${NC}"
fi

# Check yabai service
if pgrep -x "yabai" > /dev/null; then
    echo -e "${GREEN}✓ Yabai is running${NC}"
else
    echo -e "${YELLOW}! Yabai is not running${NC}"
fi

# Check skhd service
if pgrep -x "skhd" > /dev/null; then
    echo -e "${GREEN}✓ SKHD is running${NC}"
else
    echo -e "${YELLOW}! SKHD is not running${NC}"
fi

echo ""
echo -e "${GREEN}Quick status check completed!${NC}"
read -p "Press Enter to close..."
EOF

chmod +x "$QUICK_STATUS_FILE"
print_success "Created: Quick Status Check"

print_header "Creating README File"

# Create a README file in the shortcuts directory
README_FILE="$SHORTCUTS_DIR/README.txt"

cat > "$README_FILE" << 'EOF'
Dotfiles Desktop Shortcuts
==========================

These shortcuts provide easy access to dotfiles management operations.
Simply double-click any shortcut to run it.

Available Shortcuts:
-------------------

1. Setup Dotfiles - Initial dotfiles installation
2. Update Dotfiles - Update from git repository
3. Check Status - Comprehensive system status check
4. Start Services - Start window management services
5. Backup Dotfiles - Create backup of current config
6. Cleanup Dotfiles - Clean up broken links and old files
7. Clean Repository - Remove ._ files and other unwanted files
8. Dotfiles Manager - Interactive menu for all operations
9. Smart Update Dotfiles - Backup + update in one operation
10. Quick Status Check - Fast system status check

Usage:
------
• Double-click any shortcut to run it
• All shortcuts will show progress and wait for you to press Enter
• The shortcuts directory can be moved anywhere on your desktop
• You can add these shortcuts to your Dock for even easier access

Tips:
-----
• Keep this shortcuts folder on your desktop for easy access
• You can rename shortcuts if you prefer different names
• All shortcuts are safe to run multiple times
• If you get permission errors, right-click and select "Open"

For more information, see the documentation in your dotfiles repository.
EOF

print_success "Created README file"

print_header "Shortcuts Created Successfully!"

echo "✅ Created ${#SHORTCUTS[@]} basic shortcuts"
echo "✅ Created 2 advanced shortcuts"
echo "✅ Created shortcuts directory: $SHORTCUTS_DIR"
echo "✅ Created README file with instructions"
echo ""

print_status "Your shortcuts are now available at:"
echo "  $SHORTCUTS_DIR"
echo ""

print_status "You can access them by:"
echo "1. ${CYAN}Double-clicking${NC} any shortcut in the folder"
echo "2. ${CYAN}Adding to Dock${NC} - Drag shortcuts to your Dock"
echo "3. ${CYAN}Creating aliases${NC} - Right-click → Make Alias"
echo "4. ${CYAN}Moving the folder${NC} - Drag the folder anywhere"
echo ""

print_status "Available shortcuts:"
for shortcut_name in "${!SHORTCUTS[@]}"; do
    echo "  • $shortcut_name"
done
echo "  • Smart Update Dotfiles"
echo "  • Quick Status Check"
echo ""

print_success "All shortcuts created! No manual work required!"
print_status "Open the 'Dotfiles Shortcuts' folder on your desktop to get started."
echo ""
read -p "Press Enter to close..."
