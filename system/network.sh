#!/bin/sh
set -eu

msg() { printf '\n==> %s\n' "$*"; }
info() { printf '  -> %s\n' "$*"; }
skip() { printf '  -> [SKIP] %s\n' "$*"; }
update() { printf '  -> [UPDATE] %s\n' "$*"; }
done_msg() { printf '  -> [DONE] %s\n' "$*"; }
tip() { printf '\n  -> [TIP] %s\n' "$*"; }

msg "Configuring NetworkManager..."
NM_CONF_DIR="/etc/NetworkManager/conf.d"
sudo mkdir -p "$NM_CONF_DIR"

if grep -q "dns=none" "$NM_CONF_DIR/dns.conf" 2>/dev/null; then
  skip "NetworkManager DNS config already optimal."
else
  info "Writing NetworkManager DNS config..."
  sudo tee "$NM_CONF_DIR/dns.conf" >/dev/null <<'EOF'
[main]
dns=none
rc-manager=unmanaged
EOF
  done_msg "NetworkManager DNS config updated."
fi

if grep -q "wifi.powersave=2" "$NM_CONF_DIR/wifi-powersave.conf" 2>/dev/null; then
  skip "NetworkManager WiFi powersave already disabled."
else
  info "Writing NetworkManager WiFi powersave config..."
  sudo tee "$NM_CONF_DIR/wifi-powersave.conf" >/dev/null <<'EOF'
[connection]
wifi.powersave=2
EOF
  done_msg "NetworkManager WiFi powersave config updated."
fi

msg "Configuring dnscrypt-proxy..."
DCP_CONF="/etc/dnscrypt-proxy/dnscrypt-proxy.toml"
DCP_BAK="/etc/dnscrypt-proxy/dnscrypt-proxy.toml.bak"

if ! pacman -Q dnscrypt-proxy dnscrypt-proxy-runit >/dev/null 2>&1; then
  info "Installing dnscrypt-proxy and runit service..."
  sudo pacman -S --noconfirm --needed dnscrypt-proxy dnscrypt-proxy-runit >/dev/null
  done_msg "dnscrypt-proxy installed."
else
  skip "dnscrypt-proxy already installed."
fi

# FIX: Create and permission directories (runit doesn't auto-create these like systemd does)
info "Setting up cache and log directories..."
sudo mkdir -p /var/cache/dnscrypt-proxy /var/log/dnscrypt-proxy
sudo chmod 777 /var/cache/dnscrypt-proxy /var/log/dnscrypt-proxy

if [ ! -f "$DCP_BAK" ]; then
  update "Backing up default config to dnscrypt-proxy.toml.bak..."
  sudo cp -f "$DCP_CONF" "$DCP_BAK" 2>/dev/null || true
fi

update "Writing minimal dnscrypt-proxy configuration..."
sudo tee "$DCP_CONF" >/dev/null <<'EOF'
server_names = ['google', 'google-ipv6', 'cloudflare', 'cloudflare-ipv6']
listen_addresses = ['127.0.0.1:53', '[::1]:53']
max_clients = 250
ipv4_servers = true
ipv6_servers = true
dnscrypt_servers = true
doh_servers = true
odoh_servers = false
require_dnssec = false
require_nolog = true
require_nofilter = true
disabled_server_names = []
force_tcp = false
http3 = true
http3_probe = false
timeout = 5000
keepalive = 30
bootstrap_resolvers = ['8.8.8.8:53', '1.1.1.1:53', '[2001:4860:4860::8888]:53', '[2606:4700:4700::1111]:53']
ignore_system_dns = true
netprobe_timeout = 60
netprobe_address = '9.9.9.9:53'
block_ipv6 = false
block_unqualified = true
block_undelegated = true
reject_ttl = 10
cache = true
cache_size = 4096
cache_min_ttl = 2400
cache_max_ttl = 86400
cache_neg_min_ttl = 60
cache_neg_max_ttl = 600
log_file = '/var/log/dnscrypt-proxy/dnscrypt-proxy.log'
use_syslog = false
log_files_max_size = 10
log_files_max_age = 7
log_files_max_backups = 1
cert_refresh_delay = 240
[sources.public-resolvers]
urls = ['https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md', 'https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md', 'https://cdn.jsdelivr.net/gh/DNSCrypt/dnscrypt-resolvers@master/v3/public-resolvers.md']
cache_file = '/var/cache/dnscrypt-proxy/public-resolvers.md'
minisign_key = 'RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3'
refresh_delay = 73
prefix = ''
[sources.relays]
urls = ['https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/relays.md', 'https://download.dnscrypt.info/resolvers-list/v3/relays.md', 'https://cdn.jsdelivr.net/gh/DNSCrypt/dnscrypt-resolvers@master/v3/relays.md']
cache_file = '/var/cache/dnscrypt-proxy/relays.md'
minisign_key = 'RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3'
refresh_delay = 73
prefix = ''
[broken_implementations]
fragments_blocked = ['cisco', 'cisco-ipv6', 'cisco-familyshield', 'cisco-familyshield-ipv6', 'cisco-sandbox', 'cleanbrowsing-adult', 'cleanbrowsing-adult-ipv6', 'cleanbrowsing-family', 'cleanbrowsing-family-ipv6', 'cleanbrowsing-security', 'cleanbrowsing-security-ipv6']
[anonymized_dns]
skip_incompatible = false
[ip_encryption]
algorithm = "none"
key = ""
[monitoring_ui]
enabled = false
listen_address = "127.0.0.1:8080"
username = "admin"
password = "changeme"
tls_certificate = ""
tls_key = ""
enable_query_log = true
privacy_level = 1
EOF
done_msg "Minimal config written."

if [ ! -L "/run/runit/service/dnscrypt-proxy" ]; then
  info "Enabling dnscrypt-proxy service..."
  sudo ln -sf /etc/runit/sv/dnscrypt-proxy /run/runit/service/dnscrypt-proxy
fi

RESOLV_CONF="/etc/resolv.conf"
if grep -q "^nameserver 127.0.0.1$" "$RESOLV_CONF" 2>/dev/null && lsattr "$RESOLV_CONF" 2>/dev/null | grep -qE '^.{4}i'; then
  skip "resolv.conf already points to 127.0.0.1 and is immutable."
else
  update "Updating resolv.conf..."
  sudo chattr -i "$RESOLV_CONF" 2>/dev/null || true
  sudo rm -f "$RESOLV_CONF"
  echo "nameserver 127.0.0.1" | sudo tee "$RESOLV_CONF" >/dev/null
  sudo chattr +i "$RESOLV_CONF" 2>/dev/null || true
  done_msg "resolv.conf updated."
fi

info "Restarting dnscrypt-proxy..."
sudo sv restart dnscrypt-proxy >/dev/null 2>&1 || sudo sv up dnscrypt-proxy >/dev/null 2>&1 || true
done_msg "dnscrypt-proxy restarted."

msg "Restarting NetworkManager..."
sudo sv restart NetworkManager >/dev/null 2>&1 || true
done_msg "NetworkManager restarted."

tip "Minimal config applied. Original saved to /etc/dnscrypt-proxy/dnscrypt-proxy.toml.bak"
