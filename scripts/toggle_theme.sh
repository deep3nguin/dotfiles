#!/usr/bin/env bash

# Resolve the script's directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Run python theme toggler
python3 "${SCRIPT_DIR}/toggle_theme.py"

# Reload Hyprland config
hyprctl reload

# Restart Waybar
killall waybar
sleep 0.5
waybar >/dev/null 2>&1 &
