#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <path-to-app-list.yaml>"
    exit 1
fi

APP_LIST_PATH="$1"

parseBackedApp() {
    local apps=()
    while IFS= read -r line; do
        if [[ "$line" == \#* ]] || [[ -z "$line" ]] || [[ "$line" == *":" ]]; then
            continue
        fi
        local software_name=$(echo "$line" | sed -e 's/^[[:space:]]*-\{1\}[[:space:]]*//' -e 's/\/\/.*//' -e 's/[[:space:]]*$//')
        apps+=("$software_name")
    done < "$APP_LIST_PATH"
    echo "${apps[*]}"
}

getGroups() {
    local software="$1"
    local groups
    groups=$(LC_ALL=C yay -Qi "$software" | grep "Groups" | cut -d: -f2 | sed 's/,/ /g' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | tr -d '\n')
    if [[ "$groups" == "None" ]]; then
        echo ""
    else
        echo "$groups"
    fi
}

getInstalledPackage() {
    yay -Qqe | tr '\n' ' '
}

genDiff() {
    read -ra backedPackages <<< "$(parseBackedApp)"
    read -ra installedPackages <<< "$(getInstalledPackage)"
    declare -A installedGroups=()

    declare -a diffAdd=()
    declare -a diffRemove=()

    for p in "${installedPackages[@]}"; do
        if [[ " ${backedPackages[*]} " =~ " ${p} " ]]; then
            continue
        fi
        read -ra groups <<< "$(getGroups "$p")"
        local backedAsGroup=false
        for g in "${groups[@]}"; do
            if [[ " ${backedPackages[*]} " =~ " ${g} " ]]; then
                installedGroups["$g"]=1
                backedAsGroup=true
                break
            fi
        done
        if [[ "$backedAsGroup" = false ]]; then
            diffAdd+=("$p")
        fi
    done

    for p in "${backedPackages[@]}"; do
        if [[ " ${installedPackages[*]} " =~ " ${p} " ]] || [[ -n "${installedGroups[$p]}" ]]; then
            continue
        fi
        diffRemove+=("$p")
    done

    {
        echo "# In the System but not in the backup"
        for d in "${diffAdd[@]}"; do
            echo "+ $d"
        done
        echo "# In the backup but not in the System"
        for d in "${diffRemove[@]}"; do
            echo "- $d"
        done
    } > diff-app.txt
}

genDiff
yay -Qqe > new-app-list.txt
