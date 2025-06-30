#! /usr/bin/env bash

PREFIX="$1"
FILETYPE="$2"
RESOLUTION="$3"
FPS="$4"
START_FRAME="$5"

ffmpeg -r "$FPS" -f image2 -s "$RESOLUTION" -start_number "$START_FRAME" -i "$PREFIX"%04d."$FILETYPE" -vcodec libx264 -crf 25 -pix_fmt yuvj420p "$PREFIX"_OUT.mp4