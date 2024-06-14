#! /usr/bin/env bash

function do-notify() {
    if mpc status | grep "paused" > /dev/null; then return; fi

    TITLE=$(mpc --format %title% current)
    ALBUM=$(mpc --format %album% current)

    notify-send "$TITLE" "$ALBUM" -h string:x-canonical-private-synchronous:mpd-notify -c "mpd"
}

do-notify
