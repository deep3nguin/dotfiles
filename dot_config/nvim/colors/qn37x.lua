-- qn37x.lua - Custom colorscheme implementing QN37x Design System
-- Clear existing highlights
vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end
vim.g.colors_name = "qn37x"

-- Light (Parchment) and Dark (Dusk) palettes from DESIGN.md
local colors = {
  light = {
    bg = "#fefffc",            -- Parchment
    fg = "#171717",            -- Ink Black
    cursorline = "#f9faf7",    -- Linen
    comment = "#646464",       -- Ash
    visual = "#dee2de",        -- Mist
    keyword = "#0081c0",       -- Cerulean
    string = "#444141",        -- Charcoal
    border = "#dee2de",        -- Mist
    accent = "#41a1cf",        -- Signal Blue
    constant = "#2c2c2c",      -- Graphite
    statusline_bg = "#ffffff",  -- Paper
    statusline_fg = "#171717",
  },
  dark = {
    bg = "#1f1f29",            -- Dusk
    fg = "#ffffff",            -- Paper
    cursorline = "#282834",    -- Twilight
    comment = "#b4b8b4",       -- Fog
    visual = "#444141",        -- Charcoal
    keyword = "#41a1cf",       -- Signal Blue
    string = "#dee2de",        -- Mist
    border = "#282834",        -- Twilight
    accent = "#0081c0",        -- Cerulean
    constant = "#fefffc",      -- Parchment
    statusline_bg = "#2c2c2c",  -- Graphite
    statusline_fg = "#ffffff",
  }
}

local function apply()
  local bg_type = vim.o.background
  -- Fallback to dark if not set properly
  if bg_type ~= "light" and bg_type ~= "dark" then
    bg_type = "dark"
  end
  local c = colors[bg_type]

  local groups = {
    -- Editor basics
    Normal = { fg = c.fg, bg = c.bg },
    NormalFloat = { fg = c.fg, bg = c.statusline_bg },
    FloatBorder = { fg = c.border, bg = c.statusline_bg },
    LineNr = { fg = c.comment },
    CursorLine = { bg = c.cursorline },
    CursorLineNr = { fg = c.accent, bold = true },
    Visual = { bg = c.visual },
    Search = { fg = c.bg, bg = c.keyword },
    IncSearch = { fg = c.bg, bg = c.accent },
    ColorColumn = { bg = c.cursorline },
    SignColumn = { bg = c.bg },
    
    -- Syntax
    Comment = { fg = c.comment, italic = true },
    Keyword = { fg = c.keyword, bold = true },
    String = { fg = c.string },
    Function = { fg = c.accent, bold = true },
    Identifier = { fg = c.fg },
    Statement = { fg = c.keyword },
    PreProc = { fg = c.accent },
    Type = { fg = c.keyword },
    Constant = { fg = c.constant },
    Special = { fg = c.accent },
    Underlined = { underline = true },
    Error = { fg = "#ff385c", bg = c.bg },
    Todo = { fg = c.accent, bold = true },
    
    -- StatusLine
    StatusLine = { fg = c.statusline_fg, bg = c.statusline_bg },
    StatusLineNC = { fg = c.comment, bg = c.cursorline },
    
    -- TreeSitter & Diagnostics
    DiagnosticError = { fg = "#ff385c" },
    DiagnosticWarn = { fg = c.keyword },
    DiagnosticInfo = { fg = c.accent },
    DiagnosticHint = { fg = c.comment },
    
    -- NeoTree
    NeoTreeNormal = { fg = c.fg, bg = c.bg },
    NeoTreeNormalNC = { fg = c.fg, bg = c.bg },
    NeoTreeWinSeparator = { fg = c.border, bg = c.bg },
    
    -- Gitsigns
    GitSignsAdd = { fg = c.keyword },
    GitSignsChange = { fg = c.accent },
    GitSignsDelete = { fg = "#ff385c" },
  }

  for group, opts in pairs(groups) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

apply()
