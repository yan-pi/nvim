# Keymaps to Try

**Leader:** `Space`. When a sequence is shown as `<leader>cf`, press `Space`, then `c`, then `f`. Uppercase letters matter: `gI` uses capital `I`; `<leader>gI` begins with `Space`.

Use this as a day-to-day trial list. The goal is to see which reorganized keys feel natural and whether anything still collides.

## Navigation

| Key | Action | Try it when… |
|---|---|---|
| `s` | Flash jump to visible text | Moving to a word or location on screen |
| `S` | Flash Treesitter selection | Selecting a syntax node |
| `[t` / `]t` | Previous / next Treesitter node (Mini.bracketed) | Moving between nearby syntax nodes |
| `gd` | Go to definition | Following a symbol |
| `gI` | Go to implementation | Finding implementations of a trait/interface or method |
| `<leader>gI` | List all GitHub issues | Browsing issues, including closed ones |
| `gr` | Find references | Seeing where a symbol is used |
| `gy` | Go to type definition | Inspecting a symbol's type |

Implementation results still depend on the active language server and the symbol under the cursor.

## Surround: Code → Surround

These are the new Surround mappings. Select text first, or use a textobject after the action key.

| Key sequence | Action | Example |
|---|---|---|
| `<leader>csa` | Add surrounding | Select a word and add `"`; or use `<leader>csa` + `iw` + `"` |
| `<leader>csd` | Delete surrounding | `<leader>csd` + `"` removes surrounding double quotes |
| `<leader>csr` | Replace surrounding | `<leader>csr` + `"` + `'` changes double quotes to single quotes |
| `<leader>csf` / `<leader>csF` | Find surrounding to the right / left | Follow with a delimiter such as `)` or `"` |
| `<leader>csh` | Highlight surrounding | Follow with the delimiter to highlight |

`iw` means “inner word.” Other textobjects work too. Surround operations can be repeated with `.`. The optional `n` / `l` suffixes select the next / previous surrounding, e.g. `<leader>csdn` + `)`.

## Files, buffers, and formatting

| Key | Action | What changed |
|---|---|---|
| `<leader>ff` | Find files | — |
| `<leader>fr` | Recent files | — |
| `<leader>fp` | Project switcher | — |
| `<leader>bt` | Buffers in this tab | — |
| `<leader>bN` | Create a new empty buffer | Moved from `<leader>b`, which is now only a prefix |
| `<leader>bd` | Close buffer | — |
| `<leader>bn` / `<leader>bp` | Next / previous buffer in this tab | — |
| `<leader>cf` | Format current buffer | Moved from `<leader>f`; `f…` remains for file actions |

Format-on-save controls remain `<leader>uf` (global) and `<leader>uF` (current buffer).

## Git and UI

| Key | Action | What changed |
|---|---|---|
| `<leader>gB` | Open current file/revision in the browser (Git Browse) | Kept for Git/GitHub |
| `<leader>uB` | Toggle Git Blame | Moved out of Git Browse's key |
| `<leader>uz` | Toggle Zen mode | Moved under UI options |
| `<leader>Z` | Toggle Zen zoom | — |
| `<leader>gI` | GitHub issues, all states | Distinct from `gI` (LSP implementation) |

## Documentation generation

`<leader>cD` is now a prefix, not an action:

| Key | Action |
|---|---|
| `<leader>cDd` | Generate default documentation |
| `<leader>cDf` | Document function |
| `<leader>cDc` | Document class/struct |
| `<leader>cDt` | Document type |
| `<leader>cDF` | Document file |

## Tests

The frequently used Treesitter navigation keeps `[t` / `]t`. Neotest's failed-test jumps moved under the less frequently used test prefix:

| Key | Action |
|---|---|
| `<leader>T[` / `<leader>T]` | Previous / next failed test |
| `<leader>Tt` | Run nearest test |
| `<leader>Tf` | Run tests in current file |
| `<leader>Ta` | Run all tests in current project |
| `<leader>Ts` | Toggle test summary |
| `<leader>To` / `<leader>TO` | Open test output / toggle output panel |
| `<leader>Td` | Debug nearest test |
| `<leader>Tw` / `<leader>TW` | Toggle watch for test / current file |
| `<leader>Tp` | Stop nearest test |

## Refactoring

Lowercase `<leader>r…` remains the Rust namespace. Refactoring now uses uppercase `<leader>R…`:

| Key | Action | Mode |
|---|---|---|
| `<leader>Re` | Extract function | Visual selection |
| `<leader>Rf` | Extract function to file | Visual selection |
| `<leader>Rv` | Extract variable | Visual selection |
| `<leader>Ri` | Inline variable | Normal / visual |
| `<leader>Rb` / `<leader>RB` | Extract block / block to file | Normal |
| `<leader>RI` | Inline function | Normal |
| `<leader>Rr` | Open refactoring menu | Normal / visual |
| `<leader>Rdp` | Insert debug print | Normal |
| `<leader>Rdv` | Insert debug print for variable | Normal / visual |
| `<leader>Rdc` | Clean up debug prints | Normal |

## Completion

In Insert mode, press `Ctrl-Space` to open Blink's completion menu. `Tab` / `Shift-Tab` navigate suggestions; `Enter` accepts. This is no longer disabled for the old Zellij shortcut.

## Quick trial notes

After using the new keys for a few days, jot down:

- Which keys were easy to discover and remember?
- Which old key did your hands still reach for?
- Did any sequence trigger a different action than expected?
- Which features did you actually use (especially Surround and refactoring)?
