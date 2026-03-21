#!/bin/bash
# Build the Bloom ISO.
# Usage: ./scripts/build.sh [--clean]
#   --clean  Full rebuild: wipe the entire work directory first (slow, re-downloads packages)
#   default  Incremental: only re-apply config overlay and re-squash (fast, keeps cached packages)
#
# Override defaults with env vars:
#   BLOOM_WORK_DIR  — build work directory  (default: ../tmp/archiso relative to profile)
#   BLOOM_OUT_DIR   — ISO output directory  (default: ../iso-out relative to profile)

PROFILE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK_DIR="${BLOOM_WORK_DIR:-$(dirname "$PROFILE_DIR")/tmp/archiso}"
OUT_DIR="${BLOOM_OUT_DIR:-$(dirname "$PROFILE_DIR")/iso-out}"

cd "$PROFILE_DIR"
source scripts/preflight.sh

mkdir -p "$WORK_DIR" "$OUT_DIR"

if [[ "$1" == "--clean" ]]; then
    echo "Full clean build — wiping work directory..."
    sudo rm -rf "$WORK_DIR"
    mkdir -p "$WORK_DIR"
else
    echo "Incremental build — clearing markers and squashfs only..."
    sudo rm -f "$WORK_DIR/base._make_customize_airootfs"
    sudo rm -f "$WORK_DIR/base._mkairootfs_squashfs"
    sudo rm -f "$WORK_DIR/base._prepare_airootfs_image"
    sudo rm -f "$WORK_DIR/build._build_buildmode_iso"
    sudo rm -f "$WORK_DIR/iso._build_iso_image"
    sudo rm -f "$WORK_DIR/iso/arch/x86_64/airootfs.sfs"
    sudo rm -f "$WORK_DIR/iso/arch/x86_64/airootfs.sha512"
fi

sudo rm -f "$OUT_DIR"/bloom-*.iso

echo "Building ISO..."
sudo mkarchiso -v -C pacman.conf -w "$WORK_DIR" -o "$OUT_DIR" .
BUILD_STATUS=$?

if [ $BUILD_STATUS -ne 0 ]; then
    echo "ERROR: mkarchiso build failed."
    exit 1
fi

ISO_FILE=$(ls -t "$OUT_DIR"/bloom-*.iso 2>/dev/null | head -n 1)
echo ""
echo "Build complete: $ISO_FILE"
