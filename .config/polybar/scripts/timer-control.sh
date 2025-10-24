#!/bin/bash

# Timer control script for rofi menu
STATE_FILE="/tmp/polybar_timer_state"
END_TIME_FILE="/tmp/polybar_timer_endtime"
PAUSE_TIME_FILE="/tmp/polybar_timer_pausetime"

# Initialize if files don't exist
if [ ! -f "$STATE_FILE" ]; then
    echo "stopped" > "$STATE_FILE"
fi

if [ ! -f "$END_TIME_FILE" ]; then
    echo "0" > "$END_TIME_FILE"
fi

state=$(cat "$STATE_FILE")
end_time=$(cat "$END_TIME_FILE")

# Calculate remaining time
if [ "$state" = "running" ]; then
    current_time=$(date +%s)
    remaining=$((end_time - current_time))
    if [ "$remaining" -lt 0 ]; then
        remaining=0
    fi
elif [ "$state" = "paused" ] && [ -f "$PAUSE_TIME_FILE" ]; then
    remaining=$(cat "$PAUSE_TIME_FILE")
else
    remaining=0
fi

# Format time as HH:MM:SS or MM:SS
format_time() {
    local total_seconds=$1
    local hours=$((total_seconds / 3600))
    local minutes=$(((total_seconds % 3600) / 60))
    local seconds=$((total_seconds % 60))
    
    if [ $hours -gt 0 ]; then
        printf "%d:%02d:%02d" $hours $minutes $seconds
    else
        printf "%02d:%02d" $minutes $seconds
    fi
}

# Menu options based on current state
if [ "$state" = "running" ]; then
    options="⏸ Pause\n⏹ Stop\n⏱ Set New Timer"
elif [ "$state" = "paused" ]; then
    options="▶ Resume\n⏹ Stop\n⏱ Set New Timer"
else
    options="⏱ Set Timer"
fi

# Show rofi menu
choice=$(echo -e "$options" | rofi -dmenu -i -p "Timer ($(format_time $remaining)):")

case "$choice" in
    "▶ Resume")
        if [ -f "$PAUSE_TIME_FILE" ]; then
            paused_remaining=$(cat "$PAUSE_TIME_FILE")
            current_time=$(date +%s)
            new_end_time=$((current_time + paused_remaining))
            echo "$new_end_time" > "$END_TIME_FILE"
            rm -f "$PAUSE_TIME_FILE"
        fi
        echo "running" > "$STATE_FILE"
        ;;
    "⏸ Pause")
        current_time=$(date +%s)
        remaining=$((end_time - current_time))
        if [ "$remaining" -gt 0 ]; then
            echo "$remaining" > "$PAUSE_TIME_FILE"
        fi
        echo "paused" > "$STATE_FILE"
        ;;
    "⏹ Stop")
        echo "stopped" > "$STATE_FILE"
        echo "0" > "$END_TIME_FILE"
        rm -f "$PAUSE_TIME_FILE"
        ;;
    "⏱ Set Timer"|"⏱ Set New Timer")
        custom=$(echo "" | rofi -dmenu -p "Enter minutes:")
        if [[ "$custom" =~ ^[0-9]+$ ]] && [ "$custom" -gt 0 ]; then
            seconds=$((custom * 60))
            current_time=$(date +%s)
            end_time=$((current_time + seconds))
            echo "$end_time" > "$END_TIME_FILE"
            echo "running" > "$STATE_FILE"
            rm -f "$PAUSE_TIME_FILE"
        fi
        ;;
esac
