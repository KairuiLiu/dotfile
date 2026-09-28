#!/bin/sh
set -eu

# Usage: move-or-open.sh OPEN_APP [YABAI_APP]
# Example: move-or-open.sh LarkSuite Lark
if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    echo "Usage: $0 OPEN_APP [YABAI_APP]" >&2
    exit 2
fi
launch_app=$1
window_app=${2:-$launch_app}

PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"
export PATH

target_uuid=$(yabai -m query --spaces --space | jq -r '.uuid')
target_space() {
    yabai -m query --spaces | jq -r --arg uuid "$target_uuid" '.[] | select(.uuid == $uuid) | .index'
}

find_window() {
    space=$(target_space)
    yabai -m query --windows | jq -r --arg app "$window_app" --argjson space "$space" '
        [.[] | select(.app == $app and .["root-window"])]
        | sort_by(.space != $space) | .[0].id // empty
    '
}

window=$(find_window)
if [ -z "$window" ]; then
    open -a "$launch_app"
    attempts=0
    while [ -z "$window" ] && [ "$attempts" -lt 40 ]; do
        sleep 0.25
        window=$(find_window)
        attempts=$((attempts + 1))
    done
fi
[ -n "$window" ] || { echo "No window found for $window_app" >&2; exit 1; }

space=$(target_space)
if [ "$(yabai -m query --windows --window "$window" | jq -r '.space')" != "$space" ]; then
    yabai -m window "$window" --space "$space"
fi
open -a "$launch_app"
yabai -m space --focus "$(target_space)" 2>/dev/null || true
yabai -m window "$window" --focus
