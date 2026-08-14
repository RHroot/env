#!/bin/bash

VAL=50
ICON="?"

if [ "$1" == "volume" ]; then
  VAL=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')
  ICON="🔊"
elif [ "$1" == "brightness" ]; then
  VAL=$(brightnessctl -m | awk -F, '{print substr($4, 1, length($4)-1)}')
  ICON="☀️"
elif [ "$1" == "mute" ]; then
  if wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q "MUTED"; then
    VAL=0
    ICON="🔇"
  else
    VAL=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')
    ICON="🔊"
  fi
elif [ "$1" == "mic" ]; then
  if wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q "MUTED"; then
    VAL=0
    ICON="🎙️"
  else
    VAL=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | awk '{print int($2 * 100)}')
    ICON="🎤"
  fi
fi

# Fallback to prevent eww crashes
VAL=${VAL:-0}

eww update osd_value=$VAL
eww update osd_icon="$ICON"
eww open vbosd

# Manage timer
if [ -f "/tmp/vbosd.pid" ]; then
  kill $(cat /tmp/vbosd.pid) 2>/dev/null
fi

(sleep 2 && eww close vbosd) &
echo $! >/tmp/vbosd.pid
