# source global env
source $HOME/.global_settings

# Use Xresources
xrdb -merge $HOME/.Xresources

# Here i3 is kept as default
session=${1:-i3}

case $session in
    i3|i3wm           ) exec i3;;
    kde               ) exec startplasma-x11;;
    # No known session, try to run it as command
    *                 ) exec $1;;
esac
