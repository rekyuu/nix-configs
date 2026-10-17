#! /usr/bin/env bash

FILEPATH=$1
START_TIME=$2
END_TIME=$3

FILE=$(basename -- "$FILEPATH")
FILENAME="${FILE%.*}"
FILEEXTENSION="${FILE##*.}"

ffmpeg -i "$FILE" -ss "$START_TIME" -to "$END_TIME" -c copy -avoid_negative_ts make_zero "${FILENAME}_trim.${FILEEXTENSION}"