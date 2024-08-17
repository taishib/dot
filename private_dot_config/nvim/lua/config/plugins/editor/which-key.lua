require("which-key").setup({
  key_labels = {
    ["<leader>"] = "",
    ["<localleader>"] = "",
    ["<space>"] = "SPC",
    ["<cr>"] = "RET",
    ["<tab>"] = "TAB",
  },
  window = {
    position = "bottom",
    border = "single",
    title = "test",
    winblend = 0,
    margin = {
      0,
      0,
      1,
      function()
        return math.max(vim.o.columns - 32, (math.floor(vim.o.columns / 4) * 3))
      end,
    },
    padding = { 1, 0, 1, 0 },
    zindex = 200,
  },
  layout = {
    height = { min = 4, max = 30 }, -- min and max height of the columns
    width = { min = 20, max = 30 }, -- min and max width of the columns
    spacing = 1, -- spacing between columns
    align = "left", -- align columns left, center or right
  },
})

local defaults = {
  mode = { "n", "v" },
  ["<leader><tab>"] = { name = "+tabs" },
  ["<leader>q"] = { name = "+quit/session" },
  ["<leader>s"] = { name = "+search" },
  ["<leader>u"] = { name = "+ui" },
  ["<leader>x"] = { name = "+diagnostics/quickfix" },
  ["<leader>r"] = { name = "+refactor/replace" },
  ["<leader>o"] = { name = "+overseer" },
  ["<localleader>h"] = { name = "+hydras" },
  ["<localleader>p"] = { name = "+pick" },
}

local wk = require("which-key")
wk.register(defaults)
