#!/bin/bash

VOLTAGE_NOW=$(cat /sys/class/power_supply/BAT0/voltage_now)
CURRENT_NOW=$(cat /sys/class/power_supply/BAT0/current_now)
POWER=$(($VOLTAGE_NOW * $CURRENT_NOW))
POWER_W=$(echo "scale=1; $POWER/1000000000000" | bc)
STATUS=$(cat /sys/class/power_supply/BAT0/status)

echo "$POWER_W W"

#case $STATUS in
#    Charging)
#        echo "充电功率: $POWER_W W"
#        ;;
#    Discharging)
#        echo "电池放电功率: $POWER_W W"
#        ;;
#    Full)
#        echo "电池已充满，当前功率: $POWER_W W"
#        ;;
#    *)
#        echo "电池状态未知，当前功率: $POWER_W W"
#        ;;
#esac

