#!/usr/bin/env bash
# Waybar update notifier — uses checkupdates from pacman-contrib (no root needed)

COUNT=$(checkupdates 2>/dev/null | wc -l)

if [ "$COUNT" -gt 0 ]; then
    echo "{\"text\":\" $COUNT\",\"tooltip\":\"$COUNT package update(s) available\",\"class\":\"has-updates\"}"
else
    echo "{\"text\":\"\",\"tooltip\":\"System is up to date\",\"class\":\"updated\"}"
fi
