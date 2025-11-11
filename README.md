# Neovim Configuration (Lightweight - Fast - Minimal as I can)

This Neovim setup is designed for operations, systems administration, and configuration-heavy workflows.  
It focuses on stability, speed, and predictable behavior while staying minimal and terminal-friendly.

Key features:
- Fast fuzzy finding with **fzf-lua**
- Clean directory editing with **oil.nvim** (replaces netrw workflow)
- Auto-installed LSP servers, linters, and formatters through **Mason**
- Lightweight autocompletion (nvim-cmp, no snippets)
- YAML/TOML/JSON schema support with Ansible LSP
- Smart keymaps and quality-of-life improvements
- Modern colorscheme (Kanagawa)

Ideal for:
- Linux/Unix systems work  
- HPC / Research computing
- Ansible/infrastructure automation
- Scripting in Bash, Python, etc.

## Requirements

Neovim **0.10+**  
Git installed  
A few command-line tools for best performance.

### Arch Linux
```bash
sudo pacman -S neovim git ripgrep fzf fd shellcheck shfmt python-ruff prettier yamllint
```

### Debian / Ubuntu
```bash
sudo apt update
sudo apt install neovim git ripgrep fzf fd-find shellcheck shfmt python3-ruff prettier yamllint
```

### Fedora
```bash
sudo dnf install neovim git ripgrep fzf fd-find ShellCheck shfmt python3-ruff prettier yamllint
```

### macOS (Homebrew)
```bash
brew install neovim git ripgrep fzf fd shellcheck shfmt ruff prettier yamllint
```

---

## Installation

Clone this configuration into your Neovim directory:
```bash
git clone https://github.com/philipbhaworth/nvim-simple.git ~/.config/nvim
```

Run Neovim:
```bash
nvim
```

Plugins install automatically on first launch.
Mason will auto-install LSPs and tools via `mason-tool-installer`.

---

## Workflow Guide

### File Picking (fzf-lua)

* `<leader>ff` – find files
* `<leader>fg` – ripgrep live search
* `<leader>fb` – buffers
* `<leader>fh` – help tags

### Directory Editing (oil.nvim)

Oil provides a buffer-based file manager - edit your filesystem like a text file.

* `-` – open parent directory in Oil
* `<leader>o` – open Oil in floating window
* `<CR>` – open file/directory
* `g.` – toggle hidden files
* `g?` – help
* `<C-v>` – open in vertical split
* `<C-x>` – open in horizontal split
* `:w` – apply changes (renames/moves/deletes)

**Why Oil over netrw?**
- Edit filesystem like text (rename multiple files, etc.)
- Shows permissions and file sizes
- More intuitive for batch operations
- Better split/preview support

### Quick Save/Quit

* `<leader>w` – save file
* `<leader>q` – quit
* `<leader>x` – save and quit

### Buffer Management

* `<leader>bn` – next buffer
* `<leader>bp` – previous buffer
* `<leader>bd` – close buffer

### Split Navigation

* `<C-h>` – move to left split
* `<C-j>` – move to bottom split
* `<C-k>` – move to top split
* `<C-l>` – move to right split

### Terminal

* `<leader>t` – toggle terminal split
* `<Esc><Esc>` – exit terminal mode

### Comments

* `gcc` – toggle comment on line (normal mode)
* `gc` – toggle comment on selection (visual mode)
* `<leader>/` – toggle comment

---

## LSP / Formatting / Linting

### LSPs enabled:

* YAML (yamlls) – with GitHub Actions & docker-compose schemas
* Ansible (ansiblels) – playbooks, roles, tasks
* Bash (bashls)
* Python (pyright)
* TOML (taplo)
* Docker (dockerls)
* JSON (jsonls) – with schemastore.nvim

### LSP Keymaps

* `gd` – goto definition
* `gr` – find references
* `K` – hover documentation
* `<leader>rn` – rename symbol
* `<leader>ca` – code actions
* `<leader>e` – show line diagnostics
* `]d` – next diagnostic
* `[d` – previous diagnostic

### Formatters (Conform)

