-- Hyprland Main Configuration File (Lua format)

-- Source external configuration modules using require()
require("monitors")     -- Load monitor configurations
require("autostart")    -- Load autostart applications
require("rules")        -- Load window and workspace rules
require("animations")   -- Load window transitions and animations
require("keybinds")     -- Load keyboard shortcuts and binds

-- General window layout and aesthetics
hl.config({
    general = {
        gaps_in = 6,              -- Inner gaps between adjacent windows
        gaps_out = 12,            -- Outer gaps between windows and monitor edges
        border_size = 2,          -- Border width of windows
        col = {
            active_border = {
                colors = { "rgba(0053D6ff)", "rgba(A261FFff)" }, -- Active border with Blue and Purple gradient
                angle = 45
            },
            inactive_border = "rgba(0B0B0Cff)"                   -- Inactive border color matching Ink
        },
        layout = "dwindle",       -- Use the dwindle tiling layout by default
    }
})

-- Window decoration settings
hl.config({
    decoration = {
        rounding = 12,            -- Corner rounding radius in pixels (matching radius_sm: 12px)
        active_opacity = 1.0,     -- Opacity for the active window
        inactive_opacity = 1.0,   -- Opacity for inactive windows

        -- Configure background blur
        blur = {
            enabled = true,       -- Enable background blur for transparent windows
            size = 3,             -- Blur size multiplier
            passes = 1,           -- Number of blur passes to perform
        }
    }
})

-- Input device configuration
hl.config({
    input = {
        kb_layout = "us",         -- Keyboard layout configuration
        follow_mouse = 1,         -- Focus follows mouse pointer movement
        sensitivity = 0,          -- Mouse cursor sensitivity adjustments
    }
})

-- Layout specific configurations
hl.config({
    dwindle = {
        pseudotile = true,        -- Enable pseudo-tiling for tiled layouts
        preserve_split = true,    -- Preserve layout split ratio during window adjustments
    }
})

-- Miscellaneous behaviors
hl.config({
    misc = {
        force_default_wallpaper = 0,    -- Disable default Hyprland wallpaper
        disable_hyprland_logo = true,   -- Do not display the Hyprland logo at startup
    }
})
