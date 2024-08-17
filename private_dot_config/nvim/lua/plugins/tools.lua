return {
  {
    "gbprod/yanky.nvim",
    keys = {
      { "<leader>p", false },
      {
        "<leader>fy",
        function()
          if LazyVim.pick.picker.name == "telescope" then
            require("telescope").extensions.yank_history.yank_history({})
          else
            vim.cmd([[YankyRingHistory]])
          end
        end,
        desc = "Open Yank History",
      },
    },
  },
  {
    "nvimtools/hydra.nvim",
    event = "VeryLazy",
    config = function()
      require("config.plugins.tools.hydra")
    end,
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<localleader>h", group = "+Hydra" },
      },
    },
  },
  {
    "jbyuki/venn.nvim",
    cmd = "VBox",
  },
  {
    "ecthelionvi/NeoComposer.nvim",
    dependencies = { "kkharji/sqlite.lua" },
    event = "VeryLazy",
    opts = {
      window = {
        border = "solid",
        winhl = {
          Normal = "NormalFloat",
          FloatBorder = "FloatBorder",
          FloatTitle = "FloatTitle",
        },
      },
      colors = {
        bg = "#26283f",
      },
      keymaps = {
        play_macro = "Q",
        yank_macro = "yq",
        stop_macro = "cq",
        toggle_record = "q",
        toggle_macro_menu = "<A-q>",
      },
    },
  },
  {
    "nmac427/guess-indent.nvim",
    opts = { auto_cmd = true },
    event = "VeryLazy",
  },
  {
    "tomiis4/Hypersonic.nvim",
    cmd = "Hypersonic",
    config = function()
      require("config.plugins.tools.hypersonic")
    end,
  },
  {
    "bennypowers/nvim-regexplainer",
    event = "VeryLazy",
    config = function()
      require("regexplainer").setup({
        mappings = {
          toggle = "gR",
        },
      })
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "MunifTanjim/nui.nvim",
    },
  },
  {
    "tzachar/highlight-undo.nvim",
    config = true,
    event = "VeryLazy",
  },
  {
    "gbprod/stay-in-place.nvim",
    config = true,
    event = "VeryLazy",
  },
  {
    "Wansmer/treesj",
    keys = {
      { "J", "<cmd>TSJToggle<cr>", desc = "Join Toggle" },
    },
    opts = { use_default_keymaps = false, max_join_length = 150 },
  },
  {
    "2kabhishek/nerdy.nvim",
    cmd = "Nerdy",
    keys = {
      { "<leader>ui", "<cmd>Telescope nerdy<cr>", desc = "Pick Icon" },
    },
  },
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },
  {
    "seandewar/bad-apple.nvim",
    cmd = "BadApple",
  },
  {
    "fazibear/screen_saviour.nvim",
    cmd = "ScreenSaviour",
  },
  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    event = "LazyFile",
    keys = {
      { "<leader>uH", "<cmd>Hardtime toggle<CR>", desc = "Toggle Hardtime" },
    },
    config = function()
      require("config.plugins.tools.hardtime")
    end,
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      preset = "helix", -- classic, modern, helix
      win = {
        wo = {
          winblend = 0,
        },
      },
      icons = {
        keys = {
          Space = " ",
        },
      },
      spec = {
        { "<leader>l", group = "+lazy" },
        { "<leader>p", group = "+project" },
      },
    },
  },
  {
    "epwalsh/obsidian.nvim",
    keys = {
      { "<leader>z", gruop = "obsidian" },
      { "<leader>zo", "<cmd>ObsidianOpen<CR>", desc = "Open on App" },
      { "<leader>zg", "<cmd>ObsidianSearch<CR>", desc = "Grep" },
      { "<leader>zO", "<cmd>ObsidianSearch<CR>", desc = "Obsidian Grep" },
      { "<leader>zn", "<cmd>ObsidianNew<CR>", desc = "New Note" },
      { "<leader>z<space>", "<cmd>ObsidianQuickSwitch<CR>", desc = "Find Files" },
      { "<leader>zb", "<cmd>ObsidianBacklinks<CR>", desc = "Backlinks" },
      { "<leader>zt", "<cmd>ObsidianTags<CR>", desc = "Tags" },
      { "<leader>zt", "<cmd>ObsidianTemplate<CR>", desc = "Template" },
      { "<leader>zl", "<cmd>ObsidianLink<CR>", desc = "Link" },
      { "<leader>zL", "<cmd>ObsidianLinks<CR>", desc = "Links" },
      { "<leader>zN", "<cmd>ObsidianLinkNew<CR>", desc = "New Link" },
      { "<leader>ze", "<cmd>ObsidianExtractNote<CR>", desc = "Extract Note" },
      { "<leader>zw", "<cmd>ObsidianWorkspace<CR>", desc = "Workspace" },
      { "<leader>zr", "<cmd>ObsidianRename<CR>", desc = "Rename" },
      { "<leader>zi", "<cmd>ObsidianPasteImg<CR>", desc = "Paste Image" },
      { "<leader>zd", "<cmd>ObsidianDailies<CR>", desc = "Daily Notes" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("config.plugins.tools.obsidian")
    end,
  },
  {
    "ravibrock/spellwarn.nvim",
    --stylua: ignore
    keys = { { "<leader>uS", function() require("spellwarn").toggle() end, mode = "n", desc = "Toggle spell warnings" } },
    opts = {
      enable = true,
      ft_default = "cursor",
      ft_config = {
        markdown = "iter",
        tex = "cursor",
        text = "iter",
      },
      severity = {
        spellcap = false,
        spelllocal = false,
        spellrare = false,
      },
    },
  },
  {
    "OXY2DEV/markview.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- Used by the code bloxks
    },
    config = function()
      require("markview").setup()
    end,
    enabled = false,
  },
  {
    "3rd/image.nvim",
    enabled = false,
    dependencies = {
      "leafo/magick",
    },
    event = "VeryLazy",
    opts = {},
  },
  {
    "ejrichards/mise.nvim",
    enabled = vim.fn.executable("mise") == 1,
    opts = {},
  },
  {
    "OXY2DEV/helpview.nvim",
    ft = "help",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
}
