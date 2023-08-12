#!/bin/bash

PROC=$(pgrep -a "yesplaymusic")
if [ ${#PROC} -eq 0 ]; then
  echo ''
else
  node ~/.config/waybar/scripts/lyric/app.js
fi
