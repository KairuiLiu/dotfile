#!/bin/bash

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <software_name> <file_path>"
  exit 1
fi

file_path=$1
software_name=$2

grep -P "^$software_name:" "$file_path"
yay -Qi "$software_name"
