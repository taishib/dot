local Hydra = require("hydra")

local venn_hint_utf = [[
 Arrow^^^^^^  Select region with <C-v>^^^^^^
 ^ ^ _K_ ^ ^  _f_: Surround with box ^ ^ ^ ^
 _H_ ^ ^ _L_  _<C-h>_: ◄, _<C-j>_: ▼
 ^ ^ _J_ ^ ^  _<C-k>_: ▲, _<C-l>_: ► _<C-c>_
]]

-- :setlocal ve=all
-- :setlocal ve=none
Hydra({
  name = "Draw Utf-8 Venn Diagram",
  hint = venn_hint_utf,
  config = {
    color = "pink",
    invoke_on_body = true,
    on_enter = function()
      vim.wo.virtualedit = "all"
    end,
  },
  mode = "n",
  body = "<localleader>he",
  heads = {
    { "<C-h>", "xi<C-v>u25c4<Esc>" }, -- mode = 'v' somehow breaks
    { "<C-j>", "xi<C-v>u25bc<Esc>" },
    { "<C-k>", "xi<C-v>u25b2<Esc>" },
    { "<C-l>", "xi<C-v>u25ba<Esc>" },
    { "H", "<C-v>h:VBox<CR>" },
    { "J", "<C-v>j:VBox<CR>" },
    { "K", "<C-v>k:VBox<CR>" },
    { "L", "<C-v>l:VBox<CR>" },
    { "f", ":VBox<CR>", { mode = "v" } },
    { "<C-c>", nil, { exit = true } },
  },
})

local venn_hint_ascii = [[
 -| moves: _H_ _J_ _K_ _L_
 <v^> arrow: _<C-h>_ _<C-j>_ _<C-k>_ _<C-l>_
 diagnoal + move: localleader + clockwise like ◄ ▲
 _<localleader>jh_ _<localleader>hk_ _<localleader>lj_ _<localleader>kl_
 diagnoal + nomove: anticlockwise like ▲ + ◄
 _<localleader>hj_ _<localleader>kh_ _<localleader>jl_ _<localleader>lk_
 set +: _<localleader>n_
 rectangle move + arrow, ie ► with ->
 _<localleader>h_ _<localleader>j_ _<localleader>k_ _<localleader>l_
                              _<C-c>_
]]
-- _F_: surround^^   _f_: surround     ^^ ^
-- + corners ^  ^^   overwritten corners

Hydra({
  name = "Draw Ascii Diagram",
  hint = venn_hint_ascii,
  config = {
    color = "pink",
    invoke_on_body = true,
    on_enter = function()
      vim.wo.virtualedit = "all"
    end,
  },
  mode = "n",
  body = "<localleader>ha",
  heads = {
    { "<C-h>", "r<" },
    { "<C-j>", "rv" },
    { "<C-k>", "r^" },
    { "<C-l>", "r>" },
    { "H", "r-h" },
    { "J", "r|j" },
    { "K", "r|k" },
    { "L", "r-l" },
    { "<localleader>jh", "r/hj" },
    { "<localleader>hj", "r/" },
    { "<localleader>hk", "r\\hk" },
    { "<localleader>kh", "r\\" },
    { "<localleader>lj", "r\\jl" },
    { "<localleader>jl", "r\\" },
    { "<localleader>kl", "r/kl" },
    { "<localleader>lk", "r/" },
    { "<localleader>n", "r+" },
    { "<localleader>h", "r-hr<" },
    { "<localleader>j", "r|jrv" },
    { "<localleader>k", "r|kr^" },
    { "<localleader>l", "r-lr>" },

    { "<C-c>", nil, { exit = true } },
  },
})

