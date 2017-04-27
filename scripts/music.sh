#!/bin/bash
#music status helper for TinTin++
#Written by Storm Dragon

mpd="$(mpc current 2> /dev/null)"
if [ -n "$mpd" ] ; then
mpd="true"
fi

if [[ $(pgrep xmms2) ]] ; then
xmms="true"
fi

#check for mpd
if [ "$mpd" == "true" ] ; then
musicURL="$1"
musicProvider="$2"
artist="$(mpc -f %artist% current)"
title="$(mpc -f %title% current)"
album="$(mpc -f %album% current)"
if [ -n "$musicURL" -a "$musicURL" != false ] ; then
url="$(curl -s "http://is.gd/create.php?format=simple&url=$(echo "${musicURL}${artist} ${title}" | sed -e 's/"/%22/g' -e 's/&/%26/g' -e "s/'/%27/g" -e 's/</%3c/g' -e 's/>/%3e/g' -e 's/ /%20/g')")"
fi
#check for xmms2
elif [ "$xmms" == "true" ] ; then
musicURL="$1"
musicProvider="$2"
artist="$(nyxmms2 info | grep artist | cut -d '=' -f2-)"
album="$(nyxmms2 info | grep album | cut -d '=' -f2-)"
title="$(nyxmms2 info | grep title | cut -d '=' -f2-)"
if [ -n "$musicURL" -a "$musicURL" != false ] ; then
url="$(curl -s "http://is.gd/create.php?format=simple&url=$(echo "${musicURL}${artist} ${title}" | sed -e 's/"/%22/g' -e 's/&/%26/g' -e "s/'/%27/g" -e 's/</%3c/g' -e 's/>/%3e/g' -e 's/ /%20/g')")"
fi
#check for last.fm:
elif [ -f "$HOME/.shell-fm/nowplaying" ] ; then
artist="$(cut -f 1 -d '\' "$HOME/.shell-fm/nowplaying")"
title="$(cut -f 2 -d '\' "$HOME/.shell-fm/nowplaying")"
album="$(cut -f 3 -d '\' "$HOME/.shell-fm/nowplaying")"
if [ "$1" != false ] ; then
url="$(curl -s "http://is.gd/create.php?format=simple&url=$(cut -f 4 -d '\' "$HOME/.shell-fm/nowplaying")")"
musicProvider="Last.fm"
fi
elif cmus-remote -C >/dev/null 2>&1 ; then
#If there was no last.fm file assume we're using cmus
musicURL="$1"
musicProvider="$2"
info="$(cmus-remote -Q)"
artist="$(echo "$info" | sed -n 's/^tag artist //p')"
title="$(echo "$info" | sed -n 's/^tag title //p')"
album="$(echo "$info" | sed -n 's/^tag album //p')"
if [ -n "$musicURL" -a "$musicURL" != false ] ; then
url="$(curl -s "http://is.gd/create.php?format=simple&url=$(echo "${musicURL}${artist} ${title}" | sed -e 's/"/%22/g' -e 's/&/%26/g' -e "s/'/%27/g" -e 's/</%3c/g' -e 's/>/%3e/g' -e 's/ /%20/g')")"
fi
else
#Fianlly, check for Pianobar
if [ -f "$HOME/.config/pianobar/nowplaying" ] ; then
musicURL="$1"
musicProvider="$2"
artist="$(cut -f 1 -d '\' "$HOME/.config/pianobar/nowplaying")"
title="$(cut -f 2 -d '\' "$HOME/.config/pianobar/nowplaying")"
album="$(cut -f 3 -d '\' "$HOME/.config/pianobar/nowplaying")"
if [ -n "$musicURL" -a "$musicURL" != false ] ; then
url="$(curl -s "http://is.gd/create.php?format=simple&url=$(echo "${musicURL}${artist} ${title}" | sed -e 's/"/%22/g' -e 's/&/%26/g' -e "s/'/%27/g" -e 's/</%3c/g' -e 's/>/%3e/g' -e 's/ /%20/g')")"
fi
fi
fi

if [ -n "$artist" -a -n "$title" -a -n "$album" ] ; then
msg="\"$title\" by \"$artist\" from \"$album\" $url"
if [ -n "$musicProvider" ] ; then
msg="$msg (Search results provided by $musicProvider)"
fi
msg=$(echo "$msg" | tr -d "\n")
else
if [ "$mpd" == "true" ] ; then
fileName="$(mpc current | rev)"
else
fileName="$(cmus-remote -Q | head -2 | tail -1 | rev)"
fi
if [ -z "$title" ] ; then
title="$(echo "$fileName" | cut -f 1 -d '/' | cut -f 2 -d '.' | rev)"
fi
if [ -z "$artist" ] ; then
artist="$(echo "$fileName" | cut -f 2 -d '/' | rev)"
fi
msg="$artist - $title"
fi
echo "$msg"
exit 0
