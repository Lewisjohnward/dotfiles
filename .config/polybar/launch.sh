#!/usr/bin/env bash

# Kill existing polybar instances
killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Paths
CONFIG_DIR="$HOME/.config/polybar"
BASE_CONFIG="$CONFIG_DIR/generated.ini"
TMP_CONFIG="/tmp/polybar_config_$USER.ini"

# Detect if 4K external monitor is connected
EXTERNAL_MONITOR="HDMI-2"  # adjust if different
LAPTOP_MONITOR="eDP-1"     # adjust if different

if xrandr | grep -q "^$EXTERNAL_MONITOR connected"; then
    FONT_SIZE=16
    SHOW_SONG=1
    TARGET_MONITOR=$EXTERNAL_MONITOR
    echo "4K external monitor detected: using large fonts and showing song"
else
    FONT_SIZE=12
    SHOW_SONG=0
    TARGET_MONITOR=$LAPTOP_MONITOR
    echo "No external monitor: using laptop screen"
fi

# Set MPD format depending on SHOW_SONG
if [ "$SHOW_SONG" -eq 1 ]; then
    MPD_FORMAT='format-online = <label-song> <label-time> <icon-prev> <toggle> <icon-next>'
else
    MPD_FORMAT='format-online = <label-time> <icon-prev> <toggle> <icon-next>'
fi

# Replace placeholders in base config
sed "s|\${POLYBAR_FONT_SIZE}|$FONT_SIZE|g; s|__MPD_FORMAT__|$MPD_FORMAT|g" "$BASE_CONFIG" > "$TMP_CONFIG"

# Launch Polybar on all connected monitors
echo "---" | tee -a /tmp/polybar.log

# Get all connected monitors
EXTERNAL_CONNECTED=$(xrandr | grep -q "^$EXTERNAL_MONITOR connected" && echo "yes" || echo "no")

for monitor in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    # Use minimal bar for laptop monitor if external monitor is connected
    if [ "$monitor" = "$LAPTOP_MONITOR" ] && [ "$EXTERNAL_CONNECTED" = "yes" ]; then
        echo "Launching minimal Polybar on $monitor (external monitor connected)"
        MONITOR=$monitor polybar --config="$TMP_CONFIG" minimal 2>&1 | tee -a /tmp/polybar_${monitor}.log & disown
    else
        echo "Launching full Polybar on monitor: $monitor"
        MONITOR=$monitor polybar --config="$TMP_CONFIG" main 2>&1 | tee -a /tmp/polybar_${monitor}.log & disown
    fi
done

echo "Polybar launched on all monitors with font size $FONT_SIZE, SHOW_SONG=$SHOW_SONG"
