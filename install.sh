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
    swaync
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
    log_info "Missing system packages: ${MISSING_PACKAGES[*]}"
    if [ -n "${DOTFILES_INSTALL_DRY_RUN:-}" ]; then
        log_info "[DRY-RUN] Would install missing system packages: ${MISSING_PACKAGES[*]}"
    elif sudo -n pacman -S --needed --noconfirm "${MISSING_PACKAGES[@]}" 2>/dev/null; then
        log_success "All missing packages installed successfully."
    else
        log_warn "Could not install packages automatically without password. Run 'sudo pacman -S --needed ${MISSING_PACKAGES[*]}' manually if needed."
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
safe_symlink "swaync" "$XDG_CONFIG_HOME/swaync"
safe_symlink "waybar" "$XDG_CONFIG_HOME/waybar"
safe_symlink "fuzzel" "$XDG_CONFIG_HOME/fuzzel"
safe_symlink "yazi" "$XDG_CONFIG_HOME/yazi"
safe_symlink "dot_config/kitty" "$XDG_CONFIG_HOME/kitty"
safe_symlink "dot_config/lazydocker" "$XDG_CONFIG_HOME/lazydocker"
safe_symlink "dot_config/lazygit" "$XDG_CONFIG_HOME/lazygit"
safe_symlink "dot_config/nvim" "$XDG_CONFIG_HOME/nvim"
safe_symlink "dot_config/systemd" "$XDG_CONFIG_HOME/systemd"

safe_symlink "scripts/cliphist-fuzzel.sh" "$HOME/.local/bin/cliphist-fuzzel.sh"
safe_symlink "scripts/manage-llama.sh" "$HOME/.local/bin/manage-llama.sh"
safe_symlink "scripts/toggle_theme.sh" "$HOME/.local/bin/toggle_theme.sh"

# --- Executable Permissions & Transpilation ---
log_info "Setting executable permissions on scripts..."
for script in "scripts/wallpaper.sh" "scripts/cliphist-fuzzel.sh" "scripts/manage-llama.sh" "scripts/toggle_theme.sh" "scripts/toggle_theme.py" "scripts/build_hypr_config.py"; do
    if [ -f "$DOTFILES_DIR/$script" ]; then
        if [ -n "${DOTFILES_INSTALL_DRY_RUN:-}" ]; then
            log_info "[DRY-RUN] Would set executable permission on $script"
        else
            chmod +x "$DOTFILES_DIR/$script"
            log_success "$script is now executable."
        fi
    fi
done

log_info "Transpiling Hyprland configuration..."
if [ -z "${DOTFILES_INSTALL_DRY_RUN:-}" ]; then
    python3 "$DOTFILES_DIR/scripts/build_hypr_config.py"
else
    log_info "[DRY-RUN] Would run python3 $DOTFILES_DIR/scripts/build_hypr_config.py"
fi

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
ZSHRC_CONTENT='# ==============================================================================
# QN37x DESIGN SYSTEM - PROFESSIONAL NATIVE ZSH CONFIGURATION
# Pure ZSH (Zero External Dependencies)
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. Environment & History Options
# ------------------------------------------------------------------------------
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# History File Settings
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

setopt SHARE_HISTORY          # Share command history instantly across all open shell windows
setopt HIST_IGNORE_ALL_DUPS   # Automatically purge older duplicates when a new line is saved
setopt HIST_REDUCE_BLANKS     # Remove unnecessary blanks from history entries
setopt HIST_IGNORE_SPACE      # Don'\''t record commands that begin with a leading space
setopt HIST_SAVE_NO_DUPS      # Do not write duplicate commands to history file
setopt HIST_VERIFY            # Show history expansion result before executing

# Navigation & Directory Stack
setopt AUTO_CD                # Change directory by typing path alone (e.g. ~/Projects)
setopt AUTO_PUSHD             # Push old directory onto directory stack on every cd
setopt PUSHD_IGNORE_DUPS      # Avoid duplicate entries in directory stack
setopt PUSHD_SILENT           # Suppress printing directory stack on cd

