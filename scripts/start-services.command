#!/bin/bash

# macOS Start Services
# Double-click to start window management services

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

print_header "Starting Window Management Services"
echo ""

# Check if we're in the right directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ ! -f "$SCRIPT_DIR/.stow-local-ignore" ]]; then
    print_error "This script must be run from the dotfiles directory"
    read -p "Press Enter to exit..."
    exit 1
fi

print_header "Yabai Window Manager"

# Check if yabai is installed
if ! command -v yabai &> /dev/null; then
    print_error "Yabai is not installed"
    print_status "Install with: brew install koekeishiya/formulae/yabai"
else
    print_success "Yabai is installed"
    
    # Check if yabai is running
    if pgrep -x "yabai" > /dev/null; then
        print_warning "Yabai is already running"
        print_status "Restarting yabai..."
        yabai --stop-service
        sleep 1
    fi
    
    # Start yabai
    print_status "Starting yabai..."
    if yabai --start-service; then
        print_success "Yabai started successfully"
    else
        print_error "Failed to start yabai"
    fi
fi

echo ""

print_header "SKHD Hotkey Daemon"

# Check if skhd is installed
if ! command -v skhd &> /dev/null; then
    print_error "SKHD is not installed"
    print_status "Install with: brew install koekeishiya/formulae/skhd"
else
    print_success "SKHD is installed"
    
    # Check if skhd is running
    if pgrep -x "skhd" > /dev/null; then
        print_warning "SKHD is already running"
        print_status "Restarting skhd..."
        skhd --stop-service
        sleep 1
    fi
    
    # Start skhd
    print_status "Starting skhd..."
    if skhd --start-service; then
        print_success "SKHD started successfully"
    else
        print_error "Failed to start skhd"
    fi
fi

echo ""

print_header "Service Status"

# Check final status
sleep 2

if pgrep -x "yabai" > /dev/null; then
    print_success "Yabai is running (PID: $(pgrep yabai))"
else
    print_error "Yabai is not running"
fi

if pgrep -x "skhd" > /dev/null; then
    print_success "SKHD is running (PID: $(pgrep skhd))"
else
    print_error "SKHD is not running"
fi

echo ""

print_header "Troubleshooting"

if ! pgrep -x "yabai" > /dev/null || ! pgrep -x "skhd" > /dev/null; then
    print_warning "Some services failed to start. Common issues:"
    echo "  1. Check if you have the required permissions"
    echo "  2. Make sure SIP is disabled for yabai"
    echo "  3. Check the service logs:"
    echo "     - yabai: brew services list | grep yabai"
    echo "     - skhd: brew services list | grep skhd"
    echo ""
    print_status "You can also try starting manually:"
    echo "  yabai --start-service"
    echo "  skhd --start-service"
fi

echo ""
print_header "Services Started"
read -p "Press Enter to close..."
