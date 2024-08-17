return {
  -- LAYOUT / CORE UI --
  {
    "nvimdev/dashboard-nvim",
    opts = function(_, opts)
      vim.api.nvim_create_autocmd("TabNewEntered", { command = "Dashboard" })

      local logo = [[
                                                                     
        ████ ██████           █████      ██                    
       ███████████             █████                            
       █████████ ███████████████████ ███   ███████████  
      █████████  ███    █████████████ █████ ██████████████  
     █████████ ██████████ █████████ █████ █████ ████ █████  
   ███████████ ███    ███ █████████ █████ █████ ████ █████ 
  ██████  █████████████████████ ████ █████ █████ ████ ██████
        ]]

      logo = string.rep("\n", 8) .. logo .. "\n\n"
      opts.config.header = vim.split(logo, "\n")
      return opts
    end,
  },
  {
    "goolord/alpha-nvim",
    dependencies = {
      "echasnovski/mini.icons",
      {
        "juansalvatore/git-dashboard-nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
      },
    },
    config = function()
      require("config.plugins.ui.alpha")
    end,
    enabled = false,
  },
  {
    "folke/zen-mode.nvim",
    dependencies = { "folke/twilight.nvim" },
    opts = {
      plugins = {
        gitsigns = true,
        tmux = true,
        kitty = { enabled = true, font = "+2" },
        twilight = { enabled = true },
        alacritty = {
          enabled = true,
          font = "+2", -- font size
        },
      },
      on_open = function(win)
        vim.wo[win].fillchars = vim.go.fillchars
        vim.wo[win].winbar = "%{%v:lua.dropbar.get_dropbar_str()%}"
      end,
    },
    cmd = "ZenMode",
    keys = { { "<leader>uz", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
  },
  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("config.plugins.ui.noice")
    end,
  },
  -- SCOPE / CURSORWORD --
  {
    "tiagovla/scope.nvim",
    event = "VeryLazy",
    config = function()
      require("scope").setup({ restore_state = true })
    end,
  },
  {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre" },
    config = function()
      require("config.plugins.ui.hlchunk")
    end,
    enabled = false,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = true,
  },
  -- WINDOWS --
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      { "<leader>e", false },
      { "<leader>E", false },
    },
  },
  {
    "mrjones2014/smart-splits.nvim",
    config = function()
      require("config.plugins.window.smart-splits")
    end,
    event = "VeryLazy",
  },
  {
    "nvim-focus/focus.nvim",
    dependencies = {
      "echasnovski/mini.animate",
    },
    config = function()
      vim.api.nvim_create_autocmd("WinEnter", {
        once = true,
        callback = function()
          require("config.plugins.window.focus")
        end,
      })
    end,
    event = "VeryLazy",
    enabled = true,
  },
  {
    "willothy/nvim-window-picker",
    event = "VeryLazy",
    config = function()
      require("config.plugins.window.window-picker")
    end,
  },
  {
    "kwkarlwang/bufresize.nvim",
    event = "VeryLazy",
    config = function()
      require("config.plugins.window.bufresize")
    end,
  },
  {
    "tummetott/winshift.nvim",
    config = true,
    cmd = "WinShift",
  },
  {
    "stevearc/stickybuf.nvim",
    event = "VeryLazy",
    opts = {
      get_auto_pin = function(bufnr)
        -- Shell terminals will all have ft `terminal`, and can be switched between.
        -- They should be pinned by filetype only, not bufnr.
        if vim.bo[bufnr].filetype == "terminal" then
          return "filetype"
        end
        -- Non-shell terminals should be pinned by bufnr, not filetype.
        if vim.bo[bufnr].buftype == "terminal" then
          return "bufnr"
        end
        return require("stickybuf").should_auto_pin(bufnr)
      end,
    },
  },
  {
    "anuvyklack/windows.nvim",
    event = "VeryLazy",
    dependencies = {
      "anuvyklack/middleclass",
      "anuvyklack/animation.nvim",
    },
    config = function()
      require("config.plugins.window.windows")
    end,
  },
  -- STATUS --
  {
    "nvim-lualine/lualine.nvim",
    enabled = false,
  },
  {
    "rebelot/heirline.nvim",
    dependencies = {
      "abeldekat/harpoonline",
      version = "*",
    },
    enabled = true,
    event = "BufReadPre",
    config = function(_, default_opts)
      local heirline_opts = {
        statusline = require("config.plugins.status.heirline.statusline"),
        opts = {
          colors = require("config.plugins.status.heirline.colors").colors,
        },
      }
      local opts = vim.tbl_deep_extend("force", heirline_opts, default_opts) or {}
      require("heirline").setup(opts)

      vim.api.nvim_create_augroup("Heirline", { clear = true })
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          require("heirline.utils").on_colorscheme(require("config.plugins.status.heirline.colors").setup_colors())
        end,
        group = "Heirline",
      })
    end,
  },
  {
    "akinsho/bufferline.nvim",
    keys = {
      { "<leader>bb", "<Cmd>BufferLinePick<CR>", desc = "Pick Open" },
      { "<leader>bx", "<Cmd>BufferLinePickClose<CR>", desc = "Pick Close" },
    },
    opts = function()
      --- Check if a buffer is pinned
      ---@param buf any
      local function is_pinned(buf)
        for _, e in ipairs(require("bufferline").get_elements().elements or {}) do
          if e.id == buf.bufnr then
            return require("bufferline.groups")._is_pinned(e)
          end
        end

        return false
      end

      ---@param position Edgy.Pos
      local function get_edgy_group_icons(position)
        local result = {}
        local statusline = require("edgy-group.stl").get_statusline(position)
        for _, item in ipairs(statusline) do
          table.insert(result, { text = item })
          table.insert(result, { text = " ", link = "Normal" })
        end
        return result
      end
      return {
        options = {
          themable = true,

          show_buffer_close_icons = false,
          show_close_icon = false,
          show_tab_indicators = true,
          always_show_bufferline = true,

          name_formatter = function(buf)
            local short_name = vim.fn.fnamemodify(buf.name, ":t:r")
            return is_pinned(buf) and "" or short_name
          end,
          tab_size = 0,
          separator_style = { "", "" },
          indicator = {
            icon = "",
            style = "none",
          },
          diagnostics = false,
          diagnostics_update_in_insert = false,
          diagnostics_indicator = nil,
          groups = {
            items = {
              require("bufferline.groups").builtin.pinned:with({ icon = "󱂺" }),
            },
          },
          hover = { enabled = false },
          custom_filter = function(buf, buf_nums)
            -- Don't show gp.nvim buffers with filename: 2024-01-21.16-05-02.538
            local is_gp = vim.bo[buf].filetype == "markdown" and require("util.util").is_gp_file(vim.fn.bufname(buf))
            return not is_gp
          end,
        },
      }
    end,
  },
  {
    "Bekaboo/dropbar.nvim",
    config = function()
      require("config.plugins.status.dropbar")
    end,
    event = "BufReadPost",
    keys = {
      {
        "<leader>bq",
        function()
          require("dropbar.api").pick()
        end,
        desc = "Pick Dropbar Item",
      },
    },
  },
  {
    "b0o/incline.nvim",
    event = "VeryLazy",
    config = function()
      require("config.plugins.status.incline")
    end,
  },
  {
    "lewis6991/satellite.nvim",
    event = "BufReadPost",
    config = function()
      require("config.plugins.ui.satellite")
    end,
  },
  -- COLORS --
  {
    "brenoprata10/nvim-highlight-colors",
    event = "BufReadPost",
    opts = {
      render = "virtual",
    },
  },
  {
    "folke/tokyonight.nvim",
    event = "VeryLazy",
  },
  {
    "EdenEast/nightfox.nvim",
    event = "UiEnter",
    config = function()
      require("config.plugins.colorscheme.nightfox")
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    event = "VeryLazy",
    config = function()
      require("config.plugins.colorscheme.kanagawa")
    end,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    opts = {
      styles = {
        transparency = false,
      },
      highlight_groups = {
        TelescopeBorder = { fg = "highlight_high", bg = "none" },
        TelescopeNormal = { bg = "none" },
        TelescopePromptNormal = { bg = "base" },
        TelescopeResultsNormal = { fg = "subtle", bg = "none" },
        TelescopeSelection = { fg = "text", bg = "base" },
        TelescopeSelectionCaret = { fg = "rose", bg = "rose" },
      },
    },
    event = "VeryLazy",
  },
  {
    "sainnhe/gruvbox-material",
    event = "VeryLazy",
    config = function()
      vim.g.gruvbox_material_enable_italic = true
      -- vim.g.gruvbox_material_transparent_background = 2
    end,
  },
  {
    "diegoulloao/neofusion.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "xiyaowong/transparent.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "<leader>uP", "<Cmd>TransparentToggle<CR>", desc = "Toggle Transparent" },
    },
  },
  {
    "catppuccin/nvim",
    event = "VeryLazy",
  },
  {
    "fcancelinha/nordern.nvim",
    branch = "master",
    event = "VeryLazy",
  },
  {
    "yardnsm/nvim-base46",
    event = "VeryLazy",
    opts = {},
  },
}
