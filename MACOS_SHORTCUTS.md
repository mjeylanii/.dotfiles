# macOS Shortcuts for Dotfiles Management

This guide explains how to use the macOS shortcuts for easy dotfiles setup and updates.

## Available Shortcuts

### 🚀 `setup-dotfiles.command`
**Purpose**: Install/setup your dotfiles
**Usage**: Double-click to run

This shortcut will:
- Automatically detect if you're on an external drive or standard location
- Run the appropriate installation method
- Show colored output with progress information
- Keep the terminal open so you can see the results

### 🔄 `update-dotfiles.command`
**Purpose**: Update your dotfiles
**Usage**: Double-click to run

This shortcut will:
- Pull the latest changes from git
- Update your dotfiles configuration
- Show colored output with progress information
- Keep the terminal open so you can see the results

### 📊 `check-status.command`
**Purpose**: Check the status of your dotfiles and system
**Usage**: Double-click to run

This shortcut will:
- Check system information and required tools
- Verify git repository status
- Check symlink integrity
- Monitor external drive status
- Check if services (yabai, skhd) are running
- Provide recommendations for issues

### 🎯 `start-services.command`
**Purpose**: Start window management services
**Usage**: Double-click to run

This shortcut will:
- Start/restart Yabai window manager
- Start/restart SKHD hotkey daemon
- Check service status and provide troubleshooting
- Show helpful error messages if services fail

### 💾 `backup-dotfiles.command`
**Purpose**: Create a backup of your current dotfiles
**Usage**: Double-click to run

This shortcut will:
- Create timestamped backup directory
- Backup all important configuration files
- Verify backup integrity
- Show backup contents and sizes
- Provide restore instructions

### 🧹 `cleanup-dotfiles.command`
**Purpose**: Clean up broken symlinks and old backups
**Usage**: Double-click to run

This shortcut will:
- Find and remove broken symlinks
- Clean up old backup directories
- Remove temporary files
- Show disk usage information
- Suggest additional cleanup options

## How to Use

### Method 1: Double-click from Finder
1. Navigate to your dotfiles directory in Finder
2. Double-click any `.command` file to run it
3. A Terminal window will open and run the script
4. Press Enter when prompted to close the terminal

**Available commands:**
- `setup-dotfiles.command` - Install dotfiles
- `update-dotfiles.command` - Update dotfiles
- `check-status.command` - Check system status
- `start-services.command` - Start window services
- `backup-dotfiles.command` - Create backup
- `cleanup-dotfiles.command` - Clean up files

### Method 2: Add to Dock
1. Drag `setup-dotfiles.command` to your Dock
2. When you need to set up dotfiles, just click the Dock icon
3. The script will run in a new Terminal window

### Method 3: Create Desktop Shortcuts
1. Create aliases of the `.command` files on your Desktop
2. Double-click the aliases to run the scripts

## Features

### Automatic Detection
- **External Drive**: Automatically detects if dotfiles are on `/Volumes/` and uses the external drive scripts
- **Standard Location**: Detects if dotfiles are in `~/.dotfiles` and uses standard stow commands

### Error Handling
- Checks if required tools (git, stow) are installed
- Validates that you're in the correct directory
- Shows helpful error messages with instructions

### User-Friendly
- Colored output for easy reading
- Progress information
- Terminal stays open to show results
- Clear success/error messages

## Troubleshooting

### "Permission Denied" Error
If you get a permission error:
```bash
chmod +x setup-dotfiles.command update-dotfiles.command
```

### "Command Not Found" Error
If you get a "command not found" error:
1. Make sure you have the required tools installed:
   ```bash
   brew install stow git
   ```
2. Make sure you're double-clicking from within the dotfiles directory

### Script Won't Run
If the script won't run:
1. Right-click the `.command` file
2. Select "Open With" → "Terminal"
3. Click "Open" when prompted

## Customization

You can customize the shortcuts by editing the `.command` files. They are just bash scripts with a `.command` extension.

### Adding Your Own Shortcuts
To create additional shortcuts:
1. Create a bash script with your desired functionality
2. Save it with a `.command` extension
3. Make it executable: `chmod +x your-script.command`
4. Double-click to run

## Security Note

These shortcuts run bash scripts, so only use them with dotfiles you trust. The scripts are designed to be safe and only modify your dotfiles configuration.
