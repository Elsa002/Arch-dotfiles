#!/usr/bin/env bash

DIR="$HOME/.config/polybar"

# read screen orientation
read -r line < <($DIR/read_orientation.sh) 

# Launch top and bottom bars
if [[ "$line" == "normal" || "$line" == "bottom-up" ]]; then
	echo "Bars launched(top, bottom)..."
elif [[ "$line" == "right-up" || "$line" == "left-up" ]]; then
	echo "Bars launched(small-top, small-bottom)..."
else
	echo "Bars launched(top, bottom)..."
fi
