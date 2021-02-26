#!/bin/env sh

currentValue=$(synclient -l | grep TouchpadOff | cut -d '=' -f 2 | xargs)

if [ $((currentValue)) -eq 0 ]; then
        notify-send "Touchpad disable"
        synclient TouchpadOff=1
else
        notify-send "Touchpad enable"
        synclient TouchpadOff=0
fi
