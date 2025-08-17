# External Drive Dotfiles Management Guide

This guide explains how to properly manage your dotfiles when they're stored on an external drive (like `/Volumes/vaultex/.dotfiles`).

## Overview

Your dotfiles are currently stored on an external SSD at `/Volumes/vaultex/.dotfiles`, but your home directory is `/Users/mohamedjeylani`. This setup requires special handling with GNU Stow.

## Key Concepts

### How Stow Works with External Drives

Normally, stow creates symlinks from your home directory to files in `~/.dotfiles/`. When your dotfiles are on an external drive, we use the `--target` option to tell stow where to create the symlinks.

### Symlink Structure

With external drive setup:
- **Source**: `/Volumes/vaultex/.dotfiles/.zshrc`
- **Target**: `/Users/mohamedjeylani/.zshrc` (symlink)
- **Command**: `stow --target=$HOME .`

## Common Operations

### Initial Installation

```bash
cd /Volumes/vaultex/.dotfiles
./install.sh
```

### Updating Dotfiles

```bash
cd /Volumes/vaultex/.dotfiles
./update.sh
```

### Manual Stow Operations

```bash
# Stow all packages
cd /Volumes/vaultex/.dotfiles
stow --target=$HOME .

# Stow specific package
stow --target=$HOME zsh

# Unstow a package
stow --target=$HOME -D zsh

# Restow a package (unstow then stow)
stow --target=$HOME -R zsh
```

### Checking Symlinks

```bash
# Check if symlinks are correct
ls -la ~/.zshrc
ls -la ~/.config/yabai

# Should show symlinks pointing to your external drive
```

## Troubleshooting

### External Drive Not Mounted

If your external drive isn't mounted, your symlinks will be broken. You'll see errors like:
```
ls: cannot access '/Users/mohamedjeylani/.zshrc': No such file or directory
```

**Solution**: Mount your external drive, then the symlinks will work again.

### Permission Issues

If you get permission errors:
```bash
# Check drive permissions
ls -la /Volumes/vaultex/

# Ensure your user owns the dotfiles
sudo chown -R $(whoami) /Volumes/vaultex/.dotfiles
```

### Broken Symlinks

If symlinks are broken:
```bash
# Remove broken symlinks
find ~ -maxdepth 1 -type l -name ".*" -delete
find ~/.config -type l -delete

# Restow everything
cd /Volumes/vaultex/.dotfiles
stow --target=$HOME .
```

## Best Practices

1. **Always use the scripts**: Use `./install.sh` and `./update.sh` instead of manual stow commands
2. **Keep drive mounted**: Ensure your external drive is mounted before using your shell
3. **Backup regularly**: Your dotfiles are on an external drive, but consider backing up the drive itself
4. **Check symlinks**: Periodically verify that symlinks are pointing to the correct locations

## Handling Unmounted Drive Issues

### The Problem
When your external drive isn't mounted, symlinks become broken and your system won't work properly.

### Solution 1: Hybrid Setup (Recommended)
Keep essential configs on main drive, others on external:

```bash
cd /Volumes/vaultex/.dotfiles
./hybrid-setup.sh
```

This creates:
- Essential configs (shell, window management) on main drive
- Non-essential configs (editor themes, etc.) on external drive
- Your system works even when external drive is unmounted

### Solution 2: Migration to Standard Location
Move everything to the standard `~/.dotfiles` location:

```bash
cd /Volumes/vaultex/.dotfiles
./migrate-to-standard.sh
```

This:
- Moves all dotfiles to `~/.dotfiles`
- Removes dependency on external drive
- Cleans up resource fork files (._*)
- Your system works regardless of external drive status

### Solution 3: Manual Migration
If you prefer to do it manually:

```bash
# Unstow current setup
cd /Volumes/vaultex/.dotfiles
stow --target=$HOME -D .

# Move to standard location
mv /Volumes/vaultex/.dotfiles ~/.dotfiles

# Stow from new location
cd ~/.dotfiles
stow .
```

## Automation

You can add these aliases to your `.zshrc` for easier management:

```bash
# Add to your .zshrc
alias dotfiles='cd /Volumes/vaultex/.dotfiles'
alias dotfiles-update='cd /Volumes/vaultex/.dotfiles && ./update.sh'
alias dotfiles-install='cd /Volumes/vaultex/.dotfiles && ./install.sh'
```

Then you can simply run:
```bash
dotfiles-update  # Update your dotfiles
dotfiles         # Navigate to dotfiles directory
```
