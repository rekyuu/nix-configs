#! /usr/bin/env bash

DESKTOP="Desktop [PRTSCR]"
ACTIVE_WINDOW="Active window [ALT + PRTSCR]"
ACTIVE_MONITOR="Active monitor"
SELECTION_MONITOR="Select monitor"
SELECTION="Selection [SHIFT + PRTSCR]"
SELECTION_VIDEO="Selection (Video) [CTRL + PRTSCR]"
TIMELAPSE="Timelapse"

OPTS="$ACTIVE_MONITOR;$SELECTION_MONITOR;$ACTIVE_WINDOW;$SELECTION;$SELECTION_VIDEO;$DESKTOP;$TIMELAPSE"

CHOICE=$(echo "$OPTS" | rofi -dmenu -sep ';' -m DP-1)

case "$CHOICE" in
    "$DESKTOP")
        if [[ $DESKTOP_SESSION == hyprland* ]]; then
            screenshot-hyprland.sh desktop
        elif [[ $DESKTOP_SESSION == "sway" ]]; then
            screenshot-sway.sh desktop
        fi
        ;;
    "$ACTIVE_WINDOW")
        if [[ $DESKTOP_SESSION == hyprland* ]]; then
            screenshot-hyprland.sh active-window
        elif [[ $DESKTOP_SESSION == "sway" ]]; then
            screenshot-sway.sh active-window
        fi
        ;;
    "$ACTIVE_MONITOR")
        if [[ $DESKTOP_SESSION == hyprland* ]]; then
            screenshot-hyprland.sh active-monitor
        elif [[ $DESKTOP_SESSION == "sway" ]]; then
            screenshot-sway.sh active-monitor
        fi
        ;;
    "$SELECTION_MONITOR")
        if [[ $DESKTOP_SESSION == hyprland* ]]; then
            screenshot-hyprland.sh selection-monitor
        elif [[ $DESKTOP_SESSION == "sway" ]]; then
            screenshot-sway.sh selection-monitor
        fi
        ;;
    "$SELECTION")
        if [[ $DESKTOP_SESSION == hyprland* ]]; then
            screenshot-hyprland.sh selection
        elif [[ $DESKTOP_SESSION == "sway" ]]; then
            screenshot-sway.sh selection
        fi
        ;;
    "$SELECTION_VIDEO")
        if [[ $DESKTOP_SESSION == hyprland* ]]; then
            screenshot-hyprland.sh selection-video
        elif [[ $DESKTOP_SESSION == "sway" ]]; then
            screenshot-sway.sh selection-video
        fi
        ;;
    "$TIMELAPSE")
        if [[ $DESKTOP_SESSION == hyprland* ]]; then
            screenshot-hyprland.sh timelapse
        elif [[ $DESKTOP_SESSION == "sway" ]]; then
            exit 0
        fi
        ;;
esac