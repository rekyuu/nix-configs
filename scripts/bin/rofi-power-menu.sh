#! /usr/bin/env bash

LOGOUT="Logout"
SHUTDOWN="Shutdown"
REBOOT="Reboot"
RELOAD_SWAY="Reload Sway"
ADJUST_HYPRLAND_LAYOUT="Adjust Hyprland Layout"

DEFAULT_OPTIONS="$LOGOUT;$SHUTDOWN;$REBOOT"

if [[ $DESKTOP_SESSION == "hyprland" ]]; then
    CHOICE=$(echo "$ADJUST_HYPRLAND_LAYOUT;$DEFAULT_OPTIONS" \
        | rofi -dmenu -sep ';' -m DP-1)
elif [[ $DESKTOP_SESSION == "sway" ]]; then
    CHOICE=$(echo "$RELOAD_SWAY;$DEFAULT_OPTIONS" \
        | rofi -dmenu -sep ';' -m DP-1)
else
    CHOICE=$(echo "$DEFAULT_OPTIONS" \
        | rofi -dmenu -sep ';' -m DP-1)
fi

case "$CHOICE" in
    "$LOGOUT")
        if [[ $DESKTOP_SESSION == "hyprland" ]]; then
            hyprctl dispatch exit
        elif [[ $DESKTOP_SESSION == "niri" ]]; then
            niri msg action quit
        elif [[ $DESKTOP_SESSION == "sway" ]]; then
            swaymsg exit
        fi
        ;;
    "$SHUTDOWN")
        sudo shutdown now
        ;;
    "$REBOOT")
        sudo reboot
        ;;
    "$ADJUST_HYPRLAND_LAYOUT")
        hyprland-adjust-layout.py
        ;;
    "$RELOAD_SWAY")
        swaymsg reload
        ;;
esac