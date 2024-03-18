#!/bin/bash

weather=$(curl -s wttr.in/Grafton%20Auckland?format="%c%t")
if [ ${#weather} -lt 15 ]; then
  echo $weather
fi
