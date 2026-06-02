#! /usr/bin/env bash

FILEPATH=$1

FILE=$(basename -- "$FILEPATH")
FILENAME="${FILE%.*}"
FILEEXTENSION="${FILE##*.}"

ffmpeg \
    -i "$FILEPATH" \
    -vf reverse \
    "$FILENAME-reversed.$FILEEXTENSION"