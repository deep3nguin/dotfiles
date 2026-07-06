-- Window rules configuration for Hyprland

-- Float rules for standard utility and dialog windows
hl.window_rule({ match = { class = "^confirm$" }, float = true }) -- Float confirmation dialogs
hl.window_rule({ match = { class = "^dialog$" }, float = true }) -- Float utility dialog windows
hl.window_rule({ match = { class = "^download$" }, float = true }) -- Float download manager windows
hl.window_rule({ match = { class = "^notification$" }, float = true }) -- Float system notification overlays
hl.window_rule({ match = { class = "^error$" }, float = true }) -- Float application error windows
hl.window_rule({ match = { class = "^splash$" }, float = true }) -- Float splash screen windows
hl.window_rule({ match = { class = "^confirmreset$" }, float = true }) -- Float reset prompt screens
hl.window_rule({ match = { class = "^org.gnome.Calculator$" }, float = true }) -- Float GNOME calculator utility
hl.window_rule({ match = { class = "^file_progress$" }, float = true }) -- Float file progress indicators
