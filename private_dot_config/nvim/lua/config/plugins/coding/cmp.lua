---@diagnostic disable: missing-fields
local cmp = require("cmp")
local icons = LazyVim.config.icons

local format = {
  fields = { "kind", "abbr", "menu" },
  format = function(_, vim_item)
    local kind = vim_item.kind
    local icon = (icons.kinds[kind] or ""):gsub("%s+", "")
    vim_item.kind = " " .. icon
    vim_item.menu = kind
    return vim_item
  end,
}

local opts = {
  formatting = format,
  mapping = cmp.mapping.preset.insert({
    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
  }),
}

cmp.setup(opts)

cmp.setup.cmdline(":", {
  sources = cmp.config.sources({
    { name = "cmdline", group_index = 0 },
    { name = "path", group_index = 0 },
    { name = "copilot", group_index = 0 },
    { name = "cmdline_history", group_index = 1 },
  }),
  formatting = format,
})

cmp.setup.cmdline({ "/", "?" }, {
  sources = cmp.config.sources({
    { name = "buffer" },
  }),
  formatting = format,
})
