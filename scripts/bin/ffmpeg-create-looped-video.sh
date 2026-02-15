#! /usr/bin/env bash

FILENAME="$1"
LOOP_TIMES="$2"

ffmpeg -y -stream_loop "$LOOP_TIMES" -i "$FILENAME.mp4" -c copy "${FILENAME}_loop.mp4"