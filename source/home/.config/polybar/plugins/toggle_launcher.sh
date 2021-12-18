#!/bin/bash

if pidof rofi
then
	pkill rofi
else
	rofi -modi drun -show drun -normal-window -theme-str "scrollbar{ handle-width: 2ch; } window { width: 100%; height: 50%; location: north; anchor: north; }" -yoffset $TOP_BAR_HEIGHT 
fi
