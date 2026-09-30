set -gx NIRI_SOCKET (ls -t $XDG_RUNTIME_DIR/niri*.sock 2>/dev/null | head -n 1)
