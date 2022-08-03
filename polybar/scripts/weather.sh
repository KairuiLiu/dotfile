#!/bin/bash

weather=$(curl -s wttr.in/重庆市北碚区天生路?format="%c%t")
if [ ${#weather} -lt 15 ]; then
  echo $weather
fi
