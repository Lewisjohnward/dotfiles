#!/usr/bin/env bash
set -euo pipefail

# ---------- get hostname for policy ----------
HOST="$(hostname -s)"
case "$HOST" in
  Thinkerton) DEVICE_TYPE="laptop" ;;
  BadRobot)   DEVICE_TYPE="desktop" ;;
  *)
    echo "Unknown host '$HOST'. Defaulting to desktop behavior." >&2
    DEVICE_TYPE="desktop"
    ;;
esac

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

# ---------- config paths ----------
CONFIG_DIR="$HOME/.config/polybar"

# Pick ONE convention and stick to it:
BASE_CONFIG="$CONFIG_DIR/generated.ini"
# BASE_CONFIG="$CONFIG_DIR/generated.ini"

TMP_CONFIG="/tmp/polybar_config_${USER}.ini"

if [[ ! -f "$BASE_CONFIG" ]]; then
  echo "ERROR: $BASE_CONFIG not found. Run your generator first." >&2
  exit 1
fi

# ---------- set env vars BEFORE launching ----------
# Network interface auto-detect
if iface="$(ip route get 1.1.1.1 2>/dev/null | awk '{for(i=1;i<=NF;i++) if ($i=="dev") {print $(i+1); exit}}')"; then
  [[ -n "${iface:-}" ]] && export POLYBAR_NET_IFACE="$iface"
fi

DESKTOP_MODULES_RIGHT="timer mpd weather docker filesystem memory cpu network bluetooth uptime pulseaudio date"
LAPTOP_MODULES_RIGHT="timer mpd weather docker filesystem memory cpu network bluetooth uptime battery pulseaudio date"

if [[ "$DEVICE_TYPE" == "laptop" ]]; then
  export POLYBAR_MODULES_RIGHT="$LAPTOP_MODULES_RIGHT"
else
  export POLYBAR_MODULES_RIGHT="$DESKTOP_MODULES_RIGHT"
fi

# ---------- laptop-only external monitor logic ----------
EXTERNAL_CONNECTED="no"
FONT_SIZE="${POLYBAR_FONT_SIZE:-12}"
SHOW_SONG="${SHOW_SONG:-0}"

if [[ "$DEVICE_TYPE" == "laptop" ]]; then
  EXTERNAL_MONITOR="${EXTERNAL_MONITOR:-HDMI-2}"
  LAPTOP_MONITOR="${LAPTOP_MONITOR:-eDP-1}"

  if xrandr | grep -q "^${EXTERNAL_MONITOR} connected"; then
    EXTERNAL_CONNECTED="yes"
    FONT_SIZE="${POLYBAR_FONT_SIZE_EXTERNAL:-16}"
    SHOW_SONG="${SHOW_SONG_EXTERNAL:-1}"
  fi
fi

if [[ "$SHOW_SONG" == "1" ]]; then
  MPD_FORMAT='format-online = <label-song> <label-time> <icon-prev> <toggle> <icon-next>'
else
  MPD_FORMAT='format-online = <label-time> <icon-prev> <toggle> <icon-next>'
fi

# Apply substitutions (safe even if placeholders not present)
sed \
  -e "s|\${POLYBAR_FONT_SIZE}|${FONT_SIZE}|g" \
  -e "s|__MPD_FORMAT__|${MPD_FORMAT}|g" \
  "$BASE_CONFIG" > "$TMP_CONFIG"

# ---------- monitor detection ----------
XRANDR="$(xrandr --query)"
PRIMARY="$(awk '/ connected primary/{print $1; exit}' <<<"$XRANDR")"
if [[ -z "${PRIMARY:-}" ]]; then
  PRIMARY="$(awk '/ connected/{print $1; exit}' <<<"$XRANDR")"
fi

# ---------- launch ----------
echo "---" | tee -a /tmp/polybar.log
echo "HOST=$HOST DEVICE_TYPE=$DEVICE_TYPE PRIMARY=$PRIMARY EXTERNAL_CONNECTED=$EXTERNAL_CONNECTED FONT_SIZE=$FONT_SIZE SHOW_SONG=$SHOW_SONG IFACE=${POLYBAR_NET_IFACE:-}" | tee -a /tmp/polybar.log

awk '/ connected/{print $1}' <<<"$XRANDR" | while read -r monitor; do
  # Laptop: when docked, keep internal panel minimal
  if [[ "$DEVICE_TYPE" == "laptop" && "$EXTERNAL_CONNECTED" == "yes" && "$monitor" == "${LAPTOP_MONITOR:-}" ]]; then
    echo "Launching minimal on $monitor (laptop panel while docked)" | tee -a /tmp/polybar.log
    MONITOR="$monitor" polybar --config="$TMP_CONFIG" minimal 2>&1 | tee -a "/tmp/polybar_${monitor}.log" & disown
    continue
  fi

  # Default: main on PRIMARY, minimal elsewhere
  if [[ "$monitor" == "$PRIMARY" ]]; then
    echo "Launching main on $monitor" | tee -a /tmp/polybar.log
    MONITOR="$monitor" polybar --config="$TMP_CONFIG" main 2>&1 | tee -a "/tmp/polybar_${monitor}.log" & disown
  else
    echo "Launching minimal on $monitor" | tee -a /tmp/polybar.log
    MONITOR="$monitor" polybar --config="$TMP_CONFIG" minimal 2>&1 | tee -a "/tmp/polybar_${monitor}.log" & disown
  fi
done

