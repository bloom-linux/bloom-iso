#!/usr/bin/env python3
# Bloom dynamic island controller

import subprocess
import json
import os
import sys

CACHE_DIR = "/tmp/island_cache"
os.makedirs(CACHE_DIR, exist_ok=True)


def run(cmd):
    try:
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True, timeout=2)
        return result.stdout.strip()
    except Exception:
        return ""


def get_active_player():
    """Return the best available player name, preferring active ones."""
    players = run("playerctl -l 2>/dev/null").splitlines()
    if not players:
        return None
    # Prefer playing, then paused, then any
    for p in players:
        s = run(f"playerctl -p '{p}' status 2>/dev/null")
        if s == "Playing":
            return p
    for p in players:
        s = run(f"playerctl -p '{p}' status 2>/dev/null")
        if s == "Paused":
            return p
    return players[0]


def main():
    # --- Media playing? ---
    player = get_active_player()
    status = run(f"playerctl -p '{player}' status 2>/dev/null") if player else ""
    if status in ("Playing", "Paused"):
        title  = run(f"playerctl -p '{player}' metadata title  2>/dev/null") or "Unknown"
        artist = run(f"playerctl -p '{player}' metadata artist 2>/dev/null") or ""
        # Derive a clean player name for icon lookup
        player_base = player.split(".")[0] if player else ""

        # Pick icon by player
        icons = {
            "firefox":  "",
            "chromium": "",
            "mpv":      "󰎆",
            "spotify":  "",
        }
        icon = icons.get(player_base, "󰎇")

        if status == "Paused":
            icon = "⏸"

        # Truncate
        title  = title[:28]  + ("…" if len(title)  > 28 else "")
        artist = artist[:18] + ("…" if len(artist) > 18 else "")

        parts = [icon, title]
        if artist:
            parts.append(f"— {artist}")

        text    = "  ".join(parts)
        tooltip = f"{title}\n{artist}\n\n⏮ scroll-down  |  click play/pause  |  scroll-up ⏭"

        print(json.dumps({
            "text":    text,
            "tooltip": tooltip,
            "class":   "music" if status == "Playing" else "paused",
        }), flush=True)
        return

    # --- Active window title ---
    title = run("hyprctl activewindow -j 2>/dev/null | python3 -c \"import sys,json; d=json.load(sys.stdin); print(d.get('title',''))\" 2>/dev/null")
    if not title or title == "null":
        title = "Bloom"

    title = title[:35] + ("…" if len(title) > 35 else "")

    print(json.dumps({
        "text":  f"󱂬  {title}",
        "class": "default",
    }), flush=True)


if __name__ == "__main__":
    main()
