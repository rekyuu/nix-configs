#! /usr/bin/env bash

COOLDOWN_FILE="/tmp/media-control-cooldown-$1"

if [[ -f $COOLDOWN_FILE ]]
then
    return 0
else
    mpc -q "$1"
    touch "$COOLDOWN_FILE"
    sleep 0.1
    rm "$COOLDOWN_FILE"
fi

mpd-notify.sh

# lol
systemctl --user restart mpd-discord-rpc.service
