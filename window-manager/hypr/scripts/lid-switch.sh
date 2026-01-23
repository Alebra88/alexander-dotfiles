#!/bin/bash

# Smart lid switch script for Hyprland
# Handles monitor configuration based on lid state and external monitors

ACTION="$1"
LAPTOP_MONITOR="eDP-1"

# Check if external monitors are connected
check_external_monitors() {
    hyprctl monitors | grep -v "$LAPTOP_MONITOR" | grep -q "Monitor"
    return $?
}

# Get current lid state
get_lid_state() {
    if [ -f /proc/acpi/button/lid/LID0/state ]; then
        grep -c "open" /proc/acpi/button/lid/LID0/state
    else
        echo "1"  # Assume open if we can't detect
    fi
}

case "$ACTION" in
    "close")
        if check_external_monitors; then
            # External monitor connected, disable laptop screen
            hyprctl keyword monitor "$LAPTOP_MONITOR,disable"
            echo "Lid closed: Disabled laptop screen, external monitor active"
        else
            # No external monitor, let system handle suspend
            echo "Lid closed: No external monitor, allowing suspend"
        fi
        ;;
    "open")
        # Always enable laptop screen when lid opens
        hyprctl keyword monitor "$LAPTOP_MONITOR,1920x1080@60,0x0,1.5"
        echo "Lid opened: Enabled laptop screen"
        ;;
    *)
        echo "Usage: $0 {close|open}"
        exit 1
        ;;
esac