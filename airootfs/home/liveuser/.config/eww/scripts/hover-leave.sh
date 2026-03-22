#!/usr/bin/env bash
# Collapse the island: shape shrinks immediately, content swaps after animation
EWW_CFG="${XDG_CONFIG_HOME:-$HOME/.config}/eww"
notif=$(eww --config "$EWW_CFG" get notif-active 2>/dev/null)
if [[ "$notif" != "true" ]]; then
    eww --config "$EWW_CFG" update island-active=false island-expanded=false
fi
