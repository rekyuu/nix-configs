#! /usr/bin/env bash

while true; do
    vesktop &
    # discord &
    D_PID=$!

    wait $D_PID
done