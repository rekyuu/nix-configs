#! /usr/bin/env bash

# Based on the flamenco render method
ffmpeg \
    -r "60" \
    -pattern_type "glob" \
    -i "*.png" \
    -c:v "h264" \
    -crf "20" \
    -g "18" \
    -vf "pad=ceil(iw/2)*2:ceil(ih/2)*2" \
    -pix_fmt "yuv420p" \
    -r 60 \
    -y \
    render.mp4 