-- Autostart configuration for Hyprland

hl.on("hyprland.start", function ()
    hl.exec_cmd("waybar")     -- Launch Waybar panel on startup
    hl.exec_cmd("hyprpaper")  -- Launch Hyprpaper utility on startup
end)
