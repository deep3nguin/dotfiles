-- Neovim custom keybindings (loaded on VeryLazy event)
local keymap = vim.keymap.set

-- Custom shortcuts
keymap("n", "<leader>pv", vim.cmd.Ex, { desc = "Open File Explorer (Netrw)" })

-- Toggle light/dark background mode based on QN37x DESIGN.md tokens
local toggle_background = function()
  if vim.o.background == "dark" then
    vim.o.background = "light"
  else
    vim.o.background = "dark"
  end
  -- Reload the colorscheme to ensure custom highlights adapt correctly
  vim.cmd("colorscheme qn37x")
end

keymap("n", "<leader>ut", toggle_background, { desc = "Toggle Light/Dark Editorial Theme" })
keymap("n", "<F5>", toggle_background, { desc = "Toggle Light/Dark Editorial Theme" })
