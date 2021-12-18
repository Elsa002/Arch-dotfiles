#!/bin/zsh
SCRIPT_DIR="`dirname $0`"

# Includes ################################################
# Prefer tools from $HOME/.dotfiles/installer
if [ -f "$HOME/.dotfiles/installer/installer-tools.sh" ]; then
    source "$HOME/.dotfiles/installer/installer-tools.sh"
else
    source "$SCRIPT_DIR/installer-tools.sh"
fi

if [ -f "$HOME/.dotfiles/installer/package-manager-tools.sh" ]; then
    source "$HOME/.dotfiles/installer/package-manager-tools.sh"
else
    source "$SCRIPT_DIR/package-manager-tools.sh"
fi


# Constants ###############################################
## Packer
PACKER_SRC="https://github.com/wbthomason/packer.nvim"
PACKER_DST="$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"

## Offline files locations
# Neovim language servers
NVIM_LSP_TAR="$HOME/.config/nvim/installer/nvim-lsp.tar.gz"
NVIM_LSP_DIR="$HOME/.local/share/nvim"

# Neovim custom language servers
NVIM_CUSTOM_LSP_TAR="$HOME/.config/nvim/installer/nvim-custom-lsp.tar.gz"
NVIM_CUSTOM_LSP_DIR="$HOME"

# Neovim plugins
NVIM_PLUGINS_TAR="$HOME/.config/nvim/installer/nvim-plugins.tar.gz"
NVIM_PLUGINS_DIR="$HOME/.local/share/nvim"

## Fonts
FONTS_URL_JET_BRAINS="https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip"
FONTS_ZIP_JET_BRAINS="$HOME/.config/nvim/installer/JetBrainsMono.zip"
FONTS_NAME_JET_BRAINS="JetBrainsMono.zip"
FONTS_DIR="$HOME/.fonts"


# Functions ###############################################
function update_lsp()
{
    verbose_run cd "$HOME/.local/share/nvim/"
    tar --create --use-compress-program="pigz" --file="$HOME/.config/nvim/installer/nvim-lsp.tar.gz" "lsp_servers"
}

function update_custom_lsp()
{
    verbose_run cd "$HOME"
    tar --create --use-compress-program="pigz" --file="$HOME/.config/nvim/installer/nvim-custom-lsp.tar.gz" ".language-servers"
}

function update_plugins()
{
    verbose_run cd "$HOME/.local/share/nvim"
    tar --create --use-compress-program="pigz" --file="$HOME/.config/nvim/installer/nvim-plugins.tar.gz" "site"
}

function update_fonts()
{
    verbose_run cp "$FONTS_DIR/$FONTS_NAME_JET_BRAINS" $FONTS_ZIP_JET_BRAINS
}

# Main logic ##############################################
if yes_no_prompt "Update offline lsp installation?"; then
    update_lsp
fi
if yes_no_prompt "Update custom lsp installation?"; then
    update_custom_lsp
fi
if yes_no_prompt "Update offline plugins installation?"; then
    update_plugins
fi
if yes_no_prompt "Update offline fonts installation?"; then
    update_fonts
fi
