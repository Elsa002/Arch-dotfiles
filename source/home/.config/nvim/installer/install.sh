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

# Packages
declare -A PackagesList=(
    ['Base','yay']="curl git pigz tar bash zsh nodejs npm unzip python3 gcc make"
    ['Base','pacman']="curl git pigz tar bash zsh nodejs npm unzip python3 gcc make"
    ['Base','apt']="curl git pigz tar bash zsh nodejs npm unzip python3 gcc make"
    ['Base','apt-get']="curl git pigz tar bash zsh nodejs npm unzip python3 gcc make"

    ['NeoVim','yay']="ripgrep fd subversion python-pynvim xclip  bash-language-server pyright clang"
    ['NeoVim','pacman']="ripgrep fd subversion python-pynvim xclip  bash-language-server pyright clang"
    ['NeoVim','apt']="ripgrep fd-find subversion xclip clang clangd clang-tidy clang-format"
    ['NeoVim','apt-get']="ripgrep fd-find subversion xclip clang clangd clang-tidy clang-format"

    ['npm','yay']="neovim"
    ['npm','pacman']="neovim"
    ['npm','apt']="neovim"
    ['npm','apt-get']="neovim"

    ['pip','yay']="pynvim"
    ['pip','pacman']="pynvim"
    ['pip','apt']="pynvim"
    ['pip','apt-get']="pynvim"
)


# Functions ###############################################
function install_package_group()  # $1 is the group name
{
    PackageGroup=$1

    if [[ $PackageManager == "" ]]; then
        get_package_manager
        if [[ $PackageManager == "" ]]; then
            return EXIT_STATUS_FAILURE
        fi
        install_package_group $PackageGroup
    else
        packages=$PackagesList[$PackageGroup,$PackageManager]
        if yes_no_prompt "\033[1;32mInstall\033[0m group \033[1;36m'$PackageGroup'\033[1;33m {\033[0;33m\t$packages\033[1;33m}\033[0m using '\033[1;34m$PackageManager\033[0m'?"; then
            print_info "Installing group \033[1;36m'$PackageGroup'\033[1;33m {\033[0;33m$packages\033[1;33m}\033[0m using '\033[1;34m$PackageManager\033[0m'"
            install_packages $packages
        else
            print_info "\033[0;31mSkipping \033[0minstallation of group \033[1;36m'$PackageGroup'\033[0;33m using '\033[1;34m$PackageManager\033[0m'"
        fi
    fi
}

function install_all_groups()  # loop on all installation groups
{
    for g in {'Base','Neovim','pip','npm'}; do
        print_seperator "$g package group"
        install_package_group $g
    done
}

function install_fonts()
{
    verbose_run mkdir -p $FONTS_DIR
    verbose_run curl -o "$FONTS_DIR/$FONTS_NAME_JET_BRAINS" $FONTS_URL
    OLD_WD=`pwd`
    verbose_run cd $FONTS_DIR
    verbose_run unzip "$FONTS_DIR/$FONTS_NAME_JET_BRAINS"
    verbose_run fc-cache -f -v
    verbose_run cd $OLD_WD
}

function offline_install_fonts()
{
    verbose_run mkdir -p $FONTS_DIR
    verbose_run cp $FONTS_ZIP_JET_BRAINS "$FONTS_DIR/$FONTS_NAME_JET_BRAINS"
    OLD_WD=`pwd`
    verbose_run cd $FONTS_DIR
    verbose_run unzip "$FONTS_DIR/$FONTS_NAME_JET_BRAINS"
    verbose_run fc-cache -f -v
    verbose_run cd $OLD_WD
}

function install_packer()
{
    verbose_run git clone $PACKER_SRC $PACKER_DST
}

function offline_install_lsp()
{
    verbose_run tar --extract --use-compress-program="pigz" --file="$NVIM_LSP_TAR" --directory="$NVIM_LSP_DIR"
}

function offline_install_custom_lsp()
{
    verbose_run tar --extract --use-compress-program="pigz" --file="$NVIM_CUSTOM_LSP_TAR" --directory="$NVIM_CUSTOM_LSP_DIR"
}

function offline_install_plugins()
{
    verbose_run tar --extract --use-compress-program="pigz" --file="$NVIM_PLUGINS_TAR" --directory="$NVIM_PLUGINS_DIR"
}

function install_dependencies()
{

    if yes_no_prompt "Install fonts?"; then
        install_fonts
    fi
    if yes_no_prompt "Install packer?"; then
        install_packer
    fi
    print_note "Dont forget to run ':PackerInstall' and then 'PackerCompile' to get all plugins working."
}

function install_offline_items()
{
    if yes_no_prompt "Install LSP offline?"; then
        offline_install_lsp
    fi
    if yes_no_prompt "Install custom LSP offline?"; then
        offline_install_custom_lsp
    fi
    if yes_no_prompt "Install plugins offline?"; then
        offline_install_plugins
    fi
    if yes_no_prompt "Install fonts offline?"; then
        offline_install_fonts
    fi
}

# Main logic ##############################################
if yes_no_prompt "Install neovim online dependencies?"; then
    install_dependencies
fi
if yes_no_prompt "Install offline items?"; then
    install_offline_items
else
    print_note "To get tree-sitter working: \":TSInstall c cpp cmake python bash lua rst c_sharp json regex java http yaml dockerfile javascript vim\""
    print_note "To get LSP working: \":LSPInstall pyright bashls lemminx yamlls jdtls tsserver vimls cmake jsonls cssls html omnisharp sqlls\""
fi
print_note "Install NeoVim 0.5.1 or newer. If your repos don't have it, you can use the appimage from https://github.com/neovim/neovim/releases"
