# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

Personal dotfiles for macOS — shell configs, editor settings, and package snapshots. It does **not** use symlinks; instead, `update.sh` manually copies files from the live system into the repo.

## Setup

Prerequisites: `brew`, `mise`, `pnpm` must already be installed.

```sh
mise use node@22
pnpm install
```

## Syncing Dotfiles

```sh
sh update.sh
```

This copies current system configurations into `dotfiles/` and `packages/`. Nothing installs from the repo back to the system — sync is one-directional (system → repo).

## Architecture

```
dotfiles/     # Config files copied from ~/ and app support dirs
packages/     # Snapshot lists of installed packages (brew, npm, uv)
update.sh     # Sync script — source of truth for what gets captured
```

**`update.sh`** defines the scope of the repo. To add a new config file, add a `cp` line there.

**`packages/`** are snapshot text files, not lockfiles. They reflect what's installed on the machine at sync time.

## Pre-commit Hook

Husky runs `gitleaks git -v --staged` before every commit to prevent secrets from leaking out of `.zshrc`, `.zprofile`, or `.gitconfig`. If a commit is blocked, inspect the diff for API keys, tokens, or credentials before forcing through.

## Key Configs and Their Locations

| File | Configures |
|------|-----------|
| `dotfiles/.zshrc` | Zsh shell, PATH, aliases, completions, Oh-my-zsh plugins |
| `dotfiles/.zprofile` | Brew init, mise shims, Kiro CLI |
| `dotfiles/.gitconfig` | Git settings; `~/Code/Internal/` uses a separate conditional config |
| `dotfiles/zed.settings.json` | Zed editor with AWS Bedrock / Claude AI via MCP servers |
| `dotfiles/ghostty` | Ghostty terminal emulator |
| `dotfiles/.starship.toml` | Starship prompt |
| `dotfiles/.vale.ini` | Vale writing linter (Google, proselint, write-good styles) |
| `dotfiles/docker.config.json` | Docker with Colima runtime and ECR credential helpers |
