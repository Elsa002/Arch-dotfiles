#!/bin/sh

# Automatically rotate the screen when the device's orientation changes.
# Use 'xrandr' to get the correct display for the first argument (for example, "eDP-1"),
# and 'xinput' to get the correct input element for your touch screen, if applicable
# (for example,  "Wacom HID 486A Finger").
#
# The script depends on the monitor-sensor program from the iio-sensor-proxy package.

if [ -z "$1" ]; then
	echo "Usage: $0 <display> [touchinputs ...]"
	exit 1
fi

monitor-sensor --accel \
	| grep --line-buffered "Accelerometer orientation changed" \
	| grep --line-buffered -o ": .*" \
	| while read -r line; do
		line="${line#??}"
		if [ "$line" = "normal" ]; then
			rotate=normal
			matrix="0 0 0 0 0 0 0 0 0"
		elif [ "$line" = "left-up" ]; then
			rotate=left
			matrix="0 -1 1 1 0 0 0 0 1"
		elif [ "$line" = "right-up" ]; then
			rotate=right
			matrix="0 1 0 -1 0 1 0 0 1"
		elif [ "$line" = "bottom-up" ]; then
			rotate=inverted
			matrix="-1 0 1 0 -1 1 0 0 1"
		else
			echo "Unknown rotation: $line"
			continue
		fi

		xrandr --output "$1" --rotate "$rotate"
		echo setting output $1

		if ! [ -z "$2" ]; then
			xinput set-prop "$2" --type=float "Coordinate Transformation Matrix" $matrix
			echo setting input $2
		fi

		if ! [ -z "$3" ]; then
			xinput set-prop "$3" --type=float "Coordinate Transformation Matrix" $matrix
			echo setting input $3
		fi

		if ! [ -z "$4" ]; then
			xinput set-prop "$4" --type=float "Coordinate Transformation Matrix" $matrix
			echo setting input $4
		fi

		if ! [ -z "$5" ]; then
			xinput set-prop "$5" --type=float "Coordinate Transformation Matrix" $matrix
			echo setting input $5
		fi

		if ! [ -z "$6" ]; then
			xinput set-prop "$6" --type=float "Coordinate Transformation Matrix" $matrix
			echo setting input $6
		fi

		if ! [ -z "$7" ]; then
			xinput set-prop "$7" --type=float "Coordinate Transformation Matrix" $matrix
			echo setting input $7
		fi

		if ! [ -z "$8" ]; then
			xinput set-prop "$8" --type=float "Coordinate Transformation Matrix" $matrix
			echo setting input $8
		fi

		i3-msg 'restart'
	done
