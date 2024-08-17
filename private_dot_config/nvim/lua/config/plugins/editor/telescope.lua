local actions = require("telescope.actions")
local telescope = require("telescope")

local ui = require("util.telescope")

local trouble = require("trouble.sources.telescope")

local function add_to_harpoon(prompt_bufnr)
  local action_state = require("telescope.actions.state")

  local picker = action_state.get_current_picker(prompt_bufnr)

  local multi_selection = picker:get_multi_selection()

  local iter
  if #multi_selection > 0 then
    iter = vim.iter(multi_selection)
  else
    iter = vim.iter({ picker:get_selection() })
  end

  local list = require("harpoon"):list()

  for file in iter do
    if file.filename and file.filename ~= "" then
      list:add(file.filename)
    else
      vim.notify("No filename found for " .. vim.inspect(file), vim.log.levlels.ERROR, {})
    end
  end
end

local function create_and_add_to_harpoon(prompt_bufnr)
  local fb_actions = telescope.extensions.file_browser.actions
  local path = fb_actions.create(prompt_bufnr)
  if path ~= nil then
    require("harpoon"):list():add(path)
  end
end

telescope.setup({
  pickers = {
    colorscheme = {
      enable_preview = true,
    },
  },
  defaults = {
    create_layout = ui.flexible,
    find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
    dynamic_preview_title = true,
    -- get_status_text = function(self, opts)
    --   return ""
    -- end,
    mappings = {
      i = {
        ["<C-t>"] = trouble.open,
        ["<esc>"] = actions.close,
      },
      n = {
        ["<C-t>"] = trouble.open,
      },
    },
  },
  extensions = {
    file_browser = {
      mappings = {
        ["i"] = {
          ["<C-a>"] = add_to_harpoon,
          ["<C-h>"] = create_and_add_to_harpoon,
          ["<C-t>"] = trouble.open,
        },
        ["n"] = {
          ["c"] = create_and_add_to_harpoon,
          ["<C-a>"] = add_to_harpoon,
          ["<C-t>"] = trouble.open,
        },
      },
      sorting_strategy = "ascending",
      prompt_path = true,
      create_layout = ui.bottom_pane,
      -- display_stat = false,
    },
    frecency = {
      ignore_patterns = {
        "*.git/*",
        "*/tmp/*",
      },
      use_sqlite = false,
      show_scores = false,
      show_unindexed = true,
      db_safe_mode = false,
      default_workspace = "CWD",
      workspaces = {},
      path_display = { "filename_first" },
      prompt_title = "Find Files",
      preview_title = "Preview",
      results_title = "Files",
      temp__scrolling_limit = 100,
    },
  },
})

for _, ext in ipairs({
  "frecency",
  -- "smart_history",
  -- "neoclip",
  "file_browser",
  -- "projects",
  -- "noice",
  -- "macros",
  -- "scope",
  -- "yank_history",
  -- "attempt",
  -- "bookmarks",
}) do
  telescope.load_extension(ext)
end
