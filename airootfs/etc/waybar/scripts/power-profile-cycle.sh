#!/usr/bin/env bash
# Cycle through power profiles: balanced → performance → power-saver → balanced
CURRENT=$(powerprofilesctl get 2>/dev/null)
case "$CURRENT" in
    balanced)     powerprofilesctl set performance ;;
    performance)  powerprofilesctl set power-saver ;;
    power-saver)  powerprofilesctl set balanced ;;
    *)            powerprofilesctl set balanced ;;
esac
