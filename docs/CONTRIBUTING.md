# Contributing to Bloom

## Getting Started

1. Read `INSTALL.md` to learn how to build and test the ISO
2. Pick something from the issue tracker or propose your own improvement
3. Test your change in QEMU before submitting

## Code Style

### Python (bloom-* apps)

- GTK4 + Python, no external dependencies beyond what's in `packages.x86_64`
- Follow the existing pattern: `Gtk.Application` subclass, `do_activate` builds the window
- Colors always from `_bloom_colors()` — don't hardcode hex values
- Keep CSS in a module-level `CSS` f-string, not inline
- Use `threading.Thread` + `GLib.idle_add` for any blocking work (never block the GTK main loop)

### Shell scripts

- `#!/usr/bin/env bash`, `set -e` at the top
- Always `|| true` after commands that may legitimately fail (chroot hooks, optional services)
- Quote all variables: `"$VAR"` not `$VAR`
- Check before acting: `command -v foo &>/dev/null` before using `foo`

### Hyprland config

- All bloom popup windowrules use the `windowrule { }` block syntax (not `windowrulev2`)
- App IDs use dots: `bloom.volume`, `bloom.network`, etc.
- Application IDs in Python use hyphens: `bloom-install`, `bloom-settings`

## Adding a New Bloom App

1. Create `airootfs/usr/local/bin/bloom-yourapp` (Python, GTK4)
2. Add `["/usr/local/bin/bloom-yourapp"]="0:0:755"` to `profiledef.sh`
3. Add a `.desktop` file in `airootfs/usr/share/applications/`
4. Add a `windowrule {}` block in `hyprland.conf`
5. Wire up a keybind or Waybar button if appropriate

## Modifying the Installer

The installer (`bloom-install`) generates an archinstall JSON config and runs
`sudo archinstall --config /tmp/bloom-install-config.json --silent`.

- `generate_config(data)` — builds the JSON from collected user data
- Each page is a `Page` subclass with `validate()` and `save()` methods
- `INSTALL_PKGS` — base packages always installed
- `GPU_DRIVER_MAP` — maps detected GPU type to archinstall `gfx_driver` + extra packages

## Modifying the Post-Install Script

`airootfs/usr/share/bloom/post-install.sh` runs inside `arch-chroot` after archinstall
completes. The live host's `/run` is bind-mounted, so files staged by `bloom-stage-assets`
are accessible at `/run/bloom/`.

Files staged by `bloom-stage-assets`:
- `bloom-plymouth.tar.gz` — Plymouth theme
- `grub-theme/` — GRUB2 theme directory
- `startpage/` — Firefox homepage
- `policies.json` — Firefox policies
- `skel/` — `/etc/skel` contents for new users
- `post-install.sh` — this script itself

## Testing

Always test changes in QEMU before considering them done:

```bash
# Quick build + test
sudo mkarchiso -v -w /tmp/bloom-work -o /tmp/bloom-out . && \
qemu-system-x86_64 -enable-kvm -m 4096 -cpu host -smp 4 \
  -bios /usr/share/ovmf/x64/OVMF.fd \
  -cdrom /tmp/bloom-out/bloom-*.iso -boot d \
  -vga virtio -display sdl,gl=on
```

## What Needs Work (Pre-v1)

- [ ] Test full build end-to-end in QEMU
- [ ] Verify installer completes successfully on a clean VM disk
- [ ] AppArmor profiles for bloom-* apps and Firefox
- [ ] Secure Boot (shim + MOK signing)
- [ ] Custom pacman repo for bloom packages (so they update via pacman)
- [ ] CI/CD pipeline (GitHub Actions: build + smoke-test in QEMU)
- [ ] Signed ISO + checksums for release
- [ ] Display page in bloom-settings (resolution, refresh rate, rotation)
- [ ] bloom-network: show ethernet connection details
