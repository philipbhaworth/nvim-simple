# Neovim Configuration (Lightweight - Fast - Minimal as I can)

This Neovim setup is designed for operations, systems administration, and configuration-heavy workflows.  
It focuses on stability, speed, and predictable behavior while staying minimal and terminal-friendly.

Key features:
- Fast fuzzy finding with **fzf-lua**
- Clean directory editing with **oil.nvim**
- Auto-installed LSP servers, linters, and formatters through **Mason**
- Lightweight autocompletion (nvim-cmp, no snippets)
- YAML/TOML/JSON schema support
- Clear keymaps and no IDE bloat

Ideal for:
- Linux/Unix systems work  
- HPC / Research computing  
- DevOps / SRE environments  
- Scripting in Bash, Python, etc.

## Requirements

Neovim **0.10+**  
Git installed  
A few command-line tools for best performance.

### Arch Linux
```bash
sudo pacman -S neovim git ripgrep fzf fd shellcheck shfmt python-ruff prettier yamllint
````

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
git clone <your-repo-url> ~/.config/nvim
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

* `-` – open parent directory in Oil
* `<CR>` – open file/dir
* `g.` – toggle dotfiles
* `g?` – help
* `<C-s>`, `<C-h>`, `<C-t>` – split, vsplit, tab
* `<C-p>` – preview
* `:w` – apply renames/moves/deletes

### Netrw fallback

Oil **does not** override netrw by default.

Use:

* `nvim .`
* `:edit <dir>`

Set `default_file_explorer = true` if you prefer Oil everywhere.

---

## LSP / Formatting / Linting

### LSPs enabled:

* YAML (yamlls)
* Bash (bashls)
* Python (pyright)
* TOML (taplo)
* Docker (dockerls)
* JSON (jsonls)

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

Splits:
  :sp / :vsp            split / vsplit
  <C-w>h/j/k/l          move between splits
  <C-w>q                close split

Buffers:
  :bnext / :bprev       next / previous buffer
  :bd                   delete buffer
```

---

## Leader Key

The leader key is:

```
<Space>
```

Used for all custom mappings.
This keeps commands short, clear, and ergonomic.

Example:

```
<leader>ff  → Find files
<leader>f   → Format file
<leader>ll  → Lint file
<leader>rn  → LSP rename
<leader>ca  → Code action
```

---

## Directory Navigation Cheat Sheet

```
Oil (directory editor)
  :Oil                Open Oil
  :Oil --float        Floating Oil
  -                   Open parent directory
  g.                  Toggle dotfiles
  <CR>                Open entry
  :w                  Apply changes

fzf-lua (fuzzy finder)
  <leader>ff          Files
  <leader>fg          Live grep
  <leader>fb          Buffers
  <leader>fh          Help

netrw (fallback)
  nvim .              Open directory
  :edit <dir>         Open directory
```

---

## Philosophy

This configuration is meant to:

* stay minimal
* avoid heavy IDE plugins
* rely on terminal tools
* provide strong defaults for YAML/TOML/JSON/Bash/Python
* support quick file movement and directory work
* be fully reproducible across machines

---