local gitsigns = require("gitsigns")
local hint = [[
 _J_: next hunk   _s_: stage hunk        _d_: show deleted   _b_: blame line
 _K_: prev hunk   _u_: undo last stage   _p_: preview hunk   _B_: blame show full 
 ^ ^              _S_: stage buffer      ^ ^                 _/_: show base file
 ^
 ^ ^              _<Enter>_: Neogit              _q_: exit
]]
Hydra({
  name = "Git",
  hint = hint,
  config = {
    -- buffer = bufnr,
    color = "amaranth",
    invoke_on_body = true,
    on_key = function()
      vim.wait(50)
    end,
    on_enter = function()
      vim.cmd("mkview")
      vim.cmd("silent! %foldopen!")
      gitsigns.toggle_signs(true)
      gitsigns.toggle_linehl(true)
    end,
    on_exit = function()
      local cursor_pos = vim.api.nvim_win_get_cursor(0)
      vim.cmd("loadview")
      vim.api.nvim_win_set_cursor(0, cursor_pos)
      vim.cmd("normal zv")
      gitsigns.toggle_signs(false)
      gitsigns.toggle_linehl(false)
      gitsigns.toggle_deleted(false)
    end,
  },
  mode = { "n", "x" },
  body = "<localleader>hg",
  heads = {
    {
      "J",
      function()
        if vim.wo.diff then
          return "]c"
        end
        vim.schedule(function()
          gitsigns.next_hunk()
        end)
        return "<Ignore>"
      end,
      { expr = true, desc = "next hunk" },
    },
    {
      "K",
      function()
        if vim.wo.diff then
          return "[c"
        end
        vim.schedule(function()
          gitsigns.prev_hunk()
        end)
        return "<Ignore>"
      end,
      { expr = true, desc = "prev hunk" },
    },
    {
      "s",
      function()
        local mode = vim.api.nvim_get_mode().mode:sub(1, 1)
        if mode == "V" then -- visual-line mode
          local esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)
          vim.api.nvim_feedkeys(esc, "x", false) -- exit visual mode
          vim.cmd("'<,'>Gitsigns stage_hunk")
        else
          vim.cmd("Gitsigns stage_hunk")
        end
      end,
      { desc = "stage hunk" },
    },
    { "u", gitsigns.undo_stage_hunk, { desc = "undo last stage" } },
    { "S", gitsigns.stage_buffer, { desc = "stage buffer" } },
    { "p", gitsigns.preview_hunk, { desc = "preview hunk" } },
    { "d", gitsigns.toggle_deleted, { nowait = true, desc = "toggle deleted" } },
    { "b", gitsigns.blame_line, { desc = "blame" } },
    {
      "B",
      function()
        gitsigns.blame_line({ full = true })
      end,
      { desc = "blame show full" },
    },
    { "/", gitsigns.show, { exit = true, desc = "show base file" } }, -- show the base of the file
    {
      "<Enter>",
      function()
        vim.cmd("Neogit")
      end,
      { exit = true, desc = "Neogit" },
    },
    { "q", nil, { exit = true, nowait = true, desc = "exit" } },
  },
})

local selmove_hint = [[
 Arrow^^^^^^
 ^ ^ _k_ ^ ^
 _h_ ^ ^ _l_
 ^ ^ _j_ ^ ^                      _<C-c>_
]]

local ok_minimove, minimove = pcall(require, "mini.move")
assert(ok_minimove)
if ok_minimove == true then
  local opts = {
    mappings = {
      left = "",
      right = "",
      down = "",
      up = "",
      line_left = "",
      line_right = "",
      line_down = "",
      line_up = "",
    },
  }
  minimove.setup(opts)
  -- setup here prevents needless global vars for opts required by `move_selection()/moveline()`
  Hydra({
    name = "Move Box Selection",
    hint = selmove_hint,
    config = {
      color = "pink",
      invoke_on_body = true,
    },
    mode = "v",
    body = "<localleader>hb",
    heads = {
      {
        "h",
        function()
          minimove.move_selection("left", opts)
        end,
      },
      {
        "j",
        function()
          minimove.move_selection("down", opts)
        end,
      },
      {
        "k",
        function()
          minimove.move_selection("up", opts)
        end,
      },
      {
        "l",
        function()
          minimove.move_selection("right", opts)
        end,
      },
      { "<C-c>", nil, { exit = true } },
    },
  })
  Hydra({
    name = "Move Line Selection",
    hint = selmove_hint,
    config = {
      color = "pink",
      invoke_on_body = true,
    },
    mode = "n",
    body = "<localleader>hl",
    heads = {
      {
        "h",
        function()
          minimove.move_line("left", opts)
        end,
      },
      {
        "j",
        function()
          minimove.move_line("down", opts)
        end,
      },
      {
        "k",
        function()
          minimove.move_line("up", opts)
        end,
      },
      {
        "l",
        function()
          minimove.move_line("right", opts)
        end,
      },
      { "<C-c>", nil, { exit = true } },
    },
  })
end

local cmd = require("hydra.keymap-util").cmd
local hint = [[
                 _f_: files       _m_: marks
   🭇🬭🬭🬭🬭🬭🬭🬭🬭🬼    _o_: old files   _g_: live grep
  🭉🭁🭠🭘    🭣🭕🭌🬾   _p_: projects    _/_: search in file
  🭅█ ▁     █🭐
  ██🬿      🭊██   _r_: resume      _u_: undotree
 🭋█🬝🮄🮄🮄🮄🮄🮄🮄🮄🬆█🭀  _h_: vim help    _c_: execute command
 🭤🭒🬺🬹🬱🬭🬭🬭🬭🬵🬹🬹🭝🭙  _k_: keymaps     _;_: commands history 
                 _O_: options     _?_: search history
 ^
                 _<Enter>_: Telescope           _<Esc>_
]]

