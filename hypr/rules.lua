-- Window and layer rules configuration for Hyprland (aligned with DESIGN.md layout system)

-- Float rules for standard utility, dialog, notification, calculator, and scratchpad windows
hl.window_rule({ match = { class = "^confirm$" }, float = true }) -- Float confirmation dialogs
hl.window_rule({ match = { class = "^dialog$" }, float = true }) -- Float utility dialog windows
hl.window_rule({ match = { class = "^download$" }, float = true }) -- Float download manager windows
hl.window_rule({ match = { class = "^notification$" }, float = true }) -- Float system notification overlays
hl.window_rule({ match = { class = "^error$" }, float = true }) -- Float application error windows
hl.window_rule({ match = { class = "^splash$" }, float = true }) -- Float splash screen windows
hl.window_rule({ match = { class = "^confirmreset$" }, float = true }) -- Float reset prompt screens
hl.window_rule({ match = { class = "^org.gnome.Calculator$" }, float = true }) -- Float GNOME calculator utility
hl.window_rule({ match = { class = "^calc$" }, float = true }) -- Float generic calculator utilities
hl.window_rule({ match = { class = "^file_progress$" }, float = true }) -- Float file progress indicators

-- Scratchpad terminal floating rule and workspace placement
hl.window_rule({ match = { class = "^scratchpad$" }, float = true }) -- Float scratchpad terminal window
hl.window_rule({ match = { class = "^scratchpad$" }, workspace = "special silent" }) -- Place scratchpad in special workspace silently

-- Layer-shell rules for SwayNC notification window, SwayNC control center, and Waybar panel with blur enabled
hl.layer_rule({
    match = { namespace = "swaync-notification-window" },
    blur = true,
}) -- Enable background blur for SwayNC notification window
hl.layer_rule({
    match = { namespace = "swaync-control-center" },
    blur = true,
}) -- Enable background blur for SwayNC control center panel
hl.layer_rule({
    match = { namespace = "waybar" },
    blur = true,
}) -- Enable background blur for Waybar panel
