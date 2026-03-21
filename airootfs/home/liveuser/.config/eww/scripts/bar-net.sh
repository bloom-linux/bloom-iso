#!/usr/bin/env bash
# Network icon for eww bar: ethernet > wifi signal > no connection

# Ethernet connected?
eth=$(nmcli -t -f TYPE,STATE device 2>/dev/null | grep "^ethernet:connected" | head -1)
if [[ -n "$eth" ]]; then
    echo "󰈀"
    exit 0
fi

# Wifi active?
wifi_line=$(nmcli -t -f ACTIVE,SIGNAL device wifi list 2>/dev/null | grep "^yes:" | head -1)
if [[ -n "$wifi_line" ]]; then
    sig=$(echo "$wifi_line" | cut -d: -f2)
    sig=${sig:-0}
    if   (( sig >= 75 )); then echo "󰤨"
    elif (( sig >= 50 )); then echo "󰤥"
    elif (( sig >= 25 )); then echo "󰤢"
    else                       echo "󰤟"
    fi
    exit 0
fi

# Wifi on but not connected
wifi_state=$(nmcli radio wifi 2>/dev/null)
if [[ "$wifi_state" == "enabled" ]]; then
    echo "󰖪"
else
    echo "󰤭"
fi
