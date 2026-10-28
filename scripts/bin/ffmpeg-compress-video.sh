#! /usr/bin/env bash

FILEPATH=$1
CRF=${2:-18}

FILE=$(basename -- "$FILEPATH")
FILENAME="${FILE%.*}"
FILEEXTENSION="${FILE##*.}"

ffmpeg \
    -i "$FILEPATH" \
    -vcodec libx265 \
    -crf "$CRF" \
    "$FILENAME-compressed.$FILEEXTENSION"