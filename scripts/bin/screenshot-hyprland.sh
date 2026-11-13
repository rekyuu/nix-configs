#! /usr/bin/env bash

export SLURP_ARGS="-b 00000075 -B 00000075 -c FFFFFFFF -d -w 1"

filename=$(date "+%Y-%m-%d_%H-%M-%S-%3N")
foldername=$(date "+%Y-%m")
destination_folder=~/Screenshots/$foldername
output="$destination_folder/$filename"

mkdir -p "$destination_folder"

case "$1" in
    "desktop") # prtscr
        grimblast copysave screen "$output.png"
        ;;
    "active-window") # alt + prtscr
        grimblast copysave active "$output.png"
        ;;
    "active-monitor")
        # not yet implemented
        exit 0
        ;;
    "selection-monitor")
        grim -g "$(eval slurp "$SLURP_ARGS" -or)" "$output.png"
        ;;
    "selection") # shift + prtscr
        grimblast --freeze copysave area "$output.png"
        ;;
    "selection-video") # ctrl + prtscr
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
    "timelapse")
        if ! [[ -f /tmp/timelapse-pid ]]; then
            geometry="$(eval slurp "$SLURP_ARGS" -or)"
            timelapse_folder=~/Screenshots/timelapses/$filename

            mkdir -p "$timelapse_folder"

            if [[ "$geometry" != "" ]]; then
                i=0
                while true; do
                    timelapse_filename=$(printf "%05d" "$i")
                    grim -g "$geometry" "$timelapse_folder/$timelapse_filename.png"
                    i=$((i+1))
                    sleep 5
                done &
                TIMELAPSE_PID=$!

                echo "$TIMELAPSE_PID" >> /tmp/timelapse-pid

                notify-send "Timelapse started."
            fi
        else
            TIMELAPSE_PID="$(cat /tmp/timelapse-pid)"
            kill "$TIMELAPSE_PID"

            rm /tmp/timelapse-pid

            notify-send "Timelapse finished."
        fi
        ;;
esac

if [[ -f "$output.png" ]]; then
    wl-copy < "$output.png"
    notify-send "Image copied to clipboard."
fi