#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
last=""

emit() {
    local art
    art=$("$SCRIPT_DIR/get-art.sh")
    if [[ -n "$art" && "$art" != "$last" ]]; then
        echo "$art"
        last="$art"
    elif [[ -z "$art" && -z "$last" ]]; then
        echo ""
    fi
}

emit
while true; do
    playerctl --follow metadata mpris:artUrl 2>/dev/null | while read -r _; do
        emit
    done
    sleep 1
done
