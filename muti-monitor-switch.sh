#!/bin/bash

external_output=$(swaymsg -t get_outputs | jq -r '.[] | select(.name | startswith("DP-") or startswith("HDMI-")) | .name')

echo $external_output
echo "output $external_output enable primary"
if [ -n "$external_output" ]; then
  case "$1" in
  "external_only")
    swaymsg "output eDP-1 disable" &&
      swaymsg "output $external_output enable" &&
      swaymsg "output $external_output resolution 2560x1440 position 0 0 scale 1.25"
    ;;
  "edp_only")
    swaymsg "output eDP-1 enable" &&
      swaymsg "output eDP-1 resolution 2880x1800 position 0 0 scale 1.75" &&
      swaymsg "output $external_output disable"
    ;;
  "both")
    swaymsg "output eDP-1 enable" &&
      swaymsg "output eDP-1 resolution 2880x1800 position 2048 736 scale 1.75" &&
      swaymsg "output $external_output enable" &&
      swaymsg "output $external_output resolution 2560x1440 position 0 0 scale 1.25"
    ;;
  *)
    echo "Unknown option: $1"
    ;;
  esac
fi
