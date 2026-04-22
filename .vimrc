" === BASIC SETTINGS ===
colorscheme unokai
set nocompatible
filetype plugin indent on
syntax on

let mapleader = " "
let maplocalleader = "\\"

" Interface
set number
set relativenumber
set cursorline
set cursorcolumn
set signcolumn=yes
set showmode
set clipboard=unnamedplus

"
set hidden
set splitbelow splitright
set wildmenu wildmode=longest,list,full
set completeopt=menuone,noselect
set laststatus=2
set formatoptions+=croq
set undofile

" VISUAL ALERT
set list listchars=trail:·
highlight TrailingSpace ctermbg=red guibg=red
autocmd BufEnter * call matchadd('TrailingSpace', '\s\+$')

" AUTO-REMOVE ON SAVE
autocmd BufWritePre * %s/\s\+$//e   " //e suppresses error if none exist

" Tabs & indentation
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set smartindent
set autoindent

" Wrapping
set wrap
set linebreak
set showbreak=↪
set sidescroll=1
set scrolloff=8

" Search
set ignorecase
set smartcase
set incsearch
set hlsearch

" Performance
set updatetime=300
set timeout
set timeoutlen=500
set noswapfile
set nobackup

" Undo
let undodir = expand('~/.vim/undodir')
if !isdirectory(undodir)
    call mkdir(undodir, "p")
endif
set undodir=~/.vim/undodir

" Encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8

" KEYMAPS
" Map ; to : in normal and visual modes
nnoremap ; :
xnoremap ; :

" Easy ESC
inoremap <C-c> <Esc>
cnoremap <C-c> <C-c>
vnoremap <C-c> <Esc>

" General leader mappings
nnoremap <leader>e :Ex<CR>
nnoremap <leader>so :update<CR>:source<CR>
nnoremap <leader>si :source $MYVIMRC<CR>
nnoremap <leader>w :write<CR>
nnoremap <leader>q :quit<CR>
nnoremap <leader>bc :enew<CR>
nnoremap <leader>bn :bn<CR>
nnoremap <leader>bp :bp<CR>

" Highlight clear
nnoremap <Esc> :nohlsearch<CR>
nnoremap <C-c> :nohlsearch<CR>

" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Yank to system clipboard
nnoremap <leader>y :"+yy
vnoremap J :m '>+1<CR>gv=gv
nnoremap J mzJ`z
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv

" HIGHLIGHT ON YANK
augroup highlight_yank
    autocmd!
    if has('nvim')
        autocmd TextYankPost * silent! lua vim.highlight.on_yank()
    else
        autocmd TextYankPost * silent! call s:HighlightYank()
        function! s:HighlightYank() abort
            silent! execute "normal! gv\<Esc>"
        endfunction
    endif
augroup END

" Enable mouse support
set mouse=a
