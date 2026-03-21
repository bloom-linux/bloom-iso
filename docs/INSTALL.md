# Building Bloom Linux

## Prerequisites

Arch-based host with `archiso` installed:

```bash
sudo pacman -S archiso qemu-full
```

## Build the ISO

```bash
# Incremental build (fast — keeps cached packages, re-applies config overlay)
./scripts/build.sh

# Full clean build (slow — wipes work dir and re-downloads everything)
./scripts/build.sh --clean
```

Output: `../iso-out/bloom-YYYY.MM.DD-x86_64.iso`

Override paths with env vars:
```bash
BLOOM_OUT_DIR=~/iso BLOOM_WORK_DIR=/tmp/build ./scripts/build.sh
```

## Test in a VM

```bash
# Build and immediately launch in QEMU
./test.sh

# Launch the latest built ISO
./scripts/run-vm.sh

# Launch a specific ISO
./scripts/run-vm.sh ~/Downloads/bloom-2026.03.21-x86_64.iso
```

Mouse is grabbed on hover. Press `Ctrl+Alt+G` to release.

## Project Layout

| Path | Purpose |
|---|---|
| `packages.x86_64` | Package list for the live ISO (includes `bloom-desktop`) |
| `profiledef.sh` | ISO metadata, compression, file permissions |
| `airootfs/etc/` | System config overlay (hyprland, swaync, rofi, plymouth…) |
| `airootfs/home/liveuser/` | Live session user dotfiles |
| `airootfs/etc/skel/` | Default dotfiles copied to new users on installed system |
| `airootfs/usr/local/bin/` | ISO-specific utilities (installer launcher, livecd-sound…) |
| `scripts/` | Build and test helper scripts |

Bloom apps are installed via the `[bloom]` pacman repo — see
[bloom-packages](https://github.com/bloom-linux/bloom-packages).

## Signing a Release

```bash
gpg --detach-sign --armor bloom-YYYY.MM.DD-x86_64.iso
sha256sum bloom-YYYY.MM.DD-x86_64.iso > bloom-YYYY.MM.DD-x86_64.iso.sha256
```
