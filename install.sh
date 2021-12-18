#!/bin/zsh
SCRIPT_DIR="`dirname $0`"

# Includes ################################################
source "$SCRIPT_DIR/installer/installer-tools.sh"

# Constants ###############################################
TMP_DIR_PATH="/tmp/dotfiles-source-$USER.tmp"

# Functions ###############################################
function fix_git_submodules()
{
    print_seperator "Fix git submodules"
    # Change working directory to $TMP_DIR_PATH
    verbose_run rm -rf $TMP_DIR_PATH 2>/dev/null
    verbose_run mkdir $TMP_DIR_PATH
    verbose_run cp -r source $TMP_DIR_PATH
    verbose_run cd $TMP_DIR_PATH

    # Fix git stuff
    for i in `find -name ..git | grep source`
    do
        verbose_run mv $i `dirname $i`/.git
    done
    for i in `find -name ..gitignore | grep source`
    do
        verbose_run mv $i `dirname $i`/.gitignore
    done
    print_done "Fix git submodules."
}

function install_files()
{
    print_seperator "Installing files"
    if yes_no_prompt "Install files?"; then
        verbose_run cp -r source/home/.* $HOME/
        print_note "Errors about .git files and .cache files can be ignored."
        print_done "installing files."
    else
        print_info "Skipping files installation."
    fi
}

function install_opt_bin()
{
    print_seperator "Copy /opt/bin files"
    if yes_no_prompt "Copy files outside of the home directory?"
    then
        # Copy regular scripts
        verbose_run sudo cp source/opt-bin/* /opt/bin

        # Copy root scripts
        verbose_run mkdir -p $HOME/.root-scripts
        for i in source/opt-bin-root/*
        do
            script_name=`basename $i`
            verbose_run cp -r source/opt-bin-root/$script_name $HOME/.root-scripts
            verbose_run cd $i
            verbose_run make -j
            verbose_run sudo cp $script_name /opt/bin
            verbose_run sudo chown root /opt/bin/$script_name
            verbose_run sudo chmod 6711 /opt/bin/$script_name
            verbose_run cd $TMP_DIR_PATH
        done
        print_done "Copy /opt/bin files."
    else
        print_info 'Skipping files outside of the home directory'
    fi
}

function install_system_settings()
{
    print_seperator "Perform system settings changes"
    print_note "This step can affect ALL of the users."
    if yes_no_prompt "Perform system settings changes?"; then
        # Pacman multilib
        if [ -f /etc/pacman.conf ] && silent_call vim --version; then
            print_vim_help
            print_note "To enable multilib, search for '[multilib]' by typing '/\[multilib\], and make sure it is uncommented, as well as the 'Include' line below it. It should be at the bottom of the file, you can get there with 'G'."
            if yes_no_prompt "Do you want to edit pacman.conf to add multilib?"; then
                verbose_run sudo vim /etc/pacman.conf
            fi
        fi
        print_done "performing system settings changes"
    else
        print_info "Skipping system settings"
    fi
}

function install_deps()
{
    print_seperator "Installing dependencies"
    if yes_no_prompt "Install dependencies?"
    then
        verbose_run "$SCRIPT_DIR/installer/install-dependencies.sh"
        print_done "Installing dependencies."
    else
        print_info 'Skipping dependencies installations'
    fi
}

function install_extra()
{
    print_seperator "Installing nvim config"
    if yes_no_prompt "Install nvim config?"
    then
        verbose_run $HOME/.config/nvim/installer/install.sh
        print_done "Install nvim config."
    else
        print_info 'Skipping nvim installer'
    fi
}

function config_dotfiles()
{
    print_seperator "Configuring settings"
    if yes_no_prompt "Run config script?"
    then
        verbose_run "$SCRIPT_DIR/config.sh"
        print_done "Configuring settings."
    else
        print_info 'Skipping Configuring settings'
    fi
}

# Script ##################################################
# Change to the script directory
verbose_run cd "$SCRIPT_DIR"
SCRIPT_DIR=`pwd`

fix_git_submodules

install_files
install_opt_bin
install_system_settings
install_deps
install_extra

config_dotfiles

print_done "Installing."

