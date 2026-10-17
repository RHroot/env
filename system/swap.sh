#!/bin/sh
set -eu

# Auto-elevate to root if not already
if [ "$(id -u)" -ne 0 ]; then
  exec sudo "$0" "$@"
fi

msg() { printf '\n==> %s\n' "$*"; }
info() { printf '  -> %s\n' "$*"; }
skip() { printf '  -> [SKIP] %s\n' "$*"; }
update() { printf '  -> [UPDATE] %s\n' "$*"; }
done_msg() { printf '  -> [DONE] %s\n' "$*"; }
tip() { printf '\n  -> [TIP] %s\n' "$*"; }
verify() { printf '  -> [VERIFY] %s\n' "$*"; }

SWAP_FILE="/swapfile"
SIZE_MB=4096
SWAPPINESS=10

msg "Configuring 4GB Swap File..."

SWAP_ACTIVE="false"
SWAP_EXISTS="false"

if [ -f "$SWAP_FILE" ]; then
  SWAP_EXISTS="true"
fi

if [ -s /proc/swaps ] && [ "$(awk 'END {print NR-1}' /proc/swaps)" -gt 0 ]; then
  SWAP_ACTIVE="true"
fi

if [ "$SWAP_EXISTS" = "true" ] || [ "$SWAP_ACTIVE" = "true" ]; then
  info "Existing swap detected."
  if [ "$SWAP_EXISTS" = "true" ]; then
    printf '  -> File %s exists.\n' "$SWAP_FILE"
  fi
  if [ "$SWAP_ACTIVE" = "true" ]; then
    printf '  -> Active swap:\n'
    awk 'NR>1 {printf "     %s\n", $1}' /proc/swaps
  fi

  printf '\n  -> Remove/disable existing swap and create a new 4GB %s? [y/N] ' "$SWAP_FILE"
  read -r ans
  case "$ans" in
    [Yy] | [Yy][Ee][Ss])
      info "Removing existing swap..."
      if [ "$SWAP_ACTIVE" = "true" ]; then
        awk 'NR>1 {print $1}' /proc/swaps | while read -r swap_dev; do
          swapoff "$swap_dev" || true
        done
        done_msg "Deactivated active swap(s)."
      fi
      if [ "$SWAP_EXISTS" = "true" ]; then
        rm -f "$SWAP_FILE"
        done_msg "Removed existing swap file."
      fi
      if grep -q "^[[:space:]]*$SWAP_FILE[[:space:]]" /etc/fstab 2>/dev/null; then
        sed -i "\|^[[:space:]]*$SWAP_FILE[[:space:]]|d" /etc/fstab
        done_msg "Removed old entry from /etc/fstab."
      fi
      ;;
    *)
      skip "Keeping existing swap configuration. Doing nothing."
      exit 0
      ;;
  esac
fi

AVAIL_KB=$(df -Pk / | awk 'NR==2 {print $4}')
NEEDED_KB=$(((SIZE_MB + 512) * 1024))

if [ -n "$AVAIL_KB" ] && [ "$AVAIL_KB" -lt "$NEEDED_KB" ]; then
  info "Not enough disk space. Need at least $((SIZE_MB + 512))MB free."
  exit 1
fi

FSTYPE=$(findmnt -no FSTYPE / 2>/dev/null || df -T / | awk 'NR==2 {print $2}')

info "Creating 4GB swap file at $SWAP_FILE..."
touch "$SWAP_FILE"

if [ "$FSTYPE" = "btrfs" ]; then
  info "Btrfs detected. Disabling Copy-on-Write for swap file..."
  chattr +C "$SWAP_FILE" || true
fi

dd if=/dev/zero of="$SWAP_FILE" bs=1M count="$SIZE_MB" status=progress
done_msg "Swap file created."

info "Setting permissions and formatting swap..."
chmod 600 "$SWAP_FILE"
mkswap "$SWAP_FILE"
done_msg "Swap file formatted."

info "Activating swap..."
swapon "$SWAP_FILE"
done_msg "Swap activated."

if grep -q "^[[:space:]]*$SWAP_FILE[[:space:]]" /etc/fstab 2>/dev/null; then
  skip "Swap file already in /etc/fstab."
else
  update "Adding swap file to /etc/fstab..."
  echo "$SWAP_FILE none swap defaults 0 0" >>/etc/fstab
  done_msg "Added to /etc/fstab."
fi

msg "Configuring Swappiness..."
if grep -q "^[[:space:]]*vm\.swappiness[[:space:]]*=[[:space:]]*$SWAPPINESS" /etc/sysctl.conf 2>/dev/null; then
  skip "vm.swappiness is already set to $SWAPPINESS."
else
  if grep -q "^[[:space:]]*vm\.swappiness[[:space:]]*=" /etc/sysctl.conf 2>/dev/null; then
    update "Updating existing vm.swappiness value..."
    sed -i "s/^[[:space:]]*vm\.swappiness[[:space:]]*=.*/vm.swappiness=$SWAPPINESS/" /etc/sysctl.conf
  else
    update "Adding vm.swappiness to /etc/sysctl.conf..."
    echo "vm.swappiness=$SWAPPINESS" >>/etc/sysctl.conf
  fi

  info "Applying sysctl changes..."
  sysctl -p >/dev/null 2>&1 || sysctl -w "vm.swappiness=$SWAPPINESS" >/dev/null
  done_msg "vm.swappiness set to $SWAPPINESS."
fi

msg "Summary:"
verify "swapon --show"
verify "free -h"

tip "Your system will now use RAM primarily and only use swap when necessary."
