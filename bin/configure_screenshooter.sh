#!/bin/sh
# Register the interactive Wayland clipboard action without replacing other actions.
set -eu

for dependency in xfconf-query xfce4-screenshooter wl-copy; do
    if ! command -v "$dependency" >/dev/null 2>&1; then
        printf 'Screenshooter setup requires %s; install it and rerun bin/configure_screenshooter.sh.\n' "$dependency" >&2
        exit 1
    fi
done

channel=xfce4-screenshooter
name='Copy to clipboard (Wayland)'
command=$(cat <<'COMMAND'
sh -c 'wl-copy --type image/png < "$1"' sh %f
COMMAND
)

count=$(xfconf-query -c "$channel" -p /actions/actions 2>/dev/null || printf '0')
case "$count" in
    ''|*[!0-9]*) printf 'Invalid Screenshooter action count: %s\n' "$count" >&2; exit 1 ;;
esac

index=0
while [ "$index" -lt "$count" ]; do
    existing=$(xfconf-query -c "$channel" -p "/actions/action-$index/name" 2>/dev/null || true)
    [ "$existing" != "$name" ] || break
    index=$((index + 1))
done

set_property() {
    xfconf-query -c "$channel" -p "$1" --create --type "$2" --set "$3"
}

set_property "/actions/action-$index/name" string "$name"
set_property "/actions/action-$index/command" string "$command"
if [ "$index" -eq "$count" ]; then
    set_property /actions/actions int "$((count + 1))"
fi
