**This repo is supposed to used as config by NvChad users!**

- The main nvchad repo (NvChad/NvChad) is used as a plugin by this repo.
- So you just import its modules , like `require "nvchad.options" , require "nvchad.mappings"`
- So you can delete the .git from this repo ( when you clone it locally ) or fork it :)

TODO:

- add rust suport
- add latext suport
- fix global diagnostics

# Credits

1. Lazyvim starter https://github.com/LazyVim/starter as nvchad's starter was inspired by Lazyvim's . It made a lot of things easier!

# Copilot Keybindings

## Suggestion Keybindings

| Key      | Action              | Mode   |
| -------- | ------------------- | ------ |
| `Alt-l`  | Accept suggestion   | Insert |
| `Alt-]`  | Next suggestion     | Insert |
| `Alt-[`  | Previous suggestion | Insert |
| `Ctrl-]` | Dismiss suggestion  | Insert |

## Panel Keybindings

| Key         | Action           | Mode   |
| ----------- | ---------------- | ------ |
| `[[`        | Jump to previous | Normal |
| `]]`        | Jump to next     | Normal |
| `Enter`     | Accept           | Normal |
| `gr`        | Refresh panel    | Normal |
| `Alt-Enter` | Open panel       | Normal |

## Copilot Chat Keybindings

| Key           | Action                  | Mode           |
| ------------- | ----------------------- | -------------- |
| `<leader>cc`  | Copilot Chat Menu       | Normal         |
| `<leader>cci` | Inline Chat             | Normal, Visual |
| `<leader>ccp` | Custom Prompt           | Normal, Visual |
| `<leader>cce` | Explain Code            | Normal         |
| `<leader>cct` | Generate Tests          | Normal         |
| `<leader>ccr` | Refactor Code           | Normal         |
| `<leader>ccf` | Fix Code                | Normal         |
| `<leader>cco` | Optimize Code           | Normal         |
| `<leader>ccd` | Add Documentation       | Normal         |
| `<leader>ccm` | Generate Commit Message | Normal         |
| `<leader>ccv` | Code Review             | Normal         |
