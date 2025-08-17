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

print_menu_item() {
    echo -e "${CYAN}$1${NC}"
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
    
    echo "1. ${CYAN}Setup & Installation${NC}"
    echo "   • Install dotfiles"
    echo "   • Update dotfiles"
    echo "   • Check system status"
    echo ""
    
    echo "2. ${CYAN}Services & Maintenance${NC}"
    echo "   • Start window management services"
    echo "   • Backup dotfiles"
    echo "   • Clean up files"
    echo ""
    
    echo "3. ${CYAN}Advanced Operations${NC}"
    echo "   • Migrate to standard location"
    echo "   • Hybrid setup"
    echo "   • Clean repository"
    echo ""
    
    echo "4. ${CYAN}Shortcuts & Integration${NC}"
    echo "   • Create macOS shortcuts"
    echo "   • View documentation"
    echo ""
    
    echo "5. ${CYAN}Exit${NC}"
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
    echo "1. ${CYAN}Install Dotfiles${NC} - Initial setup"
    echo "2. ${CYAN}Update Dotfiles${NC} - Pull latest changes"
    echo "3. ${CYAN}Check Status${NC} - System diagnostics"
    echo "4. ${CYAN}Back to Main Menu${NC}"
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
    echo "1. ${CYAN}Start Services${NC} - Start window management"
    echo "2. ${CYAN}Backup Dotfiles${NC} - Create backup"
    echo "3. ${CYAN}Cleanup Files${NC} - Remove broken links"
    echo "4. ${CYAN}Back to Main Menu${NC}"
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
    echo "1. ${CYAN}Migrate to Standard${NC} - Move to ~/.dotfiles"
    echo "2. ${CYAN}Hybrid Setup${NC} - Local + external setup"
    echo "3. ${CYAN}Clean Repository${NC} - Remove ._ files"
    echo "4. ${CYAN}Back to Main Menu${NC}"
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
    echo "1. ${CYAN}Create Shortcuts${NC} - macOS Shortcuts app"
    echo "2. ${CYAN}View Documentation${NC} - Open docs folder"
    echo "3. ${CYAN}Back to Main Menu${NC}"
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
