# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal Neovim configuration using **lazy.nvim** as the plugin manager. Part of a larger dotfiles repo at `~/dotfiles`.

## Architecture

- `init.lua` — Entry point: loads core modules, bootstraps lazy.nvim, registers all plugins
- `lua/core/options.lua` — Vim options (tabs=4 spaces, relative line numbers, no swap/backup)
- `lua/core/keymaps.lua` — Global keymaps (leader is `<Space>`)
- `lua/plugins/*.lua` — Each file returns a lazy.nvim plugin spec table

## Key Design Decisions

- **Nord colorscheme** with transparent background by default (`<leader>bg` toggles)
- **conform.nvim** for manual formatting with `<leader>f`
- **Mason** manages LSP servers and tools — servers are defined in `lua/plugins/lsp.lua` and auto-installed
- **LazyDev** provides Neovim Lua API and plugin-library completion without loading the entire runtime into LuaLS
- **LSP servers configured**: ts_ls, ruff, pylsp, html, emmet_ls, cssls, tailwindcss, dockerls, sqlls, terraformls, jsonls, yamlls, lua_ls. For Python, pylsp provides language intelligence and Ruff provides diagnostics and code actions; Conform handles formatting.
- **Formatters**: stylua (Lua), ruff_format (Python), prettier (JS/TS/CSS/HTML/JSON/Markdown)
- **vim-tmux-navigator** for seamless tmux/nvim split navigation

## Formatting & Style

Lua files are formatted with **StyLua** using the config in `.stylua.toml`:
- 160 column width, 2-space indent, single quotes, no call parentheses

When editing Lua files in this config, match these conventions:
- Single quotes for strings
- No parentheses on single-argument function calls (e.g., `require 'foo'` not `require('foo')`)
- 2-space indentation
