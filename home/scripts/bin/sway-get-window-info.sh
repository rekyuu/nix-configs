#! /usr/bin/env bash

sleep 3 && swaymsg -t get_tree | jq '.. | select(.type?) | select(.focused==true)'