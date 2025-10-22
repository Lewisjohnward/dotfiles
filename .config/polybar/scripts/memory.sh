#!/bin/bash

# Get memory usage percentage
mem_used=$(free | grep Mem | awk '{printf "%.0f", ($3/$2) * 100}')

# Determine color based on usage
color=""
if [ "$mem_used" -ge 85 ]; then
    # Red for 85% or above
    color="%{F#F44336}"
elif [ "$mem_used" -ge 75 ]; then
    # Yellow for 75% or above
    color="%{F#FDD835}"
fi

# Output with icon and color
if [ -n "$color" ]; then
    echo "󰘚 ${color}${mem_used}%%{F-}"
else
    echo "󰘚 ${mem_used}%"
fi
