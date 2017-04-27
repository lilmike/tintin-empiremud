#!/bin/bash
# create variables
while read L; do
k="`echo "$L" | cut -d '=' -f 1`"
v="`echo "$L" | cut -d '=' -f 2`"
export "$k=$v"
done < <(grep -e '^\(title\|artist\|album\|stationName\|pRet\|pRetStr\|wRet\|wRetStr\|songDuration\|songPlayed\|rating\|coverArt\|stationCount\|station[0-9]*\)=' /dev/stdin) # don’t overwrite $1…
album=$(echo "$album" | sed 's/ (Explicit)//g')
if [ "$1" == "songstart" ] ; then
echo "$artist\\$title\\$album" > $HOME/.config/pianobar/nowplaying
fi
exit 0
