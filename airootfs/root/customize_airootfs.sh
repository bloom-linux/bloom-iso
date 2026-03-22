#!/usr/bin/env bash
# Runs inside the chroot during mkarchiso build

set -e

# Create greeter system user for greetd (must exist before greetd starts)
if ! id greeter &>/dev/null 2>&1; then
    useradd -r -M -s /sbin/nologin greeter 2>/dev/null || true
fi

# Rebuild font cache so all icon fonts render correctly at first boot
fc-cache -f

# Compile dconf system database (enables prefer-dark for all users incl. Firefox)
dconf update 2>/dev/null || true

# Set default Plymouth theme by updating the symlink directly
# (plymouth-set-default-theme -R fails in build chroot; archiso runs mkinitcpio after this)
ln -sfn /usr/share/plymouth/themes/bloom/bloom.plymouth \
    /usr/share/plymouth/themes/default.plymouth 2>/dev/null || true
# Also write plymouthd.conf for runtime
mkdir -p /etc/plymouth
cat > /etc/plymouth/plymouthd.conf << 'PLEOF'
[Daemon]
Theme=bloom
ShowDelay=0
DeviceTimeout=8
PLEOF

# Set default icon theme and environment for all users
cat >> /etc/environment <<'EOF'
XCURSOR_THEME=Vanilla-DMZ-AA
XCURSOR_SIZE=24
GTK_THEME=Adwaita-dark
QT_QPA_PLATFORMTHEME=qt6ct
QT_STYLE_OVERRIDE=kvantum-dark
EOF

# Enable systemd-resolved stub listener
ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf 2>/dev/null || true

# Create liveuser home dirs
sudo -u liveuser xdg-user-dirs-update 2>/dev/null || true

# Mark firstrun as done in live session — it should only run on the installed system
mkdir -p /home/liveuser/.config/bloom
touch /home/liveuser/.config/bloom/firstrun-done
chown -R 1000:1000 /home/liveuser/.config/bloom

# ── Chaotic-AUR binary repo (yay, pamac-aur, eww-bin, etc.) ──────────────────
# Add Chaotic-AUR to the live system's pacman.conf so users can install AUR
# packages with regular pacman after booting.
if ! grep -q '\[chaotic-aur\]' /etc/pacman.conf 2>/dev/null; then
    cat >> /etc/pacman.conf <<'PEOF'

[chaotic-aur]
SigLevel = Never
Server = https://cdn-mirror.chaotic.cx/$repo/$arch
Server = https://cdn1.chaotic.cx/$repo/$arch
PEOF
fi

# Sync package databases now that Chaotic-AUR is added
pacman -Sy --noconfirm 2>/dev/null || true

# ── yay AUR helper ────────────────────────────────────────────────────────────
if ! command -v yay &>/dev/null; then
    pacman -S --noconfirm --needed yay 2>/dev/null || true
fi

# ── pamac (GUI package manager: pacman + AUR + flatpak) ──────────────────────
if ! command -v pamac &>/dev/null; then
    pacman -S --noconfirm --needed pamac 2>/dev/null || true
fi

# ── candy-icons ───────────────────────────────────────────────────────────────
pacman -S --noconfirm --needed candy-icons 2>/dev/null || true

# Enable flatpak + Flathub
if command -v flatpak &>/dev/null; then
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo 2>/dev/null || true
fi

# ── AppArmor ──────────────────────────────────────────────────────────────────
# Load AppArmor profiles if apparmor is installed
if command -v apparmor_parser &>/dev/null; then
    systemctl enable apparmor.service 2>/dev/null || true
fi

# ── Sync liveuser config to /etc/skel ────────────────────────────────────────
# So newly created users after installation inherit the Bloom config
if [[ -d /home/liveuser ]]; then
    mkdir -p /home/liveuser/.config/eww
    cp -rf /etc/xdg/eww/. /home/liveuser/.config/eww/ 2>/dev/null || true
    
    # Critical: fix ownership so liveuser can read/write their own config
    chown -R 1000:1000 /home/liveuser
    chmod +x /home/liveuser/.config/eww/scripts/*.sh 2>/dev/null || true

    mkdir -p /etc/skel
    cp -rn /home/liveuser/. /etc/skel/ 2>/dev/null || true
    chown -R 0:0 /etc/skel
fi

# ── EWW (Elkowar's Wacky Widgets) — dynamic island layer-shell engine ─────────
# Strategy: install eww from Chaotic-AUR (pre-compiled binary, fast).
# Fallback: download the static binary directly from GitHub releases.
if ! command -v eww &>/dev/null && [[ ! -f /usr/local/bin/eww ]]; then
    if pacman -S --noconfirm --needed eww 2>/dev/null; then
        # Symlink to /usr/local/bin for PATH consistency
        eww_path="$(command -v eww 2>/dev/null)"
        [[ -n "$eww_path" && ! -f /usr/local/bin/eww ]] && \
            cp "$eww_path" /usr/local/bin/eww 2>/dev/null || true
    else
        # Fallback: download pre-built static binary from GitHub releases
        EWW_VER="0.6.0"
        EWW_URL="https://github.com/elkowar/eww/releases/download/v${EWW_VER}/eww-x86_64-linux-musl"
        pacman -S --noconfirm --needed curl 2>/dev/null || true
        if curl -fsSL --retry 3 --connect-timeout 30 "$EWW_URL" -o /usr/local/bin/eww 2>/dev/null; then
            chmod +x /usr/local/bin/eww
        fi
    fi
fi

# ── Make scripts executable ───────────────────────────────────────────────────
chmod +x /usr/local/bin/bloom-* 2>/dev/null || true
chmod +x /etc/xdg/eww/scripts/*.sh 2>/dev/null || true
