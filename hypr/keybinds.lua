-- Keybindings configuration for Hyprland (aligned with DESIGN.md layout system)
-- Enforces design constraints: workspaces are strictly capped at 5.

local mainMod = "SUPER" -- Set the main modifier key to SUPER

-- Application Launchers
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("kitty")) -- Open kitty terminal emulator
hl.bind(mainMod .. " + d", hl.dsp.exec_cmd("fuzzel")) -- Launch Fuzzel application launcher
hl.bind(mainMod .. " + e", hl.dsp.exec_cmd("kitty -e yazi")) -- Launch Yazi file manager inside kitty

-- Window Management Binds
hl.bind(mainMod .. " + q", hl.dsp.window.close()) -- Close/kill the active window
hl.bind(mainMod .. " + c", hl.dsp.window.close()) -- Close/kill the active window (alternative)
hl.bind(mainMod .. " + f", hl.dsp.window.fullscreen()) -- Toggle fullscreen state for the active window
hl.bind(mainMod .. " + v", hl.dsp.window.float({ action = "toggle" })) -- Toggle floating/tiling state for the active window
hl.bind(mainMod .. " + s", hl.dsp.layout("togglesplit")) -- Toggle window split direction (dwindle layout)

-- Focus Directional (Vim-style)
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" })) -- Move focus to the left window
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" })) -- Move focus to the bottom window
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" })) -- Move focus to the top window
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" })) -- Move focus to the right window

-- Focus Cycling (Alt-Tab style)
hl.bind(mainMod .. " + TAB", hl.dsp.window.cycle_next()) -- Cycle focus to the next window
hl.bind(mainMod .. " + SHIFT + TAB", hl.dsp.window.cycle_next({ prev = true })) -- Cycle focus to the previous window

-- Workspace Navigation (Limited to workspaces 1-5)
hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = 1 })) -- Switch focus to workspace 1
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = 2 })) -- Switch focus to workspace 2
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = 3 })) -- Switch focus to workspace 3
hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = 4 })) -- Switch focus to workspace 4
hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace = 5 })) -- Switch focus to workspace 5

-- Move Active Window to Workspaces (Limited to workspaces 1-5)
hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 })) -- Move focused window to workspace 1
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 })) -- Move focused window to workspace 2
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 })) -- Move focused window to workspace 3
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 })) -- Move focused window to workspace 4
hl.bind(mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5 })) -- Move focused window to workspace 5

-- Previous/Current Workspace Toggle
hl.bind(mainMod .. " + grave", hl.dsp.focus({ workspace = "previous" })) -- Toggle between current and last active workspace

-- Resize Submap (SUPER+r)
hl.bind(mainMod .. " + r", hl.dsp.submap("resize")) -- Enter window resize submap mode
hl.define_submap("resize", function() -- Start definition of the resize submap
    hl.bind("h", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true }) -- Shrink the active window horizontally
    hl.bind("l", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true }) -- Expand the active window horizontally
    hl.bind("k", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true }) -- Shrink the active window vertically
    hl.bind("j", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true }) -- Expand the active window vertically
    hl.bind("escape", hl.dsp.submap("reset")) -- Exit resize submap and restore default mode
    hl.bind("Return", hl.dsp.submap("reset")) -- Exit resize submap and restore default mode
end)

-- Screenshots (grim + slurp)
hl.bind("Print", hl.dsp.exec_cmd("grim ~/Pictures/$(date +'%Y%m%d_%H%M%S_screenshot.png')")) -- Capture full screen to files
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy")) -- Capture regional screenshot to clipboard
hl.bind(mainMod .. " + SHIFT + s", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy")) -- Capture regional screenshot to clipboard (alternative)

-- System Controls
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("hyprlock")) -- Lock screen using hyprlock utility
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exit()) -- Exit Hyprland and terminate user session

-- Special Workspace and Scratchpad
hl.bind(mainMod .. " + minus", hl.dsp.exec_cmd("hyprctl dispatch togglespecialworkspace")) -- Toggle special workspace (scratchpad)
hl.bind(mainMod .. " + SHIFT + minus", hl.dsp.exec_cmd("hyprctl dispatch movetoworkspace special")) -- Move active window to special workspace
hl.bind(mainMod .. " + u", hl.dsp.exec_cmd("kitty --class scratchpad")) -- Launch scratchpad terminal

-- Sticky Window (Pinning)
hl.bind(mainMod .. " + p", hl.dsp.exec_cmd("hyprctl dispatch pin")) -- Pin active window (sticky across workspaces)

-- Clipboard History
hl.bind(mainMod .. " + SHIFT + v", hl.dsp.exec_cmd("~/.local/bin/cliphist-fuzzel.sh")) -- Open clipboard history via fuzzel

-- Mouse Bindings for Resizing/Moving
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true }) -- Drag with mouse left click to move window
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true }) -- Drag with mouse right click to resize window

