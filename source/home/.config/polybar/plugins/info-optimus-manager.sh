#!/bin/sh

# Simple script for displaying and switching gpus for optimus-manager and polybar.


# Configuration

# Set the symbols to be displayed in polybar
intel_symbol="%{F#a0e0ff}Intel%{F-}"
nvidia_symbol="%{F#00ff60}Nvidia%{F-}"
hybrid_symbol="%{F#a0e0c0}Hyb%{F#a0e0ff}rid%{F-}"

# Prefered setup. 
# Set to 1 if the system switches between intel and hybrid.
# Set to 0 if the system switches between intel and nvidia.
hybrid_switching=1



# Functions

get_current(){
	mode=$(prime-offload && optimus-manager --print-mode)
	
	if [[ $mode == *"integrated"* ]]; then
		echo "intel"
	elif [[ $mode == *"nvidia"* ]]; then
		echo "nvidia"
	elif [[ $mode == *"hybrid"* ]]; then
		echo "hybrid"
	fi
}

display_gpu(){
	if [[ $(get_current) == "intel" ]]; then
		echo "$intel_symbol"
	elif [[ $(get_current) == "nvidia" ]]; then
		echo "$nvidia_symbol"
	elif [[ $(get_current) == "hybrid" ]]; then
		echo "$hybrid_symbol"
	fi
}

switch_gpu(){	
	if [[ $(get_current) == "nvidia" ]]; then
		next="intel"
	elif [[ $(get_current) == "intel" ]]; then
		if [[ $hybrid_switching == 1 ]]; then
			next="hybrid"
		else
			next="nvidia"
		fi
	elif [[ $(get_current) == "hybrid" ]]; then
		next="intel"
	fi	
	eval "prime-offload && optimus-manager --switch $next --no-confirm"
}

# Handle arguments. 

case "$1" in
	--switch)
		switch_gpu
		;;
	*)
		display_gpu
		;;
esac
