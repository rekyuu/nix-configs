#! /usr/bin/env bash

FILE=$1
START_TIME=$2
END_TIME=$3

OUTFILE="${FILE/%.mkv/.mp4}"

ffmpeg -i "$FILE" -ss "$START_TIME" -to "$END_TIME" -c:v copy -c:a copy "$OUTFILE"