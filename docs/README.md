# Bloom Linux

A modern, Wayland-native Arch-based Linux distribution built around Hyprland.

## What is Bloom?

Bloom is a curated desktop experience on top of Arch Linux. It ships a cohesive set of apps, tools, and visual polish so you get a working, beautiful system from the first boot — without manually assembling a Hyprland setup.

**Key features:**

- **Hyprland** compositor with blur, animations, and rounded corners out of the box
- **Waybar** top bar + Dynamic Island overlay (EWW)
- **Bloom UI suite** — volume, brightness, network, calendar, power, and settings popups
- **Graphical installer** with disk, user, timezone, and GPU driver selection
- **Security by default** — AppArmor + UFW enabled, root locked, passwordless sudo for wheel
- **Rolling release** via Arch + Chaotic-AUR binary repo
- **Flatpak + Flathub** pre-configured
- **Accessibility** — Orca screen reader available, high-contrast and large-text toggles

## System Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| CPU | x86_64, 2 cores | 4+ cores |
| RAM | 2 GB | 8 GB |
| Disk | 20 GB | 50 GB |
| GPU | Any with Mesa/DRM | AMD/Intel (open-source) or NVIDIA (dkms) |
| Boot | BIOS or UEFI | UEFI |
| Display | Any monitor | 1920×1080+ |

## Quick Start

1. Download the ISO (see Releases)
2. Write to USB: `dd if=bloom-*.iso of=/dev/sdX bs=4M status=progress`
3. Boot from USB
4. Click **Install Bloom** on the desktop or in the welcome app
5. Follow the 8-step graphical installer

## Keyboard Shortcuts (live + installed)

| Shortcut | Action |
|----------|--------|
| `Super+Return` | Terminal (kitty) |
| `Super+D` | App launcher (rofi) |
| `Super+E` | File manager (Thunar) |
| `Super+Q` | Close window |
| `Super+F` | Fullscreen |
| `Super+A` | Volume popup |
| `Super+B` | Brightness popup |
| `Super+W` | Network popup |
| `Super+N` | Notification center |
| `Super+L` | Lock screen |
| `Super+Shift+S` | Screenshot (area) |
| `Print` | Screenshot (full) |
| `Super+1–4` | Switch workspace |

## Included Applications

- **Browser:** Firefox (dark theme, Bloom startpage)
- **Terminal:** kitty
- **Files:** Thunar
- **Editor:** mousepad, neovim
- **Media:** mpv, eog
- **Audio:** pavucontrol, PipeWire
- **System:** btop, gparted, baobab, gnome-system-monitor
- **Packages:** pamac (GUI), yay (AUR helper)

## Project Structure

```
archlive/
├── profiledef.sh          # ISO build profile
├── packages.x86_64        # Package list for live ISO
├── pacman.conf            # Build-time pacman config (includes Chaotic-AUR)
├── arch_mirrorlist        # Mirror list
├── docs/                  # This documentation
├── efiboot/               # UEFI boot entries
├── grub/                  # GRUB config
└── airootfs/              # Live filesystem overlay
    ├── root/
    │   └── customize_airootfs.sh   # Post-build setup script
    ├── home/liveuser/     # Live user dotfiles
    │   └── .config/       # Hyprland, Waybar, rofi, etc.
    ├── etc/               # System config (waybar scripts, EWW, services)
    └── usr/
        ├── local/bin/     # bloom-* applications
        └── share/bloom/   # Installer assets, post-install script
```
