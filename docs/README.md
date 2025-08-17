# Dotfiles

My personal dotfiles configuration for macOS, managed with GNU Stow.

## 🚀 Quick Start

### Option 1: Master Script (Recommended)
```bash
./dotfiles-manager.command
```
This opens an interactive menu to manage all dotfiles operations.

### Option 2: Standard Installation
```bash
stow .
```

### Option 3: External Drive Installation
```bash
./scripts/setup-dotfiles.command
```

### Option 4: Manual External Drive Setup
```bash
stow --target=$HOME .
```

## 📁 Project Structure

```
.dotfiles/
├── dotfiles-manager.command    # Master script (interactive menu)
├── scripts/                    # All management scripts
│   ├── setup-dotfiles.command  # Initial setup
│   ├── update-dotfiles.command # Update dotfiles
│   ├── check-status.command    # System status check
│   ├── start-services.command  # Start window management
│   ├── backup-dotfiles.command # Create backups
│   ├── cleanup-dotfiles.command # Clean up files
│   ├── clean-dotfiles.command  # Clean repository
│   ├── create-shortcuts.command # Create macOS shortcuts
│   ├── migrate-to-standard.sh  # Move to standard location
│   ├── hybrid-setup.sh         # Hybrid local/external setup
│   ├── install.sh              # Legacy install script
│   └── update.sh               # Legacy update script
├── docs/                       # Documentation
│   ├── README.md               # This file
│   ├── EXTERNAL_DRIVE_GUIDE.md # External drive management
│   ├── MACOS_SHORTCUTS.md      # macOS shortcuts guide
│   └── SHORTCUTS_APP_GUIDE.md  # Shortcuts app integration
├── .config/                    # Application configurations
│   ├── yabai/                  # Window manager
│   ├── skhd/                   # Hotkey daemon
│   └── zed/                    # Text editor
├── .zshrc                      # Zsh configuration
├── .p10k.zsh                   # Powerlevel10k theme
├── .tool-versions              # ASDF tool versions
└── .stow-local-ignore          # Stow ignore patterns
```

## 🎯 Available Scripts

### Core Management
- **`dotfiles-manager.command`** - Master script with interactive menu
- **`setup-dotfiles.command`** - Install/setup dotfiles
- **`update-dotfiles.command`** - Update from git repository

### Monitoring & Diagnostics
- **`check-status.command`** - Comprehensive system status check
- **`start-services.command`** - Start window management services

### Backup & Maintenance
- **`backup-dotfiles.command`** - Create safe backups
- **`cleanup-dotfiles.command`** - Clean up broken links and old files
- **`clean-dotfiles.command`** - Remove ._ files and other unwanted files

### Advanced Operations
- **`migrate-to-standard.sh`** - Move dotfiles to standard location
- **`hybrid-setup.sh`** - Hybrid local/external setup
- **`create-shortcuts.command`** - Create macOS shortcuts

## 🔧 Updating Dotfiles

### Option 1: Master Script
```bash
./dotfiles-manager.command
# Choose "Setup & Installation" → "Update Dotfiles"
```

### Option 2: Direct Script
```bash
./scripts/update-dotfiles.command
```

### Option 3: Manual Update
```bash
git pull && stow .
```

## 📱 macOS Shortcuts

Create easy-to-use shortcuts for common operations:

```bash
./scripts/create-shortcuts.command
```

This creates `.command` files that can be:
- Double-clicked to run
- Added to Dock
- Added to Shortcuts app
- Used with Siri voice commands

## 🗂️ External Drive Setup

This dotfiles repository is designed to work from an external SSD. See `docs/EXTERNAL_DRIVE_GUIDE.md` for detailed instructions.

## 🎨 Features

- **Window Management**: Yabai + SKHD for tiling windows
- **Shell**: Zsh with Oh My Zsh and Powerlevel10k
- **Version Management**: ASDF for multiple language versions
- **Package Management**: Homebrew, npm, pip
- **Development Tools**: Git, Node.js, Python, Ruby

## 🔍 Troubleshooting

### Check System Status
```bash
./scripts/check-status.command
```

### Start Services
```bash
./scripts/start-services.command
```

### Clean Up Issues
```bash
./scripts/cleanup-dotfiles.command
```

## 📚 Documentation

- **`docs/EXTERNAL_DRIVE_GUIDE.md`** - Managing dotfiles from external drive
- **`docs/MACOS_SHORTCUTS.md`** - Using macOS shortcuts
- **`docs/SHORTCUTS_APP_GUIDE.md`** - Shortcuts app integration

## 🎯 Quick Commands

```bash
# Master menu
./dotfiles-manager.command

# Quick status check
./scripts/check-status.command

# Quick backup
./scripts/backup-dotfiles.command

# Quick cleanup
./scripts/cleanup-dotfiles.command
```

## 🚀 Getting Started

1. **Clone the repository** to your external drive
2. **Run the master script**: `./dotfiles-manager.command`
3. **Choose "Setup & Installation"** → "Install Dotfiles"
4. **Follow the prompts** to complete setup
5. **Create shortcuts** for easy future access

That's it! Your dotfiles are now organized and easy to manage! 🎉
