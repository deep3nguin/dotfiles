#!/usr/bin/env bash

# Exit immediately on failure, unset variable reference, or pipe failure
set -euo pipefail

# Check for help flags or missing argument
if [[ $# -lt 1 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: $(basename "$0") <path-to-wallpaper>"
    echo "Changes the wallpaper dynamically using hyprctl hyprpaper."
    exit 1
fi

WALLPAPER_PATH="$1"

# Resolve target path to an absolute path to avoid loading issues in hyprpaper
WALLPAPER_PATH=$(realpath "$WALLPAPER_PATH")

# Verify that the target wallpaper file exists and is readable
if [[ ! -f "$WALLPAPER_PATH" ]]; then
    echo "Error: File '$WALLPAPER_PATH' does not exist or is not a regular file." >&2
    exit 1
fi

# Preload the new wallpaper image into hyprpaper's memory
hyprctl hyprpaper preload "$WALLPAPER_PATH"

# Apply the preloaded wallpaper to all monitors (wildcard syntax)
hyprctl hyprpaper wallpaper ",$WALLPAPER_PATH"

# Unload any inactive preloaded wallpapers from memory to prevent memory accumulation
hyprctl hyprpaper unload unused
