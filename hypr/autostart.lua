-- Autostart configuration for Hyprland (aligned with DESIGN.md design system)

hl.on("hyprland.start", function ()
    hl.exec_cmd("waybar")     -- Launch Waybar panel on startup
    hl.exec_cmd("hyprpaper")  -- Launch Hyprpaper utility on startup
    hl.exec_cmd("systemctl --user start hyprpolkitagent") -- Launch Hyprpolkitagent authentication daemon
    hl.exec_cmd("swayosd-server") -- Launch SwayOSD daemon for OSD notifications
    hl.exec_cmd("wl-paste --type text --watch cliphist store") -- Start cliphist watcher for text clipboard content
    hl.exec_cmd("wl-paste --type image --watch cliphist store") -- Start cliphist watcher for image clipboard content
end)
