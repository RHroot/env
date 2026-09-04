#!/usr/bin/env bash

get_workspaces() {
  ACTIVE=$(hyprctl activeworkspace -j 2>/dev/null | jq -r .id)
  hyprctl workspaces -j 2>/dev/null | jq -c --arg active "$ACTIVE" '
    map(select(.id >= 1)) | sort_by(.id) |
    map({id: .id, is_active: (.id == ($active | tonumber))})
  ' || echo '[]'
}

get_workspaces

SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

# Use nc if socat unavailable
if command -v socat &>/dev/null; then
  socat -u UNIX-CONNECT:"$SOCKET" -
elif command -v nc &>/dev/null; then
  nc -U "$SOCKET"
else
  echo "Install socat or netcat" >&2
  exit 1
fi | stdbuf -o0 grep -E 'workspace>>|focusedmon>>' | while read -r _; do
  get_workspaces
done
