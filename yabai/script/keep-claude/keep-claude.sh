#!/bin/bash
APP_BIN="/Applications/Claude.app/Contents/MacOS/Claude"

if pgrep -fq "$APP_BIN"; then
  osascript -e 'display notification "Claude 已启动" with title "ipgatekeeper"'
  open -a "Claude"
  exit 0
fi

ipgatekeeper --country JP -- "$APP_BIN"
