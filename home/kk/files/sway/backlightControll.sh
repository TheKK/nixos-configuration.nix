#!/usr/bin/env sh

LEVELS='10%
20%
30%
40%
50%
60%
70%
80%
90%
100%'
RUN_DMENU='dmenu -b -i -l 15 -p backlight_level -fn Hermit-9'

echo "$LEVELS" | $RUN_DMENU | xargs brightnessctl set
