-- bootstrap lazy.nvim ---------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- core options ----------------------------------------------------------------
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.updatetime = 200
vim.opt.signcolumn = "yes"

require("lazy").setup({
  -- Treesitter (syntax/indent)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "bash","python","yaml","toml","dockerfile","lua","json","markdown","ini"
      },
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts) require("nvim-treesitter.configs").setup(opts) end,
  },

  -- Picker: fzf-lua (fast, no telescope)
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- optional, nice icons
    config = function()
      local fzf = require("fzf-lua")
      fzf.setup({})
      vim.keymap.set("n","<leader>ff", fzf.files,     { desc="Find files" })
      vim.keymap.set("n","<leader>fg", fzf.live_grep, { desc="Grep (ripgrep)" })
      vim.keymap.set("n","<leader>fb", fzf.buffers,   { desc="Buffers" })
      vim.keymap.set("n","<leader>fh", fzf.help_tags, { desc="Help" })
    end,
  },

  -- File explorer: oil.nvim 
  {
  "stevearc/oil.nvim",
  -- Optional icons; pick one (mini.icons is very light)
  dependencies = {
    { "nvim-tree/nvim-web-devicons", lazy = true }, -- or { "nvim-mini/mini.icons", opts = {} }
  },
  -- Oil’s author discourages lazy-loading for reliability; keep lazy=false
  lazy = false,
  opts = {
    -- Keep netrw as the default explorer; open Oil on demand
    default_file_explorer = false,
    -- Show basic columns; remove "icon" if you don’t want icons
    columns = { "icon" },
    view_options = { show_hidden = false }, -- toggle in buffer via "g."
    keymaps = {
      -- Leave defaults; you’ll get: g? help, <CR> open, - up, g. toggle hidden, etc.
    },
  },
  config = function(_, opts)
    require("oil").setup(opts)
    -- Open parent directory of current file (Vinegar-style)
    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory (Oil)" })
    -- Optional: open Oil floating window
    vim.keymap.set("n", "<leader>o", "<CMD>Oil --float<CR>", { desc = "Oil (float)" })
  end,
 },

  -- Mason core (manages LSP/linters/formatters)
  { "williamboman/mason.nvim", config = function() require("mason").setup() end },

  -- Auto-install tools on startup (one-and-done per machine)
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- LSP servers
          "yaml-language-server",
          "bash-language-server",
          "pyright",
          "taplo",
          "dockerfile-language-server",
          "json-lsp",

          -- Linters/formatters
          "yamllint",
          "yamlfmt",
          "ruff",
          "shfmt",
          "prettier",
        },
        run_on_start = true,
        auto_update = false,
        start_delay = 100, -- ms after UI is ready
      })
    end,
  },

  -- Keep nvim-lspconfig in runtime for defaults (no .setup() calls)
  { "neovim/nvim-lspconfig" },

  -- JSON/YAML schemas to improve validation
  { "b0o/schemastore.nvim" },

  -- Formatting (Conform)
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        yaml = { "yamlfmt" },         -- or "prettier" if you prefer
        python = { "ruff_format" },   -- or "black"
        sh = { "shfmt" },
        toml = { "taplo" },
        json = { "prettier" },
        markdown = { "prettier" },
      },
      format_on_save = false,         -- stay explicit
    },
    config = function(_, opts)
      require("conform").setup(opts)
      vim.keymap.set({ "n","v" }, "<leader>f",
        function() require("conform").format({ async = true, lsp_fallback = true }) end,
        { desc = "Format buffer/selection" })
    end
  },

  -- On-demand linting
  {
    "mfussenegger/nvim-lint",
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        yaml = { "yamllint" },
        sh = { "shellcheck" },
        python = { "ruff" },
      }
      vim.keymap.set("n", "<leader>ll", function() lint.try_lint() end, { desc = "Run linter" })
    end
  },

  -- Git signs
  { "lewis6991/gitsigns.nvim", opts = {} },

  -- Discover keymaps
  { "folke/which-key.nvim", opts = {} },

  -- Autocomplete (nvim-cmp) — no snippets
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = { expand = function() end }, -- no snippet engine
        mapping = cmp.mapping.preset.insert({
          ["<CR>"]     = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"]= cmp.mapping.complete(),
          ["<C-n>"]    = cmp.mapping.select_next_item(),
          ["<C-p>"]    = cmp.mapping.select_prev_item(),
          ["<C-e>"]    = cmp.mapping.abort(),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "buffer" },
        },
        preselect = cmp.PreselectMode.Item,
      })
    end,
  },
})

-- =========================
-- LSP (new API, no .setup)
-- =========================

-- Global defaults/keys for any attached LSP
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(args)
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, desc = desc })
    end
    map("n","gd", vim.lsp.buf.definition,            "Goto def")
    map("n","gr", vim.lsp.buf.references,            "Refs")
    map("n","K",  vim.lsp.buf.hover,                 "Hover")
    map("n","<leader>rn", vim.lsp.buf.rename,        "Rename")
    map("n","<leader>ca", vim.lsp.buf.code_action,   "Code action")
    map("n","<leader>e",  vim.diagnostic.open_float, "Line diag")
  end,
})

-- Capabilities for cmp; disable snippet support
local caps = vim.lsp.protocol.make_client_capabilities()
local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok then caps = cmp_lsp.default_capabilities(caps) end
caps.textDocument.completion.completionItem.snippetSupport = false

-- Base config for all servers
vim.lsp.config('*', {
  capabilities = caps,
  root_markers = {
    ".git",
    "pyproject.toml", "requirements.txt", "setup.py",
    "ansible.cfg", ".yamllint",
    "docker-compose.yml", "Dockerfile",
  },
})

-- Per-server tweaks
vim.lsp.config('yamlls', {
  settings = {
    yaml = {
      keyOrdering = false,
      schemas = {
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
        ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] =
          "docker-compose*.y*ml",
      },
    },
  },
})
vim.lsp.config('bashls', {})
vim.lsp.config('pyright', {})
vim.lsp.config('taplo', {})      -- TOML
vim.lsp.config('dockerls', {})
vim.lsp.config('jsonls', {
  settings = { json = { schemas = (function()
    local ok2, s = pcall(require, "schemastore")
    return ok2 and s.json.schemas() or {}
  end)() } },
})

-- Enable the servers
vim.lsp.enable({ 'yamlls','bashls','pyright','taplo','dockerls','jsonls' })

