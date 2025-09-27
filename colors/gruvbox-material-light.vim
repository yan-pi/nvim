" Gruvbox Material Light
" Based on sainnhe/gruvbox-material

" Set configuration for material palette, light background
let g:gruvbox_material_background = 'medium'
let g:gruvbox_material_foreground = 'material'
let g:gruvbox_material_enable_italic = 1

" Set light background
set background=light

" Source the main gruvbox-material colorscheme
runtime colors/gruvbox-material.vim

" Override the colors_name to distinguish this variant
let g:colors_name = 'gruvbox-material-light'