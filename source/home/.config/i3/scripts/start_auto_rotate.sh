#!/bin/bash

# run the following command to get devices list: xinput --list | grep -o -e 'Wacom [a-zA-Z0-9 ()]*'

kill_script "auto_rotate.sh"
~/.config/i3/scripts/auto_rotate.sh "eDP-1" "eDP-1-1" "Wacom HID 50FE Finger" "Wacom HID 50FE Pen Pen (0x9b1c2429)" "Wacom HID 50FE Pen Eraser (0x9b1c2429)" &
