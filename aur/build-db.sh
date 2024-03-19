#!/bin/bash

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <path-to-app-list.yaml>"
  exit 1
fi

FILE_PATH="$1"

declare -a categories=()
db=""

while IFS= read -r line; do
  if [[ $line =~ ^([[:space:]]*)-[\ ]([^:/]+)(:?)\ *(\//.*|)$ ]]; then
    deep=$(((${#BASH_REMATCH[1]} / 2)))
    name=${BASH_REMATCH[2]}
    name=${name%% }
    isCategories=${BASH_REMATCH[3]}
    comment=${BASH_REMATCH[4]}

    comment=${comment#//}
    comment=${comment// /}

    if [[ -n $isCategories ]]; then
      if [[ ${#categories[@]} -gt $deep ]]; then
        categories=("${categories[@]:0:$deep}")
      fi
      categories[$deep]="$name"
    else
      path=$(
        IFS=/
        echo "${categories[*]:0:$deep}"
      )
      db+="${name}:\t${path}\t${comment}\n"
    fi
  fi
done <"$FILE_PATH"
echo -e "$db" >app-list.db
