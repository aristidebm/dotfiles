# vim:ft=sh

[ -f ~/.Xresources] && xrdb ~/.Xresources

[ -f ~/.xprofile] && source ~/.xprofile

setxkbmap -option compose:caps &

# Launch Notification daemon
dunst &

# Launch battery monitor
battery &

xset r rate 300 40

# Set the background
# feh --bg-scale ~/Pictures/background/lofoten-wilderness-3840x2160-20426.jpg &

# Lanch windows manager
session=${1:-herb}
case $session in
   qtile) exec qtile start;;
   xfce|xfce4) exec startxfce4;;
   herb|herbst|herbstluftwm) exec herbstluftwm;;
   i3|i3m) exec i3;;
   * ) exec $1;;
esac