* YAML: yamlfmt
* Python: ruff_format
* Shell: shfmt
* TOML: taplo
* JSON/Markdown: prettier

Trigger:
```text
<leader>f
```

### Linters (nvim-lint)

* YAML: yamllint
* Shell: shellcheck
* Python: ruff
* Ansible: ansible-lint

Trigger:
```text
<leader>ll
```

---

## Completion (nvim-cmp)

Default behavior (auto-popup):

* `<C-n>` – next suggestion
* `<C-p>` – previous
* `<CR>` – confirm
* `<C-Space>` – manual completion
* `<C-e>` – cancel

No snippet engine is included for simplicity.

---

## Configuration Philosophy

### Core Options

* **No relative line numbers** – absolute numbers for clearer reference
* **2-space indentation** – standard for YAML, JSON, configs (4-space for Python)
* **Smart search** – case-insensitive unless capitals used
* **System clipboard** – seamless copy/paste with OS
* **No swap files** – cleaner workflow, use git instead
* **Mouse enabled** – quick splits and scrolling when needed

### Colorscheme

**Kanagawa** (wave theme by default)
- Warm, easy-on-the-eyes palette
- Excellent syntax highlighting
- Clean floating windows
- Alternative variants: `dragon` (darker), `lotus` (light)

Switch themes:
```vim
:colorscheme kanagawa-wave
:colorscheme kanagawa-dragon
:colorscheme kanagawa-lotus
```

---

## Leader Key

The leader key is:
```
<Space>
```

Used for all custom mappings.
This keeps commands short, clear, and ergonomic.

### Full Leader Key Reference
```
File Operations:
  <leader>w           Save file
  <leader>q           Quit
  <leader>x           Save and quit

Finding:
  <leader>ff          Find files
  <leader>fg          Live grep
  <leader>fb          Buffers
  <leader>fh          Help tags

File Explorer:
  <leader>o           Oil (floating)

Buffers:
  <leader>bn          Next buffer
  <leader>bp          Previous buffer
  <leader>bd          Close buffer

Code:
  <leader>f           Format buffer
  <leader>ll          Run linter
  <leader>rn          LSP rename
  <leader>ca          Code action
  <leader>e           Line diagnostics
  <leader>/           Toggle comment

Terminal:
  <leader>t           Open terminal split
```

---

## Core Vim Keybindings (quick reference)
```
Movement:
  h j k l       basic motion
  w / b         next/back word
  0 / ^ / $     line start / first nonblank / line end
  gg / G        top / bottom of file

Editing:
  i / a         insert / append
  o / O         new line below / above
  x / dd / yy   delete char / delete line / copy line
  p / P         paste after / before
  u / <C-r>     undo / redo

Search:
  /text         forward search
  ?text         backward search
  n / N         next / previous match
  <Esc>         clear search highlight

Splits:
  :sp / :vsp            split / vsplit
  <C-h/j/k/l>           move between splits
  <C-w>q                close split

Buffers:
  :bnext / :bprev       next / previous buffer
  :bd                   delete buffer

Diagnostics:
  ]d / [d               next / previous diagnostic
```

---

## Philosophy

This configuration is meant to:

* Stay minimal and fast
* Avoid heavy IDE plugins
* Rely on terminal tools where possible
* Provide strong defaults for sysadmin languages (YAML/TOML/JSON/Bash/Python/Ansible)
* Support quick file movement and directory operations
* Be fully reproducible across machines
* Offer quality-of-life improvements without bloat

---

## Troubleshooting

### LSP not working?
Check Mason installations:
```vim
:Mason
```

### Want to recompile colorscheme?
After config changes (if you enable compilation):
```vim
:KanagawaCompile
```

### Linter/formatter missing?
Mason auto-installs on startup, but you can manually trigger:
```vim
:MasonToolsInstall
```

### Oil not showing hidden files?
Press `g.` in Oil buffer to toggle hidden file visibility.

---

## Contributing

This is a personal config, but feel free to fork and adapt.  
Keep it simple. Keep it fast. Keep it focused.
