# Dotfiles

This directory contains the dotfiles for my system

## Requirements

Ensure you have the following installed on your system:

```shell
brew install gh

brew install koekeishiya/formulae/yabai
brew install koekeishiya/formulae/skhd

brew install neovim

brew install pyenv

brew install stow

brew install tmux

brew install zoxide
```

## Installation

### Option 1: Standard Installation (Recommended for most users)

First, check out the dotfiles repo in your $HOME directory using git

```shell
git clone git@github.com/mjeylanii/.dotfiles
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

cd .dotfiles
```

Next, use GNU stow to create symlinks

```shell
stow .
```

### Option 2: External Drive Installation

If your dotfiles are stored on an external drive (like `/Volumes/vaultex/.dotfiles`), use the provided installation script:

```shell
cd /path/to/your/external/drive/.dotfiles
./install.sh
```

This script will:
- Automatically detect the external drive setup
- Use the `--target` option to create symlinks in your home directory
- Backup any existing dotfiles before installation
- Install required Oh My Zsh plugins
- Handle git submodules

### Option 3: Manual External Drive Setup

If you prefer to do it manually:

```shell
cd /path/to/your/external/drive/.dotfiles
stow --target=$HOME .
```

### Option 4: macOS Shortcuts (Easiest)

For the easiest setup, use the provided macOS shortcuts:

1. **Setup**: Double-click `setup-dotfiles.command` in Finder
2. **Update**: Double-click `update-dotfiles.command` in Finder

These shortcuts automatically detect your setup and run the appropriate commands. See `MACOS_SHORTCUTS.md` for detailed instructions.

Finally, ensure to download and install the nerd font, preferably JetBrainsMono Nerd font:
https://www.nerdfonts.com/font-downloads

## Updating Dotfiles

### For External Drive Users

If your dotfiles are on an external drive, use the update script:

```shell
cd /path/to/your/external/drive/.dotfiles
./update.sh
```

### For Standard Installation

```shell
cd ~/.dotfiles
git pull origin main
stow .
```

## Start Yabai

```shell
yabai --start-service
skhd --start-service
```
