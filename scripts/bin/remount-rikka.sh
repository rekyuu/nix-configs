#! /usr/bin/env bash

sudo mount -a &&
systemctl --user restart mpd mpd-discord-rpc &&
waypaper --restore &&
pkill waybar && waybar &