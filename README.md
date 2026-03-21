# bloom-iso

Archiso profile for building the Bloom Linux live ISO.

## Building

```bash
./test.sh
```

This generates a local `arch_mirrorlist` and `pacman.conf`, then runs `mkarchiso`. The resulting ISO is placed in `/home/rati/extra/iso-out/` and automatically launched in QEMU for testing.

## Structure

```
airootfs/          System overlay applied on top of packages
  etc/             Hyprland, swaync, rofi, grub, plymouth configs
  home/liveuser/   Live session user dotfiles
  etc/skel/        Default dotfiles for installed system
  usr/local/bin/   ISO-specific utilities (installer, livecd-sound, etc.)
efiboot/           EFI boot entries
grub/              GRUB theme and config
syslinux/          Syslinux boot menu
packages.x86_64    Package list (includes bloom-desktop from bloom repo)
profiledef.sh      ISO metadata and build settings
```

## Packages

Bloom apps are installed via the `[bloom]` pacman repo:

```ini
[bloom]
SigLevel = Never
Server = https://bloom-linux.github.io/bloom-packages/
```

See [bloom-packages](https://github.com/bloom-linux/bloom-packages) for PKGBUILDs.
