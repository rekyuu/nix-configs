#! /usr/bin/env bash

DESKTOP="Desktop [PRTSCR]"
ACTIVE_WINDOW="Active window [ALT + PRTSCR]"
ACTIVE_MONITOR="Active monitor"
SELECTION_MONITOR="Select monitor"
SELECTION="Selection [SHIFT + PRTSCR]"
SELECTION_VIDEO="Selection (Video) [CTRL + PRTSCR]"

OPTS="$ACTIVE_MONITOR;$SELECTION_MONITOR;$ACTIVE_WINDOW;$SELECTION;$SELECTION_VIDEO;$DESKTOP"

CHOICE=$(echo "$OPTS" | rofi -dmenu -sep ';' -m DP-1)

case "$CHOICE" in
    "$DESKTOP")
        screenshot-sway.sh desktop
        ;;
    "$ACTIVE_WINDOW")
        screenshot-sway.sh active-window
        ;;
    "$ACTIVE_MONITOR")
        screenshot-sway.sh active-monitor
        ;;
    "$SELECTION_MONITOR")
        screenshot-sway.sh selection-monitor
        ;;
    "$SELECTION")
        screenshot-sway.sh selection
        ;;
    "$SELECTION_VIDEO")
        screenshot-sway.sh selection-video
        ;;
esac