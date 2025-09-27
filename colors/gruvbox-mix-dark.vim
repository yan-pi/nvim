" Gruvbox Mix Dark
" Based on sainnhe/gruvbox-material with mix palette

" Set configuration for mix palette, dark background
let g:gruvbox_material_background = 'medium'
let g:gruvbox_material_foreground = 'mix'
let g:gruvbox_material_enable_italic = 1

" Set dark background
set background=dark

" Source the main gruvbox-material colorscheme
runtime colors/gruvbox-material.vim

" Override the colors_name to distinguish this variant
let g:colors_name = 'gruvbox-mix-dark'