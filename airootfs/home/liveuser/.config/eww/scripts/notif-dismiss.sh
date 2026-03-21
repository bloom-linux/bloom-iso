#!/usr/bin/env bash
# Dismiss the current notification and collapse the island
EWW_CFG="${XDG_CONFIG_HOME:-$HOME/.config}/eww"
eww --config "$EWW_CFG" update notif-active=false
eww --config "$EWW_CFG" update island-expanded=false
