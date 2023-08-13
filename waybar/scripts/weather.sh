#!/bin/bash

weather=$(curl -s wttr.in/Grafton%20Auckland?format="%c%t")

if [ ${#weather} -lt 15 ]; then
  emoji=$(echo $weather | cut -d' ' -f1)
  temp=$(echo $weather | cut -d' ' -f2)
  echo "<span font_family='Noto Color Emoji'>$emoji</span> <span>$temp</span>"
fi
