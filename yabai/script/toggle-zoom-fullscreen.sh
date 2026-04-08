#!/usr/bin/env zsh
# Toggle zoom-fullscreen on the focused window, ensuring no other window
# in the current space remains zoom-fullscreened.

fid=$(yabai -m query --windows --window | jq -r '.id')

yabai -m query --windows --space \
  | jq -r ".[] | select(.\"has-fullscreen-zoom\" and .id != $fid) | .id" \
  | while read -r wid; do
      yabai -m window "$wid" --toggle zoom-fullscreen
    done

yabai -m window --toggle zoom-fullscreen
yabai -m window "$fid" --raise
