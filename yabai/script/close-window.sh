#!/bin/zsh

APP=$(yabai -m query --windows --window | jq -r '.app')

echo "Current app: [$APP]"

case "$APP" in
    "Finder"|"访达")
        echo "Using Cmd+W for Finder"
        osascript -e "tell application \"System Events\" to tell process \"$APP\" to keystroke \"w\" using command down"
        ;;
    *)
        echo "Using yabai close for $APP"
        yabai -m window --close
        ;;
esac
