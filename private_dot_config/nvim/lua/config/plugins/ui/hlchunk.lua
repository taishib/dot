require("hlchunk").setup({
  chunk = {
    enable = true,
    style = {
      { fg = "#806d9c" },
    },
    chars = {
      horizontal_line = "─",
      vertical_line = "│",
      left_top = "╭",
      left_bottom = "╰",
      right_arrow = ">",
    },
  },
  indent = {
    enable = true,
    chars = {
      "│",
      "¦",
      "┆",
      "┊",
    },
    style = {
      vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Whitespace")), "fg", "gui"),
    },
  },
  line_num = {
    enabled = true,
    style = "#806d9c",
  },
})
