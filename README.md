# DeepMind-Inspired Wayland/Hyprland Dotfiles

A premium, cohesive, and production-ready Hyprland-based desktop configuration environment. Designed strictly around the **DeepMind-inspired design system** with a flat, high-key, dark-neutral aesthetic featuring vibrant blue/purple accents and sleek rounded shapes.

![DeepMind Style System Preview](assets/wallpaper.jpg)

## Features

- **Compositor (Hyprland):** Custom 5-workspace limitation (no overflow), smooth bezier transitions, layout rules, and Vim-style focus controls.
- **Status Bar (Waybar):** Clean, descriptive bar displaying active workspaces (1-5), window titles, system tray, audio volume, network, and battery status.
- **Launcher (Fuzzel):** Fast, minimal application launcher themed strictly using the primary blue accent and rounded corners.
- **File Manager (Yazi):** Cohesive console file explorer with image preview support and vim-like keybindings.
- **Wallpaper (Hyprpaper):** High-definition digital art background, reloadable dynamically using a helper shell script.
- **Screenshots (grim + slurp):** Multi-region or full-screen capture keybindings integrated seamlessly.

---

## Repository Structure

```text
dotfiles/
├── assets/
│   └── wallpaper.jpg       # Custom DeepMind-inspired 4K wallpaper
├── fuzzel/
│   └── fuzzel.ini          # Application launcher configuration
├── hypr/
│   ├── hyprland.lua        # Main compositor configuration (Lua format)
│   ├── keybinds.lua        # Custom Vim-style keybindings (Lua format)
│   ├── monitors.lua        # Display configuration (Lua format)
│   ├── autostart.lua       # Startup service calls (Lua format)
│   ├── rules.lua           # Window-specific routing rules (Lua format)
│   ├── animations.lua      # Transition and bezier settings (Lua format)
│   └── hyprpaper.conf      # Wallpaper settings (Hyprpaper format)
├── scripts/
│   └── wallpaper.sh        # Hot-reload wallpaper management script
├── waybar/
│   ├── config.jsonc        # Status bar module layout
│   └── style.css           # Waybar styling (DeepMind-colors & typography)
├── yazi/
│   ├── yazi.toml           # Console file manager layout/previews
│   ├── keymap.toml         # Vim-style navigation binds
│   └── theme.toml          # Syntax and interface colors matching DESIGN.md
├── AGENTS.md               # Scope rules for multi-agent development
├── DESIGN.md               # Design tokens (colors, typography, shapes)
└── install.sh              # Idempotent installation script
```

---

## Requirements

The configuration is tuned for **Arch Linux / CachyOS** environments. The following core utilities are managed automatically by the installation script:
- `hyprland`
- `waybar`
- `fuzzel`
- `hyprpaper`
- `yazi`
- `kitty` (Default GPU-accelerated terminal)
- `grim` & `slurp` (Screenshots)
- `wl-clipboard`
- `pavucontrol` (Volume details)
- `ttf-jetbrains-mono` & `otf-font-awesome`

---

## Installation

### One-line Setup

Clone this repository and run the idempotent installation script:

```bash
git clone https://github.com/qn37x/dotfiles.git && cd dotfiles && ./install.sh
```

> [!IMPORTANT]
> The script is safe to re-run. If it detects any pre-existing configurations under `~/.config/`, it will automatically back them up to `<folder>.bak_<timestamp>` before establishing the correct symbolic links.

---

## Keybindings (SUPER Mod Key)

### Navigation & Focus
- `SUPER` + `h` / `j` / `k` / `l` : Focus left, down, up, right (Vim style).
- `SUPER` + `Tab` / `SUPER` + `Shift` + `Tab` : Cycle forward/backward through open windows.
- `SUPER` + `[1-5]` : Switch workspace (limited to 1 through 5).
- `SUPER` + `Shift` + `[1-5]` : Move focused window to workspace.
- `SUPER` + `` ` `` (Backtick) : Toggle between current and previous active workspace.

### Window Operations
- `SUPER` + `q` / `c` : Close/kill active window.
- `SUPER` + `f` : Toggle fullscreen state.
- `SUPER` + `v` : Toggle floating layout.
- `SUPER` + `s` : Toggle window split direction (dwindle layout).

### Application Launches
- `SUPER` + `Return` : Open Terminal (`kitty`).
- `SUPER` + `d` : Open Application Launcher (`fuzzel`).
- `SUPER` + `e` : Open Console File Manager (`yazi` in `kitty`).

### Utilities & Session
- `Print` : Full screen capture (Grim/Slurp to file).
- `SUPER` + `Print` / `SUPER` + `Shift` + `s` : Capture regional screenshot to clipboard.
- `SUPER` + `Escape` : Lock desktop using `hyprlock`.
- `SUPER` + `Shift` + `q` : Log out / exit Hyprland.

### Window Resizing (Submap)
1. Press `SUPER` + `r` to enter Resize Mode.
2. Use `h` / `j` / `k` / `l` to shrink or expand the active window.
3. Press `Escape` or `Enter` to return to Normal Mode.

---

## Customizing Theming (DESIGN.md)

All styling rules, spacing values, borders, and colors are defined in `DESIGN.md`. 
To modify the accent colors, modify the Hex values under the `colors` YAML section of `DESIGN.md`:

```yaml
colors:
  ink: "#0B0B0C"        # Main dark-theme background
  blue: "#0053D6"       # Primary focus & accent color
  purple: "#A261FF"     # Secondary accent
```

If you alter these colors, rebuild/restart the systems (e.g. `hyprctl reload` or restarting Waybar) to propagate changes.
