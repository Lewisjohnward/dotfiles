#!/usr/bin/env bash
set -euo pipefail

# ---------- kill existing polybars (robust) ----------
pkill -u "$UID" -f '(^|/)(polybar)(\s|$)' 2>/dev/null || true

for _ in {1..20}; do
  pgrep -u "$UID" -f '(^|/)(polybar)(\s|$)' >/dev/null || break
  sleep 0.1
done

pkill -u "$UID" -9 -f '(^|/)(polybar)(\s|$)' 2>/dev/null || true
while pgrep -u "$UID" -f '(^|/)(polybar)(\s|$)' >/dev/null; do
  sleep 0.1
done

# ---------- get hostname for dymanic modules / wifi ----------
HOST="$(hostname -s)"

case "$HOST" in
  Thinkerton)
    DEVICE_TYPE="laptop"
    ;;
  BadRobot)
    DEVICE_TYPE="desktop"
    ;;
  *)
    echo "Unknown host '$HOST'. Defaulting to desktop behavior." >&2
    DEVICE_TYPE="desktop"
    ;;
esac

# ---------- config paths ----------
CONFIG_DIR="$HOME/.config/polybar"
BASE_CONFIG="$CONFIG_DIR/generated.ini"
TMP_CONFIG="/tmp/polybar_config_${USER}.ini"

if [ ! -f "$BASE_CONFIG" ]; then
  echo "ERROR: $BASE_CONFIG not found. Run your generator first." >&2
  exit 1
fi

# ---------- monitor detection ----------
PRIMARY="$(xrandr --query | awk '/ connected primary/{print $1; exit}')"
if [ -z "$PRIMARY" ]; then
  PRIMARY="$(xrandr --query | awk '/ connected/{print $1; exit}')"
fi

# Laptop-specific names (safe even on desktop; logic will no-op if not present)
EXTERNAL_MONITOR="${EXTERNAL_MONITOR:-HDMI-2}"
LAPTOP_MONITOR="${LAPTOP_MONITOR:-eDP-1}"

EXTERNAL_CONNECTED="no"
if xrandr | grep -q "^${EXTERNAL_MONITOR} connected"; then
  EXTERNAL_CONNECTED="yes"
fi

# ---------- dynamic substitutions (laptop behavior) ----------
# Only do replacements if the placeholders exist in the base config
FONT_SIZE="${POLYBAR_FONT_SIZE:-12}"
SHOW_SONG="${SHOW_SONG:-0}"

if [ "$EXTERNAL_CONNECTED" = "yes" ]; then
  FONT_SIZE="${POLYBAR_FONT_SIZE_EXTERNAL:-16}"
  SHOW_SONG="${SHOW_SONG_EXTERNAL:-1}"
fi

if [ "$SHOW_SONG" -eq 1 ]; then
  MPD_FORMAT='format-online = <label-song> <label-time> <icon-prev> <toggle> <icon-next>'
else
  MPD_FORMAT='format-online = <label-time> <icon-prev> <toggle> <icon-next>'
fi

# Always generate a temp config (works for both machines; harmless on desktop)
sed \
  -e "s|\${POLYBAR_FONT_SIZE}|${FONT_SIZE}|g" \
  -e "s|__MPD_FORMAT__|${MPD_FORMAT}|g" \
  "$BASE_CONFIG" > "$TMP_CONFIG"

# Network interface used for default route (wifi or ethernet)
if iface="$(ip route get 1.1.1.1 2>/dev/null | awk '{for(i=1;i<=NF;i++) if ($i=="dev") {print $(i+1); exit}}')"; then
  if [ -n "${iface:-}" ]; then
    export POLYBAR_NET_IFACE="$iface"
  fi
fi

DESKTOP_MODULES_RIGHT="timer mpd weather docker filesystem memory cpu network bluetooth uptime pulseaudio date"

LAPTOP_MODULES_RIGHT="timer mpd weather docker filesystem memory cpu network bluetooth uptime battery pulseaudio date"

if [[ "$DEVICE_TYPE" == "laptop" ]]; then
  export POLYBAR_MODULES_RIGHT="$LAPTOP_MODULES_RIGHT"
else
  export POLYBAR_MODULES_RIGHT="$DESKTOP_MODULES_RIGHT"
fi




# ---------- launch ----------
echo "---" | tee -a /tmp/polybar.log
echo "PRIMARY=$PRIMARY  EXTERNAL_CONNECTED=$EXTERNAL_CONNECTED  FONT_SIZE=$FONT_SIZE  SHOW_SONG=$SHOW_SONG" | tee -a /tmp/polybar.log

xrandr --query | awk '/ connected/{print $1}' | while read -r monitor; do
  # Laptop rule: if external is connected, keep laptop panel minimal
  if [ "$monitor" = "$LAPTOP_MONITOR" ] && [ "$EXTERNAL_CONNECTED" = "yes" ]; then
    echo "Launching minimal Polybar on $monitor (external monitor connected)" | tee -a /tmp/polybar.log
    MONITOR="$monitor" polybar --config="$TMP_CONFIG" minimal 2>&1 | tee -a "/tmp/polybar_${monitor}.log" & disown
    continue
  fi

  # Desktop rule: main on PRIMARY, minimal on others
  if [ "$monitor" = "$PRIMARY" ]; then
    echo "Launching main Polybar on $monitor (primary)" | tee -a /tmp/polybar.log
    MONITOR="$monitor" polybar --config="$TMP_CONFIG" main 2>&1 | tee -a "/tmp/polybar_${monitor}.log" & disown
  else
    echo "Launching minimal Polybar on $monitor" | tee -a /tmp/polybar.log
    MONITOR="$monitor" polybar --config="$TMP_CONFIG" minimal 2>&1 | tee -a "/tmp/polybar_${monitor}.log" & disown
  fi
done
