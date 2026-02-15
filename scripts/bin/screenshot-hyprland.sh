#! /usr/bin/env bash

export SLURP_ARGS="-b 00000075 -B 00000075 -c FFFFFFFF -d -w 1"

function slurp-custom() {
    eval "slurp $SLURP_ARGS"
}

filename=$(date "+%Y-%m-%d_%H-%M-%S-%3N")
foldername=$(date "+%Y-%m")
destination_folder=~/Screenshots/$foldername
output="$destination_folder/$filename"

mkdir -p "$destination_folder"

case $1 in
    all) # prtscr
        grimblast --freeze save screen "$output.png"
        ;;
    window) # alt + prtscr
        grimblast --freeze save active "$output.png"
        ;;
    selection) # shift + prtscr
        grimblast --freeze save area "$output.png"
        ;;
    video) # ctrl + prtscr
        if ! [[ -f /tmp/rec-pid ]]; then
            geometry="$(slurp-custom)"

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

            notify-send "Video recording finished."z
        fi
        ;;
esac

if [[ -f "$output.png" ]]; then
    wl-copy < "$output.png"
    notify-send "Image copied to clipboard."
fi