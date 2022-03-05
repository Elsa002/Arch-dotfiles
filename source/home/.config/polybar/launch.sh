#!/usr/bin/env bash

DIR="$HOME/.config/polybar"

# top bars: top, top-minimal, small-top
# bottom bars: bottom, bottom-minimal, small-bottom
# MAIN_TOP_BAR="top"
# MAIN_BOTTOM_BAR="bottom"
# VERTICAL_TOP_BAR="small-top"
# VERTICALMAIN_BOTTOM_BAR="small-bottom"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.001; done

# read screen orientation
read -r line < <($DIR/read_orientation.sh)

# Launch bars
if [[ "$line" == "normal" || "$line" == "bottom-up" ]]; then
	polybar $MAIN_TOP_BAR &
	polybar $MAIN_BOTTOM_BAR &
	echo "Bars launched(top, bottom)..."
elif [[ "$line" == "right-up" || "$line" == "left-up" ]]; then
	polybar $VERTICAL_TOP_BAR &
	polybar $VERTICALMAIN_BOTTOM_BAR &
	echo "Bars launched(small-top, small-bottom)..."
else
	polybar $MAIN_TOP_BAR &
	polybar $MAIN_BOTTOM_BAR &
	echo "Bars launched(top, bottom)..."
fi
