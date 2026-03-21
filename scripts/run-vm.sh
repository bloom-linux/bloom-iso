#!/bin/bash
# Run a Bloom ISO in QEMU.
# Usage: ./scripts/run-vm.sh [path/to/bloom.iso]
#   If no ISO path given, uses the latest build from $BLOOM_OUT_DIR (default: ../iso-out)

PROFILE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="${BLOOM_OUT_DIR:-$(dirname "$PROFILE_DIR")/iso-out}"

if [ -n "$1" ]; then
    ISO_FILE="$1"
else
    ISO_FILE=$(ls -t "$OUT_DIR"/bloom-*.iso 2>/dev/null | head -n 1)
fi

if [ -z "$ISO_FILE" ] || [ ! -f "$ISO_FILE" ]; then
    echo "ERROR: No ISO found. Pass a path or build one first with ./scripts/build.sh"
    exit 1
fi

echo "Launching VM: $ISO_FILE"
qemu-system-x86_64 \
    -m 4G \
    -cpu host \
    -cdrom "$ISO_FILE" \
    -net nic -net user \
    -enable-kvm \
    -device virtio-vga-gl \
    -display gtk,gl=on,show-menubar=off,grab-on-hover=on \
    -device virtio-keyboard-pci \
    -audiodev pipewire,id=audio0 \
    -device ich9-intel-hda \
    -device hda-duplex,audiodev=audio0
