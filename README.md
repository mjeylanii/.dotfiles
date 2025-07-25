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

Finally, ensure to download and install the nerd font, preferably JetBrainsMono Nerd font:
https://www.nerdfonts.com/font-downloads

## Start Yabai

```shell
yabai --start-service
skhd --start-service
```