Hydra({
  name = "Telescope",
  hint = hint,
  config = {
    color = "teal",
    invoke_on_body = true,
    hint = {
      position = "middle",
    },
  },
  mode = "n",
  body = "<localleader>hf",
  heads = {
    { "f", cmd("Telescope find_files") },
    { "g", cmd("Telescope live_grep") },
    { "o", cmd("Telescope oldfiles"), { desc = "recently opened files" } },
    { "h", cmd("Telescope help_tags"), { desc = "vim help" } },
    { "m", cmd("MarksListBuf"), { desc = "marks" } },
    { "k", cmd("Telescope keymaps") },
    { "O", cmd("Telescope vim_options") },
    { "r", cmd("Telescope resume") },
    { "p", cmd("Telescope projects"), { desc = "projects" } },
    { "/", cmd("Telescope current_buffer_fuzzy_find"), { desc = "search in file" } },
    { "?", cmd("Telescope search_history"), { desc = "search history" } },
    { ";", cmd("Telescope command_history"), { desc = "command-line history" } },
    { "c", cmd("Telescope commands"), { desc = "execute command" } },
    { "u", cmd("silent! %foldopen! | UndotreeToggle"), { desc = "undotree" } },
    { "<Enter>", cmd("Telescope"), { exit = true, desc = "list all pickers" } },
    { "<Esc>", nil, { exit = true, nowait = true } },
  },
})

local hint = [[
  ^ ^        Options
  ^
  _v_ %{ve} virtual edit
  _i_ %{list} invisible characters  
  _s_ %{spell} spell
  _w_ %{wrap} wrap
  _c_ %{cul} cursor line
  _n_ %{nu} number
  _r_ %{rnu} relative number
  ^
       ^^^^                _<Esc>_
]]

Hydra({
  name = "Options",
  hint = hint,
  config = {
    color = "amaranth",
    invoke_on_body = true,
    hint = {
      position = "bottom-left",
    },
  },
  mode = { "n", "x" },
  body = "<localleader>ho",
  heads = {
    {
      "n",
      function()
        if vim.o.number == true then
          vim.o.number = false
        else
          vim.o.number = true
        end
      end,
      { desc = "number" },
    },
    {
      "r",
      function()
        if vim.o.relativenumber == true then
          vim.o.relativenumber = false
        else
          vim.o.number = true
          vim.o.relativenumber = true
        end
      end,
      { desc = "relativenumber" },
    },
    {
      "v",
      function()
        if vim.o.virtualedit == "all" then
          vim.o.virtualedit = "block"
        else
          vim.o.virtualedit = "all"
        end
      end,
      { desc = "virtualedit" },
    },
    {
      "i",
      function()
        if vim.o.list == true then
          vim.o.list = false
        else
          vim.o.list = true
        end
      end,
      { desc = "show invisible" },
    },
    {
      "s",
      function()
        if vim.o.spell == true then
          vim.o.spell = false
        else
          vim.o.spell = true
        end
      end,
      { exit = true, desc = "spell" },
    },
    {
      "w",
      function()
        if vim.o.wrap ~= true then
          vim.o.wrap = true
          -- Dealing with word wrap:
          -- If cursor is inside very long line in the file than wraps
          -- around several rows on the screen, then 'j' key moves you to
          -- the next line in the file, but not to the next row on the
          -- screen under your previous position as in other editors. These
          -- bindings fixes this.
          vim.keymap.set("n", "k", function()
            return vim.v.count > 0 and "k" or "gk"
          end, { expr = true, desc = "k or gk" })
          vim.keymap.set("n", "j", function()
            return vim.v.count > 0 and "j" or "gj"
          end, { expr = true, desc = "j or gj" })
        else
          vim.o.wrap = false
          vim.keymap.del("n", "k")
          vim.keymap.del("n", "j")
        end
      end,
      { desc = "wrap" },
    },
    {
      "c",
      function()
        if vim.o.cursorline == true then
          vim.o.cursorline = false
        else
          vim.o.cursorline = true
        end
      end,
      { desc = "cursor line" },
    },
    { "<Esc>", nil, { exit = true } },
  },
})

local shared = require("nvim-treesitter.textobjects.shared")
local swap = require("nvim-treesitter.textobjects.swap")
local ts_utils = require("nvim-treesitter.ts_utils")

local queries = {
  "@parameter.inner",
  "@argument.inner",
  "@property.inner",
  "@function.outer",
  "@method.outer",
}
local current_query = 1
local query_string = queries[current_query]

