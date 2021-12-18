# Add to path
PATH="/opt/bin:$PATH"
WINEPREFIX=/home/raven/Games/games_wine_prefix

source "$HOME/.dotfiles/installer/installer-tools.sh"
source "$HOME/.dotfiles/installer/package-manager-tools.sh"
source "$HOME/.aliases"

# Start x server on tty1
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    if [ -f "/opt/bin/start_i3" ]; then
        exec /opt/bin/start_i3
        exit
    fi
    if which startx 1>/dev/null 2>&1; then
        startx
        exit
    fi
fi

# Basic aliases
alias ls="ls --color=always"

# Choose zshrc
if [ `tput colors` != "256" ] || [[ $FORCE_SIMPLE_ZSH == "1" ]]; then
    source "$HOME/.simple-zshrc.zsh"
else
    source "$HOME/.custom-zshrc.zsh"
fi

