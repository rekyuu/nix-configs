#! /usr/bin/env bash

PREFIX="$1"
FILETYPE="$2"
FPS="$3"
START_FRAME="$4"

ffmpeg \
    -r "$FPS" \
    -f image2 \
    -start_number "$START_FRAME" \
    -i "$PREFIX"%04d."$FILETYPE" \
    -vcodec libx265 \
    -qp 0 \
    "$PREFIX"_OUT.mp4