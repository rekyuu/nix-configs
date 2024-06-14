#! /usr/bin/env bash

function rdc() {
    HOST=$1
    USERNAME=$2
    PASSWORD=$3

    # Start RDC
    # xfreerdp - X
    # wlfreerdp - Wayland
    # sdl-freerdp - genius shit
    sdl-freerdp \
        /v:"$HOST" \
        /u:"$USERNAME" \
        /p:"$PASSWORD" \
        /sound:sys:pulse \
        /microphone:sys:pulse,format:1 \
        /gfx:RFX \
        +rfx \
        /size:3420x1388 \
        -grab-keyboard \
        +window-drag \
        -compression \
        +aero \
        +menu-anims \
        +clipboard
}

case $1 in
    kyoko)
        rdc "192.168.0.27" "$(secret-tool lookup kyoko username)" "$(secret-tool lookup kyoko password)"
        ;;
    work)
        rdc "192.168.0.59" "$(secret-tool lookup work username)" "$(secret-tool lookup work password)"
        ;;
    work-windows)
        rdc "192.168.0.59" "$(secret-tool lookup work-windows username)" "$(secret-tool lookup work-windows password)"
        ;;
    zooey)
        rdc "192.168.0.62" "$(secret-tool lookup zooey username)" "$(secret-tool lookup zooey password)"
        ;;
esac