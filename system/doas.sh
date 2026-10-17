#!/bin/sh
set -eu

msg() { printf '\n==> %s\n' "$*"; }
info() { printf '  -> %s\n' "$*"; }
skip() { printf '  -> [SKIP] %s\n' "$*"; }
done_msg() { printf '  -> [DONE] %s\n' "$*"; }
tip() { printf '\n  -> [TIP] %s\n' "$*"; }

# Use current user, fallback to 'sten' if needed
USERNAME="${SUDO_USER:-$(whoami)}"
USERNAME="${USERNAME:-sten}"

msg "Switching from sudo to doas for user: $USERNAME"

# 1. Install doas
if command -v doas >/dev/null 2>&1; then
  skip "doas is already installed."
else
  info "Installing doas..."
  sudo pacman -S --noconfirm opendoas
fi

# 2. Configure doas
if [ -f /etc/doas.conf ] && grep -q "permit persist $USERNAME" /etc/doas.conf; then
  skip "doas.conf is already configured for $USERNAME."
else
  info "Configuring /etc/doas.conf..."
  echo "permit persist $USERNAME" | sudo tee /etc/doas.conf >/dev/null
  sudo chown root:root /etc/doas.conf
  sudo chmod 0400 /etc/doas.conf
fi

# 3. Create sudo symlink (done BEFORE removing sudo to prevent script breakage)
if [ -L /usr/local/bin/sudo ] && [ "$(readlink /usr/local/bin/sudo)" = "/usr/bin/doas" ]; then
  skip "sudo symlink already exists in /usr/local/bin."
else
  info "Creating sudo symlink..."
  doas ln -sf /usr/bin/doas /usr/local/bin/sudo
fi

# 4. Configure AUR helpers
for helper in yay paru; do
  if command -v "$helper" >/dev/null 2>&1; then
    info "Configuring $helper to use doas..."
    doas -u "$USERNAME" "$helper" --save --sudobin=doas >/dev/null 2>&1 || true
  fi
done

# 5. Remove sudo (done last)
if pacman -Q sudo >/dev/null 2>&1; then
  info "Removing sudo package..."
  doas pacman -Rdd --noconfirm sudo
else
  skip "sudo package is not installed."
fi

done_msg "Switch to doas complete."
tip "Test it by running: doas ls /root"
