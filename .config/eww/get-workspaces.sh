#!/usr/bin/env bash
ACTIVE=$(hyprctl activeworkspace -j | jq -r .id)
hyprctl workspaces -j | jq -c --arg active "$ACTIVE" 'map(select(.id >= 1)) | sort_by(.id) | map({id: .id, is_active: (.id == ($active | tonumber))})'
