#!/bin/bash

# Quick timer set script - goes straight to input
STATE_FILE="/tmp/polybar_timer_state"
END_TIME_FILE="/tmp/polybar_timer_endtime"
PAUSE_TIME_FILE="/tmp/polybar_timer_pausetime"

# Ask for minutes
custom=$(echo "" | rofi -dmenu -p "Enter minutes:" -theme ~/.config/rofi/themes/timer-input.rasi)

if [[ "$custom" =~ ^[0-9]+$ ]] && [ "$custom" -gt 0 ]; then
    seconds=$((custom * 60))
    current_time=$(date +%s)
    end_time=$((current_time + seconds))
    echo "$end_time" > "$END_TIME_FILE"
    echo "running" > "$STATE_FILE"
    rm -f "$PAUSE_TIME_FILE"
    notify-send "Timer" "Started ${custom}m timer"
fi
