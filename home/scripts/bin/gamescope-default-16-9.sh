#! /usr/bin/env bash

WIDTH=2560
HEIGHT=1440
REFRESH_RATE=144

export DXVK_HUD=fps

gamescope \
    --output-width $WIDTH \
    --output-height $HEIGHT \
    --nested-width $WIDTH \
    --nested-height $HEIGHT \
    --nested-refresh $REFRESH_RATE \
    --force-windows-fullscreen \
    --fullscreen \
    -- "$@"