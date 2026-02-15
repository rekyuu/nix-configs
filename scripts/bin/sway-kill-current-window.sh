#! /usr/bin/env bash

PID="$(swaymsg -t get_tree | jq '.. | select(.type?) | select(.focused==true)' | jq '.pid')"
kill -9 "$PID"