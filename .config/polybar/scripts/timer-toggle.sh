#!/bin/bash

STATE_FILE="/tmp/polybar_timer_state"
END_TIME_FILE="/tmp/polybar_timer_endtime"
PAUSE_TIME_FILE="/tmp/polybar_timer_pausetime"

if [ ! -f "$STATE_FILE" ]; then
    echo "stopped" > "$STATE_FILE"
    exit 0
fi

state=$(cat "$STATE_FILE")
end_time=$(cat "$END_TIME_FILE" 2>/dev/null || echo "0")

if [ "$state" = "running" ]; then
    # Pause: save remaining time
    current_time=$(date +%s)
    remaining=$((end_time - current_time))
    if [ "$remaining" -gt 0 ]; then
        echo "$remaining" > "$PAUSE_TIME_FILE"
    fi
    echo "paused" > "$STATE_FILE"
    notify-send "Timer" "Paused"
elif [ "$state" = "paused" ]; then
    # Resume: calculate new end time
    if [ -f "$PAUSE_TIME_FILE" ]; then
        paused_remaining=$(cat "$PAUSE_TIME_FILE")
        current_time=$(date +%s)
        new_end_time=$((current_time + paused_remaining))
        echo "$new_end_time" > "$END_TIME_FILE"
        rm -f "$PAUSE_TIME_FILE"
    fi
    echo "running" > "$STATE_FILE"
    notify-send "Timer" "Resumed"
fi
