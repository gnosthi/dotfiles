# Dotfiles

This repository contains my personal dotfiles managed with GNU Stow.

## Structure
- `zsh/` - ZSH configuration
- `nvim/.config/nvim/` - Neovim configuration
- `vim/.config/vim/` - Vim configuration
- `hypr/.config/hypr/` - Hyprland configuration

## Usage
1. Clone this repository to your home directory
2. Use stow to create symlinks:
   ```bash
   cd ~/dotfiles
   stow zsh nvim vim hypr
   ```

