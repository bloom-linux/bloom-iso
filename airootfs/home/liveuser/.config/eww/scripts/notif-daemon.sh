#!/usr/bin/env bash
# Intercepts D-Bus notifications and pushes them into EWW variables.
# Runs as a background daemon launched by bloom-island.

# Single instance: kill any previous copies (exclude self)
for _pid in $(pgrep -f "notif-daemon.sh" -u "$USER" 2>/dev/null); do
    [ "$_pid" != "$$" ] && kill "$_pid" 2>/dev/null
done
sleep 0.1

EWW="eww --config ${XDG_CONFIG_HOME:-$HOME/.config}/eww"
NOTIF_COUNT=0

dbus-monitor --session \
    "eavesdrop=true,type=method_call,interface=org.freedesktop.Notifications,member=Notify" \
    2>/dev/null | \
while IFS= read -r line; do

    # Start of a new Notify call
    if [[ "$line" == *"member=Notify"* ]]; then
        _app=""; _summary=""; _body=""; _idx=0
        continue
    fi

    # Top-level string fields (exactly 3 spaces of indent)
    if [[ "$line" =~ ^[[:space:]]{3}string[[:space:]]\"(.*)\"$ ]]; then
        val="${BASH_REMATCH[1]}"
        case $_idx in
            0) _app="$val" ;;      # arg0: app_name
            # arg1 is uint32 (replaces_id) — handled below
            2) ;;                   # arg2: app_icon — skip
            3) _summary="$val" ;;  # arg3: summary
            4) _body="$val"        # arg4: body — complete, emit
               if [[ -n "$_summary" || -n "$_body" ]]; then
                   NOTIF_COUNT=$(( NOTIF_COUNT + 1 ))

                   # Properly escape and quote strings for EWW
                   $EWW update notif-count="$NOTIF_COUNT"
                   $EWW update notif-app="\"${_app//\"/\\\"}\""
                   $EWW update notif-summary="\"${_summary//\"/\\\"}\""
                   $EWW update notif-body="\"${_body//\"/\\\"}\""
                   $EWW update notif-active=true
                   $EWW update island-expanded=true

                   # Auto-dismiss after 5 s (runs in subshell)
                   ( sleep 5
                     $EWW update notif-active=false
                     $EWW update island-expanded=false
                   ) &
               fi
               ;;
        esac
        _idx=$(( _idx + 1 ))

    elif [[ "$line" =~ ^[[:space:]]{3}uint32[[:space:]] ]]; then
        _idx=$(( _idx + 1 ))   # replaces_id counts as positional arg

    elif [[ "$line" =~ ^[[:space:]]{3}(array|dict)[[:space:]] ]] || \
         [[ "$line" =~ ^[[:space:]]{3}int32[[:space:]] ]]; then
        _idx=99   # reached actions/hints — stop parsing this call
    fi

done
