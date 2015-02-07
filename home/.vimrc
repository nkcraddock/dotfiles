set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#rc()
set shell=/bin/bash
" let Vundle manage Vundle
" required! 
Plugin 'gmarik/Vundle.vim'

" plugins
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdtree'
Plugin 'desert-warm-256'
Plugin 'jinfield/vim-nginx'
Plugin 'bling/vim-airline'
Plugin 'kien/ctrlp.vim'
Plugin 'john2x/flatui.vim'
Plugin 'digitaltoad/vim-jade'
Plugin 'kchmck/vim-coffee-script'
Plugin 'elzr/vim-json'
Plugin 'fatih/vim-go'
Plugin 'scrooloose/nerdcommenter'

"Finish vundle setup
filetype plugin indent on     " required!
syntax on

"Custom keymaps
map <silent> <LocalLeader>nt :NERDTreeToggle<CR>
map <silent> <LocalLeader>gi :GoImports<CR>
map <silent> <LocalLeader>mm :!make<CR>
map <silent> <LocalLeader>mt :!make test<CR>
map <silent> <LocalLeader>mr :!make run<CR>
map <silent> <LocalLeader>gr :GoRun<CR>
map <silent> <LocalLeader>gt :!go test ./...<CR>
map <silent> <LocalLeader>rr :!rake<CR>
map <silent> <LocalLeader>rt :!rake test<CR>
setlocal isk+=?

nno <leader>t :<C-u>AsyncFinder<CR>

"Preferences
set hlsearch
set number
set textwidth=0 nosmartindent tabstop=4 shiftwidth=2 softtabstop=2 expandtab
let &t_Co=256
set backspace=2
set hidden
set wildignore+=*.class,*.jar,.git,*.swp
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git'
let g:ctrlp_show_hidden = 1
let g:asyncfinder_ignore_files = "['*.swp', '*.class']"
let g:asyncfinder_ignore_dirs = "['*.AppleDouble*','*.DS_Store*','*.git*','*.hg*','*.bzr*','*target*']"

" Sane window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l


