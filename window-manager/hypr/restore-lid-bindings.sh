#!/bin/bash
# Restore lid bindings after nwg-displays overwrites monitors.conf

LID_BINDINGS=(
    'bindl=,switch:on:Lid Switch,exec,hyprctl keyword monitor "eDP-1, disable"'
    'bindl=,switch:off:Lid Switch,exec,hyprctl keyword monitor "eDP-1, preferred, auto, auto"'
)

MONITOR_CONF="/home/alexander/.config/hypr/monitors.conf"

# Remove existing lid bindings if they exist
sed -i '/bindl=,switch:.*Lid Switch/d' "$MONITOR_CONF"

# Add lid bindings at the end
for binding in "${LID_BINDINGS[@]}"; do
    echo "$binding" >> "$MONITOR_CONF"
done

echo "Lid bindings restored to monitors.conf"