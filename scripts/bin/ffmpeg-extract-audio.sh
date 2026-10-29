#! /usr/bin/env bash

FILEPATH=$1

FILE=$(basename -- "$FILEPATH")
FILENAME="${FILE%.*}"

ffmpeg -i "$FILEPATH" -vn -acodec libmp3lame "$FILENAME.mp3"