local function get_or_create_namespace()
  return vim.api.nvim_create_namespace("hydra_swap_hl_node")
end

local function clear_highlight()
  local hl_ns = get_or_create_namespace()
  vim.api.nvim_buf_clear_namespace(0, hl_ns, 0, -1)
end

local function update_highlight(range)
  local hl_ns = get_or_create_namespace()
  local hl_group = "IncSearch"
  local start = { range[1], range[2] }
  local finish = { range[3], range[4] }
  vim.highlight.range(0, hl_ns, hl_group, start, finish)
end

local function set_cursor_on_node(node)
  local row, col, _ = node:start()
  vim.api.nvim_win_set_cursor(0, { row + 1, col })
end

local function choose_adjacent(forward)
  local _, _, node = shared.textobject_at_point(query_string)
  if not node then
    return
  end

  node = shared.get_adjacent(forward, node, query_string, nil, true)
  if not node then
    return
  end

  set_cursor_on_node(node)
  clear_highlight()
end

local function get_siblings_for_edit(node)
  local ranges, texts = {}, {}
  for sibling in node:parent():iter_children() do
    if sibling:named() then
      ranges[#ranges + 1] = ts_utils.node_to_lsp_range(sibling)
      texts[#texts + 1] = vim.treesitter.get_node_text(sibling, 0)
    end
  end
  return ranges, texts
end

local function sort_nodes(reverse)
  local _, _, node = shared.textobject_at_point(query_string)
  if not node then
    return
  end

  local ranges, texts = get_siblings_for_edit(node)

  table.sort(texts, function(a, b)
    if reverse then
      return a > b
    end
    return a < b
  end)

  local edits = {}
  for i, range in ipairs(ranges) do
    edits[#edits + 1] = { range = range, newText = texts[i] }
  end

  vim.lsp.util.apply_text_edits(edits, 0, "utf-8")

  clear_highlight()
end

local function reverse_nodes()
  local _, _, node = shared.textobject_at_point(query_string)
  if not node then
    return
  end

  local ranges, texts = get_siblings_for_edit(node)

  local edits = {}
  for i, range in ipairs(ranges) do
    edits[#edits + 1] = { range = range, newText = texts[#texts + 1 - i] }
  end

  vim.lsp.util.apply_text_edits(edits, 0, "utf-8")

  clear_highlight()
end

local swap_hint = [[
 query: %{query}

 select^^     swap^^        _s_: sort
 _k_: next    _K_: next     _S_: sort rev.
 _j_: prev    _J_: prev     _r_: reverse

 _<Tab>_: switch query
 _<Enter>_: edit query
 _<Esc>_, _q_: quit
]]

Hydra({
  name = "Swap",
  mode = "n",
  body = "<localleader>hs",
  hint = swap_hint,
  short_name = "S󰅩",
  config = {
    desc = "swap",
    hint = {
      position = "bottom-left",
      funcs = {
        query = function()
          return query_string
        end,
      },
    },
    invoke_on_body = true,
    on_enter = function()
      local _, range, _ = shared.textobject_at_point(query_string)
      if not range then
        return
      end

      update_highlight(range)
    end,
    on_key = function()
      local _, range, _ = shared.textobject_at_point(query_string)
      if not range then
        return
      end

      update_highlight(range)
    end,
    on_exit = clear_highlight,
  },
  heads = {
    {
      "j",
      function()
        choose_adjacent(true)
      end,
      { desc = "choose" },
    },
    {
      "k",
      function()
        choose_adjacent(false)
      end,
      { desc = "choose" },
    },
    {
      "J",
      function()
        swap.swap_next(query_string)
      end,
      { desc = "swap" },
    },
    {
      "K",
      function()
        swap.swap_previous(query_string)
      end,
      { desc = "swap" },
    },
    {
      "s",
      function()
        sort_nodes(false)
      end,
    },
    {
      "S",
      function()
        sort_nodes(true)
      end,
      { desc = "sort" },
    },
    {
      "r",
      function()
        reverse_nodes()
      end,
      { desc = "reverse" },
    },
    {
      "<Enter>",
      function()
        query_string = vim.fn.input("query: ", query_string)
        vim.cmd.redraw({ bang = true })
        clear_highlight()
      end,
      { desc = "edit query" },
    },
    {
      "<Tab>",
      function()
        current_query = current_query + 1
        if current_query > #queries then
          current_query = 1
        end
        query_string = queries[current_query]
        clear_highlight()
      end,
      { desc = "switch query" },
    },
    { "<Esc>", nil, { exit = true } },
    { "q", nil, { exit = true } },
  },
})
