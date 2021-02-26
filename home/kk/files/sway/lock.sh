#!/usr/bin/env sh

tmpFile="/tmp/lockImg.png"

# This is fun!
scrot -m "$tmpFile"
convert "$tmpFile" -sepia-tone 75% -noise 5% "$tmpFile"
composite -gravity SouthEast -geometry +40+40 ~/Pictures/lockscreen/jojo.png "$tmpFile" "$tmpFile"

revert() {
        xset dpms 0 0 0
}

trap revert SIGHUP SIGINT SIGTERM
xset +dpms dpms 5 5 5
i3lock -i "$tmpFile" -p win -e -u -n
revert
