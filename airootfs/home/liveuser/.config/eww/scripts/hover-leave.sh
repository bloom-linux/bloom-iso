#!/usr/bin/env bash
# Collapse the island: shape shrinks immediately, content swaps after animation
EWW_CFG="${XDG_CONFIG_HOME:-$HOME/.config}/eww"
notif=$(eww --config "$EWW_CFG" get notif-active 2>/dev/null)
if [[ "$notif" != "true" ]]; then
    # Drop active class now so shape transition starts immediately
    eww --config "$EWW_CFG" update island-active=false
    # Swap content after the shrink animation finishes (matches 0.55s transition)
    ( sleep 0.55
      notif2=$(eww --config "$EWW_CFG" get notif-active 2>/dev/null)
      [[ "$notif2" != "true" ]] && eww --config "$EWW_CFG" update island-expanded=false
    ) &
fi
