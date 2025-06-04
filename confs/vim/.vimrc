set nocompatible
set number

call plug#begin('~/.vim/plugged')

	Plug 'jiangmiao/auto-pairs'
	Plug 'morhetz/gruvbox'
	Plug 'ncm2/ncm2'
	Plug 'ncm2/ncm2-bufword'
	Plug 'ncm2/ncm2-path'
	Plug 'roxma/nvim-yarp'
	Plug 'vim-airline/vim-airline'
	Plug 'sheerun/vim-polyglot'
	Plug 'joshdick/onedark.vim'

call plug#end()

autocmd vimenter * ++nested colorscheme onedark

set background=dark
syntax on
set completeopt=noinsert,menuone,noselect
set mouse=r


map <C-a> ggVG
map <C-c> "+y"
map <C-v> "+p"
