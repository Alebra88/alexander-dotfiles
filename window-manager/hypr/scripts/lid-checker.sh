#!/bin/bash

# Periodic lid state checker
# This script checks lid state every 2 seconds and handles monitor switching

LAPTOP_MONITOR="eDP-1"
LID_STATE_FILE="/proc/acpi/button/lid/LID0/state"
LAST_STATE=""

# Function to check if external monitors are connected
check_external_monitors() {
    hyprctl monitors 2>/dev/null | grep -v "$LAPTOP_MONITOR" | grep -q "Monitor"
    return $?
}

# Function to get current lid state
get_lid_state() {
    if [ -f "$LID_STATE_FILE" ]; then
        grep -o "open\|closed" "$LID_STATE_FILE" 2>/dev/null || echo "open"
    else
        echo "open"
    fi
}

# Function to handle lid state changes
handle_lid_change() {
    local current_state="$1"
    
    if [ "$current_state" = "closed" ]; then
        if check_external_monitors; then
            # External monitor connected, disable laptop screen
            hyprctl keyword monitor "$LAPTOP_MONITOR,disable" 2>/dev/null
            echo "[$(date)] Lid closed: Disabled laptop screen, external monitor active"
        else
            echo "[$(date)] Lid closed: No external monitor, allowing suspend"
        fi
    elif [ "$current_state" = "open" ]; then
        # Always enable laptop screen when lid opens
        hyprctl keyword monitor "$LAPTOP_MONITOR,1920x1080@60,0x0,1.5" 2>/dev/null
        echo "[$(date)] Lid opened: Enabled laptop screen"
    fi
}

# Main monitoring loop
echo "Starting periodic lid state checker..."
while true; do
    current_state=$(get_lid_state)
    
    if [ "$current_state" != "$LAST_STATE" ]; then
        handle_lid_change "$current_state"
        LAST_STATE="$current_state"
    fi
    
    sleep 2
done