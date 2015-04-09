set nocompatible
filetype off

" Vundle settings
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'altercation/vim-colors-solarized'
Plugin 'jnurmine/Zenburn'
Plugin 'bling/vim-airline'

call vundle#end()

" General settings
set enc=utf-8
set ls=2
set incsearch
set hlsearch
set nu
syntax on

" No swap and backup files
set nobackup
set nowritebackup
set noswapfile

" Tabulation settings
set tabstop=4
set expandtab
set shiftwidth=4

" NERDTree settings

map <F3> :NERDTreeToggle<CR>
let NERDTreeIgnore=['\~$', '\.pyc$']

" Theme
set background=dark
colorscheme zenburn

" Airline
set laststatus=2
let g:airline_theme='badwolf'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline_left_sep=''
let g:airline_right_sep=''
