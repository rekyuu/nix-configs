#! /usr/bin/env bash

while true; do
    vesktop &
    D_PID=$!

    wait $D_PID
done