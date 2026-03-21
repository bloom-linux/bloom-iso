#!/usr/bin/env bash
# Returns Playing/Paused within 30s of last play, "" after that
STATE_FILE=/tmp/bloom-last-playing
status=$(playerctl status 2>/dev/null)
if [[ "$status" == "Playing" ]]; then
    date +%s > "$STATE_FILE"
    echo "Playing"
elif [[ "$status" == "Paused" ]]; then
    last=$(cat "$STATE_FILE" 2>/dev/null || echo 0)
    now=$(date +%s)
    if (( now - last < 30 )); then
        echo "Paused"
    else
        echo ""
    fi
else
    echo ""
fi
