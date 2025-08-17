#!/bin/bash

# Auto Create Shortcuts
# This script automatically creates shortcuts in the macOS Shortcuts app

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

print_header "Auto Create macOS Shortcuts"
echo ""

# Check if we're in the right directory
if [[ ! -f "$DOTFILES_DIR/.stow-local-ignore" ]]; then
    print_error "This script must be run from the dotfiles scripts directory"
    read -p "Press Enter to exit..."
    exit 1
fi

print_status "This script will automatically create shortcuts in the macOS Shortcuts app."
print_status "No manual copying and pasting required!"
echo ""

# Check if Shortcuts app is available
if ! command -v shortcuts &> /dev/null; then
    print_warning "Shortcuts CLI not found. Installing..."
    
    # Check if Homebrew is available
    if command -v brew &> /dev/null; then
        print_status "Installing Shortcuts CLI via Homebrew..."
        brew install --cask shortcuts
    else
        print_error "Homebrew not found. Please install Homebrew first:"
        echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        read -p "Press Enter to exit..."
        exit 1
    fi
fi

print_header "Creating Shortcuts"

# Define shortcuts to create
declare -A SHORTCUTS=(
    ["Setup Dotfiles"]="cd \"$DOTFILES_DIR\" && ./scripts/setup-dotfiles.command"
    ["Update Dotfiles"]="cd \"$DOTFILES_DIR\" && ./scripts/update-dotfiles.command"
    ["Check Status"]="cd \"$DOTFILES_DIR\" && ./scripts/check-status.command"
    ["Start Services"]="cd \"$DOTFILES_DIR\" && ./scripts/start-services.command"
    ["Backup Dotfiles"]="cd \"$DOTFILES_DIR\" && ./scripts/backup-dotfiles.command"
    ["Cleanup Dotfiles"]="cd \"$DOTFILES_DIR\" && ./scripts/cleanup-dotfiles.command"
    ["Dotfiles Manager"]="cd \"$DOTFILES_DIR\" && ./dotfiles-manager.command"
)

# Create shortcuts
for shortcut_name in "${!SHORTCUTS[@]}"; do
    script_command="${SHORTCUTS[$shortcut_name]}"
    
    print_status "Creating shortcut: $shortcut_name"
    
    # Create the shortcut using shortcuts CLI
    if shortcuts create "$shortcut_name" --input-text "$script_command" --type shell-script; then
        print_success "Created shortcut: $shortcut_name"
    else
        print_error "Failed to create shortcut: $shortcut_name"
    fi
done

print_header "Creating Advanced Shortcuts"

# Create a menu shortcut
print_status "Creating Dotfiles Menu shortcut..."

MENU_SHORTCUT_NAME="Dotfiles Menu"
MENU_SCRIPT="cd \"$DOTFILES_DIR\" && ./dotfiles-manager.command"

if shortcuts create "$MENU_SHORTCUT_NAME" --input-text "$MENU_SCRIPT" --type shell-script; then
    print_success "Created menu shortcut: $MENU_SHORTCUT_NAME"
else
    print_error "Failed to create menu shortcut"
fi

# Create a smart update shortcut (backup + update)
print_status "Creating Smart Update shortcut..."

SMART_UPDATE_NAME="Smart Update Dotfiles"
SMART_UPDATE_SCRIPT="cd \"$DOTFILES_DIR\" && ./scripts/backup-dotfiles.command && ./scripts/update-dotfiles.command"

if shortcuts create "$SMART_UPDATE_NAME" --input-text "$SMART_UPDATE_SCRIPT" --type shell-script; then
    print_success "Created smart update shortcut: $SMART_UPDATE_NAME"
else
    print_error "Failed to create smart update shortcut"
fi

print_header "Organizing Shortcuts"

# Create a folder for dotfiles shortcuts
print_status "Creating Dotfiles folder in Shortcuts app..."

if shortcuts create-folder "Dotfiles"; then
    print_success "Created Dotfiles folder"
    
    # Move all created shortcuts to the folder
    for shortcut_name in "${!SHORTCUTS[@]}"; do
        if shortcuts move "$shortcut_name" "Dotfiles"; then
            print_success "Moved $shortcut_name to Dotfiles folder"
        fi
    done
    
    # Move advanced shortcuts
    shortcuts move "$MENU_SHORTCUT_NAME" "Dotfiles" 2>/dev/null
    shortcuts move "$SMART_UPDATE_NAME" "Dotfiles" 2>/dev/null
    
else
    print_warning "Could not create folder (might already exist)"
fi

print_header "Adding to Menu Bar"

print_status "Adding shortcuts to menu bar for easy access..."

# Add the main menu shortcut to menu bar
if shortcuts add-to-menu-bar "$MENU_SHORTCUT_NAME"; then
    print_success "Added $MENU_SHORTCUT_NAME to menu bar"
else
    print_warning "Could not add to menu bar (might need manual setup)"
fi

print_header "Creating Desktop Shortcuts"

print_status "Creating desktop shortcuts for easy access..."

# Create desktop shortcuts using .command files
DESKTOP_DIR="$HOME/Desktop"

# Create desktop shortcuts
for shortcut_name in "${!SHORTCUTS[@]}"; do
    script_command="${SHORTCUTS[$shortcut_name]}"
    
    # Create .command file
    command_file="$DESKTOP_DIR/$shortcut_name.command"
    
    cat > "$command_file" << EOF
#!/bin/bash
$script_command
read -p "Press Enter to close..."
EOF
    
    chmod +x "$command_file"
    print_success "Created desktop shortcut: $shortcut_name"
done

print_header "Shortcuts Created Successfully!"

echo "✅ Created ${#SHORTCUTS[@]} shortcuts in Shortcuts app"
echo "✅ Created desktop shortcuts for easy access"
echo "✅ Organized shortcuts in 'Dotfiles' folder"
echo "✅ Added menu bar shortcut for quick access"
echo ""

print_status "You can now access your dotfiles shortcuts via:"
echo ""
echo "1. ${CYAN}Shortcuts App${NC} - Open Shortcuts app and look for 'Dotfiles' folder"
echo "2. ${CYAN}Menu Bar${NC} - Click the shortcuts icon in the menu bar"
echo "3. ${CYAN}Desktop${NC} - Double-click any .command file on your desktop"
echo "4. ${CYAN}Siri${NC} - Say 'Hey Siri, run [shortcut name]'"
echo "5. ${CYAN}Spotlight${NC} - Search for shortcut names"
echo ""

print_status "Available shortcuts:"
for shortcut_name in "${!SHORTCUTS[@]}"; do
    echo "  • $shortcut_name"
done
echo "  • $MENU_SHORTCUT_NAME"
echo "  • $SMART_UPDATE_NAME"
echo ""

print_success "All shortcuts created automatically! No manual work required!"
echo ""
read -p "Press Enter to close..."
