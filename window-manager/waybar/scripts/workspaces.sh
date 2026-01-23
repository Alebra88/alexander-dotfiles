#!/bin/bash

# Simple workspace display script
# Shows workspace numbers and window classes

# Get current workspace
current_ws=$(hyprctl activeworkspace -j | jq -r '.id')

# Get all windows and their workspaces
get_workspace_windows() {
    local ws_id=$1
    hyprctl clients -j | jq -r ".[] | select(.workspace.id == $ws_id) | .class" | sort -u | tr '\n' ' ' | sed 's/ *$//'
}

# Build workspace text
workspaces_text=""

for ws_id in {1..5}; do
    windows=$(get_workspace_windows $ws_id)
    
    if [ $ws_id -eq $current_ws ]; then
        ws_text="󱓻$ws_id"
    else
        ws_text="$ws_id"
    fi
    
    if [ -n "$windows" ]; then
        ws_text="$ws_text: $windows"
    fi
    
    if [ -n "$workspaces_text" ]; then
        workspaces_text="$workspaces_text  $ws_text"
    else
        workspaces_text="$ws_text"
    fi
done

# Output JSON for Waybar
echo "{\"text\":\"$workspaces_text\",\"tooltip\":\"\",\"class\":\"\"}"