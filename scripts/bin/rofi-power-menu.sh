#! /usr/bin/env bash

LOGOUT="Logout"
SHUTDOWN="Shutdown"
REBOOT="Reboot"
RELOAD_SWAY="Reload Sway"

DEFAULT_OPTIONS="$LOGOUT;$SHUTDOWN;$REBOOT"

if [[ $DESKTOP_SESSION == "sway" ]]; then
    CHOICE=$(echo "$RELOAD_SWAY;$DEFAULT_OPTIONS" \
        | rofi -dmenu -sep ';' -m DP-1)
else
    CHOICE=$(echo "$DEFAULT_OPTIONS" \
        | rofi -dmenu -sep ';' -m DP-1)
fi

case "$CHOICE" in
    "$LOGOUT")
        if [[ $DESKTOP_SESSION == hyprland* ]]; then
            hyprshutdown --post-cmd "hyprctl dispatch exit"
        elif [[ $DESKTOP_SESSION == "niri" ]]; then
            niri msg action quit
        elif [[ $DESKTOP_SESSION == "sway" ]]; then
            swaymsg exit
        fi
        ;;
    "$SHUTDOWN")
        if [[ $DESKTOP_SESSION == hyprland* ]]; then
            hyprshutdown --post-cmd "sudo shutdown now"
        else
            sudo shutdown now
        fi
        ;;
    "$REBOOT")
        if [[ $DESKTOP_SESSION == hyprland* ]]; then
            hyprshutdown --post-cmd "sudo reboot"
        else
            sudo reboot
        fi
        ;;
    "$RELOAD_SWAY")
        swaymsg reload
        ;;
esac