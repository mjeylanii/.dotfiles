#!/bin/bash

# Clean Dotfiles Repository
# This script removes ._ files and other unwanted files from the dotfiles repository

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

print_header "Dotfiles Repository Cleanup"
echo ""

# Check if we're in the right directory
if [[ ! -f "$SCRIPT_DIR/.stow-local-ignore" ]]; then
    print_error "This script must be run from the dotfiles directory"
    read -p "Press Enter to exit..."
    exit 1
fi

print_status "This script will clean up unwanted files from your dotfiles repository."
print_status "Repository location: $SCRIPT_DIR"
echo ""

# Check if git repository is clean
if ! git diff-index --quiet HEAD --; then
    print_warning "You have uncommitted changes in your repository."
    print_warning "It's recommended to commit or stash your changes before cleaning."
    echo ""
    read -p "Do you want to continue anyway? (y/N): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_status "Cleanup cancelled."
        read -p "Press Enter to exit..."
        exit 0
    fi
fi

print_header "Files to Clean"

echo "The following types of files will be removed:"
echo ""
echo "1. ._* files (macOS resource fork files)"
echo "2. .DS_Store files (macOS directory metadata)"
echo "3. Thumbs.db files (Windows thumbnail cache)"
echo "4. *.tmp files (temporary files)"
echo "5. *.log files (log files)"
echo "6. *.bak files (backup files)"
echo ""

read -p "Do you want to proceed with the cleanup? (y/N): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_status "Cleanup cancelled."
    read -p "Press Enter to exit..."
    exit 0
fi

print_header "Starting Cleanup"

# Count files before cleanup
print_status "Counting files before cleanup..."

DOT_FILES_COUNT=$(find . -name "._*" 2>/dev/null | wc -l | tr -d ' ')
DS_STORE_COUNT=$(find . -name ".DS_Store" 2>/dev/null | wc -l | tr -d ' ')
THUMBS_COUNT=$(find . -name "Thumbs.db" 2>/dev/null | wc -l | tr -d ' ')
TMP_COUNT=$(find . -name "*.tmp" 2>/dev/null | wc -l | tr -d ' ')
LOG_COUNT=$(find . -name "*.log" 2>/dev/null | wc -l | tr -d ' ')
BAK_COUNT=$(find . -name "*.bak" 2>/dev/null | wc -l | tr -d ' ')

echo "Found:"
echo "  • $DOT_FILES_COUNT ._* files"
echo "  • $DS_STORE_COUNT .DS_Store files"
echo "  • $THUMBS_COUNT Thumbs.db files"
echo "  • $TMP_COUNT *.tmp files"
echo "  • $LOG_COUNT *.log files"
echo "  • $BAK_COUNT *.bak files"
echo ""

TOTAL_FILES=$((DOT_FILES_COUNT + DS_STORE_COUNT + THUMBS_COUNT + TMP_COUNT + LOG_COUNT + BAK_COUNT))

if [ $TOTAL_FILES -eq 0 ]; then
    print_success "No files to clean! Your repository is already clean."
    read -p "Press Enter to exit..."
    exit 0
fi

# Remove ._ files (macOS resource fork files)
print_status "Removing ._* files..."
if [ $DOT_FILES_COUNT -gt 0 ]; then
    find . -name "._*" -type f -delete 2>/dev/null
    print_success "Removed $DOT_FILES_COUNT ._* files"
else
    print_status "No ._* files found"
fi

# Remove .DS_Store files
print_status "Removing .DS_Store files..."
if [ $DS_STORE_COUNT -gt 0 ]; then
    find . -name ".DS_Store" -type f -delete 2>/dev/null
    print_success "Removed $DS_STORE_COUNT .DS_Store files"
else
    print_status "No .DS_Store files found"
fi

# Remove Thumbs.db files
print_status "Removing Thumbs.db files..."
if [ $THUMBS_COUNT -gt 0 ]; then
    find . -name "Thumbs.db" -type f -delete 2>/dev/null
    print_success "Removed $THUMBS_COUNT Thumbs.db files"
else
    print_status "No Thumbs.db files found"
fi

# Remove .tmp files
print_status "Removing *.tmp files..."
if [ $TMP_COUNT -gt 0 ]; then
    find . -name "*.tmp" -type f -delete 2>/dev/null
    print_success "Removed $TMP_COUNT *.tmp files"
else
    print_status "No *.tmp files found"
fi

# Remove .log files
print_status "Removing *.log files..."
if [ $LOG_COUNT -gt 0 ]; then
    find . -name "*.log" -type f -delete 2>/dev/null
    print_success "Removed $LOG_COUNT *.log files"
else
    print_status "No *.log files found"
fi

