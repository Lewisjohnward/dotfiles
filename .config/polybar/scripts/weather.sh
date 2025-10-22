#!/bin/bash

# Get temperature and weather condition from wttr.in
temp=$(curl -s "wttr.in/Harlow?format=%t")
condition=$(curl -s "wttr.in/Harlow?format=%C")

# Extract numeric value (remove °C or °F)
temp_num=$(echo "$temp" | grep -oP '[-+]?\d+' | head -1)

# Default color (white/default)
color=""

# Check temperature and set color
if [ -n "$temp_num" ]; then
    if [ "$temp_num" -le 5 ]; then
        # Blue for cold (5°C or below)
        color="%{F#2196F3}"
    elif [ "$temp_num" -ge 20 ]; then
        # Red for hot (20°C or above)
        color="%{F#F44336}"
    fi
fi

# Determine weather icon and color based on condition
icon=""
icon_color=""
case "${condition,,}" in
    *clear*|*sunny*)
        icon="󰖙"  # Sun
        icon_color="%{F#FDD835}"  # Yellow
        ;;
    *cloud*)
        icon="󰖐"  # Cloud
        icon_color="%{F#9E9E9E}"  # Grey
        ;;
    *rain*|*drizzle*)
        icon="󰖗"  # Rain
        icon_color="%{F#42A5F5}"  # Light blue
        ;;
    *snow*|*sleet*)
        icon="󰖘"  # Snow
        icon_color="%{F#90CAF9}"  # Light blue
        ;;
    *thunder*|*storm*)
        icon="󰖓"  # Thunder
        icon_color="%{F#7E57C2}"  # Purple
        ;;
    *fog*|*mist*)
        icon="󰖑"  # Fog
        icon_color="%{F#B0BEC5}"  # Light grey
        ;;
    *overcast*)
        icon="󰖐"  # Overcast
        icon_color="%{F#757575}"  # Dark grey
        ;;
    *)
        icon="?"  # No data available
        icon_color="%{F#9E9E9E}"  # Grey
        ;;
esac

# Output with colored icon and temperature
if [ -n "$icon_color" ]; then
    if [ -n "$color" ]; then
        echo "${icon_color}${icon}%{F-} ${color}${temp}%{F-}"
    else
        echo "${icon_color}${icon}%{F-} ${temp}"
    fi
else
    if [ -n "$color" ]; then
        echo "${icon} ${color}${temp}%{F-}"
    else
        echo "${icon} ${temp}"
    fi
fi
