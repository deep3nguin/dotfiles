#!/usr/bin/env bash
#
# cliphist-fuzzel.sh - Fuzzel clipboard manager integration using cliphist
#

set -euo pipefail

# Check if required commands exist
for cmd in cliphist fuzzel wl-copy; do
    if ! command -v "$cmd" &>/dev/null; then
        echo "Error: Required command '$cmd' is not installed." >&2
        exit 1
    fi
done

# Colors derived from DESIGN.md (Parchment #fefffc, Ink Black #171717, Signal Blue #41a1cf, Mist #dee2de)
BG_COLOR="fefffcff"
TEXT_COLOR="171717ff"
SELECTION_COLOR="41a1cfff"
BORDER_COLOR="dee2deff"

# Show clipboard history via fuzzel and select an item to copy back to clipboard
cliphist list | \
    fuzzel --dmenu \
           --background="$BG_COLOR" \
           --text-color="$TEXT_COLOR" \
           --selection-color="$SELECTION_COLOR" \
           --border-color="$BORDER_COLOR" \
           --border-width=1 \
           --border-radius=16 \
           --font="af:size=15" \
           --placeholder="Search clipboard..." \
           | cliphist decode | wl-copy