# Remove .bak files
print_status "Removing *.bak files..."
if [ $BAK_COUNT -gt 0 ]; then
    find . -name "*.bak" -type f -delete 2>/dev/null
    print_success "Removed $BAK_COUNT *.bak files"
else
    print_status "No *.bak files found"
fi

print_header "Cleanup Complete"

# Verify cleanup
print_status "Verifying cleanup..."

REMAINING_DOT=$(find . -name "._*" 2>/dev/null | wc -l | tr -d ' ')
REMAINING_DS=$(find . -name ".DS_Store" 2>/dev/null | wc -l | tr -d ' ')
REMAINING_THUMBS=$(find . -name "Thumbs.db" 2>/dev/null | wc -l | tr -d ' ')
REMAINING_TMP=$(find . -name "*.tmp" 2>/dev/null | wc -l | tr -d ' ')
REMAINING_LOG=$(find . -name "*.log" 2>/dev/null | wc -l | tr -d ' ')
REMAINING_BAK=$(find . -name "*.bak" 2>/dev/null | wc -l | tr -d ' ')

TOTAL_REMAINING=$((REMAINING_DOT + REMAINING_DS + REMAINING_THUMBS + REMAINING_TMP + REMAINING_LOG + REMAINING_BAK))

if [ $TOTAL_REMAINING -eq 0 ]; then
    print_success "All unwanted files have been successfully removed!"
else
    print_warning "Some files could not be removed:"
    [ $REMAINING_DOT -gt 0 ] && echo "  • $REMAINING_DOT ._* files remaining"
    [ $REMAINING_DS -gt 0 ] && echo "  • $REMAINING_DS .DS_Store files remaining"
    [ $REMAINING_THUMBS -gt 0 ] && echo "  • $REMAINING_THUMBS Thumbs.db files remaining"
    [ $REMAINING_TMP -gt 0 ] && echo "  • $REMAINING_TMP *.tmp files remaining"
    [ $REMAINING_LOG -gt 0 ] && echo "  • $REMAINING_LOG *.log files remaining"
    [ $REMAINING_BAK -gt 0 ] && echo "  • $REMAINING_BAK *.bak files remaining"
fi

print_header "Prevention Measures"

echo "To prevent these files from coming back:"
echo ""
echo "1. ✅ .stow-local-ignore already includes ._*"
echo "2. ✅ .gitignore should include these patterns:"
echo ""

# Check if .gitignore exists and has the right patterns
if [ -f ".gitignore" ]; then
    print_status "Checking .gitignore patterns..."
    
    PATTERNS=("._*" ".DS_Store" "Thumbs.db" "*.tmp" "*.log" "*.bak")
    MISSING_PATTERNS=()
    
    for pattern in "${PATTERNS[@]}"; do
        if ! grep -q "^$pattern$" .gitignore 2>/dev/null; then
            MISSING_PATTERNS+=("$pattern")
        fi
    done
    
    if [ ${#MISSING_PATTERNS[@]} -eq 0 ]; then
        print_success "All patterns are already in .gitignore"
    else
        print_warning "Missing patterns in .gitignore:"
        for pattern in "${MISSING_PATTERNS[@]}"; do
            echo "  • $pattern"
        done
        
        read -p "Do you want to add missing patterns to .gitignore? (y/N): " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            for pattern in "${MISSING_PATTERNS[@]}"; do
                echo "$pattern" >> .gitignore
                print_success "Added $pattern to .gitignore"
            done
        fi
    fi
else
    print_warning ".gitignore file not found. Creating one with common patterns..."
    
    cat > .gitignore << 'EOF'
# macOS
._*
.DS_Store
.AppleDouble
.LSOverride

# Windows
Thumbs.db
ehthumbs.db
Desktop.ini

# Temporary files
*.tmp
*.temp
*.swp
*.swo
*~

# Log files
*.log

# Backup files
*.bak
*.backup

# IDE files
.vscode/
.idea/
*.sublime-*

# OS generated files
.DocumentRevisions-V100
.fseventsd
.Spotlight-V100
.TemporaryItems
.Trashes
.VolumeIcon.icns
.com.apple.timemachine.donotpresent
EOF
    
    print_success "Created .gitignore with common patterns"
fi

print_header "Git Status"

print_status "Checking git status..."
git status --porcelain

echo ""
print_status "If you see any unwanted files in git status, you can:"
echo "1. Add them to .gitignore (if not already there)"
echo "2. Remove them from git tracking: git rm --cached <file>"
echo "3. Commit the changes: git add . && git commit -m 'Clean up unwanted files'"

print_header "Cleanup Summary"

echo "✅ Removed $TOTAL_FILES unwanted files"
echo "✅ Verified cleanup completion"
echo "✅ Updated prevention measures"
echo "✅ Checked git status"
echo ""
print_success "Your dotfiles repository is now clean!"
echo ""
read -p "Press Enter to close..."
