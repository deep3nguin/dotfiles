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
    zsh
    cachyos-themes-sddm
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
safe_symlink "dot_config/kitty" "$XDG_CONFIG_HOME/kitty"
safe_symlink "dot_config/lazydocker" "$XDG_CONFIG_HOME/lazydocker"
safe_symlink "dot_config/lazygit" "$XDG_CONFIG_HOME/lazygit"
safe_symlink "dot_config/mako" "$XDG_CONFIG_HOME/mako"
safe_symlink "dot_config/nvim" "$XDG_CONFIG_HOME/nvim"
safe_symlink "dot_config/systemd" "$XDG_CONFIG_HOME/systemd"

safe_symlink "scripts/cliphist-fuzzel.sh" "$HOME/.local/bin/cliphist-fuzzel.sh"
safe_symlink "scripts/manage-llama.sh" "$HOME/.local/bin/manage-llama.sh"
safe_symlink "scripts/toggle_theme.sh" "$HOME/.local/bin/toggle_theme.sh"

# --- Executable Permissions ---
log_info "Setting executable permissions on scripts..."
for script in "scripts/wallpaper.sh" "scripts/cliphist-fuzzel.sh" "scripts/manage-llama.sh" "scripts/toggle_theme.sh" "scripts/toggle_theme.py"; do
    if [ -f "$DOTFILES_DIR/$script" ]; then
        if [ -n "${DOTFILES_INSTALL_DRY_RUN:-}" ]; then
            log_info "[DRY-RUN] Would set executable permission on $script"
        else
            chmod +x "$DOTFILES_DIR/$script"
            log_success "$script is now executable."
        fi
    fi
done

# --- ZSH Configuration ---
log_info "Configuring ZSH..."

# Create directory for plugins
mkdir -p "$HOME/.zsh"

# Clone zsh-autosuggestions
if [ ! -d "$HOME/.zsh/zsh-autosuggestions" ]; then
    log_info "Cloning zsh-autosuggestions..."
    if [ -z "${DOTFILES_INSTALL_DRY_RUN:-}" ]; then
        git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions "$HOME/.zsh/zsh-autosuggestions"
    else
        log_info "[DRY-RUN] Would clone zsh-autosuggestions into ~/.zsh/"
    fi
else
    log_success "zsh-autosuggestions is already cloned."
fi

# Clone zsh-syntax-highlighting
if [ ! -d "$HOME/.zsh/zsh-syntax-highlighting" ]; then
    log_info "Cloning zsh-syntax-highlighting..."
    if [ -z "${DOTFILES_INSTALL_DRY_RUN:-}" ]; then
        git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting "$HOME/.zsh/zsh-syntax-highlighting"
    else
        log_info "[DRY-RUN] Would clone zsh-syntax-highlighting into ~/.zsh/"
    fi
else
    log_success "zsh-syntax-highlighting is already cloned."
fi

# Write .zshrc
ZSHRC_PATH="$HOME/.zshrc"
ZSHRC_CONTENT='# ==========================================
# CachyOS Base / Fallback Config
# ==========================================
if [ -f /usr/share/cachyos-zsh-config/cachyos-config.zsh ]; then
    source /usr/share/cachyos-zsh-config/cachyos-config.zsh 2>/dev/null
