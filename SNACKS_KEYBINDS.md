# Navigation shortcuts

This branch keeps only Snacks picker mappings useful for text and Bash work:

| Mapping | Action |
| --- | --- |
| `<leader><space>` | Smart file finder |
| `<leader>ff` | Find files |
| `<leader>fg` | Find Git files |
| `<leader>fr` | Recent files |
| `<leader>,` | Buffers |
| `<leader>/`, `<leader>sg` | Grep files |
| `<leader>sw` | Search word or visual selection |
| `<leader>sb` | Search current buffer lines |
| `<leader>sh` | Help tags |
| `<leader>sm` | Man pages |
| `<leader>s"` | Registers |
| `<leader>s/` | Search history |
| `<leader>bd` | Close current buffer |

For file-system navigation, use Mini.files with `<leader>e` or `<leader>E`.

## Terminal workflow

ToggleTerm is intentionally retained for the Kali profile and lazy-loads only
when one of its commands or mappings is invoked:

| Mapping | Action |
| --- | --- |
| `<leader>th` | Toggle horizontal terminal |
| `<leader>tv` | Toggle vertical terminal |
| `<leader>ti` | Toggle floating terminal |
| `<leader>ta` | Toggle all terminals |
| `<leader>ts` | Select a terminal |
| `<Esc><Esc>` (terminal mode) | Return to Normal mode |
| `<C-q>` (terminal mode) | Close the terminal |
| `<C-h/j/k/l>` (terminal mode) | Move between terminal splits |

`<leader>ty` remains reserved for creating a new tab, so it does not collide
with the terminal mappings.
