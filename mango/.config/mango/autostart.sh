# waybar -c ~/.config/waybar/config -s ~/.config/waybar/style.css >/dev/null 2>&1 &
# source: https://github.com/DreamMaoMao/mangowc/issues/299#issuecomment-3417820118

# This is useful for binaries installed with nix/cargo or go pickup in systemd
systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP DISPLAY XDG_SESSION_TYPE PATH
systemctl --user start graphical-session.target
dbus-update-activation-environment --systemd PATH

battery &

emacs --daemon &
