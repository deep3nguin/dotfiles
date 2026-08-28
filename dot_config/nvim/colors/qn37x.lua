-- qn37x.lua - Custom colorscheme implementing QN37x Design System (DESIGN.md)
vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end
vim.g.colors_name = "qn37x"

-- Light (Parchment) and Dark (Dusk) palettes strictly derived from DESIGN.md
local colors = {
  light = {
    bg = "#fefffc",            -- Parchment canvas
    fg = "#171717",            -- Ink Black text
    cursorline = "#f9faf7",    -- Linen surface wash
    comment = "#646464",       -- Ash muted text
    visual = "#dee2de",        -- Mist hairline selection
    keyword = "#0081c0",       -- Cerulean / Primary-dark blue
    string = "#444141",        -- Charcoal body
    border = "#dee2de",        -- Mist hairline border
    accent = "#41a1cf",        -- Signal Blue / Primary accent
    constant = "#2c2c2c",      -- Graphite headline text
    statusline_bg = "#ffffff",  -- Paper white card surface
    statusline_fg = "#171717",
  },
  dark = {
    bg = "#1f1f29",            -- Dusk background surface
    fg = "#fefffc",            -- Parchment text
    cursorline = "#282834",    -- Twilight dark wash
    comment = "#b4b8b4",       -- Fog muted text
    visual = "#444141",        -- Charcoal selection fill
    keyword = "#41a1cf",       -- Signal Blue primary accent
    string = "#dee2de",        -- Mist light text
    border = "#282834",        -- Twilight border
    accent = "#0081c0",        -- Cerulean / Primary-dark blue
    constant = "#fefffc",      -- Parchment
    statusline_bg = "#2c2c2c",  -- Graphite surface
    statusline_fg = "#ffffff",
  }
}

local function apply()
  local bg_type = vim.o.background
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
    
    -- NeoTree / NvimTree
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
