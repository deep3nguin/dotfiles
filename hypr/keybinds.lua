-- Keybindings configuration for Hyprland (aligned with DESIGN.md layout system)
-- Enforces design constraints: workspaces are strictly capped at 1-5.

local mainMod = "SUPER" -- Set the main modifier key to SUPER

-- Application Launchers & Terminal
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("kitty")) -- Open Kitty terminal emulator
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd("kitty")) -- Open Kitty terminal emulator (alternative)
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("fuzzel")) -- Launch Fuzzel application launcher
hl.bind(mainMod .. " + n", hl.dsp.exec_cmd("swaync-client -t -sw")) -- Toggle SwayNC notification center panel
hl.bind(mainMod .. " + v", hl.dsp.exec_cmd("~/.local/bin/cliphist-fuzzel.sh")) -- Launch clipboard history picker via fuzzel
hl.bind(mainMod .. " + e", hl.dsp.exec_cmd("kitty -e yazi")) -- Launch Yazi file manager inside Kitty terminal
hl.bind(mainMod .. " + w", hl.dsp.exec_cmd("google-chrome-stable")) -- Launch Google Chrome web browser
hl.bind(mainMod .. " + a", hl.dsp.exec_cmd("kitty -e agy")) -- Launch agy CLI tool inside Kitty terminal

-- Scratchpad Terminal Controls
hl.bind(mainMod .. " + s", hl.dsp.exec_cmd("hyprctl dispatch togglespecialworkspace")) -- Toggle special workspace scratchpad terminal
hl.bind(mainMod .. " + SHIFT + s", hl.dsp.exec_cmd("kitty --class scratchpad")) -- Launch scratchpad terminal instance

-- Window Control Shortcuts
hl.bind(mainMod .. " + c", hl.dsp.window.close()) -- Kill active window
hl.bind(mainMod .. " + t", hl.dsp.window.float({ action = "toggle" })) -- Toggle floating state for active window
hl.bind(mainMod .. " + SHIFT + v", hl.dsp.window.float({ action = "toggle" })) -- Toggle floating state for active window (alternative)
hl.bind(mainMod .. " + f", hl.dsp.window.fullscreen()) -- Toggle fullscreen state for active window
hl.bind(mainMod .. " + m", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit")) -- Exit session via hyprshutdown or exit dispatch

-- Vim-inspired Navigation Focus (SUPER + H/J/K/L)
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" })) -- Focus left window
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" })) -- Focus bottom window
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" })) -- Focus top window
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" })) -- Focus right window

-- Vim-inspired Window Movement (SUPER + SHIFT + H/J/K/L)
hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.move({ direction = "left" })) -- Move active window to the left
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.move({ direction = "down" })) -- Move active window down
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.move({ direction = "up" })) -- Move active window up
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.move({ direction = "right" })) -- Move active window to the right

-- Focus Cycling
hl.bind(mainMod .. " + TAB", hl.dsp.window.cycle_next()) -- Cycle focus to next window
hl.bind(mainMod .. " + SHIFT + TAB", hl.dsp.window.cycle_next({ prev = true })) -- Cycle focus to previous window

-- Workspace Navigation (Capped strictly at workspaces 1-5)
hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = 1 })) -- Switch focus to workspace 1
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = 2 })) -- Switch focus to workspace 2
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = 3 })) -- Switch focus to workspace 3
hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = 4 })) -- Switch focus to workspace 4
hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace = 5 })) -- Switch focus to workspace 5

-- Move Active Window to Workspaces (Capped strictly at workspaces 1-5)
hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 })) -- Move focused window to workspace 1
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 })) -- Move focused window to workspace 2
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 })) -- Move focused window to workspace 3
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 })) -- Move focused window to workspace 4
hl.bind(mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5 })) -- Move focused window to workspace 5

-- Previous Workspace Toggle
hl.bind(mainMod .. " + grave", hl.dsp.focus({ workspace = "previous" })) -- Toggle between current and last active workspace

-- Window Resize Mode (SUPER + R)
hl.bind(mainMod .. " + r", hl.dsp.submap("resize")) -- Enter window resize submap mode
hl.define_submap("resize", function() -- Define bindings for resize submap mode
    hl.bind("h", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true }) -- Shrink window horizontally
    hl.bind("l", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true }) -- Expand window horizontally
    hl.bind("k", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true }) -- Shrink window vertically
    hl.bind("j", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true }) -- Expand window vertically
    hl.bind("escape", hl.dsp.submap("reset")) -- Exit resize submap mode
    hl.bind("Return", hl.dsp.submap("reset")) -- Exit resize submap mode
end)

-- Screen Capture Controls (grim + slurp)
hl.bind("Print", hl.dsp.exec_cmd("grim ~/Pictures/$(date +'%Y%m%d_%H%M%S_screenshot.png')")) -- Capture full screen to file
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy")) -- Capture regional screenshot to clipboard

-- System Lock & Utilities
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("hyprlock")) -- Lock screen using hyprlock utility
hl.bind(mainMod .. " + SHIFT + t", hl.dsp.exec_cmd("~/.local/bin/toggle_theme.sh")) -- Toggle between light and dark visual themes
hl.bind(mainMod .. " + p", hl.dsp.exec_cmd("hyprctl dispatch pin")) -- Pin active window (sticky across workspaces)

-- Mouse Bindings
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true }) -- Drag with mouse left click to move window
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true }) -- Drag with mouse right click to resize window
