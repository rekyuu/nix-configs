#! /usr/bin/env zsh

INPUT_FILE=$1
TIMELAPSE_LENGTH_SECS=${1:-"60"}

# Assume input is 60 FPS and output will be 60 FPS

FILE=$(basename -- "$INPUT_FILE")
FILE_NAME="${FILE%.*}"
FILE_EXTENSION="${FILE##*.}"
TMP_FILE="/tmp/temp.${FILE_EXTENSION}"

DURATION=$(ffprobe -i "$INPUT_FILE" 2>&1 | grep DURATION | head -n 1 | tr -d "[:space:]")
HOURS=$(echo "$DURATION" | cut -d ":" -f 2)
MINUTES=$(echo "$DURATION" | cut -d ":" -f 3)
SECONDS=$(echo "$DURATION" | cut -d ":" -f 4)
TOTAL_SECONDS=$((("$HOURS" * 60 * 60) + ("$MINUTES" * 60) + "$SECONDS"))
TOTAL_FRAMES=$(("$TOTAL_SECONDS" * 60))
TIMELAPSE_FRAMES=$(("$TIMELAPSE_LENGTH_SECS" * 60))
FRAME_STEP=$(("$TOTAL_FRAMES" / "$TIMELAPSE_FRAMES"))
TIMELAPSE_DURATION=$(date -d@"$TIMELAPSE_LENGTH_SECS" -u +%M:%S:00)

# Create the timelapse
ffmpeg -i "$INPUT_FILE" -vf "framestep=${FRAME_STEP},setpts=N/(60*TB)" -r 60 "$TMP_FILE" &

# Trim the file to the correct length
ffmpeg -i "$TMP_FILE" -ss "00:00:00" -to "$TIMELAPSE_DURATION" -c copy -an "${FILE_NAME}_timelapse.mp4" &

# Compress it
ffmpeg -i "${FILE_NAME}_timelapse.mp4" -vcodec libx265 -crf 28 "${FILE_NAME}_timelapse_compressed.mp4"

rm "$TMP_FILE"