# Advanced Shell Options
setopt CORRECT                # Enable command auto-correction prompts for mistyped commands
setopt EXTENDED_GLOB          # Enable extended pattern matching syntax (#,~,^)
setopt GLOB_DOTS              # Include hidden files in glob matches without typing .*
setopt INTERACTIVE_COMMENTS   # Allow inline # comments in interactive terminal session
setopt NO_BEEP                # Disable audible bell/beep on command errors or completions
setopt COMPLETE_IN_WORD       # Complete from cursor position inside words
setopt ALWAYS_TO_END          # Move cursor to end of word after completion

# ------------------------------------------------------------------------------
# 2. Native Advanced Completion System (Compsys + Complist)
# ------------------------------------------------------------------------------
zmodload zsh/complist
autoload -Uz compinit

# Fast compinit initialization (only rebuild dump file once per day)
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.m+1) ]]; then
  compinit -i
else
  compinit -C
fi

# Completion Cache
zstyle '\'':completion:*'\'' use-cache on
zstyle '\'':completion:*'\'' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"

# Visual Menu Selection Navigation
zstyle '\'':completion:*'\'' menu select

# Case-Insensitive, Partial-Word, and Substring Matching
zstyle '\'':completion:*'\'' matcher-list \
  '\''m:{a-zA-Z}={A-Za-z}'\'' \
  '\''r:|[._-]=* r:|=*'\'' \
  '\''l:|[._-]=* r:|=*'\''

