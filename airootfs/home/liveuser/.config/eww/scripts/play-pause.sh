#!/usr/bin/env bash
# Play/pause and immediately update eww so icon changes without waiting for poll
EWW_CFG="$HOME/.config/eww"
playerctl play-pause
sleep 0.1
new=$(playerctl status 2>/dev/null)
if [[ "$new" == "Playing" ]]; then
    date +%s > /tmp/bloom-last-playing
    eww --config "$EWW_CFG" update media-status="Playing"
elif [[ "$new" == "Paused" ]]; then
    eww --config "$EWW_CFG" update media-status="Paused"
else
    eww --config "$EWW_CFG" update media-status=""
fi
