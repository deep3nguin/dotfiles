#!/usr/bin/env bash
#
# install.sh - Idempotent dotfiles installation script
# Targets: CachyOS / Arch Linux (pacman)
#

set -euo pipefail

# --- Logging Helpers ---
log_info() {
    echo -e "\e[34m[INFO]\e[0m $1"
}

log_success() {
    echo -e "\e[32m[SUCCESS]\e[0m $1"
}

log_warn() {
    echo -e "\e[33m[WARNING]\e[0m $1"
}

log_error() {
    echo -e "\e[31m[ERROR]\e[0m $1" >&2
}

# --- Base Verification ---
if ! command -v pacman &> /dev/null; then
    log_error "This script requires 'pacman' package manager (Arch Linux / CachyOS target). Exiting."
    exit 1
fi

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"

log_info "Starting dotfiles installation from: $DOTFILES_DIR"

# --- Package Installation ---
PACKAGES=(
    hyprland
    hyprpaper
    hyprlock
    waybar
    fuzzel
    yazi
    kitty
    grim
    slurp
    wl-clipboard
    pavucontrol
    ttf-jetbrains-mono
    otf-font-awesome
    papirus-icon-theme
    noto-fonts
)

# Check if any package is missing
MISSING_PACKAGES=()
for pkg in "${PACKAGES[@]}"; do
    if ! pacman -Qi "$pkg" &>/dev/null; then
        MISSING_PACKAGES+=("$pkg")
    fi
done

if [ ${#MISSING_PACKAGES[@]} -gt 0 ]; then
    log_info "Installing missing system packages via pacman: ${MISSING_PACKAGES[*]}"
    if [ -n "${DOTFILES_INSTALL_DRY_RUN:-}" ]; then
        log_info "[DRY-RUN] Would install missing system packages: ${MISSING_PACKAGES[*]}"
    elif sudo pacman -S --needed --noconfirm "${MISSING_PACKAGES[@]}"; then
        log_success "All missing packages installed successfully."
    else
        log_error "Failed to install some packages. Please install them manually."
        exit 1
    fi
else
    log_success "All core packages are already installed."
fi

# --- Create Symlinks Helper ---
safe_symlink() {
    local source_dir="$1"
    local target_dir="$2"

    # Resolve paths to absolute
    local abs_source="$DOTFILES_DIR/$source_dir"
    
    # Ensure source exists
    if [ ! -d "$abs_source" ] && [ ! -f "$abs_source" ]; then
        log_error "Source path $abs_source does not exist. Skipping."
        return 1
    fi

    # Ensure target parent directory exists
    mkdir -p "$(dirname "$target_dir")"

    if [ -e "$target_dir" ] || [ -L "$target_dir" ]; then
        # Check if it already points to the correct location
        if [ -L "$target_dir" ] && [ "$(readlink -f "$target_dir")" = "$abs_source" ]; then
            log_info "Symlink for $source_dir already correctly configured. Skipping."
            return 0
        fi

        # Backup existing file/directory/symlink
        local backup_path="${target_dir}.bak_${TIMESTAMP}"
        log_warn "Existing path found at $target_dir. Creating backup at $backup_path"
        if [ -z "${DOTFILES_INSTALL_DRY_RUN:-}" ]; then
            mv "$target_dir" "$backup_path"
        fi
    fi

    # Create the symlink
    if [ -n "${DOTFILES_INSTALL_DRY_RUN:-}" ]; then
        log_info "[DRY-RUN] Would create symlink: $source_dir -> $target_dir"
    else
        ln -sf "$abs_source" "$target_dir"
        log_success "Symlinked $source_dir -> $target_dir"
    fi
}

# --- Perform Symlinking ---
log_info "Creating configuration symlinks..."

safe_symlink "hypr" "$XDG_CONFIG_HOME/hypr"
safe_symlink "waybar" "$XDG_CONFIG_HOME/waybar"
safe_symlink "fuzzel" "$XDG_CONFIG_HOME/fuzzel"
safe_symlink "yazi" "$XDG_CONFIG_HOME/yazi"

# --- Executable Permissions ---
log_info "Setting executable permissions on scripts..."
if [ -f "$DOTFILES_DIR/scripts/wallpaper.sh" ]; then
    if [ -n "${DOTFILES_INSTALL_DRY_RUN:-}" ]; then
        log_info "[DRY-RUN] Would set executable permission on scripts/wallpaper.sh"
    else
        chmod +x "$DOTFILES_DIR/scripts/wallpaper.sh"
        log_success "scripts/wallpaper.sh is now executable."
    fi
fi

# --- Final Check ---
log_success "Dotfiles installation complete!"
log_info "You can now run 'hyprland' to start the session."
log_info "To set your wallpaper: $DOTFILES_DIR/scripts/wallpaper.sh $DOTFILES_DIR/assets/wallpaper.jpg"
