-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.maplocalleader = ","

vim.g.lazyvim_statuscolumn = {
  folds_open = true, -- show fold sign when fold is open
  folds_githl = true, -- highlight fold sign with git sign color
}

vim.filetype.add({
  pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
})

if vim.g.neovide then
  RefreshGuiFont = function()
    vim.opt.guifont = string.format("%s:h%s", vim.g.gui_font_face, vim.g.gui_font_size)
  end

  ResizeGuiFont = function(delta)
    vim.g.gui_font_size = vim.g.gui_font_size + delta
    RefreshGuiFont()
  end

  -- Keymaps
  local opts = { noremap = true, silent = true }

  vim.keymap.set({ "n", "i" }, "<C-+>", function()
    ResizeGuiFont(1)
  end, opts)
  vim.keymap.set({ "n", "i" }, "<C-->", function()
    ResizeGuiFont(-1)
  end, opts)

  -- Options
  vim.g.neovide_padding_top = 0
  vim.g.neovide_padding_right = 0
  vim.g.neovide_padding_left = 0

  vim.g.neovide_hide_mouse_when_typing = true

  vim.g.neovide_window_blurred = true
  vim.g.neovide_floating_blur_amount_x = 5.0
  vim.g.neovide_floating_blur_amount_y = 5.0
  vim.g.neovide_floating_shadow = true
  vim.g.neovide_floating_z_height = 10

  vim.g.neovide_cursor_antialiasing = false

  vim.g.neovide_cursor_vfx_mode = "railgun"

  vim.o.guifont = "JetBrainsMono Nerd Font:h9"

  vim.g.neovide_transparency = 0.6
  vim.opt.winblend = 100
  vim.g.neovide_refresh_rate = 60
  vim.g.neovide_fullscreen = true
  vim.g.neovide_input_ime = true
end
