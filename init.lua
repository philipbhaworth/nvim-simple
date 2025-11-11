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
vim.opt.relativenumber = false
vim.opt.termguicolors = true
vim.opt.updatetime = 200
vim.opt.signcolumn = "yes"

-- Tab/indentation settings
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.smartindent = true

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Mouse support
vim.opt.mouse = "a"

-- Command-line completion
vim.opt.wildmode = "longest:full,full"

-- Disable backup files
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- Filetype-specific overrides
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- Core keymaps ----------------------------------------------------------------
-- Clear search highlight
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Quick save/quit
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>x", "<cmd>wq<CR>", { desc = "Save and quit" })

-- Buffer navigation
vim.keymap.set("n", "<leader>bd", "<cmd>bd<CR>", { desc = "Close buffer" })
vim.keymap.set("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Previous buffer" })

-- Better split navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom split" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top split" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

-- Diagnostic navigation
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })

-- Terminal toggle
vim.keymap.set("n", "<leader>t", function()
  vim.cmd("split | terminal")
  vim.cmd("resize 15")
  vim.cmd("startinsert")
end, { desc = "Open terminal split" })

-- Easy terminal exit
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Plugin setup ----------------------------------------------------------------
require("lazy").setup({
  -- Colorschemes
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    config = function()
      require('kanagawa').setup({
        compile = false,
        undercurl = true,
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = false,
        dimInactive = false,
        terminalColors = true,
        colors = {
          theme = {
            all = {
              ui = {
                bg_gutter = "none"  -- Remove gutter background
              }
            }
          }
        },
        overrides = function(colors)
          local theme = colors.theme
          return {
            -- Transparent floating windows
            NormalFloat = { bg = "none" },
            FloatBorder = { bg = "none" },
            FloatTitle = { bg = "none" },
            
            -- Darker background for terminal/special windows
            NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
            
            -- Plugin-specific overrides
            LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            
            -- Better completion menu
            Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
            PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
            PmenuSbar = { bg = theme.ui.bg_m1 },
            PmenuThumb = { bg = theme.ui.bg_p2 },
          }
        end,
        theme = "wave",  -- Default: "wave", "dragon" for dark, "lotus" for light
        background = {
          dark = "wave",   -- or "dragon" for a different dark variant
          light = "lotus"
        },
      })
      
      vim.cmd.colorscheme("kanagawa")
    end,
  },
  
  -- Alternative colorscheme (uncomment to use instead of kanagawa)
  -- {
  --   "KijitoraFinch/nanode.nvim",
  --   priority = 1000,
  --   config = function()
  --     require("nanode").setup({
  --       transparent = false,
  --     })
  --     vim.cmd.colorscheme("nanode")
  --   end,
  -- },
  -- Treesitter (syntax/indent)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "bash", "python", "yaml", "toml", "dockerfile", "lua", "json", "markdown", "ini",
        "regex", "vim", "gitcommit", "diff",
      },
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts) require("nvim-treesitter.configs").setup(opts) end,
  },

  -- Picker: fzf-lua (fast, no telescope)
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local fzf = require("fzf-lua")
      fzf.setup({})
      vim.keymap.set("n", "<leader>ff", fzf.files,     { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "Grep (ripgrep)" })
      vim.keymap.set("n", "<leader>fb", fzf.buffers,   { desc = "Buffers" })
      vim.keymap.set("n", "<leader>fh", fzf.help_tags, { desc = "Help" })
    end,
  },

  -- File explorer: oil.nvim 
  {
    "stevearc/oil.nvim",
    dependencies = {
      { "nvim-tree/nvim-web-devicons", lazy = true },
    },
    lazy = false,
    opts = {
      default_file_explorer = false,
      columns = { "icon", "permissions", "size" },
      view_options = {
        show_hidden = true,
        is_hidden_file = function(name, bufnr)
          return vim.startswith(name, ".")
        end,
        is_always_hidden = function(name, bufnr)
          return name == ".." or name == ".git"
        end,
      },
      keymaps = {
        ["<C-v>"] = "actions.select_vsplit",
        ["<C-x>"] = "actions.select_split",
      },
    },
    config = function(_, opts)
      require("oil").setup(opts)
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory (Oil)" })
      vim.keymap.set("n", "<leader>o", "<CMD>Oil --float<CR>", { desc = "Oil (float)" })
    end,
  },

  -- Comments
  {
    "numToStr/Comment.nvim",
    opts = {},
    keys = {
      { "gcc", mode = "n", desc = "Comment line" },
      { "gc", mode = "v", desc = "Comment selection" },
      { "<leader>/", mode = { "n", "v" }, desc = "Toggle comment" },
    },
  },

  -- Mason core (manages LSP/linters/formatters)
  { "williamboman/mason.nvim", config = function() require("mason").setup() end },

  -- Auto-install tools on startup
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
          "ansible-language-server",

          -- Linters/formatters
          "yamllint",
          "yamlfmt",
          "ruff",
          "shfmt",
          "prettier",
          "ansible-lint",
        },
        run_on_start = true,
        auto_update = false,
        start_delay = 100,
      })
    end,
  },

  -- Keep nvim-lspconfig in runtime for defaults
  { "neovim/nvim-lspconfig" },

  -- JSON/YAML schemas
  { "b0o/schemastore.nvim" },

  -- Formatting (Conform)
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        yaml = { "yamlfmt" },
        python = { "ruff_format" },
        sh = { "shfmt" },
        toml = { "taplo" },
        json = { "prettier" },
        markdown = { "prettier" },
      },
      format_on_save = false,
    },
    config = function(_, opts)
      require("conform").setup(opts)
      vim.keymap.set({ "n", "v" }, "<leader>f",
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
        ansible = { "ansible_lint" },
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
        snippet = { expand = function() end },
        mapping = cmp.mapping.preset.insert({
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-n>"]     = cmp.mapping.select_next_item(),
          ["<C-p>"]     = cmp.mapping.select_prev_item(),
          ["<C-e>"]     = cmp.mapping.abort(),
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
    map("n", "gd", vim.lsp.buf.definition,            "Goto def")
    map("n", "gr", vim.lsp.buf.references,            "Refs")
    map("n", "K",  vim.lsp.buf.hover,                 "Hover")
    map("n", "<leader>rn", vim.lsp.buf.rename,        "Rename")
    map("n", "<leader>ca", vim.lsp.buf.code_action,   "Code action")
    map("n", "<leader>e",  vim.diagnostic.open_float, "Line diag")
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

vim.lsp.config('ansiblels', {
  root_markers = { "ansible.cfg", "playbook.yml", "roles/", "site.yml" },
  settings = {
    ansible = {
      python = { interpreterPath = "python3" },
      ansible = { path = "ansible" },
      validation = { enabled = true, lint = { enabled = true } },
    },
  },
})

vim.lsp.config('bashls', {})
vim.lsp.config('pyright', {})
vim.lsp.config('taplo', {})
vim.lsp.config('dockerls', {})

vim.lsp.config('jsonls', {
  settings = { json = { schemas = (function()
    local ok2, s = pcall(require, "schemastore")
    return ok2 and s.json.schemas() or {}
  end)() } },
})

-- Enable the servers
vim.lsp.enable({ 'yamlls', 'bashls', 'pyright', 'taplo', 'dockerls', 'jsonls', 'ansiblels' })
