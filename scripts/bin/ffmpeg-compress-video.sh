#! /usr/bin/env bash

FILEPATH=$1

FILE=$(basename -- "$FILEPATH")
FILENAME="${FILE%.*}"
FILEEXTENSION="${FILE##*.}"

ffmpeg \
    -i "$FILEPATH" \
    -vcodec libx265 \
    -crf 28 \
    "$FILENAME-compressed.$FILEEXTENSION"