# Neovim Keymaps

`<leader>` is `Space`. Key sequences such as `Space l w` are pressed one key
after another. `Ctrl`, `Shift`, and `Option` combinations are pressed together.

## Everyday editing

| Action | Key |
| --- | --- |
| Save | `Ctrl+S` |
| Quit | `Ctrl+Q` |
| Undo / redo | `u` / `Ctrl+R` |
| Format buffer or selection manually | `Space f` |
| Comment/uncomment current line | `gcc` |
| Comment/uncomment selected lines | Select lines, then `gc` |
| Comment using a motion | `gc` followed by a motion, such as `gcap` |
| Toggle word wrap | `Space l w` |
| Collapse/expand function or block under cursor | `Space z` |
| Collapse/open all folds | `zM` / `zR` |
| Start or expand syntax-tree selection | `Ctrl+G` repeatedly |
| Shrink syntax-tree selection | `Backspace` |
| Move selected lines down/up | `Ctrl+J` / `Ctrl+K` |
| Indent selected code | `>` / `<` |
| Paste over a selection without replacing the yank register | Visual selection, then `p` |

## Files and buffers

| Action | Key |
| --- | --- |
| Find file | `Space s f` |
| Search text across the repository | `Space s g` |
| Search the current file | `Space /` |
| Open recent files | `Space s .` |
| List open buffers | `Space Space` |
| Next/previous buffer | `Tab` / `Shift+Tab` |
| Force-close buffer (discards unsaved changes) | `Space x` |
| Create a new buffer | `Space b` |
| Toggle file explorer | `Space e` |
| Reveal the current file in the explorer | `\` |

## Windows

| Action | Key |
| --- | --- |
| Create vertical split | `Space v` |
| Create horizontal split | `Space h` |
| Move between splits | `Ctrl+H/J/K/L` |
| Equalize split sizes | `Space s e` |
| Close current split | `Space x s` |
| Resize current split | Arrow keys |

## Tabs and terminal

| Action | Key |
| --- | --- |
| Open/close tab | `Space t o` / `Space t x` |
| Next/previous tab | `Space t n` / `Space t p` |
| Open terminal split | `Space s t` |
| Leave terminal mode | `Esc` |

## Code navigation and LSP

These mappings are available when an LSP is attached to the current buffer.

| Action | Key |
| --- | --- |
| Go to definition | `gd` |
| Find references | `gr` |
| Go to implementation | `gI` |
| Go to declaration | `gD` |
| Go to type definition | `Space D` |
| Rename symbol | `Space r n` |
| Show code actions / quick fixes | `Space c a` |
| Previous/next diagnostic | `[d` / `]d` |
| Show diagnostic details | `Space d` |
| Open diagnostics list | `Space q` |
| Search document symbols | `Space d s` |
| Search workspace symbols | `Space w s` |
| Toggle inlay hints, when supported | `Space t h` |

## Git

| Action | Key |
| --- | --- |
| Open Git status, or choose/resolve conflicted files | `Space g s` |
| Resolve current conflicted file | `Space g m` |
| Open repository history | `Space g h` |
| Open current-file history | `Space g H` |
| Blame current line | `Space g b` |
| Open full-file blame | `Space g B` |
| Toggle inline blame | `Space g t` |
| Next/previous changed hunk | `]h` / `[h` |
| Preview hunk | `Space h p` |
| Stage hunk | `Space h s` |
| Reset hunk | `Space h r` |
| Next/previous merge conflict | `]x` / `[x` |
| Accept incoming/current conflict | `Space c t` / `Space c o` |
| Accept both conflict versions | `Space c b` |
| Close CodeDiff | `q` or `Esc` |

## Completion

| Action | Key |
| --- | --- |
| Next/previous suggestion | `Tab` / `Shift+Tab` |
| Accept suggestion | `Ctrl+Y` |
| Scroll completion documentation | `Ctrl+F` / `Ctrl+B` |
| Jump forward/backward through snippet fields | `Ctrl+L` / `Ctrl+H` |

Completion normally appears automatically. Its manual trigger remains
`Ctrl+Space`, which may depend on terminal settings. Syntax-tree selection uses
the portable `Ctrl+G` mapping instead.

## Discover more

| Action | Key |
| --- | --- |
| Search all registered keymaps | `Space s k` |
| Show Telescope mappings while a picker is open | `Ctrl+/` in Insert mode or `?` in Normal mode |