else
    # Fallback to native config + cloned plugins
    setopt autocd
    HISTFILE=~/.zsh_history
    HISTSIZE=10000
    SAVEHIST=10000
    setopt SHARE_HISTORY
    setopt HIST_IGNORE_ALL_DUPS
    setopt HIST_REDUCE_BLANKS
    autoload -Uz compinit && compinit
    zstyle '\'':completion:*'\'' menu select
    zstyle '\'':completion:*'\'' matcher-list '\''m:{a-zA-Z}={A-Za-z}'\'' '\''r:|[._-]=* r:|=*'\'' '\''l:|=* r:|=*'\''

    if [ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
        source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
    fi
    if [ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
        source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    fi
fi

# ==========================================
# QN37x DESIGN SYSTEM ZSH THEME
# ==========================================
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle '\'':vcs_info:git:*'\'' formats '\''%F{#41a1cf}(%b)%f '\''
PROMPT='\''%F{#0081c0}%~%f ${vcs_info_msg_0_}%F{#41a1cf}❯%f '\''
'

if [ -f "$ZSHRC_PATH" ]; then
    if [ -L "$ZSHRC_PATH" ]; then
        log_warn "Existing symlink found at $ZSHRC_PATH. Removing it to write new config."
        if [ -z "${DOTFILES_INSTALL_DRY_RUN:-}" ]; then
            rm "$ZSHRC_PATH"
        fi
    else
        backup_zshrc="${ZSHRC_PATH}.bak_${TIMESTAMP}"
        log_warn "Existing file found at $ZSHRC_PATH. Backup created at $backup_zshrc"
        if [ -z "${DOTFILES_INSTALL_DRY_RUN:-}" ]; then
            mv "$ZSHRC_PATH" "$backup_zshrc"
        fi
    fi
fi

log_info "Writing .zshrc file to ~/.zshrc..."
if [ -z "${DOTFILES_INSTALL_DRY_RUN:-}" ]; then
    echo "$ZSHRC_CONTENT" > "$ZSHRC_PATH"
    log_success ".zshrc successfully written."
else
    log_info "[DRY-RUN] Would write .zshrc content to $ZSHRC_PATH"
fi

# Change default shell to zsh
if [ "${SHELL##*/}" != "zsh" ]; then
    log_info "Changing user shell to zsh..."
    if [ -z "${DOTFILES_INSTALL_DRY_RUN:-}" ]; then
        ZSH_BIN="$(which zsh 2>/dev/null || command -v zsh)"
        if [ -n "$ZSH_BIN" ]; then
            chsh -s "$ZSH_BIN"
            log_success "Shell changed to $ZSH_BIN. Please log out and log back in for changes to take effect."
        else
            log_error "zsh binary not found. Cannot change default shell."
        fi
    else
        log_info "[DRY-RUN] Would run chsh -s \$(which zsh)"
    fi
else
    log_success "Default shell is already zsh."
fi

# --- SDDM Configuration ---
log_info "Configuring SDDM..."
if [ -d "/usr/share/sddm/themes/maldives" ]; then
    log_info "Applying wallpaper and custom layout to SDDM Maldives theme..."
    if [ -z "${DOTFILES_INSTALL_DRY_RUN:-}" ]; then
        sudo cp "$DOTFILES_DIR/assets/wallpaper.jpg" "/usr/share/sddm/themes/maldives/background.jpg"
        if [ -f "$DOTFILES_DIR/root/usr/share/sddm/themes/maldives/Main.qml" ]; then
            sudo cp "$DOTFILES_DIR/root/usr/share/sddm/themes/maldives/Main.qml" "/usr/share/sddm/themes/maldives/Main.qml"
        fi
        if [ -f "$DOTFILES_DIR/root/usr/share/sddm/themes/maldives/theme.conf" ]; then
            sudo cp "$DOTFILES_DIR/root/usr/share/sddm/themes/maldives/theme.conf" "/usr/share/sddm/themes/maldives/theme.conf"
        fi
        log_success "SDDM Maldives theme updated."
    else
        log_info "[DRY-RUN] Would copy assets/wallpaper.jpg to /usr/share/sddm/themes/maldives/background.jpg"
        log_info "[DRY-RUN] Would copy custom QML components to /usr/share/sddm/themes/maldives/"
    fi
else
    log_warn "SDDM Maldives theme not found. Skipping theme updates."
fi

# Copy SDDM config
SDDM_CONFIG_SRC="$DOTFILES_DIR/root/etc/sddm.conf.d/kde_settings.conf.tmpl"
SDDM_CONFIG_DST="/etc/sddm.conf.d/kde_settings.conf"
if [ -f "$SDDM_CONFIG_SRC" ]; then
    log_info "Writing SDDM configuration..."
    if [ -z "${DOTFILES_INSTALL_DRY_RUN:-}" ]; then
        sudo mkdir -p "$(dirname "$SDDM_CONFIG_DST")"
        sudo cp "$SDDM_CONFIG_SRC" "$SDDM_CONFIG_DST"
        log_success "SDDM configuration written to $SDDM_CONFIG_DST."
    else
        log_info "[DRY-RUN] Would copy SDDM configuration to $SDDM_CONFIG_DST"
    fi
fi

# --- Final Check ---
log_success "Dotfiles installation complete!"
log_info "You can now run 'hyprland' to start the session."
log_info "To set your wallpaper: $DOTFILES_DIR/scripts/wallpaper.sh $DOTFILES_DIR/assets/wallpaper.jpg"
