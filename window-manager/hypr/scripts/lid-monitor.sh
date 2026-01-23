#!/bin/bash

# Monitor lid state changes using systemd-logind
# This script runs in the background and handles monitor switching

LAPTOP_MONITOR="eDP-1"
SCRIPT_DIR="/home/alexander/.config/hypr/scripts"

# Function to check if external monitors are connected
check_external_monitors() {
    hyprctl monitors | grep -v "$LAPTOP_MONITOR" | grep -q "Monitor"
    return $?
}

# Function to handle lid state changes
handle_lid_change() {
    local lid_state="$1"
    
    if [ "$lid_state" = "closed" ]; then
        if check_external_monitors; then
            # External monitor connected, disable laptop screen
            hyprctl keyword monitor "$LAPTOP_MONITOR,disable"
            echo "[$(date)] Lid closed: Disabled laptop screen, external monitor active"
        else
            echo "[$(date)] Lid closed: No external monitor, allowing suspend"
        fi
    elif [ "$lid_state" = "open" ]; then
        # Always enable laptop screen when lid opens
        hyprctl keyword monitor "$LAPTOP_MONITOR,1920x1080@60,0x0,1.5"
        echo "[$(date)] Lid opened: Enabled laptop screen"
    fi
}

# Monitor systemd-logind for lid events
monitor_lid_events() {
    stdbuf -oL journalctl -f -u systemd-logind | while read line; do
        if echo "$line" | grep -q "Lid closed\|Lid opened"; then
            if echo "$line" | grep -q "Lid closed"; then
                handle_lid_change "closed"
            elif echo "$line" | grep -q "Lid opened"; then
                handle_lid_change "open"
            fi
        fi
    done
}

# Start monitoring in background
echo "Starting lid monitor..."
monitor_lid_events &

# Store PID for potential cleanup
echo $! > /tmp/lid-monitor.pid