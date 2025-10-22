#!/bin/bash

# Get CPU usage percentage (average across all cores)
cpu_usage=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {printf "%.0f", usage}')

# Determine color based on usage
color=""
if [ "$cpu_usage" -ge 85 ]; then
    # Red for 85% or above
    color="%{F#F44336}"
elif [ "$cpu_usage" -ge 75 ]; then
    # Yellow for 75% or above
    color="%{F#FDD835}"
fi

# Output with icon and color
if [ -n "$color" ]; then
    echo "󰻠 ${color}${cpu_usage}%%{F-}"
else
    echo "󰻠 ${cpu_usage}%"
fi
