#!/usr/bin/env bash

# Exit immediately on failure, unset variable reference, or pipe failure
set -euo pipefail

# ANSI escape code for Action Cyan (Secondary color) from DESIGN.md
COLOR_CYAN="\e[38;2;0;191;214m"
# ANSI escape code for Growth Green (Primary color) from DESIGN.md
COLOR_GREEN="\e[38;2;0;255;138m"
# ANSI escape code for Error Red (Error color) from DESIGN.md
COLOR_ERROR="\e[38;2;255;180;171m"
# ANSI escape code to reset color formatting
COLOR_RESET="\e[0m"

# Print an informational message in Action Cyan
log_info() {
    echo -e "${COLOR_CYAN}[INFO]${COLOR_RESET} $1"
}

# Print a success message in Growth Green
log_success() {
    echo -e "${COLOR_GREEN}[SUCCESS]${COLOR_RESET} $1"
}

# Print an error message in Error Red to standard error
log_error() {
    echo -e "${COLOR_ERROR}[ERROR]${COLOR_RESET} $1" >&2
}

# Check for help flags or missing argument
if [[ $# -lt 1 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: $(basename "$0") <path-to-wallpaper>"
    echo "Changes the wallpaper dynamically using hyprctl hyprpaper."
    exit 1
fi

# Store the first argument as the target wallpaper path
WALLPAPER_PATH="$1"

# Resolve target path to an absolute path to avoid loading issues in hyprpaper
WALLPAPER_PATH=$(realpath "$WALLPAPER_PATH")

# Verify that the target wallpaper file exists and is readable
if [[ ! -f "$WALLPAPER_PATH" ]]; then
    log_error "File '$WALLPAPER_PATH' does not exist or is not a regular file."
    exit 1
fi

# Log the preload operation
log_info "Preloading wallpaper: $WALLPAPER_PATH"

# Preload the new wallpaper image into hyprpaper's memory
hyprctl hyprpaper preload "$WALLPAPER_PATH"

# Log the wallpaper apply operation
log_info "Applying wallpaper to all active monitors"

# Apply the preloaded wallpaper to all monitors (wildcard syntax)
hyprctl hyprpaper wallpaper ",$WALLPAPER_PATH"

# Log the memory cleanup operation
log_info "Cleaning up unused wallpapers from memory"

# Unload any inactive preloaded wallpapers from memory to prevent memory accumulation
hyprctl hyprpaper unload unused

# Log the successful completion of the wallpaper change
log_success "Wallpaper successfully changed to $WALLPAPER_PATH"

