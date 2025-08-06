#! /usr/bin/env bash

WIDTH=3440
HEIGHT=1440
REFRESH_RATE=144

export LD_PRELOAD=""
export DXVK_HUD=fps

gamescope \
    --output-width $WIDTH \
    --output-height $HEIGHT \
    --nested-width $WIDTH \
    --nested-height $HEIGHT \
    --nested-refresh $REFRESH_RATE \
    --fullscreen \
    -- "$@"