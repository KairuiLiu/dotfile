#!/bin/bash

url="https://immi.homeaffairs.gov.au/what-we-do/whm-program/status-of-country-caps"

response=$(curl -s "$url")

if [[ $? -ne 0 ]]; then
    echo "WHV: ERROR"
    exit 1
fi

match=$(echo "$response" | awk '/<td>China/ {flag=1; next} flag && /<span class="label label-/ {gsub(/.*<span class="label label-[^>]+">|<\/span>.*/, ""); print; flag=0}')

if [[ -z $match ]]; then
    echo "WHV: No match found"
else
    echo "WHV: $match"
fi