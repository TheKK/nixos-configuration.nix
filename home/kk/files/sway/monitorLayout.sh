#!/usr/bin/env sh

LAYOUT_DIR="$HOME/.screenlayout"
RUN_DMENU='dmenu -b -i -l 15 -p monitor_layout -fn Hermit-9'

find "$LAYOUT_DIR" -type f | $RUN_DMENU | xargs sh
