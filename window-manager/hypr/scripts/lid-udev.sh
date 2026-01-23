#!/bin/bash

# Simple udev-based lid switch handler
# This script is called by udev rules when lid state changes

LAPTOP_MONITOR="eDP-1"
ACTION="$1"

# Function to check if external monitors are connected
check_external_monitors() {
    hyprctl monitors 2>/dev/null | grep -v "$LAPTOP_MONITOR" | grep -q "Monitor"
    return $?
}

# Function to handle lid state changes
handle_lid_change() {
    if [ "$ACTION" = "close" ]; then
        if check_external_monitors; then
            # External monitor connected, disable laptop screen
            hyprctl keyword monitor "$LAPTOP_MONITOR,disable" 2>/dev/null
            echo "[$(date)] Lid closed: Disabled laptop screen, external monitor active"
        else
            echo "[$(date)] Lid closed: No external monitor, allowing suspend"
        fi
    elif [ "$ACTION" = "open" ]; then
        # Always enable laptop screen when lid opens
        hyprctl keyword monitor "$LAPTOP_MONITOR,1920x1080@60,0x0,1.5" 2>/dev/null
        echo "[$(date)] Lid opened: Enabled laptop screen"
    fi
}

handle_lid_change