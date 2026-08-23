#!/bin/sh

while true; do
  IFACE=$(ip route | awk '/default/ {print $5}' | head -n1)

  if [ -z "$IFACE" ]; then
    echo "Disconnected"
    sleep 1
    continue
  fi

  RX1=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)
  TX1=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)
  sleep 1
  RX2=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)
  TX2=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)

  awk -v rx=$((RX2 - RX1)) -v tx=$((TX2 - TX1)) '
    function format_speed(bytes) {
        kb = bytes / 1024
        if (kb < 102.4) {
            return sprintf("%.0f KB/s", kb)
        } else {
            return sprintf("%.2f MB/s", kb / 1024)
        }
    }
    BEGIN {
        printf "↓ %s ↑ %s\n", format_speed(rx), format_speed(tx)
    }'
done
