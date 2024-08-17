-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
local o = vim.opt

local lazy = require("lazy")

-- Lazy options
map("n", "<leader>l", "<Nop>")
map("n", "<leader>ll", "<cmd>Lazy<cr>", { desc = "Lazy" })
-- stylua: ignore start
map("n", "<leader>ld", function() vim.fn.system({ "xdg-open", "https://lazyvim.org" }) end, { desc = "LazyVim Docs" })
map("n", "<leader>lr", function() vim.fn.system({ "xdg-open", "https://github.com/LazyVim/LazyVim" }) end, { desc = "LazyVim Repo" })
map("n", "<leader>lx", "<cmd>LazyExtras<cr>", { desc = "Extras" })
map("n", "<leader>lc", function() LazyVim.news.changelog() end, { desc = "LazyVim Changelog" })

map("n", "<leader>lu", function() lazy.update() end, { desc = "Lazy Update" })
map("n", "<leader>lC", function() lazy.check() end, { desc = "Lazy Check" })
map("n", "<leader>ls", function() lazy.sync() end, { desc = "Lazy Sync" })
-- stylua: ignore end

-- Disable LazyVim bindings
map("n", "<leader>L", "<Nop>")
map("n", "<leader>fT", "<Nop>")

-- Cursor navigation on insert mode
map("i", "<M-h>", "<left>", { desc = "Move Cursor Left" })
map("i", "<M-l>", "<right>", { desc = "Move Cursor Left" })
map("i", "<M-j>", "<down>", { desc = "Move Cursor Left" })
map("i", "<M-k>", "<up>", { desc = "Move Cursor Left" })

-- Dashboard
map("n", "<leader>fd", function()
  if LazyVim.has("alpha-nvim") then
    require("alpha").start(true)
  elseif LazyVim.has("dashboard-nvim") then
    vim.cmd("Dashboard")
  end
end, { desc = "Dashboard" })

-- Marks
map("n", "dm", function()
  local cur_line = vim.fn.line(".")
  -- Delete buffer local mark
  for _, mark in ipairs(vim.fn.getmarklist("%")) do
    if mark.pos[2] == cur_line and mark.mark:match("[a-zA-Z]") then
      vim.api.nvim_buf_del_mark(0, string.sub(mark.mark, 2, #mark.mark))
      return
    end
  end
  -- Delete global marks
  local cur_buf = vim.api.nvim_win_get_buf(vim.api.nvim_get_current_win())
  for _, mark in ipairs(vim.fn.getmarklist()) do
    if mark.pos[1] == cur_buf and mark.pos[2] == cur_line and mark.mark:match("[a-zA-Z]") then
      vim.api.nvim_buf_del_mark(0, string.sub(mark.mark, 2, #mark.mark))
      return
    end
  end
end, { noremap = true, desc = "Mark on Current Line" })

-- Git
map("n", "<leader>ghB", LazyVim.lazygit.blame_line, { desc = "Blame Line (LazyGit)" })

-- Projects
local util = require("util.fs")

map("n", "<leader>pf", function()
  util.browse("~/projects/")
end, { desc = "projects" })

map("n", "<leader>pF", function()
  local buf = vim.api.nvim_get_current_buf()
  local dir
  if vim.bo[buf].buftype == "" then
    dir = vim.fs.dirname(vim.api.nvim_buf_get_name(buf))
  else
    dir = vim.fn.getcwd()
  end
  util.browse(dir)
end, { desc = "current file parent dir" })

map("n", "<leader>pv", function()
  util.browse(vim.fn.getcwd(-1))
end, { desc = "current dir" })

map("n", "<leader>pr", function()
  util.browse(util.project_root())
end, { desc = "project dir" })

map("n", "<leader>po", function()
  util.browse(vim.loop.os_homedir())
end, { desc = "home dir" })

map("n", "<leader>pn", function()
  util.browse(vim.fn.stdpath("config"))
end, { desc = "nvim config" })

map("n", "<leader>pz", function()
  util.browse(vim.fn.stdpath("config") .. "/../zsh")
end, { desc = "zsh config" })

map("n", "<leader>ph", function()
  util.browse(vim.fn.stdpath("config") .. "/../hypr")
end, { desc = "hyprland config" })

map("n", "<leader>pb", function()
  util.set_browser()
end, { desc = "switch browser" })

-- portal
map("n", "<leader>jj", function()
  require("portal.builtin").jumplist.tunnel()
end, { desc = "jumplist" })
map("n", "<leader>jq", function()
  require("portal.builtin").quickfix.tunnel()
end, { desc = "quickfix" })
map("n", "<leader>jc", function()
  require("portal.builtin").changelist.tunnel()
end, { desc = "changelist" })

-- window picker
local win = require("util.win")

map("n", "<C-w>f", function()
  win.pick_focus()
end, { desc = "pick focus" })

map("n", "<C-w>c", function()
  win.pick_create()
end, { desc = "pick create" })

map("n", "<C-w>x", function()
  win.pick_swap()
end, { desc = "pick swap" })

map("n", "<C-w>q", function()
  win.pick_close()
end, { desc = "pick close" })

-- reach
map("n", "<leader>br", function()
  require("reach").buffers({
    show_current = true,
    filter = function(buf)
      return true
    end,
    auto_exclude_handles = {
      "0",
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "8",
      "9",
    },
  })
end, { desc = "reach: buffers" })

-- smart splits
map("n", "<C-h>", require("smart-splits").move_cursor_left)
map("n", "<C-j>", require("smart-splits").move_cursor_down)
map("n", "<C-k>", require("smart-splits").move_cursor_up)
map("n", "<C-l>", require("smart-splits").move_cursor_right)

local wk = require("which-key")

wk.add({
  {
    "]h",
    function()
      require("harpoon"):list("files"):next()
    end,
    desc = "harpoon mark",
  },
  {
    "[h",
    function()
      require("harpoon"):list("files"):prev()
    end,
    desc = "harpoon mark",
  },
  {
    "g?",
    function()
      wk.show({ mode = "n" })
    end,
    desc = "which-key",
  },
  {
    group = "harpoon",
    {
      "<C-e>",
      function()
        local harpoon = require("harpoon")
        local list = harpoon:list("files")
        local width_ratio = 0.45
        if vim.o.columns > 130 then
          width_ratio = 0.35
        elseif vim.o.columns < 100 then
          width_ratio = 0.55
        end

        require("harpoon").ui:toggle_quick_menu(list, {
          ui_width_ratio = width_ratio,
          border = "solid",
          title_pos = "center",
          footer_pos = "center",
        })
      end,
      desc = "harpoon: marks",
    },
    {
      "<C-c>",
      function()
        local harpoon = require("harpoon")
        local list = harpoon:list("terminals")
        local width_ratio = 0.45
        if vim.o.columns > 130 then
          width_ratio = 0.35
        elseif vim.o.columns < 100 then
          width_ratio = 0.55
        end
        harpoon.ui:toggle_quick_menu(list, {
          ui_width_ratio = width_ratio,
          border = "solid",
          title_pos = "center",
          footer_pos = "center",
        })
      end,
      desc = "harpoon: commands",
    },
    {
      "<C-b>",
      function()
        local harpoon = require("harpoon")
        local list = harpoon:list("files")

        if list:length() == list:add():length() then
          list:remove()
        end
      end,
      desc = "harpoon: add",
    },
  },
})
