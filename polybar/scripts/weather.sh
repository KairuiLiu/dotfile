#!/bin/bash

weather=$(curl -s wttr.in/xiaodian?format="%c%t")
if [ ${#weather} -lt 15 ]; then
  echo $weather
fi
