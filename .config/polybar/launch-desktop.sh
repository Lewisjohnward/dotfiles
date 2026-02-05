#!/usr/bin/env bash

# Kill all polybar instances for this user (robust: match cmdline, not just name)
pkill -u "$UID" -f '(^|/)(polybar)(\s|$)' 2>/dev/null || true

# Wait a moment for clean shutdown, then force-kill anything left
for _ in {1..20}; do
  pgrep -u "$UID" -f '(^|/)(polybar)(\s|$)' >/dev/null || break
  sleep 0.1
done
pkill -u "$UID" -9 -f '(^|/)(polybar)(\s|$)' 2>/dev/null || true

# Ensure none are left
while pgrep -u "$UID" -f '(^|/)(polybar)(\s|$)' >/dev/null; do
  sleep 0.1
done

CONFIG="$HOME/.config/polybar/config-desktop.ini"
sleep

PRIMARY="$(xrandr --query | awk '/ connected primary/{print $1; exit}')"
if [ -z "$PRIMARY" ]; then
  PRIMARY="$(xrandr --query | awk '/ connected/{print $1; exit}')"
fi

xrandr --query | awk '/ connected/{print $1}' | while read -r monitor; do
  if [ "$monitor" = "$PRIMARY" ]; then
    MONITOR="$monitor" polybar -c "$CONFIG" main &
  else
    MONITOR="$monitor" polybar -c "$CONFIG" minimal &
  fi
done
