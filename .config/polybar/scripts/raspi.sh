#!/bin/bash

# Check if Raspberry Pi is responding on 192.168.8.2
if ping -c 1 -W 1 192.168.1.2 > /dev/null 2>&1; then
    # Pi is up - show green icon
    echo "%{F#4CAF50} %{F-}"
else
    # Pi is down - show red icon
    echo "%{F#F44336} %{F-}"
fi
