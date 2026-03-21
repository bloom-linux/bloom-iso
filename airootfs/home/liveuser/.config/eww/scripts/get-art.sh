#!/usr/bin/env bash
# Returns a local file path to the current track's album art.
# Uses URL hash for cache key so EWW detects path changes between tracks.

url=$(playerctl metadata mpris:artUrl 2>/dev/null || echo "")

[[ -z "$url" ]] && { echo ""; exit 0; }

if [[ "$url" == file://* ]]; then
    path="${url#file://}"
    [[ -f "$path" ]] && echo "$path" || echo ""
    exit 0
fi

if [[ "$url" == http* ]]; then
    hash=$(printf '%s' "$url" | md5sum | cut -c1-12)
    cache="/tmp/bloom-art-${hash}.jpg"
    if [[ ! -f "$cache" ]]; then
        curl -fsSL --max-time 4 -o "$cache" "$url" 2>/dev/null || { echo ""; exit 0; }
    fi
    echo "$cache"
    exit 0
fi

echo ""
