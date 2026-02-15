#! /usr/bin/env bash

export SLURP_ARGS="-b 00000075 -B 00000075 -c FFFFFFFF -d -w 1"

function get-sway-window-id() {
    swaymsg -t get_tree | jq ".. | select(.type?) | select(.pid==$1).id"
}

filename=$(date "+%Y-%m-%d_%H-%M-%S-%3N")
foldername=$(date "+%Y-%m")
destination_folder=~/Screenshots/$foldername
output="$destination_folder/$filename"

mkdir -p "$destination_folder"

case $1 in
    desktop) # prtscr
        grim "$output.png"
        ;;
    active-window) # alt + prtscr
        window=$(swaymsg -t get_tree | jq '.. | select(.type?) | select(.focused==true)')
        pos_x=$(echo "$window" | jq ".rect.x")
        pos_y=$(echo "$window" | jq ".rect.y")
        width=$(echo "$window" | jq ".rect.width")
        height=$(echo "$window" | jq ".rect.height")

        grim -g "${pos_x},${pos_y} ${width}x${height}" "$output.png"
        ;;
    active-monitor)
        window=$(swaymsg -t get_outputs | jq '.. | select(.type?) | select(.focused==true)')
        pos_x=$(echo "$window" | jq ".rect.x")
        pos_y=$(echo "$window" | jq ".rect.y")
        width=$(echo "$window" | jq ".rect.width")
        height=$(echo "$window" | jq ".rect.height")

        grim -g "${pos_x},${pos_y} ${width}x${height}" "$output.png"
        ;;
    selection-monitor)
        grim -t ppm - | feh - &
        FEH_PID=$!

        swaymsg "for_window [pid=$FEH_PID] fullscreen enable global"

        while [ -z "$(get-sway-window-id $FEH_PID)" ]; do
            sleep 0.1
        done

        grim -g "$(eval slurp "$SLURP_ARGS" -or)" "$output.png"

        kill "$FEH_PID"
        ;;
    selection) # shift + prtscr
        grim -t ppm - | feh - &
        FEH_PID=$!

        swaymsg "for_window [pid=$FEH_PID] fullscreen enable global"

        while [ -z "$(get-sway-window-id $FEH_PID)" ]; do
            sleep 0.1
        done

        grim -g "$(eval slurp "$SLURP_ARGS")" "$output.png"

        kill "$FEH_PID"
        ;;
    selection-video)
        if ! [[ -f /tmp/rec-pid ]]; then
            geometry="$(eval slurp "$SLURP_ARGS")"

            if [[ "$geometry" != "" ]]; then
                wf-recorder -g "$geometry" -r 60 -f "$output.mp4" &
                REC_PID=$!

                echo "$REC_PID" >> /tmp/rec-pid

                notify-send "Video recording started."
            fi
        else
            REC_PID="$(cat /tmp/rec-pid)"
            kill "$REC_PID"

            rm /tmp/rec-pid

            notify-send "Video recording finished."
        fi
        ;;
esac

if [[ -f "$output.png" ]]; then
    wl-copy < "$output.png"
    notify-send "Image copied to clipboard."
fi