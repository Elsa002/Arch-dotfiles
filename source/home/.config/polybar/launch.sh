#!/usr/bin/env bash

DIR="$HOME/.config/polybar"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.001; done

# read screen orientation
read -r line < <($DIR/read_orientation.sh) 

# Launch bars
if [[ "$line" == "normal" || "$line" == "bottom-up" ]]; then
	polybar top &
	polybar bottom &
	echo "Bars launched(top, bottom)..."
elif [[ "$line" == "right-up" || "$line" == "left-up" ]]; then
	polybar small-top &
	polybar small-bottom &
	echo "Bars launched(small-top, small-bottom)..."
else
	polybar top &
	polybar bottom &
	echo "Bars launched(top, bottom)..."
fi
