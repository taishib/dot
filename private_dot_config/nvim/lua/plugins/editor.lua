return {
  -- EDITING --
  {
    "gbprod/substitute.nvim",
    opts = {
      yank_substituted_text = true,
    },
    event = "VeryLazy",
    -- stylua: ignore
    keys = {
      { "U", "<cmd>lua require('substitute').operator()<cr>", mode = "n" },
      { "U", "<cmd>lua require('substitute').visual()<cr>", mode = "x" },
      { "UU", "<cmd>lua require('substitute').line()<cr>", mode = "n" },
      { "cX", "<cmd>lua require('substitute').eol()<cr>", mode = "n" },
      { "cx", "<cmd>lua require('substitute.exchange').operator()<CR>", mode = "n", { noremap = true } },
      { "cxx", "<cmd>lua require('substitute.exchange').line()<CR>", mode = "n", { noremap = true } },
      { "X", "<cmd>lua require('substitute.exchange').visual()<CR>", mode = "x", { noremap = true } },
      { "cxc", "<cmd>lua require('substitute.exchange').cancel()<CR>", mode = "n", { noremap = true } },
    },
  },
  -- TREESITTER --
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "RRethy/nvim-treesitter-endwise",
      "yioneko/nvim-yati",
      "RRethy/nvim-treesitter-textsubjects",
      "HiPhish/rainbow-delimiters.nvim",
    },
    config = function()
      require("config.plugins.editor.treesitter")
    end,
  },
  {
    "chrisgrieser/nvim-various-textobjs",
    opts = { useDefaultKeymaps = false },
    vscode = true,
    -- stylua: ignore
    keys = {
      { "im", ft = { "markdown", "toml" }, mode = { "o", "x" }, function() require("various-textobjs").mdlink("inner") end, desc = "Markdown Link" },
      { "am", ft = { "markdown", "toml" }, mode = { "o", "x" }, function() require("various-textobjs").mdlink("outer") end, desc = "Markdown Link" },
      { "iC", ft = { "markdown" }, mode = { "o", "x" }, function() require("various-textobjs").mdFencedCodeBlock("inner") end, desc = "CodeBlock" },
      { "aC", ft = { "markdown" }, mode = { "o", "x" }, function() require("various-textobjs").mdFencedCodeBlock("outer") end, desc = "CodeBlock" },
      { "ie", ft = { "markdown" }, mode = { "o", "x" }, function() require("various-textobjs").mdEmphasis("inner") end, desc = "Emphasis" },
      { "ae", ft = { "markdown" }, mode = { "o", "x" }, function() require("various-textobjs").mdEmphasis("outer") end, desc = "Emphasis" },
      { "gd", mode = { "o", "x" }, function() require("various-textobjs").diagnostics() end, desc = "Diagnostics" },
      { "iy", ft = { "python" }, mode = { "o", "x" }, function() require("various-textobjs").pyTripleQuotes("inner") end, desc = "Triple Quotes" },
      { "ay", ft = { "python" }, mode = { "o", "x" }, function() require("various-textobjs").pyTripleQuotes("outer") end, desc = "Triple Quotes" },
      { "iC", ft = { "css", "scss", "less" }, mode = { "o", "x" }, function() require("various-textobjs").cssSelector("inner") end, desc = "CSS Selector" },
      { "aC", ft = { "css", "scss", "less" }, mode = { "o", "x" }, function() require("various-textobjs").cssSelector("outer") end, desc = "CSS Selector" },
      { "i#", ft = { "css", "scss", "less" }, mode = { "o", "x" }, function() require("various-textobjs").cssColor("inner") end, desc = "CSS Color" },
      { "a#", ft = { "css", "scss", "less" }, mode = { "o", "x" }, function() require("various-textobjs").cssColor("outer") end, desc = "CSS Color" },
      { "iP", ft = { "sh" }, mode = { "o", "x" }, function() require("various-textobjs").shellPipe("inner") end, desc = "Pipe" },
      { "aP", ft = { "sh" }, mode = { "o", "x" }, function() require("various-textobjs").shellPipe("outer") end, desc = "Pipe" },
      {"iH", ft = { "html, xml, css, scss, less" }, mode = { "o", "x" },function() require("various-textobjs").htmlAttribute("inner") end, desc = "HTML Attribute", },
      { "iv", mode = { "o", "x" }, function() require("various-textobjs").value("inner") end, desc = "Value" },
      { "av", mode = { "o", "x" }, function() require("various-textobjs").value("outer") end, desc = "Value" },
      { "ik", mode = { "o", "x" }, function() require("various-textobjs").key("inner") end, desc = "Key" },
      { "ak", mode = { "o", "x" }, function() require("various-textobjs").key("outer") end, desc = "Key" },
      { "L", mode = { "o", "x" }, function() require("various-textobjs").url() end, desc = "Link" },
      { "iN", mode = { "o", "x" }, function() require("various-textobjs").number("inner") end, desc = "Number" },
      { "aN", mode = { "o", "x" }, function() require("various-textobjs").number("outer") end, desc = "Number" },
      { "gx", mode = "n",
        function()
          require("various-textobjs").url()
          local foundURL = vim.fn.mode():find("v")
          if foundURL then
            vim.cmd.normal('"zy')
            local url = vim.fn.getreg("z")
            vim.ui.open(url)
          else
            -- find all URLs in buffer
            local urlPattern = require("various-textobjs.charwise-textobjs").urlPattern
            local bufText = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
            local urls = {}
            for url in bufText:gmatch(urlPattern) do
              table.insert(urls, url)
            end
            if #urls == 0 then
              return
            end

            -- select one, use a plugin like dressing.nvim for nicer UI for
            -- `vim.ui.select`
            vim.ui.select(urls, { prompt = "Select URL:" }, function(choice)
              if choice then
                vim.ui.open(choice)
              end
            end)
          end
        end,
        { desc = "URL Opener" },
      },
    },
  },
  -- DEFAULT FEATURE EXTENSIONS --
  {
    "nacro90/numb.nvim",
    config = true,
    event = "CmdlineEnter",
  },
  {
    "utilyre/sentiment.nvim",
    event = "VeryLazy",
    opts = {
      delay = 30,
      pairs = {
        { "(", ")" },
        { "{", "}" },
        { "[", "]" },
      },
    },
  },
  -- FILE MANAGERS & FUZZY FINDERS --
  {
    "nvim-telescope/telescope.nvim",
    config = function()
      require("config.plugins.editor.telescope")
    end,
    -- event = "VeryLazy",
    cmd = "Telescope",
    dependencies = {
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-frecency.nvim",
    },
    keys = {
      {
        "<leader><space>",
        function()
          local telescope = require("telescope")

          local function telescope_buffer_dir()
            return vim.fn.expand("%:p:h")
          end

          telescope.extensions.file_browser.file_browser({
            path = "%:p:h",
            cwd = telescope_buffer_dir(),
            respect_gitignore = false,
            hidden = true,
            grouped = true,
            previewer = true,
            initial_mode = "insert",
          })
        end,
        desc = "File Browser",
      },
      {
        "<leader>fr",
        function()
          require("telescope").extensions.frecency.frecency({
            sorter = require("telescope").extensions.fzf.native_fzf_sorter(),
          })
        end,
        desc = "File frecency",
      },
      {
        "<leader>fo",
        "<cmd>Telescope oldfiles<cr>",
        desc = "Oldfiles",
      },
    },
  },
  {
    -- "ahmedkhalf/project.nvim",
    "LennyPhoenix/project.nvim",
    branch = "fix-get_clients",
    name = "project_nvim",
    event = "VeryLazy",
    config = function()
      require("config.plugins.tools.project")
    end,
    keys = {
      {
        "<leader>fp",
        "<cmd>Telescope projects<cr>",
        desc = "Projects",
      },
    },
  },
  {
    "ahmedkhalf/project.nvim",
    enabled = false,
  },
  {
    "stevearc/oil.nvim",
    config = function()
      require("config.plugins.editor.oil")
    end,
    cmd = "Oil",
    keys = {
      {
        "<leader>f;",
        "<cmd>Oil --float<cr>",
        desc = "Oil",
      },
    },
  },
  {
    "echasnovski/mini.pick",
    dependencies = {
      { "echasnovski/mini.extra", opts = {} },
      { "echasnovski/mini.visits", opts = {} },
      { "echasnovski/mini.fuzzy", opts = {} },
    },
    cmd = "Pick",
    event = "VeryLazy",
    config = function()
      require("config.plugins.editor.mini-pick")
    end,
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<localleader>p", group = "+Pick" },
      },
    },
  },
  -- SESSIONS --
  {
    "willothy/savior.nvim",
    config = true,
    event = { "InsertEnter", "TextChanged" },
  },
  -- TERMINAL --
  {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    config = function()
      require("config.plugins.terminal.toggleterm")
    end,
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>t", group = "+terminal/test" },
      },
    },
  },
  {
    "willothy/flatten.nvim",
    branch = "guest-data",
    lazy = false,
    priority = 1000,
    config = function()
      require("config.plugins.terminal.flatten")
    end,
  },
  -- NAVIGATION --
  {
    "folke/flash.nvim",
    config = function()
      require("config.plugins.navigation.flash")
    end,
  },
  {
    "ThePrimeagen/harpoon",
    -- commit = "a38be6e0dd4c6db66997deab71fc4453ace97f9c",
    branch = "harpoon2",
    config = function()
      require("config.plugins.navigation.harpoon")
    end,
  },
  {
    "nvimdev/dashboard-nvim",
    optional = true,
    opts = function(_, opts)
      -- stylua: ignore
      local arrow = {
        action = function()
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
        desc = " Marks",
        icon = "󰛢 ",
        key = "m",
      }

      arrow.desc = arrow.desc .. string.rep(" ", 43 - #arrow.desc)
      arrow.key_format = "  %s"

      table.insert(opts.config.center, 5, arrow)
    end,
  },
  {
    "cbochs/portal.nvim",
    config = function()
      require("config.plugins.navigation.portal")
    end,
    cmd = "Portal",
    keys = {
      {
        "<leader>jd",
        function()
          require("config.plugins.navigation.portal").diagnostics({
            buffer = vim.api.nvim_get_current_buf(),
          })
        end,
        { desc = "diagnostics" },
      },
      {
        "<leader>jr",
        function()
          require("config.plugins.navigation.portal").references({
            buffer = vim.api.nvim_get_current_buf(),
          })
        end,
        { desc = "references" },
      },
    },
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>j", group = "+jump" },
      },
    },
  },
  {
    "toppair/reach.nvim",
    opts = {
      show_current = true,
    },
    cmd = "ReachOpen",
  },
  {
    "chrisgrieser/nvim-spider",
    config = true,
  },
  {
    "haya14busa/vim-edgemotion",
    keys = {
      { "ej", "<Plug>(edgemotion-j)", mode = { "n", "v" } },
      { "ek", "<Plug>(edgemotion-k)", mode = { "n", "v" } },
    },
  },
  {
    "abecodes/tabout.nvim",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
    opts = {
      tabkey = "",
      backwards_tabkey = "",
      act_as_tab = true,
      ignore_beginning = true,
      act_as_shift_tab = false,
      default_tab = "",
      default_shift_tab = "",
    },
  },
  -- GIT --
  {
    "sindrets/diffview.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
    },
    cmd = {
      "DiffviewOpen",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewRefresh",
      "DiffviewFileHistory",
    },
    -- stylua: ignore
    keys = {
      { '<leader>gdg', '<cmd>DiffviewOpen<cr>', mode = { 'n', 'v' }, desc = 'Diffview Open' },
      { '<leader>gdq', '<cmd>diffoff<cr>', mode = { 'n' }, desc = 'diffoff' },
      { '<leader>gdF', '<cmd>0,$DiffviewFileHistory --follow<cr>', mode = { 'n' }, desc = 'Diffview Range File History' },
      { '<leader>gdf', '<cmd>DiffviewFileHistory --follow %<cr>', mode = { 'n' }, desc = 'Diffview File History' },
      { '<leader>gdf', ':DiffviewFileHistory<cr>', mode = { 'v' }, desc = 'Diffview File History' },
      { '<leader>gdd', '<cmd>DiffviewOpen --imply-local origin/develop...HEAD<cr>', mode = { 'n', 'v' }, desc = 'Diffview origin/develop...HEAD' },
      { '<leader>gdw', '<cmd>windo diffthis<cr>', mode = { 'n' }, desc = 'Windo diffthis' },
      { '<leader>gdo', '<cmd>diffthis<cr>', mode = { 'n', 'v' }, desc = 'diffthis' },
    },
    config = function()
      require("config.plugins.git.diffview")
    end,
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>gd", group = "+diffview" },
      },
    },
  },
  {
    "akinsho/git-conflict.nvim",
    config = function()
      require("config.plugins.git.git-conflict")
    end,
    event = "VeryLazy",
  },
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    config = function()
      require("config.plugins.git.neogit")
    end,
  },
  {
    "linrongbin16/gitlinker.nvim",
    opts = {
      message = true,
    },
    cmd = "GitLink",
  },
  {
    "isakbm/gitgraph.nvim",
    ---@type I.GGConfig
    opts = {
      symbols = {
        merge_commit = "M",
        commit = "*",
      },
      format = {
        timestamp = "%H:%M:%S %d-%m-%Y",
        fields = { "hash", "timestamp", "author", "branch_name", "tag" },
      },
      hooks = {
        -- Check diff of a commit
        on_select_commit = function(commit)
          vim.notify("DiffviewOpen " .. commit.hash .. "^!")
          vim.cmd(":DiffviewOpen " .. commit.hash .. "^!")
        end,
        -- Check diff from commit a -> commit b
        on_select_range_commit = function(from, to)
          vim.notify("DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
          vim.cmd(":DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
        end,
      },
    },
    --stylua: ignore
    keys = {
      { "<leader>gdl", function() require("gitgraph").draw({}, {all = true, max_count = 5000}) end, desc = "GitGraph - Draw" },
    },
  },
  -- MISC --
  {
    "johmsalas/text-case.nvim",
    config = function()
      require("textcase").setup({})
      require("telescope").load_extension("textcase")
    end,
    event = "VeryLazy",
    keys = {
      { "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "x" }, desc = "Telescope" },
    },
  },
  {
    "stevearc/quicker.nvim",
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {
      keys = {
        {
          ">",
          function()
            require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
            vim.api.nvim_win_set_height(0, math.min(20, vim.api.nvim_buf_line_count(0)))
          end,
          desc = "Expand quickfix context",
        },
        {
          "<",
          function()
            require("quicker").collapse()
            vim.api.nvim_win_set_height(0, math.max(4, math.min(10, vim.api.nvim_buf_line_count(0))))
          end,
          desc = "Collapse quickfix context",
        },
      },
    },
    keys = {
      {
        "<leader>rq",
        function()
          require("quicker").toggle({})
        end,
        desc = "Toggle [Q]uickfix",
      },
      {
        "<leader>rl",
        function()
          require("quicker").toggle({ loclist = true })
        end,
        desc = "Toggle [L]oclist",
      },
      {
        "<leader>rQ",
        function()
          vim.fn.setqflist({}, "a", {
            items = {
              {
                bufnr = vim.api.nvim_get_current_buf(),
                lnum = vim.api.nvim_win_get_cursor(0)[1],
                text = vim.api.nvim_get_current_line(),
              },
            },
          })
        end,
        desc = "Add to [Q]uickfix",
      },
    },
  },
  {
    "gabrielpoca/replacer.nvim",
    opts = { rename_files = false },
    keys = {
      {
        "<leader>rh",
        function()
          require("replacer").run()
        end,
        desc = "run replacer.nvim",
      },
    },
  },
}
