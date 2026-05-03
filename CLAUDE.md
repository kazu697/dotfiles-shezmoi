# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a **chezmoi dotfiles repository** managing the macOS development environment. chezmoi is configured in `symlink` mode — dotfiles under `dot_config/` are symlinked to `~/.config/` directly without copying.

- `dot_*` files/dirs → `~/*` (e.g., `dot_zshrc` → `~/.zshrc`)
- `dot_config/dot_claude/` → `~/.config/.claude/`
- Template files use `.tmpl` suffix (processed by chezmoi with data from `.chezmoi.toml.tmpl`)

## Key Commands

```bash
# Apply dotfiles to home directory
chezmoi apply

# Preview changes before applying
chezmoi diff

# Add a new file to chezmoi management
chezmoi add ~/.config/some/file

# Edit a managed file (opens in $EDITOR, applies on save)
chezmoi edit ~/.zshrc

# Re-run initial setup (prompted for Git name/email)
chezmoi init
```

No build/test/lint pipeline exists — this is a configuration-only repo.

## Architecture

### Directory Structure

```
dot_config/
├── dot_claude/       # Claude Code global config (~/.config/.claude/)
│   ├── CLAUDE.md     # Global Claude Code instructions (loaded in all projects)
│   ├── settings.json # Allowed tools, sandbox rules, hooks
│   ├── statusline.sh # Claude Code status bar script
│   ├── commands/     # Custom slash commands (/check-pr, /fix-pr-ci, etc.)
│   ├── agents/       # Custom agent definitions
│   ├── hooks/        # WorktreeCreate/WorktreeRemove lifecycle hooks
│   └── skills/       # Reusable skill definitions (tdd-workflow, pr-worktree)
├── nvim/             # Neovim config (LazyVim-based)
│   ├── init.lua
│   ├── lua/config/   # keymaps, options, autocmds, lazy bootstrap
│   └── lua/plugins/  # Plugin specs (19 files)
├── tmux/             # Tmux config
├── chezmoi/          # chezmoi self-config (mode = "symlink")
├── starship/         # Starship prompt config
└── zsh/rc/           # Additional Zsh functions (auto-sourced by dot_zshrc)
dot_zshrc             # Main Zsh config
dot_zshenv            # Zsh env vars (XDG paths, EDITOR=nvim, PATH)
dot_gitconfig.tmpl    # Git config template (delta, ghq, gtr defaults)
.chezmoi.toml.tmpl    # chezmoi bootstrap (prompts for git name/email)
```

### Claude Code Integration

`dot_config/dot_claude/` is the core Claude Code configuration layer deployed globally:

- **`settings.json`**: Defines allowed Bash commands, sandboxed network hosts (github.com, api.github.com, etc.), and hook bindings
- **`statusline.sh`**: Renders a 2-line status bar showing model, directory, branch, git diff stats, and context/rate-limit progress bars
- **`hooks/`**: On `WorktreeCreate`/`WorktreeRemove`, runs scripts that integrate with `gtr` (git-worktree-runner)
- **`commands/`**: Slash commands for PR workflows (`/check-pr`, `/fix-pr-ci`, `/fix-pr-comments`, `/resolve-pr-conflicts`, `/issue-breakdown`)

### Neovim Plugin Architecture

LazyVim base with overrides in `lua/plugins/`. Notable integrations:
- **`claudecode.lua`**: Claude Code ↔ Neovim integration
- **`go.lua`**: gopls + golangci-lint via mason/nvim-lint
- **`octo.lua`**: GitHub PR/Issue UI inside Neovim
- **`obsidian.lua`**: Note-taking integration

### Git Workflow Tools

- **`gtr`** (git-worktree-runner): Default AI = claude, default editor = nvim. Used for managing Claude-operated worktrees.
- **`ghq`**: Repository cloning into `~/src/`, navigable via `^G` (fzf picker)
- **`gw-fzf`** (`^W`): fzf-based worktree switcher

## Chezmoi Template System

`dot_gitconfig.tmpl` uses chezmoi template variables `{{ .name }}` and `{{ .email }}` populated from `.chezmoi.toml.tmpl` prompts at `chezmoi init` time. When editing `.tmpl` files, preserve the `{{ }}` syntax.

## Modifying Claude Code Config

Changes to `dot_config/dot_claude/` take effect globally once `chezmoi apply` is run (or immediately if working directly in `~/.config/.claude/` via symlink). The `settings.json` `allowedTools` list controls what Claude can execute without prompting — add new tools there when extending automation.
