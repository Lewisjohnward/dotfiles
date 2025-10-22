#!/bin/bash

# Check if Jellyfin server is responding on localhost:8096
if curl -s --connect-timeout 2 http://localhost:8096 > /dev/null 2>&1; then
    # Server is up - show green icon
    echo "%{F#4CAF50}󰼁%{F-}"
else
    # Server is down - show red icon
    echo "%{F#F44336}󰼂%{F-}"
fi
