# Bloom OS — TODO

## v1 Remaining

- [ ] **Test full build** — run `mkarchiso` and boot the ISO, verify Plymouth, Hyprland, all bloom tools
- [ ] **ISO signing** — GPG-sign the final ISO before release
- [ ] **Release page** — GitHub Releases with signed ISO, checksums, and release notes

## Backlog (post-v1)

- [ ] **Custom pacman repo** — GitHub releases + `repo-add` to distribute Bloom packages
- [ ] **Secure boot** — shim/MOK signing for UEFI secure boot
- [ ] **Pacman keyring** — verify keyring initialization on fresh archinstall
- [ ] **Update notifier notifications** — currently updates count shows in waybar; could also send a desktop notification

## Already Done ✓

### Core ISO
- [x] Bloom rose SVG icon variants (color, black, white, icon crop)
- [x] Plymouth boot splash (bloom theme, service enabled via sysinit.target.wants)
- [x] Plymouth kernel cmdline: quiet splash loglevel=3 vt.global_cursor_default=0
- [x] Syslinux boot menu branding
- [x] systemd-boot EFI entry branding
- [x] /etc/hostname → bloom
- [x] /etc/os-release + /etc/lsb-release → Bloom branding
- [x] /etc/issue + /etc/motd → Bloom ASCII art
- [x] Pacman keyring initialization service

### Desktop
- [x] Hyprland config (keybinds, blur, animations, cliphist, screenshot, lock)
- [x] windowrulev2 → windowrule (new syntax)
- [x] Hyprlock config (clock, password, dark plum bg)
- [x] Hypridle config (dim → lock → dpms)
- [x] Waybar (workspaces, tray, bluetooth, backlight, audio, network, weather, power-profiles, updates, clock, power)
- [x] Dynamic Island (bloom-island — layer-shell overlay: app name, media controls, notifications)
- [x] Rofi launcher theme (bloom.rasi)
- [x] swaync notification center (Bloom theme)
- [x] swaybg wallpaper (dark plum gradient)
- [x] swayosd volume/brightness OSD
- [x] GTK dark theme (Adwaita-dark, gtk3 + gtk4)
- [x] Papirus-Dark icon theme
- [x] Breeze cursor theme (xcursor-breeze)
- [x] Fastfetch config (custom rose ASCII art, Nerd Font icons)
- [x] .zshrc (fastfetch on open, red ❀ prompt)

### Audio / Input / Hardware
- [x] PipeWire + WirePlumber via systemd socket activation
- [x] NetworkManager (replaced networkd + iwd)
- [x] Bluetooth service enabled
- [x] Power profiles daemon

### Bloom Apps
- [x] bloom-island — Dynamic Island overlay (layer-shell, media + notifications)
- [x] bloom-welcome — Welcome app (logo, keybinds, packages, install tab)
- [x] bloom-install — Graphical installer GUI (→ archinstall with Bloom config)
- [x] bloom-volume — Volume mixer popup (Super+A)
- [x] bloom-network — WiFi/network manager popup (Super+W)
- [x] bloom-calendar — Clock + calendar popup (click clock in waybar)
- [x] bloom-power — Power menu (rofi dmenu)
- [x] bloom-ufw-rules — First-boot UFW setup service

### Security
- [x] UFW enabled + default deny incoming / allow outgoing
- [x] AppArmor installed + enabled
- [x] bloom-ufw-rules.service (one-shot, runs once on first boot)

### Package Management
- [x] yay (AUR helper, built in customize_airootfs.sh)
- [x] pamac (GUI: pacman + AUR + flatpak, built in customize_airootfs.sh)
- [x] flatpak + Flathub remote

### Installation
- [x] archinstall-config.json (Bloom profile with all packages, greetd, services)
- [x] bloom-install GUI → archinstall --config
- [x] bloom-stage-assets.service (stages theme files to /run/bloom for archinstall chroot)
- [x] post-install.sh (run by archinstall custom-commands: greetd, Plymouth, GRUB theme, UFW)

### Post-install (installed system)
- [x] greetd + tuigreet login manager (configured in post-install.sh)
- [x] GRUB Bloom theme (staged + applied in post-install.sh)
- [x] Plymouth theme on installed system (staged + applied in post-install.sh)
- [x] Firefox policies (dark toolbar, Bloom startpage, no sponsored content)
- [x] Bloom startpage (bloom-icon.svg logo, search, quick links, clock)
- [x] /etc/skel sync (liveuser config copied to skel for new users)

### Branding
- [x] bloom-icon.svg used in welcome app, installer header, startpage
- [x] bloom-color/black/white used for Plymouth, hyprlock
- [x] Wallpaper (2560×1440 dark plum + faint rose)
