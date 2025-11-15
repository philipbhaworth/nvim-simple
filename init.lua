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

-- Horizontal terminal split
vim.keymap.set("n", "<leader>th", function()
    vim.cmd("split | terminal")
    vim.cmd("resize 15")
    vim.cmd("startinsert")
end, { desc = "Open terminal split (horizontal)" })

-- Vertical terminal split
vim.keymap.set("n", "<leader>tv", function()
    vim.cmd("vsplit | terminal")
    vim.cmd("vertical resize 80")
    vim.cmd("startinsert")
end, { desc = "Open terminal split (vertical)" })

-- Easy terminal exit
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Quick theme cycling (add to keymaps section)
local themes = { "monokai-pro", "kanagawa-wave", "tokyonight-storm" }
local current_index = 1

vim.keymap.set("n", "<leader>tt", function()
  current_index = (current_index % #themes) + 1
  vim.cmd.colorscheme(themes[current_index])
  print("→ " .. themes[current_index])
end, { desc = "Cycle themes" })

-- Plugin setup ----------------------------------------------------------------
require("lazy").setup({

    -- Colorschemes
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      opts = {
        style = "storm",
        transparent = false,
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { bold = true },
        },
      },
    },
    {
      "rebelot/kanagawa.nvim",
      lazy = false,
      priority = 1000,
      opts = {
        compile = false,
        transparent = false,
        theme = "wave",
        background = {
          dark = "wave",
          light = "lotus",
        },
      },
    },
    {
      "loctvl842/monokai-pro.nvim",
      lazy = false,
      priority = 1000,
      opts = {
        transparent_background = false,
        terminal_colors = true,
        devicons = true,
        styles = {
          comment = { italic = true },
          keyword = { italic = true },
          type = { italic = true },
          parameter = { italic = true },
        },
        filter = "pro", -- pro | octagon | machine | ristretto | spectrum | classic
        inc_search = "background",
        background_clear = {
          "toggleterm",
          "telescope",
          "renamer",
          "notify",
        },
        plugins = {
          indent_blankline = {
            context_highlight = "default",
            context_start_underline = false,
          },
        },
      },
    },

    -- Statusline
    {
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      opts = {
        options = {
          theme = "auto",  -- Auto-detects cyberdream
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      },
    },

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

    -- Indent guides
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            indent = {
                char = "▏",
                -- char = "┊", -- Option 1: Thin dotted line (RECOMMENDED - very subtle)
                -- char = "╎",  -- Option 2: Dashed line
                -- char = "·",  -- Option 3: Middle dot (minimalist)
                -- char = "⋅",  -- Option 4: Bullet operator (very small)
                -- char = "┆",  -- Option 5: Dashed vertical line
            },
            scope = {
                enabled = true,
                show_start = false,
                show_end = false,
            },
            exclude = {
                filetypes = {
                    "help",
                    "terminal",
                    "lazy",
                    "mason",
                    "oil",
                },
            },
        },
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
            { "gcc",       mode = "n",          desc = "Comment line" },
            { "gc",        mode = "v",          desc = "Comment selection" },
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
    { "folke/which-key.nvim",    opts = {} },

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
        map("n", "gd", vim.lsp.buf.definition, "Goto def")
        map("n", "gr", vim.lsp.buf.references, "Refs")
        map("n", "K", vim.lsp.buf.hover, "Hover")
        map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
        map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("n", "<leader>e", vim.diagnostic.open_float, "Line diag")
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
    settings = {
        json = {
            schemas = (function()
                local ok2, s = pcall(require, "schemastore")
                return ok2 and s.json.schemas() or {}
            end)()
        }
    },
})

-- Enable the servers
vim.lsp.enable({ 'yamlls', 'bashls', 'pyright', 'taplo', 'dockerls', 'jsonls', 'ansiblels' })

-- Set colorscheme (pick one)
vim.cmd.colorscheme("monokai-pro")
-- vim.cmd.colorscheme("kanagawa-wave")
-- vim.cmd.colorscheme("tokyonight-storm")
