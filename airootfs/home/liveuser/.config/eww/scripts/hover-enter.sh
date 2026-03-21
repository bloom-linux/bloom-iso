#!/usr/bin/env bash
# Expand the island on hover — whenever any media player is connected
EWW_CFG="${XDG_CONFIG_HOME:-$HOME/.config}/eww"
status=$(playerctl status 2>/dev/null)
if [[ "$status" == "Playing" || "$status" == "Paused" ]]; then
    eww --config "$EWW_CFG" update island-active=true island-expanded=true
fi
