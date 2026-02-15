#! /usr/bin/env bash

if mpc random | grep "random: on" > /dev/null
then 
    notify-send "random: on" -h string:x-canonical-private-synchronous:mpc-toggle-random
else 
    notify-send "random: off" -h string:x-canonical-private-synchronous:mpc-toggle-random
fi