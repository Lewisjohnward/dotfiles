#!/bin/bash

# Timer state file
STATE_FILE="/tmp/polybar_timer_state"
END_TIME_FILE="/tmp/polybar_timer_endtime"

# Initialize if files don't exist
if [ ! -f "$STATE_FILE" ]; then
    echo "stopped" > "$STATE_FILE"
fi

if [ ! -f "$END_TIME_FILE" ]; then
    echo "0" > "$END_TIME_FILE"
fi

# Read current state
state=$(cat "$STATE_FILE")
end_time=$(cat "$END_TIME_FILE")

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

# Display the timer
if [ "$state" = "running" ]; then
    # Calculate remaining time based on end time
    current_time=$(date +%s)
    remaining=$((end_time - current_time))
    
    if [ "$remaining" -gt 0 ]; then
        # Format end time as HH:MM
        end_time_formatted=$(date -d "@$end_time" +"%H:%M")
        echo " $(format_time $remaining)|$end_time_formatted"
    else
        # Timer finished
        echo "stopped" > "$STATE_FILE"
        echo "0" > "$END_TIME_FILE"
        notify-send "Timer" "Time's up!" -u critical
        echo " 00:00"
    fi
elif [ "$state" = "paused" ]; then
    # Timer is paused - show remaining time from pause file
    PAUSE_TIME_FILE="/tmp/polybar_timer_pausetime"
    if [ -f "$PAUSE_TIME_FILE" ]; then
        paused_remaining=$(cat "$PAUSE_TIME_FILE")
        # Calculate what the end time would be if resumed now
        current_time=$(date +%s)
        projected_end_time=$((current_time + paused_remaining))
        end_time_formatted=$(date -d "@$projected_end_time" +"%H:%M")
        echo "%{F#FFA500} $(format_time $paused_remaining)|$end_time_formatted%{F-}"
    else
        echo "%{F#FFA500} --:---%{F-}"
    fi
else
    # Timer is stopped
    echo "%{F#666} --:--%{F-}"
fi
