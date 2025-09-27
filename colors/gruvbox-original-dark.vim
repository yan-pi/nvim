" Gruvbox Original Dark
" Based on sainnhe/gruvbox-material with original gruvbox palette

" Set configuration for original palette, dark background
let g:gruvbox_material_background = 'medium'
let g:gruvbox_material_foreground = 'original'
let g:gruvbox_material_enable_italic = 1

" Set dark background
set background=dark

" Source the main gruvbox-material colorscheme
runtime colors/gruvbox-material.vim

" Override the colors_name to distinguish this variant
let g:colors_name = 'gruvbox-original-dark'