#! /usr/bin/env bash

FILEPATH=$1

FILE=$(basename -- "$FILEPATH")
FILENAME="${FILE%.*}"

ffmpeg -i "$FILE" -vcodec libwebp -lossless 0 -q:v 80 -loop 0 "${FILENAME}.webp"