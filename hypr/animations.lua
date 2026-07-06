-- Animations configuration for Hyprland

-- Custom Bezier deceleration curves for premium UI feel
hl.curve("fluent_curve", { type = "bezier", points = { {0.16, 1}, {0.3, 1} } }) -- Fluent-like deceleration curve
hl.curve("easeInOut", { type = "bezier", points = { {0.42, 0}, {0.58, 1} } }) -- Standard ease-in-out curve

-- Window animation settings
hl.animation({ leaf = "windows", enabled = true, speed = 4, bezier = "fluent_curve", style = "slide" }) -- Slide in/out windows smoothly
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4, bezier = "fluent_curve", style = "slide" }) -- Slide in when opening new windows
hl.animation({ leaf = "windowsOut", enabled = true, speed = 4, bezier = "fluent_curve", style = "slide" }) -- Slide out when closing windows

-- Border transitions
hl.animation({ leaf = "border", enabled = true, speed = 6, bezier = "easeInOut" }) -- Cross-fade active and inactive borders

-- Fade effects
hl.animation({ leaf = "fade", enabled = true, speed = 4, bezier = "easeInOut" }) -- Fade transition for opacity changes

-- Workspace transitions
hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "fluent_curve", style = "slide" }) -- Slide animation when switching workspaces
