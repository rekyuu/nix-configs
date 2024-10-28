#! /usr/bin/env bash

FILENAME="$1"
FPS="$2"
START_FRAME="$3"

ffmpeg -r "$FPS" -f image2 -s 1280x720 -start_number "$START_FRAME" -i "$FILENAME"%04d.png -vcodec libx264 -crf 25 -pix_fmt yuv420p "$FILENAME".mp4