# QN37x Wayland/Hyprland Dotfiles OS

A premium, cohesive, and production-ready Hyprland-based desktop configuration environment. Designed strictly around the **QN37x design system** (`DESIGN.md`) with an Editorial Light/Dark aesthetic, custom typography accents (`af` sans-serif & `ppmondwest` serif), and full keyboard-driven ergonomic workflows.

![QN37x Style System Preview](assets/wallpaper.jpg)

---

## Features

- **Compositor (Hyprland):** Transpiled native `hyprland.conf` from modular Lua configurations (`hypr/*.lua`). Workspaces are strictly capped at 5 (no overflow), smooth bezier transitions, floating layer rules, and Vim-style navigation.
- **Notification Daemon (SwayNC):** Floating layer-shell notification popups and control center (`SUPER + n`) styled strictly to `DESIGN.md` with glassmorphic cards, action buttons, MPRIS, and DND controls without altering WM tiling.
- **Status Bar (Waybar):** Clean, descriptive bar displaying active workspaces (1-5), window titles, system tray, audio volume, network, and battery status.
- **Launcher & Clipboard (Fuzzel + Cliphist):** Fast, minimal application launcher (`SUPER + Space`) and clipboard history manager (`SUPER + v`) styled using primary tokens (Signal Blue `#41a1cf` and Cerulean `#0081c0`).
- **File Manager (Yazi):** Cohesive console file explorer with image preview support and vim-like keybindings (`h/j/k/l`).
- **Editor (Neovim):** Custom `qn37x` colorscheme matching `DESIGN.md` with dynamic light (Parchment `#fefffc`) and dark (Dusk `#1f1f29`) background syncing.
- **Wallpaper (Hyprpaper):** High-definition digital art background, reloadable dynamically using a helper shell script.
- **Screenshots (grim + slurp):** Multi-region or full-screen capture keybindings integrated seamlessly.

---

## Repository Structure

```text
dotfiles/
├── assets/
│   └── wallpaper.jpg          # Custom QN37x 4K wallpaper
├── fuzzel/
│   ├── fuzzel.ini             # Application launcher configuration
│   └── colors.ini             # Dynamic color tokens
├── hypr/
│   ├── hyprland.lua           # Main compositor configuration (Lua format)
│   ├── keybinds.lua           # Custom Vim-style keybindings (Lua format)
│   ├── monitors.lua           # Display configuration (Lua format)
│   ├── autostart.lua          # Startup service calls (Lua format)
│   ├── rules.lua              # Window & layer-shell rules (Lua format)
│   ├── animations.lua         # Transition and bezier settings (Lua format)
│   ├── colors.lua             # Border color tokens (Lua format)
│   ├── hyprpaper.conf         # Wallpaper settings
│   └── hyprland.conf          # Transpiled native Hyprland configuration
├── scripts/
│   ├── build_hypr_config.py   # Lua -> Conf transpiler script
│   ├── toggle_theme.py        # Centralized design token engine & hot-reload
│   ├── toggle_theme.sh        # Shell wrapper for theme toggling
│   ├── cliphist-fuzzel.sh     # Fuzzel clipboard picker wrapper
│   └── wallpaper.sh           # Hot-reload wallpaper management script
├── swaync/
│   ├── config.json            # SwayNC widgets and behavior settings
│   └── style.css              # SwayNC glassmorphic stylesheet matching DESIGN.md
├── waybar/
│   ├── config.jsonc           # Status bar module layout
│   ├── style.css              # Waybar styling (QN37x colors & typography)
│   └── colors.css             # Dynamic CSS color tokens
├── yazi/
│   ├── yazi.toml              # Console file manager layout/previews
│   ├── keymap.toml            # Vim-style navigation binds
│   └── theme.toml             # Syntax and interface colors matching DESIGN.md
├── dot_config/
│   ├── kitty/                 # Kitty terminal config
│   ├── lazydocker/            # Lazydocker TUI config
│   ├── lazygit/               # Lazygit TUI config
│   └── nvim/                  # Neovim config (colors/qn37x.lua, init.lua)
├── tests/
│   └── test_qn37x_refactor.py # Pytest QA test suite
├── AGENTS.md                  # Scope rules for multi-agent development
├── DESIGN.md                  # Single source of truth for design tokens
└── install.sh                 # Zero-dependency idempotent installation script
```

---

## Requirements

The configuration is tuned for **Arch Linux / CachyOS** environments. The core packages managed automatically by `install.sh`:
- `hyprland`, `hyprpaper`, `hyprlock`
- `swaync` (Sway Notification Center)
- `waybar`
- `fuzzel`
- `yazi`
- `kitty` (Default GPU-accelerated terminal)
- `grim` & `slurp` (Screenshots)
- `wl-clipboard` & `cliphist` (Clipboard manager)
- `pavucontrol` (Volume details)
- `ttf-jetbrains-mono`, `otf-font-awesome`, `noto-fonts`
- `zsh`

---

## Installation

### One-line Setup

Clone this repository and run the idempotent installation script:

```bash
git clone https://github.com/qn37x/dotfiles.git && cd dotfiles && ./install.sh
```

> [!IMPORTANT]
> The script is safe to re-run. If it detects pre-existing configurations under `~/.config/`, it automatically backs them up to `<folder>.bak_<timestamp>` before establishing symbolic links and running the Hyprland transpiler.

---

## Complete Keybindings Reference Table

