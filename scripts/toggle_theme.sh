#!/usr/bin/env bash
#
# toggle_theme.sh - Shell wrapper for theme toggler
#

set -euo pipefail

# Resolve the real script directory even when executed via symlinks (e.g. ~/.local/bin)
SCRIPT_SOURCE="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_SOURCE")" && pwd)"

# Run python theme toggler (handles DESIGN.md update, token recompilation, symlinks, and live hot-reloads)
python3 "${SCRIPT_DIR}/toggle_theme.py"
