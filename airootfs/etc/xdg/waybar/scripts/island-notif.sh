#!/usr/bin/env bash
# Outputs swaync unread notification count as waybar JSON.
# Uses gdbus to query the swaync D-Bus interface.

count=$(gdbus call \
    --session \
    --dest org.erikreider.swaync \
    --object-path /org/erikreider/swaync/cc \
    --method org.erikreider.swaync.cc.GetCount \
    2>/dev/null | grep -oP '\d+' | head -1)

count=${count:-0}

if [ "$count" -gt 0 ]; then
    echo "{\"text\":\"󰂚 ${count}\",\"tooltip\":\"${count} unread notification(s) — click to open\",\"class\":\"unread\",\"alt\":\"unread\"}"
else
    echo "{\"text\":\"\",\"tooltip\":\"No notifications\",\"class\":\"\",\"alt\":\"empty\"}"
fi
