#!/bin/bash

# Check if kmonad is running
if systemctl is-active --quiet kmonad.service; then
    # Get which keyboard is active
    if [ -e "/dev/input/by-id/usb-CM_Storm_Quickfire_TKL_6keys-event-kbd" ]; then
        # External keyboard - show keyboard icon in green
        echo "%{F#4CAF50}%{F-}"
    else
        # Laptop keyboard - show laptop icon in green
        echo "%{F#4CAF50}%{F-}"
    fi
else
    # KMonad not running - show red icon
    echo "%{F#F54842}⌨%{F-}"
fi
