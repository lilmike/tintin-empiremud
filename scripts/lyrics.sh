#!/bin/bash

# Dependancy check 
for i in clyrics fortune ; do
if ! command -v $i &> /dev/null ; then
    echo "{#echo Please install $i before using this script.}"
  exit 1
  fi
done

# Path where lyrics are stored
# Most likely ~/.local/share/fortunes
lyricsPath="${XDG_DATA_HOME:-$HOME/.local/share}/fortune"
mkdir -p "$lyricsPath"

# Get the song and artist info
artist="$(echo "$2" | cut -d '-' -f1 | tr -s '[:space:]')"
artist="${artist%[[:space:]]}"
song="$(echo "$2" | cut -d '-' -f2 | cut -d '(' -f1 | tr -s '[:space:]')"
song="${song%[[:space:]]}"
lyricsFile="${song// /-}.${artist// /-}"

# Create a fortune file containing the lyrics
if ! [[ -f "$lyricsPath/$lyricsFile" ]]; then
  clyrics "$song : $artist" > "$lyricsPath/$lyricsFile"
  sed -i 's/^$/%/g' "$lyricsPath/$lyricsFile"
   strfile "$lyricsPath/$lyricsFile" &> /dev/null
  # Remove the files if they don't contain anything
  [[ -s "$lyricsPath/$lyricsFile" ]] || rm "$lyricsPath/$lyricsFile" "$lyricsPath/$lyricsFile.dat"
fi

# Sometimes the file is created, but it's one long string
# Try to protect against that since the one string will most likely be too long for the 400 character limit
if [[ -s "$lyricsPath/$lyricsFile" ]]; then
  if ! grep '%' "$lyricsPath/$lyricsFile" &> /dev/null ; then 
    rm "$lyricsPath/$lyricsFile.dat"
    tmp="$(fold -s "$lyricsPath/$lyricsFile" | sed '0~4 s/$/\n%/g')"
    echo "$tmp" > "$lyricsPath/$lyricsFile"
     strfile "$lyricsPath/$lyricsFile" &> /dev/null
  fi
fi

# Display the lyrics or an error if nothing is found
if [[ -e "$lyricsPath/$lyricsFile" ]]; then
  echo "$1 $(fortune -n400 -s -- "$lyricsPath/$lyricsFile" | tr '[:space:]' ' ') -- it's $2."
else
  echo "#echo {No lyrics found for $song by $artist.}"
fi

exit 0
