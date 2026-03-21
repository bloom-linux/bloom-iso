#!/bin/bash
# Generate arch_mirrorlist and pacman.conf for the build.
# Called by build.sh — can also be run standalone to refresh mirrors.

PROFILE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROFILE_DIR"

if [ ! -f "arch_mirrorlist" ]; then
    echo "Fetching fresh Arch Linux mirrors..."
    echo 'Server = https://geo.mirror.pkgbuild.com/$repo/os/$arch' > arch_mirrorlist
    echo 'Server = https://mirror.rackspace.com/archlinux/$repo/os/$arch' >> arch_mirrorlist
fi

echo "Writing pacman.conf..."
cat > pacman.conf << EOF
[options]
HoldPkg     = pacman glibc
Architecture = auto
ParallelDownloads = 5
SigLevel    = Never
LocalFileSigLevel = Optional

[core]
Include = $PROFILE_DIR/arch_mirrorlist

[extra]
Include = $PROFILE_DIR/arch_mirrorlist

[bloom]
SigLevel = Never
Server = https://bloom-linux.github.io/bloom-packages/

[chaotic-aur]
SigLevel = Never
Server = https://cdn-mirror.chaotic.cx/\$repo/\$arch
Server = https://cdn1.chaotic.cx/\$repo/\$arch
EOF

echo "preflight done."
