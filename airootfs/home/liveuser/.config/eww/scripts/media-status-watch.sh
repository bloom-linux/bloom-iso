#!/usr/bin/env bash
# Emit media-status on startup and on every player status change
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
STATE_FILE=/tmp/bloom-last-playing

emit() {
    local status
    status=$(playerctl status 2>/dev/null)
    case "$status" in
        Playing) date +%s > "$STATE_FILE"; echo "Playing" ;;
        Paused)
            last=$(cat "$STATE_FILE" 2>/dev/null || echo 0)
            now=$(date +%s)
            (( now - last < 30 )) && echo "Paused" || echo "" ;;
        Stopped) echo "Stopped" ;;
        *) echo "" ;;
    esac
}

emit
playerctl --follow status 2>/dev/null | while read -r _; do
    emit
done
