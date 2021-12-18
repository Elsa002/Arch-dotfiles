#!/bin/zsh
SCRIPT_DIR="`dirname $0`"

# Includes ###############################################
source "$SCRIPT_DIR/installer/installer-tools.sh"

# Script #################################################
# Change to the script directory
verbose_run cd "$SCRIPT_DIR"
SCRIPT_DIR=`pwd`

if yes_no_prompt 'Update nvim installer'; then
    $HOME/.config/nvim/installer/update_installer.sh
    print_done "Updating nvim installer."
else
    print_info 'Skipping nvim update'
fi

print_seperator "Removing old source files"
verbose_run rm -rf source/home
print_done "Removing old source files."

# Copy config files
print_seperator "Copy LSP files"
verbose_run mkdir -p source/home/.language-servers
for i in {arduino-language-server,lua-language-server}
do
    verbose_run cp -r $HOME/.language-servers/$i source/home/.language-servers
done
print_done "Copy LSP files."

# Copy config files
print_seperator "Copy config files"
verbose_run mkdir -p source/home/.config
for i in {i3,kitty,nvim,picom,polybar,rofi,qt5ct,xournalpp,kdeglobals}
do
    verbose_run cp -r $HOME/.config/$i source/home/.config
done
print_done "Copy config files."

# Copy zsh files
print_seperator "Copy zsh files"
verbose_run mkdir -p source/home
for i in {.oh-my-zsh,.p10k.zsh,.custom-zshrc.zsh,.simple-zshrc.zsh,.zshrc,.aliases}
do
    verbose_run cp -r $HOME/$i source/home
done
print_done "Copy zsh files."

# Copy general settings files
print_seperator "Copy general settings files"
verbose_run mkdir -p source/home
for i in {.global_settings,.kde4,.fonts,.xinitrc,.wallpapers,.scripts}
do
    verbose_run cp -r $HOME/$i source/home
done
print_done "Copy general settings files."

# Copy desktop files
print_seperator "Copy desktop files"
verbose_run mkdir -p source/home/.local/share/applications
for i in {web,extra,power,nvidia,spotify.desktop,looking-glass-client.desktop}
do
    verbose_run cp -r $HOME/.local/share/applications/$i source/home/.local/share/applications
done
print_done "Copy desktop files."

# Copy desktop files
print_seperator "Copy zsh cache files"
verbose_run mkdir -p source/home/.cache
for i in gitstatus
do
    verbose_run cp -r $HOME/.cache/$i source/home/.cache
done
print_done "Copy zsh cache files."

print_seperator "Fix git submodules"
for i in `find -name .git | grep source/home`
do
    verbose_run mv $i `dirname $i`/..git
done
for i in `find -name .gitignore | grep source/home`
do
    verbose_run mv $i `dirname $i`/..gitignore
done
print_done "Fix git submodules."

# Copy /opt/bin files
print_seperator "Copy /opt/bin files"
# Copy regular scripts
verbose_run mkdir -p source/opt-bin
for i in kill_script
do
    verbose_run cp /opt/bin/$i source/opt-bin
done

# Copy root scripts
verbose_run mkdir -p source/opt-bin-root
for i in {start_i3,vm-setup}
do
    verbose_run cp -r $HOME/.root-scripts/$i source/opt-bin-root
done

print_done "updating."