# Category Grouping and Formatted Headers
zstyle '\'':completion:*'\'' group-name '\'''\''
zstyle '\'':completion:*:descriptions'\'' format '\''%F{#41a1cf}── %d ──%f'\''
zstyle '\'':completion:*:messages'\'' format '\''%F{#ff9e64}%d%f'\''
zstyle '\'':completion:*:warnings'\'' format '\''%F{#f7768e}✘ No matches found%f'\''
zstyle '\'':completion:*:corrections'\'' format '\''%F{#e0af68}%d (errors: %e)%f'\''

# Colorize Completions using System LS_COLORS
zstyle '\'':completion:*:default'\'' list-colors ${(s.:.)LS_COLORS}

# Process Completion Styling
zstyle '\'':completion:*:processes'\'' command '\''ps -u $USER -o pid,user,comm -w -w'\''
zstyle '\'':completion:*:*:kill:*:processes'\'' list-colors '\''=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'\''

# Directory completion priority
zstyle '\'':completion:*:cd:*'\'' tag-order local-directories directory-stack path-directories

# Keybindings inside Menu Selection (Supports Vim keys h,j,k,l and Shift-Tab)
bindkey -M menuselect '\''h'\'' backward-char
bindkey -M menuselect '\''k'\'' up-line-or-history
bindkey -M menuselect '\''l'\'' forward-char
bindkey -M menuselect '\''j'\'' down-line-or-history
bindkey -M menuselect '\''^[[Z'\'' reverse-menu-complete # Shift-Tab

# ------------------------------------------------------------------------------
# 3. Native History Search & Keybindings (Up/Down Arrow Substring Search)
# ------------------------------------------------------------------------------
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# Typing prefix (e.g. "git ") and pressing Up/Down arrow cycles matching history
bindkey '\''^[[A'\'' up-line-or-beginning-search
bindkey '\''^[OA'\'' up-line-or-beginning-search
bindkey '\''^[[B'\'' down-line-or-beginning-search
bindkey '\''^[OB'\'' down-line-or-beginning-search

# Standard Navigation Keybindings
bindkey '\''^[[1;5C'\'' forward-word          # Ctrl + Right Arrow
bindkey '\''^[[1;5D'\'' backward-word         # Ctrl + Left Arrow
bindkey '\''^[[H'\'' beginning-of-line        # Home
bindkey '\''^[[F'\'' end-of-line              # End
bindkey '\''^[[3~'\'' delete-char             # Delete

# ------------------------------------------------------------------------------
# 4. Professional Design System Prompt & VCS Integration
# ------------------------------------------------------------------------------
setopt PROMPT_SUBST
autoload -Uz vcs_info

zstyle '\'':vcs_info:*'\'' enable git
zstyle '\'':vcs_info:git:*'\'' formats '\''%F{#41a1cf}(%b)%f '\''
zstyle '\'':vcs_info:git:*'\'' actionformats '\''%F{#ff9e64}(%b|%a)%f '\''

# Command execution duration tracker
preexec() {
  _cmd_start_time=$SECONDS
}

precmd() {
  vcs_info
  if [[ -n $_cmd_start_time ]]; then
    local _elapsed=$(( SECONDS - _cmd_start_time ))
    unset _cmd_start_time
    if (( _elapsed >= 3 )); then
      _cmd_duration="%F{#e0af68}⏱ ${_elapsed}s %f"
    else
      _cmd_duration=""
    fi
  else
    _cmd_duration=""
  fi
}

# Prompt structure
PROMPT='\''${_cmd_duration}%F{#0081c0}%~%f ${vcs_info_msg_0_}%(?.%F{#41a1cf}❯%f.%F{#f7768e}❯%f) '\''

# ------------------------------------------------------------------------------
# 5. Native Shell Utilities & Professional Aliases
# ------------------------------------------------------------------------------
alias ls='\''ls --color=auto'\''
alias ll='\''ls -la'\''
alias la='\''ls -A'\''
alias l='\''ls -CF'\''
alias grep='\''grep --color=auto'\''
alias diff='\''diff --color=auto'\''

alias ..='\''cd ..'\''
alias ...='\''cd ../..'\''
alias ....='\''cd ../../..'\''
alias d='\''dirs -v'\''
for i in {1..9}; do alias "$i"="cd +$i"; done

alias -g G='\''| grep'\''
alias -g L='\''| less'\''
alias -g H='\''| head'\''
alias -g T='\''| tail'\''

mcd() {
  mkdir -p "$1" && cd "$1"
}

extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2) tar xjf "$1" ;;
      *.tar.gz)  tar xzf "$1" ;;
      *.bz2)     bunzip2 "$1" ;;
      *.rar)     unrar x "$1" ;;
      *.gz)      gunzip "$1" ;;
      *.tar)     tar xf "$1" ;;
      *.tbz2)    tar xjf "$1" ;;
      *.tgz)     tar xzf "$1" ;;
      *.zip)     unzip "$1" ;;
      *.Z)       uncompress "$1" ;;
      *.7z)      7z x "$1" ;;
      *)         echo "extract: '\''$1'\'' format unsupported" ;;
    esac
  else
    echo "extract: '\''$1'\'' is not a valid file"
  fi
}

calc() {
  zcalc -e "$*"
}

# ------------------------------------------------------------------------------
# 6. Plugins & External Integrations
# ------------------------------------------------------------------------------
if [ -f "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
elif [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if [ -f "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
elif [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
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
        if sudo -n cp "$DOTFILES_DIR/assets/wallpaper.jpg" "/usr/share/sddm/themes/maldives/background.jpg" 2>/dev/null; then
            if [ -f "$DOTFILES_DIR/root/usr/share/sddm/themes/maldives/Main.qml" ]; then
                sudo -n cp "$DOTFILES_DIR/root/usr/share/sddm/themes/maldives/Main.qml" "/usr/share/sddm/themes/maldives/Main.qml" 2>/dev/null || true
            fi
            if [ -f "$DOTFILES_DIR/root/usr/share/sddm/themes/maldives/theme.conf" ]; then
                sudo -n cp "$DOTFILES_DIR/root/usr/share/sddm/themes/maldives/theme.conf" "/usr/share/sddm/themes/maldives/theme.conf" 2>/dev/null || true
            fi
            log_success "SDDM Maldives theme updated."
        else
            log_warn "Could not update SDDM theme automatically without sudo password. Run manually if needed."
        fi
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
        if sudo -n mkdir -p "$(dirname "$SDDM_CONFIG_DST")" 2>/dev/null && sudo -n cp "$SDDM_CONFIG_SRC" "$SDDM_CONFIG_DST" 2>/dev/null; then
            log_success "SDDM configuration written to $SDDM_CONFIG_DST."
        else
            log_warn "Could not write SDDM config automatically without sudo password. Run manually if needed."
        fi
    else
        log_info "[DRY-RUN] Would copy SDDM configuration to $SDDM_CONFIG_DST"
    fi
fi


# --- Final Check ---
log_success "Dotfiles installation complete!"
log_info "You can now run 'hyprland' to start the session."
log_info "To set your wallpaper: $DOTFILES_DIR/scripts/wallpaper.sh $DOTFILES_DIR/assets/wallpaper.jpg"