### Application Launchers
| Keybinding | Function / Command |
|---|---|
| `SUPER + Return` | Launch Kitty terminal emulator |
| `SUPER + Space` | Launch Fuzzel application launcher |
| `SUPER + d` | Launch Fuzzel application launcher (alternative) |
| `SUPER + n` | Toggle SwayNC notification center panel (`swaync-client -t -sw`) |
| `SUPER + v` | Open Clipboard History picker via Fuzzel (`cliphist-fuzzel.sh`) |
| `SUPER + s` | Launch Scratchpad terminal (`kitty --class scratchpad`) |
| `SUPER + e` | Open Yazi file manager inside Kitty (`kitty -e yazi`) |
| `SUPER + w` | Open Google Chrome web browser |
| `SUPER + a` | Open Antigravity CLI (`kitty -e agy`) |

### Window Control
| Keybinding | Function / Command |
|---|---|
| `SUPER + q` | Close / kill active window |
| `SUPER + c` | Close / kill active window (alternative) |
| `SUPER + f` | Toggle Fullscreen mode |
| `SUPER + t` | Toggle Floating / Tiling state |
| `SUPER + m` | Exit session / Hyprland (`hyprshutdown` or exit) |
| `SUPER + p` | Pin active window (sticky across workspaces) |

### Focus Navigation (Vim Hjkl)
| Keybinding | Function / Command |
|---|---|
| `SUPER + h` | Move focus to left window |
| `SUPER + j` | Move focus to bottom window |
| `SUPER + k` | Move focus to top window |
| `SUPER + l` | Move focus to right window |
| `SUPER + Tab` | Cycle focus to next window |
| `SUPER + Shift + Tab` | Cycle focus to previous window |

### Window Movement (Vim Shift Hjkl)
| Keybinding | Function / Command |
|---|---|
| `SUPER + Shift + h` | Move active window left |
| `SUPER + Shift + j` | Move active window down |
| `SUPER + Shift + k` | Move active window up |
| `SUPER + Shift + l` | Move active window right |

### Workspace Navigation (Workspaces 1–5 Strict Cap)
| Keybinding | Function / Command |
|---|---|
| `SUPER + 1` | Switch focus to Workspace 1 |
| `SUPER + 2` | Switch focus to Workspace 2 |
| `SUPER + 3` | Switch focus to Workspace 3 |
| `SUPER + 4` | Switch focus to Workspace 4 |
| `SUPER + 5` | Switch focus to Workspace 5 |
| `SUPER + ` ` (Grave) | Toggle between current and last active workspace |

### Move Window to Workspace (Workspaces 1–5 Strict Cap)
| Keybinding | Function / Command |
|---|---|
| `SUPER + Shift + 1` | Move focused window to Workspace 1 |
| `SUPER + Shift + 2` | Move focused window to Workspace 2 |
| `SUPER + Shift + 3` | Move focused window to Workspace 3 |
| `SUPER + Shift + 4` | Move focused window to Workspace 4 |
| `SUPER + Shift + 5` | Move focused window to Workspace 5 |

### Special Workspace / Scratchpad
| Keybinding | Function / Command |
|---|---|
| `SUPER + -` (Minus) | Toggle special workspace (Scratchpad) |
| `SUPER + Shift + -` (Minus) | Move focused window to special workspace |

### Window Resizing Submap (`SUPER + r`)
| Keybinding | Function / Command |
|---|---|
| `SUPER + r` | Enter Window Resize Mode |
| `h` | Shrink window width (-10px) |
| `l` | Expand window width (+10px) |
| `k` | Shrink window height (-10px) |
| `j` | Expand window height (+10px) |
| `Escape` or `Return` | Exit Resize Mode |

### Screenshots & Media
| Keybinding | Function / Command |
|---|---|
| `Print` | Fullscreen screenshot saved to `~/Pictures/YYYYMMDD_HHMMSS_screenshot.png` |
| `SUPER + Print` | Region screenshot to clipboard (`grim -g "$(slurp)" - \| wl-copy`) |
| `SUPER + Shift + s` | Region screenshot to clipboard (`grim -g "$(slurp)" - \| wl-copy`) |

### System & Theme Controls
| Keybinding | Function / Command |
|---|---|
| `SUPER + Escape` | Lock desktop using `hyprlock` |
| `SUPER + Shift + q` | Terminate session and exit Hyprland |
| `SUPER + Shift + t` | Toggle Theme (Light Parchment <-> Dark Dusk) |

### Mouse Controls
| Keybinding | Function / Command |
|---|---|
| `SUPER + Mouse Left Click (Drag)` | Move window |
| `SUPER + Mouse Right Click (Drag)` | Resize window |

---

## Yazi File Manager Navigation (`yazi/keymap.toml`)

| Key | Function |
|---|---|
| `h` | Leave current directory (go to parent directory) |
| `j` | Move selection cursor down |
| `k` | Move selection cursor up |
| `l` | Enter child directory or open file |

---

## Customizing Design System & Themes (`DESIGN.md`)

All design tokens (colors, typography, radii, spacing) are defined in `DESIGN.md`.

To switch theme mode manually or update colors, run:
```bash
~/.local/bin/toggle_theme.sh
```
or
```bash
python3 scripts/toggle_theme.py
```

This dynamically updates `DESIGN.md`, `hypr/colors.lua`, `waybar/colors.css`, `fuzzel/colors.ini`, `swaync/style.css`, and `dot_config/nvim/colors/qn37x.lua`, triggering hot-reloads across all running daemons instantly.
