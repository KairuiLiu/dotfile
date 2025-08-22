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
    # Ubuntu doesn't have the same group concept as Arch, so we'll return empty
    # Could implement task/section based grouping if needed
    echo ""
}

getInstalledPackage() {
    # Get explicitly installed packages (not dependencies)
    # Combine apt, snap, and flatpak packages
    {
        # APT packages (manually installed)
        apt-mark showmanual 2>/dev/null | tr '\n' ' '
        # Snap packages
        snap list 2>/dev/null | tail -n +2 | awk '{print $1}' | tr '\n' ' '
        # Flatpak packages
        flatpak list --app --columns=application 2>/dev/null | tr '\n' ' '
    }
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
        # Skip empty package names
        if [[ -z "$p" ]]; then
            continue
        fi
        diffAdd+=("$p")
    done

    for p in "${backedPackages[@]}"; do
        if [[ " ${installedPackages[*]} " =~ " ${p} " ]] || [[ -n "${installedGroups[$p]}" ]]; then
            continue
        fi
        # Skip empty package names
        if [[ -z "$p" ]]; then
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
getInstalledPackage > new-app-list.txt