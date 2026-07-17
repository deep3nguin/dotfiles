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
        gaps_in = 8,              -- Inner gaps between adjacent windows (derived from xs spacing: 8px)
        gaps_out = 16,            -- Outer gaps between windows and screen edges (derived from sm spacing: 16px)
        border_size = 2,          -- Border width of windows
        col = {
            active_border = {
                colors = { "rgba(41A1CFff)", "rgba(0081C0ff)" }, -- Active border gradient from primary to primary-dark
                angle = 45
            },
            inactive_border = "rgba(DEE2DEff)"                   -- Inactive border color matching border token
        },
        layout = "dwindle",       -- Use the dwindle tiling layout by default
    }
})

-- Window decoration settings
hl.config({
    decoration = {
        rounding = 16,            -- Corner rounding radius in pixels (derived from squircle-lg: 16px)
        active_opacity = 1.0,     -- Opacity for the active window
        inactive_opacity = 0.92,  -- Opacity for inactive windows (derived from design system legibility guidelines)

        -- Configure background blur
        blur = {
            enabled = true,       -- Enable background blur for transparent windows
            size = 12,            -- Blur size multiplier (derived from Glassmorphic navigation accents: 12px blur)
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
