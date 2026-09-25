#! /usr/bin/env bash

FILEPATH=$1

FILE=$(basename -- "$FILEPATH")
FILENAME="${FILE%.*}"

# https://github.com/hugocnobre/my-linux-configs/blob/main/video-editing/davinci-resolve-import.md#davinci-resolve

ffmpeg -i "$FILE" -c:v prores_ks -profile:v 3 -qscale:v 9 -c:a pcm_s16le "${FILENAME}_prores.mov"