" Gruvbox Mix Light
" Based on sainnhe/gruvbox-material with mix palette

" Set configuration for mix palette, light background
let g:gruvbox_material_background = 'medium'
let g:gruvbox_material_foreground = 'mix'
let g:gruvbox_material_enable_italic = 1

" Set light background
set background=light

" Source the main gruvbox-material colorscheme
runtime colors/gruvbox-material.vim

" Override the colors_name to distinguish this variant
let g:colors_name = 'gruvbox-mix-light'