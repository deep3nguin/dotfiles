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

# Colors derived from DESIGN.md (Surface Dark #0C1614, On-surface #e2e2e2, Growth Green #00FF8A, Action Cyan #00BFD6)
BG_COLOR="0c1614ff"
TEXT_COLOR="e2e2e2ff"
SELECTION_COLOR="00ff8aff"
BORDER_COLOR="00bfd6ff"

# Show clipboard history via fuzzel and select an item to copy back to clipboard
cliphist list | \
    fuzzel --dmenu \
           --background="$BG_COLOR" \
           --text-color="$TEXT_COLOR" \
           --selection-color="$SELECTION_COLOR" \
           --border-color="$BORDER_COLOR" \
           --border-width=2 \
           --border-radius=8 \
           --font="Google Sans Flex:size=10" \
           --placeholder="Search clipboard..." \
           | cliphist decode | wl-copy
