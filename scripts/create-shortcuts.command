#!/bin/bash

# Create Shortcuts App Shortcuts
# This script helps you create shortcuts for the macOS Shortcuts app

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

print_header "Shortcuts App Integration Helper"
echo ""

# Check if we're in the right directory
if [[ ! -f "$SCRIPT_DIR/.stow-local-ignore" ]]; then
    print_error "This script must be run from the dotfiles directory"
    read -p "Press Enter to exit..."
    exit 1
fi

print_status "This script will help you create shortcuts for the macOS Shortcuts app."
print_status "Your dotfiles location: $SCRIPT_DIR"
echo ""

print_header "Available Commands"

echo "1. Setup Dotfiles - Install/configure dotfiles"
echo "2. Update Dotfiles - Update from git repository"
echo "3. Check Status - Check system and dotfiles status"
echo "4. Start Services - Start window management services"
echo "5. Backup Dotfiles - Create backup of current config"
echo "6. Cleanup Dotfiles - Clean up broken links and old files"
echo ""

print_header "Shortcuts App Instructions"

echo "To add these to the Shortcuts app:"
echo ""
echo "1. Open the Shortcuts app"
echo "2. Click the + button to create a new shortcut"
echo "3. Search for 'Run Shell Script' and add it"
echo "4. Configure the script with one of the commands below:"
echo ""

print_header "Script Commands"

echo "For each shortcut, use this script command:"
echo ""

echo "📁 Setup Dotfiles:"
echo "cd \"$SCRIPT_DIR\" && ./setup-dotfiles.command"
echo ""

echo "🔄 Update Dotfiles:"
echo "cd \"$SCRIPT_DIR\" && ./update-dotfiles.command"
echo ""

echo "📊 Check Status:"
echo "cd \"$SCRIPT_DIR\" && ./check-status.command"
echo ""

echo "🎯 Start Services:"
echo "cd \"$SCRIPT_DIR\" && ./start-services.command"
echo ""

echo "💾 Backup Dotfiles:"
echo "cd \"$SCRIPT_DIR\" && ./backup-dotfiles.command"
echo ""

echo "🧹 Cleanup Dotfiles:"
echo "cd \"$SCRIPT_DIR\" && ./cleanup-dotfiles.command"
echo ""

print_header "Advanced Shortcuts"

echo "Smart Update (Backup + Update):"
echo "cd \"$SCRIPT_DIR\" && ./backup-dotfiles.command && ./update-dotfiles.command"
echo ""

echo "Conditional Setup (Check drive first):"
echo "if [ -d \"$SCRIPT_DIR\" ]; then cd \"$SCRIPT_DIR\" && ./setup-dotfiles.command; else echo 'Drive not mounted'; fi"
echo ""

print_header "Shortcuts App Configuration"

echo "For each shortcut in the Shortcuts app:"
echo "1. Set Shell to: /bin/bash"
echo "2. Set 'Pass input' to: as arguments"
echo "3. Copy the script command above into the script field"
echo "4. Name your shortcut (e.g., 'Setup Dotfiles')"
echo "5. Click Done to save"
echo ""

print_header "Access Methods"

echo "Once created, you can access your shortcuts via:"
echo "• Shortcuts app directly"
echo "• Menu bar (if enabled in System Preferences)"
echo "• Dock (right-click shortcut → Add to Dock)"
echo "• Keyboard shortcuts (System Preferences → Keyboard → Shortcuts)"
echo "• Siri voice commands (right-click shortcut → Add to Siri)"
echo "• Spotlight search"
echo ""

print_header "Troubleshooting"

echo "If shortcuts don't work:"
echo "1. Check that the external drive is mounted"
echo "2. Verify the path is correct: $SCRIPT_DIR"
echo "3. Ensure .command files are executable"
echo "4. Check System Preferences → Security & Privacy → Privacy"
echo "   - Add Shortcuts to Accessibility or Full Disk Access"
echo ""

print_header "Quick Copy Commands"

echo "Here are all commands ready to copy:"
echo ""

echo "=== SETUP DOTFILES ==="
echo "cd \"$SCRIPT_DIR\" && ./setup-dotfiles.command"
echo ""

echo "=== UPDATE DOTFILES ==="
echo "cd \"$SCRIPT_DIR\" && ./update-dotfiles.command"
echo ""

echo "=== CHECK STATUS ==="
echo "cd \"$SCRIPT_DIR\" && ./check-status.command"
echo ""

echo "=== START SERVICES ==="
echo "cd \"$SCRIPT_DIR\" && ./start-services.command"
echo ""

echo "=== BACKUP DOTFILES ==="
echo "cd \"$SCRIPT_DIR\" && ./backup-dotfiles.command"
echo ""

echo "=== CLEANUP DOTFILES ==="
echo "cd \"$SCRIPT_DIR\" && ./cleanup-dotfiles.command"
echo ""

echo "=== SMART UPDATE ==="
echo "cd \"$SCRIPT_DIR\" && ./backup-dotfiles.command && ./update-dotfiles.command"
echo ""

print_success "Shortcuts integration guide complete!"
print_status "See SHORTCUTS_APP_GUIDE.md for detailed instructions"
echo ""
read -p "Press Enter to close..."
