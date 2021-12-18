#!/bin/zsh
SCRIPT_DIR="`dirname $0`"

# Includes ###############################################
source "$SCRIPT_DIR/installer-tools.sh"
source "$SCRIPT_DIR/package-manager-tools.sh"

# Globals ################################################
# Packages list
declare -A PackagesList=(
    ['Base','yay']="zsh bash git gcc clang make cmake gzip less linux linux-api-headers linux-firmware linux-headers lld llvm-libs man-db man-pages alsa-utils alsa-lib bluez bluez-utils htop bridge-utils curl gdb grep grub mkinitcpio mono net-tools networkmanager noto-fonts noto-fonts-emoji npm ntfs-3g openssh os-prober pam pigz polkit pipewire pipewire-alsa pipewire-media-session pipewire-pulse python rsync sudo tree unzip vifm vim nano wget which zip"

    ['Fonts','yay']="ttf-dejavu ttf-font-icons ttf-icomoon-feather ttf-material-design-icons ttf-roboto ttf-roboto-mono"

    ['Neovim','yay']="neovim python-pynvim fzf lua pyright clangd tree-sitter xclip arduino-cli bash-language-server"

    ['Desktop','yay']="i3-gaps i3blocks i3lock i3status polybar xorg xorg-xinit picom kitty ark dolphin awesome-terminal-fonts breeze breeze-gtk breeze-icons discord feh firefox kate nautilus oh-my-zsh-git papirus-icon-theme polkit-qt5 qt5-base rofi rofi-bluetooth-git rofi-calc rofi-emoji rofi-wifi-menu-git rofimoji vlc pavucontrol"

    ['Nvidia','yay']="nvidia-dkms nvidia-prime nvidia-settings nvidia-utils optimus-manager"

    ['Intel','yay']="intel-gpu-tools intel-media-driver intel-gmmlib mesa xf86-input-libinput xf86-video-dummy xf86-video-intel xf86-video-vesa"

    ['Extra','yay']="arch-install-scripts bpytop btop cowsay ctags downgrade fortune-mod gotop ipython lolcat neofetch samba vkd3d wine wine-mono winetricks"

    ['ExtraDesktop','yay']="bluez-qt etcher-bin gameconqueror gparted grub-customizer iio-sensor-proxy kdenlive laptop-mode-tools lm_sensors looking-glass partitionmanager popcorntime-bin qtcreator steam timeshift tlauncher unityhub virt-manager xdotool xournalpp"

    ['Laptop','yay']="iio-sensor-proxy laptop-mode-tools lm_sensors"
)


# Functions ##############################################
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
    for g in {'Base','Neovim','Desktop','Nvidia','Intel','Extra','ExtraDesktop','Laptop'}; do
        print_seperator "$g package group"
        install_package_group $g
    done
}

# Script logic ###########################################
sourced=0
if [ -n "$ZSH_EVAL_CONTEXT" ]; then 
  case $ZSH_EVAL_CONTEXT in *:file) sourced=1;; esac
elif [ -n "$KSH_VERSION" ]; then
  [ "$(cd $(dirname -- $0) && pwd -P)/$(basename -- $0)" != "$(cd $(dirname -- ${.sh.file}) && pwd -P)/$(basename -- ${.sh.file})" ] && sourced=1
elif [ -n "$BASH_VERSION" ]; then
  (return 0 2>/dev/null) && sourced=1 
else # All other shells: examine $0 for known shell binary filenames
  # Detects `sh` and `dash`; add additional shell filenames as needed.
  case ${0##*/} in sh|dash) sourced=1;; esac
fi

if [[ $sourced == 0 ]]; then
    print_note "You are about to install packages. You will be prompted again with more details before each package group."
    if yes_no_prompt "Are you sure you want to install dependencies?"; then
        print_info "Try to install dependencies"
        install_all_groups
        print_done "Installing groups"
    else
        print_warning "Not installing any package."
        return $EXIT_STATUS_FAILURE
    fi
fi

