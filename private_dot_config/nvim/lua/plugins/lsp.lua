return {
  -- LSP SERVERS
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "stylua",
        "selene",
        "luacheck",
        "shellcheck",
        "shfmt",
        "tailwindcss-language-server",
        "typescript-language-server",
        "css-lsp",
        "harper-ls",
        "markdown-oxide",
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      ---@type lspconfig.options
      servers = {
        cssls = {},
        tsserver = {
          root_dir = function(...)
            return require("lspconfig.util").root_pattern(".git")(...)
          end,
          single_file_support = false,
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "literal",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },
        html = {},
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
            },
          },
        },
        lua_ls = {
          -- enabled = false,
          single_file_support = true,
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                workspaceWord = true,
                callSnippet = "Both",
              },
              misc = {
                parameters = {
                  -- "--log-level=trace",
                },
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
              doc = {
                privateName = { "^_" },
              },
              type = {
                castNumberToInteger = true,
              },
              diagnostics = {
                disable = { "incomplete-signature-doc", "trailing-space" },
                -- enable = false,
                groupSeverity = {
                  strong = "Warning",
                  strict = "Warning",
                },
                groupFileStatus = {
                  ["ambiguity"] = "Opened",
                  ["await"] = "Opened",
                  ["codestyle"] = "None",
                  ["duplicate"] = "Opened",
                  ["global"] = "Opened",
                  ["luadoc"] = "Opened",
                  ["redefined"] = "Opened",
                  ["strict"] = "Opened",
                  ["strong"] = "Opened",
                  ["type-check"] = "Opened",
                  ["unbalanced"] = "Opened",
                  ["unused"] = "Opened",
                },
                unusedLocalExclude = { "_*" },
              },
              format = {
                enable = false,
                defaultConfig = {
                  indent_style = "space",
                  indent_size = "2",
                  continuation_indent_size = "2",
                },
              },
            },
          },
        },
        harper_ls = {},
        markdown_oxide = {},
      },
    },
  },
  -- DEVELOPMENT & TESTING --
  {
    "mangelozzi/nvim-rgflow.lua",
    config = function()
      require("config.plugins.editor.rgflow")
    end,
    -- stylua: ignore
    keys = {
      { "<Leader>rG", function() require("rgflow").open() end, desc = "Rgflow open blank" },
      { "<Leader>rg", function() require("rgflow").open_cword() end, desc = "Rgflow open cword" },
      { "<Leader>ra", function() require("rgflow").open_again() end, desc = "Rgflow open again" },
      { "<Leader>rx", function() require("rgflow").abort() end, desc = "Rgflow abort" },
      { "<Leader>rC", function() require("rgflow").print_cmd() end, desc = "Rgflow print cmd" },
      { "<Leader>r?", function() require("rgflow").print_status() end, desc = "Rgflow print status" },
      { "<Leader>rg", function() require("rgflow").open_visual() end, mode = "x", desc = "Rgflow open visual" },
    },
  },
  {
    "chrisgrieser/nvim-rip-substitute",
    opts = {},
    -- stylua: ignore
    keys = {
      { "gs", function() require("rip-substitute").sub() end, mode = { "n", "x" } },
    },
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
  },
  -- LSP UI --
  {
    "j-hui/fidget.nvim",
    config = function()
      require("config.plugins.ui.fidget")
    end,
    event = "LspAttach",
  },
  {
    "aznhe21/actions-preview.nvim",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "<leader>ca", false }
    end,
    event = "LspAttach",
    opts = {
      telescope = {
        sorting_strategy = "ascending",
        layout_strategy = "vertical",
        layout_config = {
          width = 0.6,
          height = 0.7,
          prompt_position = "top",
          preview_cutoff = 20,
          preview_height = function(_, _, max_lines)
            return max_lines - 15
          end,
        },
      },
    },
    --stylua: ignore
    keys = {
      { "<leader>ca", function() require("actions-preview").code_actions() end, mode = { "n", "v" }, desc = "Code Action Preview" },
    },
    enabled = false,
  },
  {
    "Chaitanyabsprip/fastaction.nvim",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "<leader>ca", false }
    end,
    event = "LspAttach",
    opts = {},
    --stylua: ignore
    keys = {
      { "<leader>ca", '<cmd>lua require("fastaction").code_action()<CR>', mode = { "n" }, desc = "Code Action Preview" },
      { "<leader>ca", "<esc><cmd>lua require('fastaction').range_code_action()<CR>", mode = { "v" }, desc = "Code Action Preview" },
    },
  },
  {
    "dnlhc/glance.nvim",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "gd", false }
      keys[#keys + 1] = { "gr", false }
      keys[#keys + 1] = { "gy", false }
      keys[#keys + 1] = { "gI", false }
    end,
    cmd = { "Glance" },
    opts = {
      border = {
        enable = true,
      },
      use_trouble_qf = true,
      hooks = {
        before_open = function(results, open, jump, method)
          local uri = vim.uri_from_bufnr(0)
          if #results == 1 then
            local target_uri = results[1].uri or results[1].targetUri

            if target_uri == uri then
              jump(results[1])
            else
              open(results)
            end
          else
            open(results)
          end
        end,
      },
    },
    keys = {
      { "gd", "<CMD>Glance definitions<CR>", desc = "Goto Definition" },
      { "gr", "<CMD>Glance references<CR>", desc = "References" },
      { "gy", "<CMD>Glance type_definitions<CR>", desc = "Goto t[y]pe definitions" },
      { "gI", "<CMD>Glance implementations<CR>", desc = "Goto implementations" },
    },
  },
  {
    "zbirenbaum/neodim",
    event = "LspAttach",
    opts = {
      alpha = 0.60,
    },
  },
  -- DIAGNOSTICS & FORMATTING --
  {
    "dgagn/diagflow.nvim",
    -- "willothy/diagflow.nvim",
    config = function()
      require("config.plugins.lsp.diagflow")
    end,
    event = "DiagnosticChanged",
  },
  -- COMPLETION --
  {
    "hrsh7th/nvim-cmp",
    -- "willothy/nvim-cmp",
    -- dir = "~/projects/lua/nvim-cmp/",
    dependencies = {
      "hrsh7th/cmp-cmdline",
      "dmitmel/cmp-cmdline-history",
    },
    event = { "CmdlineEnter", "InsertEnter" },
    opts = function(_, opts)
      table.insert(opts.sources, {
        name = "nvim_lsp",
        option = {
          markdown_oxide = {
            keyword_pattern = [[\(\k\| \|\/\|#\)\+]],
          },
        },
      })
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
      opts.mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline({
          --stylua: ignore
          ["<C-n>"] = { c = function(fallback) if cmp.visible() then cmp.select_next_item() else fallback() end end },
        }),
        sources = cmp.config.sources({
          { name = "cmdline", group_index = 0 },
          { name = "path", group_index = 0 },
          { name = "copilot", group_index = 0 },
          { name = "cmdline_history", group_index = 1 },
        }),
        formatting = format,
      })
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline({
        --stylua: ignore
        ["<C-n>"] = { c = function(fallback) if cmp.visible() then cmp.select_next_item() else fallback() end end },
        }),
        sources = {
          { name = "buffer" },
        },
      })
    end,
  },
  {
    "altermo/ultimate-autopair.nvim",
    event = { "InsertEnter", "CmdlineEnter" },
    branch = "v0.6", --recommended as each new version will have breaking changes
    opts = {},
  },
  {
    "echasnovski/mini.pairs",
    enabled = false,
  },
  {
    "kylechui/nvim-surround",
    config = true,
    event = "InsertEnter",
    enabled = false,
  },
  {
    "roobert/surround-ui.nvim",
    event = "InsertEnter",
    dependencies = {
      "kylechui/nvim-surround",
      "folke/which-key.nvim",
    },
    config = function()
      require("surround-ui").setup({
        root_key = "S",
      })
    end,
    enabled = false,
  },
  {
    "zeioth/garbage-day.nvim",
    event = "LspAttach",
    opts = {
      notifications = true,
      grace_period = 60 * 10,
    },
  },
}
