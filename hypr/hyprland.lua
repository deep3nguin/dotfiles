-- Hyprland Main Configuration File (Lua format)

local colors = require("colors")

-- Source external configuration modules using require()
require("monitors")     -- Load monitor configurations
require("autostart")    -- Load autostart applications
require("rules")        -- Load window and workspace rules
require("animations")   -- Load window transitions and animations
require("keybinds")     -- Load keyboard shortcuts and binds

-- General window layout and aesthetics
hl.config({
    general = {
        gaps_in = 8,              -- Inner gaps between adjacent windows (derived from xs spacing: 8px)
        gaps_out = 16,            -- Outer gaps between windows and screen edges (derived from sm spacing: 16px)
        border_size = 2,          -- Border width of windows in pixels
        col = {
            active_border = {
                colors = { "rgba(" .. colors.active_border_1 .. "ff)", "rgba(" .. colors.active_border_2 .. "ff)" }, -- Active border gradient (#41a1cf & #0081c0)
                angle = 45
            },
            inactive_border = "rgba(" .. colors.inactive_border .. "ff)"                   -- Inactive border color (#dee2de)
        },
        layout = "dwindle",       -- Use dwindle layout engine by default
    }
})

-- Window decoration settings
hl.config({
    decoration = {
        rounding = 16,            -- Corner rounding radius in pixels (derived from squircle-lg: 16px)
        active_opacity = 1.0,     -- Full opacity for the active window
        inactive_opacity = 0.92,  -- Opacity for inactive windows (derived from design system legibility guidelines)

        -- Configure background blur
        blur = {
            enabled = true,       -- Enable background blur for transparent windows and layer surfaces
            size = 12,            -- Blur radius size multiplier
            passes = 1,           -- Number of blur iterations to perform
        }
    }
})

-- Input device configuration
hl.config({
    input = {
        kb_layout = "us",         -- Keyboard layout setting
        follow_mouse = 1,         -- Window focus follows mouse cursor movement
        sensitivity = 0,          -- Default mouse cursor sensitivity
    }
})

-- Dwindle layout specific configuration
hl.config({
    dwindle = {
        preserve_split = true,    -- Maintain split direction during window modifications
    }
})

-- Miscellaneous system behaviors
hl.config({
    misc = {
        force_default_wallpaper = 0,    -- Disable built-in default wallpaper
        disable_hyprland_logo = true,   -- Hide default Hyprland anime background logo
    }
})
