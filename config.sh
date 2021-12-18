#!/bin/zsh
SCRIPT_DIR="`dirname $0`"

# Includes ################################################
source "$SCRIPT_DIR/installer/installer-tools.sh"

# Functions ###############################################
function set_font_size()
{
    font_size="$1"
    bar_font_offset="($2)"
    rofi_font_offset="($3)"

    ## Bar font size and size
    bar_font_size=$(($font_size+$bar_font_offset))
    bar_size=$(($bar_font_size*3))
    verbose_run sed -i "s/^export BAR_FONT_SIZE=[0-9]\+\$/export BAR_FONT_SIZE=${bar_font_size}/" "$HOME/.global_settings"
    verbose_run sed -i "s/^export TOP_BAR_HEIGHT=[0-9]\+\$/export TOP_BAR_HEIGHT=${bar_size}/" "$HOME/.global_settings"

    ## Terminals font size
    # Kitty
    verbose_run sed -i "s/^font_size [0-9.]\+\$/font_size ${font_size}/" "$HOME/.config/kitty/kitty.conf"
    # Others (rxvt, xterm ...)
    verbose_run sed -i "s/^#define fint_size [0-9]\+\$/#define fint_size ${font_size}/" "$HOME/.Xresources"

    ## Rofi font size
    rofi_font_size=$(($font_size+$rofi_font_offset))
    rofi_font_line="`grep -o 'font: "[a-zA-Z ]\+' ~/.config/rofi/config.rasi`${rofi_font_size}\";"
    verbose_run sed -i "s/font: \"[a-zA-Z0-9 ]\+\";/${rofi_font_line}/" "$HOME/.config/rofi/config.rasi"
}

function set_scale_size()
{
    global_scale="$1"
    verbose_run sed -i "s/^export CUSTOM_GLOBAL_SCALE_FACTOR=[0-9]\+\$/export CUSTOM_GLOBAL_SCALE_FACTOR=${global_scale}/" "$HOME/.global_settings"
    verbose_run sed -i "s/scale-factor=[0-9]\+/scale-factor=${global_scale}/" "$HOME/.local/share/applications/spotify.desktop"
}

function set_nvidia_settings()
{
    enable_nvidia="false"
    if [[ "$1" ]]; then
        enable_nvidia="$1"  # true/false
    fi

    polybar_nvidia_regex='modules-right = \(info-optimus-manager-ipc \)\?lsep memory'
    polybar_with_nvidia='modules-right = info-optimus-manager-ipc lsep memory'
    polybar_without_nvidia='modules-right = lsep memory'
    polybar_file="$HOME/.config/polybar/config.ini"

    if [[ "$enable_nvidia" == "true" ]] || [[ "$enable_nvidia" == "1" ]]; then
        # polybar
        verbose_run sed -i "s/${polybar_nvidia_regex}/${polybar_with_nvidia}/" "${polybar_file}"
    else
        # polybar
        verbose_run sed -i "s/${polybar_nvidia_regex}/${polybar_without_nvidia}/" "${polybar_file}"
    fi
}

function simple_font_prompt()
{
    read_prompt "Enter terminal font size(default for 4k screen is 32)"
    terminal_font_size=$_prompt_result
    bar_font_size_off="0"
    rofi_font_size_off="$(($terminal_font_size / 2))"

    if yes_no_prompt "Set new font sizes?"; then
        set_font_size "$terminal_font_size" "$bar_font_size_off" "$rofi_font_size_off"
    fi
}

function font_prompt()
{
    read_prompt "Enter terminal font size(default for 4k screen is 32)"
    terminal_font_size=$_prompt_result

    read_prompt "Enter bar font size offset(default 0)"
    bar_font_size_off=$_prompt_result

    read_prompt "Enter rofi font size offset(default for 32 terminal font is 16 (50%))"
    rofi_font_size_off=$_prompt_result

    if yes_no_prompt "Set new font sizes?"; then
        set_font_size "$terminal_font_size" "$bar_font_size_off" "$rofi_font_size_off"
    fi
}

function scale_prompt()
{
    read_prompt "Enter global scale(default for FHD is 1, for 4k is 2)"
    global_scale=$_prompt_result
    set_scale_size "$global_scale"
}

function nvidia_prompt()
{
    if yes_no_prompt "Does the computer use nvidia optimus?"; then
        set_nvidia_settings 1
    else
        set_nvidia_settings 0
    fi
}

function choose_config()
{
    read_prompt "Enter config option(help to list all options)"
    case $_prompt_result in
        "help"|"h")
            echo "Possible options are:\n\t- help | h\n\t- done | exit | finish\n\t- font\n\t- font-advanced\n\t- scale\n\t- nvidia"
            ;;
        "done"|"exit"|"finish")
            return $EXIT_STATUS_SUCCESS
            ;;
        "font")
            simple_font_prompt
            ;;
        "font-advanced")
            font_prompt
            ;;
        "scale")
            scale_prompt
            ;;
        "nvidia")
            nvidia_prompt
            ;;
        *)
            echo "Invalid option: \"$_prompt_result\", please enter a valid option. Enter help to see the options."
            ;;
    esac
    return $EXIT_STATUS_FAILURE
}

# Script ##################################################
print_seperator "Configuring the system"
while ! choose_config; do; done
print_done "Configuring the system."

