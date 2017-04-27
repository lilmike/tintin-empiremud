#!/bin/bash

#This is a helper script for tintin-alteraeon
#It takes 2 args, player name and sould clip id from the sndup.net link.
#released under the terms of the WTFPL

if [ $# -ne 2 ] ; then
exit 1
fi

fileName="$(curl -Is http://sndup.net/$2/d | grep "filename=" | cut -d "=" -f2)"
if [ -d $HOME/Downloads ] ; then
filePath="$HOME/Downloads/$fileName"
else
filePath="./$fileName"
fi
filePath="$(echo "$filePath" | tr -d [:cntrl:])"
if [ -f "$filePath" ] ; then
echo "$filePath already exists. Please move or delete it and try again."
exit 1
fi
echo "Saving sound clip from $1 to $filePath..."
curl -s -o "${filePath}" http://sndup.net/$2/d
if [ $? -ne 0 ] ; then
echo "There was an error saving the file."
exit 1
else
if [ -f "$filePath" ] ; then
echo "$filePath saved successfully."
exit 0
else
echo "There was an error with the download."
fi
fi
