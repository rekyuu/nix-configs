#! /usr/bin/env bash

function rdc() {
    HOST=$1
    USERNAME=$2
    PASSWORD=$3

    # Start RDC
    # xfreerdp - X
    # wlfreerdp - Wayland
    # sdl-freerdp - genius shit
    xfreerdp \
        /v:"$HOST" \
        /u:"$USERNAME" \
        /p:"$PASSWORD" \
        /cert:ignore \
        /sound:sys:pulse \
        /microphone:sys:pulse,format:1 \
        /monitors:0 \
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
        rdc "kyoko.localdomain" "$(secret-tool lookup kyoko username)" "$(secret-tool lookup kyoko password)"
        ;;
    work)
        rdc "work.localdomain" "$(secret-tool lookup work username)" "$(secret-tool lookup work password)"
        ;;
    work-windows)
        rdc "work.localdomain" "$(secret-tool lookup work-windows username)" "$(secret-tool lookup work-windows password)"
        ;;
    zooey)
        rdc "zooey.localdomain" "$(secret-tool lookup zooey username)" "$(secret-tool lookup zooey password)"
        ;;
esac