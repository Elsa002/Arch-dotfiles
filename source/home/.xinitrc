# nvidia optimus stuff
xrandr --setprovideroutputsource modesetting NVIDIA-0
xrandr --auto

# Here i3 is kept as default
session=${1:-i3}

# Per session config
case $session in
    i3|i3wm)
        # source global env
        source $HOME/.global_settings

        # Use Xresources
        xrdb -merge $HOME/.Xresources

        # import DISPLAY
        systemctl --user import-environment DISPLAY

        # Start i3
        exec i3
        ;;
    kde)
        exec startplasma-x11
        ;;
    # No known session, try to run it as command
    *)
        exec $1
        ;;
esac
