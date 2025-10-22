#!/bin/bash

# Get disk usage percentage for root filesystem
disk_used=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
disk_used_readable=$(df -h / | awk 'NR==2 {print $3}')
disk_remaining=$((100 - disk_used))

# Determine color based on usage
color=""
if [ "$disk_used" -ge 85 ]; then
    # Red for 85% or above
    color="%{F#F44336}"
elif [ "$disk_used" -ge 75 ]; then
    # Yellow for 75% or above
    color="%{F#FDD835}"
fi

# Output with icon, used space, and percentage remaining
if [ -n "$color" ]; then
    echo "${color}󰋊 ${disk_used_readable} (${disk_remaining}%)%{F-}"
else
    echo "󰋊 ${disk_used_readable} (${disk_remaining}%)"
fi
