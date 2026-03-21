#!/usr/bin/env bash
# Fetch weather from wttr.in and output for waybar
# Format: icon + temperature, tooltip with full forecast

LOCATION="${BLOOM_WEATHER_LOCATION:-}"  # empty = auto-detect

WEATHER=$(curl -sf --max-time 5 \
    "wttr.in/${LOCATION}?format=%c+%t&m" 2>/dev/null)

if [[ -n "$WEATHER" ]]; then
    TOOLTIP=$(curl -sf --max-time 5 \
        "wttr.in/${LOCATION}?format=3&m" 2>/dev/null \
        | head -1)
    echo "{\"text\":\"${WEATHER}\",\"tooltip\":\"${TOOLTIP:-${WEATHER}}\"}"
else
    echo "{\"text\":\"  N/A\",\"tooltip\":\"Weather unavailable\"}"
fi
