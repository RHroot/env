#!/usr/bin/sh

TEMP=4000
GAMMA=80

case "$1" in
  toggle)
    if pgrep -x hyprsunset >/dev/null; then
      pkill -x hyprsunset
    else
      hyprsunset -t $TEMP -g $GAMMA >/dev/null 2>&1 &
      disown
    fi
    ;;
  status)
    if pgrep -x hyprsunset >/dev/null; then
      echo "󰖔"
    else
      echo "󰖙"
    fi
    ;;
esac
