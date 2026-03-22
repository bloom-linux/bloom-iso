if [[ $(tty) == "/dev/tty1" ]]; then
    export XDG_RUNTIME_DIR=/run/user/1000
    export WLR_NO_HARDWARE_CURSORS=1
    export XCURSOR_SIZE=24
    mkdir -p "$XDG_RUNTIME_DIR"
    chmod 700 "$XDG_RUNTIME_DIR"
    # Single-shot: logout returns to greetd login screen, not an infinite loop
    uwsm start hyprland.desktop > /tmp/hyprland.log 2>&1
fi
