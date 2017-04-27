#!/bin/bash

#vclip by Storm Dragon
#License: WTFPL http://wtfpl.net/
#This script makes recording and pasting sound clips to A MUD's channel easier.

#Mac compatability, hopefully
if [ "$(uname)" == "Darwin" ]; then
sedCmd="gsed"
else
sedCmd="sed"
fi
grepCmd="grep"

#Reduce file size for faster uploads, and to be nice to the sndup server
sox clip.ogg -c 1 -r 17088 tmpclip.ogg norm
mv tmpclip.ogg clip.ogg
#upload the file and extract the url from the json
upload="$(curl -s --form file=@clip.ogg --form submit=upload http://sndup.net/post.php)"
jsonInfo="$(echo "$upload" | $sedCmd 's/,/\n/g')"
#save channel command to the file and show link in the terminal
echo -n "$@ " > cliplink.txt
echo -n "$jsonInfo" | $grepCmd 'url' | $sedCmd -e 's/^{"url":"//' -e 's/a$/d/' | tr -d '"\\' >> cliplink.txt
exit 0
