#!/bin/bash
BUNDLE_ID="com.apple.ScreenContinuity"

running=$(osascript -e "tell application \"System Events\" to count (every process whose bundle identifier is \"$BUNDLE_ID\")")

if [ "$running" -gt 0 ]; then
    osascript -e "tell application id \"$BUNDLE_ID\" to quit"
else
    open -b "$BUNDLE_ID"
fi
