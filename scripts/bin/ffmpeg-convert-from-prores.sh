#! /usr/bin/env bash

FILEPATH=$1
CRF=${2:-28}

FILE=$(basename -- "$FILEPATH")
FILENAME="${FILE%.*}"

# https://github.com/Danie10/yaml-snippets/blob/main/davincimp4.sh

ffmpeg -i "$FILE" -vf yadif -codec:v libx264 -crf "$CRF" -bf 2 -flags +cgop -pix_fmt yuv420p -codec:a aac -strict -2 -b:a 384k -r:a 48000 -movflags faststart "${FILENAME}_compressed.mp4"