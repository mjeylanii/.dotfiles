#!/bin/bash

# Dotfiles Manager
# Master script to manage all dotfiles operations

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Check if colors are supported
if [[ -t 1 ]] && [[ -n "$TERM" ]] && [[ "$TERM" != "dumb" ]]; then
    # Colors are supported
    USE_COLORS=true
else
    # Colors are not supported
    USE_COLORS=false
fi

# Function to print colored text only if colors are supported
print_color() {
    if [[ "$USE_COLORS" == "true" ]]; then
        echo -e "$1"
    else
        # Strip color codes and print plain text
        echo "$1" | sed 's/\x1b\[[0-9;]*m//g'
    fi
}

print_header() {
    print_color "${PURPLE}================================${NC}"
    print_color "${PURPLE}$1${NC}"
    print_color "${PURPLE}================================${NC}"
}

print_status() {
    print_color "${BLUE}[INFO]${NC} $1"
}

print_success() {
    print_color "${GREEN}[✓]${NC} $1"
}

print_warning() {
    print_color "${YELLOW}[!]${NC} $1"
}

print_error() {
    print_color "${RED}[✗]${NC} $1"
}

print_menu_item() {
    print_color "${CYAN}$1${NC}"
}

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$SCRIPT_DIR/scripts"

# Check if we're in the right directory
if [[ ! -f "$SCRIPT_DIR/.stow-local-ignore" ]]; then
    print_error "This script must be run from the dotfiles directory"
    read -p "Press Enter to exit..."
    exit 1
fi

# Function to show main menu
show_main_menu() {
    clear
    print_header "Dotfiles Manager"
    echo ""
    print_status "Welcome to your dotfiles management system!"
    print_status "Choose an option to manage your dotfiles:"
    echo ""
    
    print_color "1. ${CYAN}Setup & Installation${NC}"
    echo "   • Install dotfiles"
    echo "   • Update dotfiles"
    echo "   • Check system status"
    echo ""
    
    print_color "2. ${CYAN}Services & Maintenance${NC}"
    echo "   • Start window management services"
    echo "   • Backup dotfiles"
    echo "   • Clean up files"
    echo ""
    
    print_color "3. ${CYAN}Advanced Operations${NC}"
    echo "   • Migrate to standard location"
    echo "   • Hybrid setup"
    echo "   • Clean repository"
    echo ""
    
    print_color "4. ${CYAN}Shortcuts & Integration${NC}"
    echo "   • Create macOS shortcuts"
    echo "   • View documentation"
    echo ""
    
    print_color "5. ${CYAN}Exit${NC}"
    echo ""
    
    read -p "Enter your choice (1-5): " -n 1 -r
    echo ""
    
    case $REPLY in
        1) show_setup_menu ;;
        2) show_maintenance_menu ;;
        3) show_advanced_menu ;;
        4) show_shortcuts_menu ;;
        5) exit 0 ;;
        *) 
            print_error "Invalid choice. Please try again."
            sleep 2
            show_main_menu
            ;;
    esac
}

# Function to show setup menu
show_setup_menu() {
    clear
    print_header "Setup & Installation"
    echo ""
    print_color "1. ${CYAN}Install Dotfiles${NC} - Initial setup"
    print_color "2. ${CYAN}Update Dotfiles${NC} - Pull latest changes"
    print_color "3. ${CYAN}Check Status${NC} - System diagnostics"
    print_color "4. ${CYAN}Back to Main Menu${NC}"
    echo ""
    
    read -p "Enter your choice (1-4): " -n 1 -r
    echo ""
    
    case $REPLY in
        1) run_script "setup-dotfiles.command" ;;
        2) run_script "update-dotfiles.command" ;;
        3) run_script "check-status.command" ;;
        4) show_main_menu ;;
        *) 
            print_error "Invalid choice. Please try again."
            sleep 2
            show_setup_menu
            ;;
    esac
}

# Function to show maintenance menu
show_maintenance_menu() {
    clear
    print_header "Services & Maintenance"
    echo ""
    print_color "1. ${CYAN}Start Services${NC} - Start window management"
    print_color "2. ${CYAN}Backup Dotfiles${NC} - Create backup"
    print_color "3. ${CYAN}Cleanup Files${NC} - Remove broken links"
    print_color "4. ${CYAN}Back to Main Menu${NC}"
    echo ""
    
    read -p "Enter your choice (1-4): " -n 1 -r
    echo ""
    
    case $REPLY in
        1) run_script "start-services.command" ;;
        2) run_script "backup-dotfiles.command" ;;
        3) run_script "cleanup-dotfiles.command" ;;
        4) show_main_menu ;;
        *) 
            print_error "Invalid choice. Please try again."
            sleep 2
            show_maintenance_menu
            ;;
    esac
}

# Function to show advanced menu
show_advanced_menu() {
    clear
    print_header "Advanced Operations"
    echo ""
    print_color "1. ${CYAN}Migrate to Standard${NC} - Move to ~/.dotfiles"
    print_color "2. ${CYAN}Hybrid Setup${NC} - Local + external setup"
    print_color "3. ${CYAN}Clean Repository${NC} - Remove ._ files"
    print_color "4. ${CYAN}Back to Main Menu${NC}"
    echo ""
    
    read -p "Enter your choice (1-4): " -n 1 -r
    echo ""
    
    case $REPLY in
        1) run_script "migrate-to-standard.sh" ;;
        2) run_script "hybrid-setup.sh" ;;
        3) run_script "clean-dotfiles.command" ;;
        4) show_main_menu ;;
        *) 
            print_error "Invalid choice. Please try again."
            sleep 2
            show_advanced_menu
            ;;
    esac
}

# Function to show shortcuts menu
show_shortcuts_menu() {
    clear
    print_header "Shortcuts & Integration"
    echo ""
    print_color "1. ${CYAN}Create Shortcuts${NC} - macOS Shortcuts app"
    print_color "2. ${CYAN}View Documentation${NC} - Open docs folder"
    print_color "3. ${CYAN}Back to Main Menu${NC}"
    echo ""
    
    read -p "Enter your choice (1-3): " -n 1 -r
    echo ""
    
    case $REPLY in
        1) run_script "create-shortcuts.command" ;;
        2) open_docs ;;
        3) show_main_menu ;;
        *) 
            print_error "Invalid choice. Please try again."
            sleep 2
            show_shortcuts_menu
            ;;
    esac
}

# Function to run a script
run_script() {
    local script_name="$1"
    local script_path="$SCRIPTS_DIR/$script_name"
    
    if [[ -f "$script_path" ]]; then
        print_status "Running $script_name..."
        echo ""
        cd "$SCRIPTS_DIR"
        ./"$script_name"
        cd "$SCRIPT_DIR"
        echo ""
        read -p "Press Enter to return to menu..."
    else
        print_error "Script not found: $script_name"
        read -p "Press Enter to continue..."
    fi
    
    show_main_menu
}

# Function to open docs folder
open_docs() {
    print_status "Opening documentation folder..."
    open "$SCRIPT_DIR/docs"
    show_main_menu
}

# Main execution
main() {
    # Check if scripts directory exists
    if [[ ! -d "$SCRIPTS_DIR" ]]; then
        print_error "Scripts directory not found: $SCRIPTS_DIR"
        read -p "Press Enter to exit..."
        exit 1
    fi
    
    # Show main menu
    show_main_menu
}

# Run main function
main
