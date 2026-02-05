#!/usr/bin/env bash

killall -q polybar
while pgrep -u "$UID" -x polybar >/dev/null; do sleep 1; done

CONFIG="$HOME/.config/polybar/config-desktop.ini"

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
