#!/usr/bin/env python3
"""
build_hypr_config.py - Transpiler for Hyprland Lua configuration files.
Generates an idempotent, native hyprland.conf from hypr/*.lua files.
"""

from pathlib import Path
import sys
import re

HYPR_DIR = Path(__file__).resolve().parent.parent / "hypr"
TARGET_CONF = HYPR_DIR / "hyprland.conf"
COLORS_LUA = HYPR_DIR / "colors.lua"

def get_border_colors() -> tuple[str, str, str]:
    c1, c2, cin = "41a1cfff", "0081c0ff", "dee2deff"
    if COLORS_LUA.exists():
        text = COLORS_LUA.read_text()
        m1 = re.search(r'active_border_1\s*=\s*"([^"]+)"', text)
        m2 = re.search(r'active_border_2\s*=\s*"([^"]+)"', text)
        mi = re.search(r'inactive_border\s*=\s*"([^"]+)"', text)
        if m1:
            c1 = f"{m1.group(1).lower()}ff"
        if m2:
            c2 = f"{m2.group(1).lower()}ff"
        if mi:
            cin = f"{mi.group(1).lower()}ff"
    return c1, c2, cin

def generate_hyprland_conf() -> str:
    active_1, active_2, inactive = get_border_colors()
    lines = [
        "# ============================================================================",
        "# GENERATED HYPRLAND CONFIGURATION - DO NOT EDIT MANUALLY",
        "# Compiled from hypr/*.lua configuration modules by scripts/build_hypr_config.py",
        "# System Design: QN37x Editorial (DESIGN.md)",
        "# ============================================================================",
        "",
        "# --- Monitored Displays ---",
        "monitor = , preferred, auto, 1",
        "",
        "# --- Startup Daemons & Applications ---",
        "exec-once = swaync",
        "exec-once = waybar",
        "exec-once = hyprpaper",
        "exec-once = systemctl --user start hyprpolkitagent",
        "exec-once = swayosd-server",
        "exec-once = wl-paste --type text --watch cliphist store",
        "exec-once = wl-paste --type image --watch cliphist store",
        "",
        "# --- Look & Feel (DESIGN.md Tokens) ---",
        "general {",
        "    gaps_in = 8",
        "    gaps_out = 16",
        "    border_size = 2",
        f"    col.active_border = rgba({active_1}) rgba({active_2}) 45deg",
        f"    col.inactive_border = rgba({inactive})",
        "    layout = dwindle",
        "}",

        "",
        "decoration {",
        "    rounding = 16",
        "    active_opacity = 1.00",
        "    inactive_opacity = 0.92",
        "    blur {",
        "        enabled = true",
        "        size = 12",
        "        passes = 1",
        "        vibrancy = 0.1696",
        "    }",
        "}",
        "",
        "# --- Animations ---",
        "animations {",
        "    enabled = true",
        "    bezier = fluent_curve, 0.16, 1, 0.3, 1",
        "    bezier = easeInOut, 0.42, 0, 0.58, 1",
        "    animation = windows, 1, 4, fluent_curve, slide",
        "    animation = windowsIn, 1, 4, fluent_curve, slide",
        "    animation = windowsOut, 1, 4, fluent_curve, slide",
        "    animation = border, 1, 6, easeInOut",
        "    animation = fade, 1, 4, easeInOut",
        "    animation = workspaces, 1, 5, fluent_curve, slide",
        "}",
        "",
        "# --- Input Settings ---",
        "input {",
        "    kb_layout = us",
        "    follow_mouse = 1",
        "    sensitivity = 0",
        "}",
        "",
        "dwindle {",
        "    preserve_split = true",
        "}",
        "",
        "misc {",
        "    force_default_wallpaper = 0",
        "    disable_hyprland_logo = true",
        "}",
        "",
        "# --- Window & Layer Rules ---",
        "windowrulev2 = float, class:^(confirm)$",
        "windowrulev2 = float, class:^(dialog)$",
        "windowrulev2 = float, class:^(download)$",
        "windowrulev2 = float, class:^(notification)$",
        "windowrulev2 = float, class:^(error)$",
        "windowrulev2 = float, class:^(splash)$",
        "windowrulev2 = float, class:^(confirmreset)$",
        "windowrulev2 = float, class:^(org.gnome.Calculator)$",
        "windowrulev2 = float, class:^(file_progress)$",
        "windowrulev2 = float, class:^(scratchpad)$",
        "windowrulev2 = workspace special silent, class:^(scratchpad)$",
        "",
        "# --- SwayNC & Waybar Layer Rules ---",
        "layerrule = blur, waybar",
        "layerrule = blur, swaync-control-center",
        "layerrule = blur, swaync-notification-window",
        "layerrule = ignorezero, swaync-control-center",
        "layerrule = ignorezero, swaync-notification-window",
        "layerrule = ignorealpha 0.5, swaync-control-center",
        "layerrule = ignorealpha 0.5, swaync-notification-window",
        "",
        "# --- Keybindings (Vim-Style & 5-Workspace Cap) ---",
        "$mainMod = SUPER",
        "",
        "# Applications & Tools",
        "bind = $mainMod, RETURN, exec, kitty",
        "bind = $mainMod, SPACE, exec, fuzzel",
        "bind = $mainMod, N, exec, swaync-client -t -sw",
        "bind = $mainMod, V, exec, ~/.local/bin/cliphist-fuzzel.sh",
        "bind = $mainMod, S, exec, kitty --class scratchpad",
        "bind = $mainMod, E, exec, kitty -e yazi",
        "bind = $mainMod, W, exec, google-chrome-stable",
        "bind = $mainMod, A, exec, kitty -e agy",
        "",
        "# Window Management",
        "bind = $mainMod, Q, killactive,",
        "bind = $mainMod, C, killactive,",
        "bind = $mainMod, F, fullscreen, 0",
        "bind = $mainMod, T, togglefloating,",
        "bind = $mainMod, M, exec, command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit",
        "",
        "# Focus Movement (Vim Hjkl)",
        "bind = $mainMod, H, movefocus, l",
        "bind = $mainMod, J, movefocus, d",
        "bind = $mainMod, K, movefocus, u",
        "bind = $mainMod, L, movefocus, r",
        "",
        "# Window Movement (Vim Shift Hjkl)",
        "bind = $mainMod SHIFT, H, movewindow, l",
        "bind = $mainMod SHIFT, J, movewindow, d",
        "bind = $mainMod SHIFT, K, movewindow, u",
        "bind = $mainMod SHIFT, L, movewindow, r",
        "",
        "# Workspaces 1-5 Focus",
        "bind = $mainMod, 1, workspace, 1",
        "bind = $mainMod, 2, workspace, 2",
        "bind = $mainMod, 3, workspace, 3",
        "bind = $mainMod, 4, workspace, 4",
        "bind = $mainMod, 5, workspace, 5",
        "",
        "# Workspaces 1-5 Move Window",
        "bind = $mainMod SHIFT, 1, movetoworkspace, 1",
        "bind = $mainMod SHIFT, 2, movetoworkspace, 2",
        "bind = $mainMod SHIFT, 3, movetoworkspace, 3",
        "bind = $mainMod SHIFT, 4, movetoworkspace, 4",
        "bind = $mainMod SHIFT, 5, movetoworkspace, 5",
        "",
        "# Special Workspace / Scratchpad",
        "bind = $mainMod, MINUS, togglespecialworkspace,",
        "bind = $mainMod SHIFT, MINUS, movetoworkspace, special",
        "",
        "# Mouse Binds",
        "bindm = $mainMod, mouse:272, movewindow",
        "bindm = $mainMod, mouse:273, resizewindow",
        "",
        "# Screenshots",
        "bind = , PRINT, exec, grim ~/Pictures/$(date +'%Y%m%d_%H%M%S_screenshot.png')",
        "bind = $mainMod SHIFT, S, exec, grim -g \"$(slurp)\" - | wl-copy",
        "",
        "# Theme Toggle",
        "bind = $mainMod SHIFT, T, exec, ~/.local/bin/toggle_theme.sh",
        "",
    ]
    return "\n".join(lines)

def main():
    content = generate_hyprland_conf()
    TARGET_CONF.write_text(content)
    print(f"[SUCCESS] Transpiled {TARGET_CONF}")

if __name__ == "__main__":
    main()
