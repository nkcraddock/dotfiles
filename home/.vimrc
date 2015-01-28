set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#rc()
set shell=/bin/bash
" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

" My Bundles here:
"
" original repos on github
Bundle 'scrooloose/nerdtree'
Bundle 'benmills/vimux'
Bundle 'jbrechtel/vimux-ruby-test'
Bundle 'tpope/vim-endwise'
Bundle 'edsono/vim-matchit'
Bundle 'vim-ruby/vim-ruby'
Bundle 'mileszs/ack.vim'
Bundle 'desert-warm-256'
Bundle 'derekwyatt/vim-scala'
Bundle 'jbrechtel/vim-iawriter'
Bundle 'tpope/vim-markdown'
Bundle 'vim-scripts/VimClojure'
Bundle 'tpope/vim-fireplace'
Bundle 'tpope/vim-classpath'
Bundle 'jamessan/vim-gnupg'
Bundle 'wikitopian/hardmode'
Bundle 'mattn/webapi-vim'
Bundle 'mattn/gist-vim'
Bundle 'jinfield/vim-nginx'
Bundle 'bling/vim-airline'
Bundle 'kien/ctrlp.vim'
Bundle 'john2x/flatui.vim'
Bundle 'digitaltoad/vim-jade'
Bundle 'kchmck/vim-coffee-script'
Bundle 'elzr/vim-json'
Bundle 'fatih/vim-go'
Bundle 'scrooloose/nerdcommenter'
"
" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle command are not allowed..
"


"Finish vundle setup
filetype plugin indent on     " required!
syntax on

"Custom keymaps
map <silent> <LocalLeader>nt :NERDTreeToggle<CR>
map <silent> <LocalLeader>gi :GoImports<CR>
map <silent> <LocalLeader>mm :!make<CR>
map <silent> <LocalLeader>gr :GoRun<CR>
map <silent> <LocalLeader>gt :!go test ./...<CR>
setlocal isk+=?

nno <leader>t :<C-u>AsyncFinder<CR>

"Preferences
set hlsearch
set number
set textwidth=0 nosmartindent tabstop=4 shiftwidth=2 softtabstop=2 expandtab
let &t_Co=256
set backspace=2
set hidden
set background=dark
set wildignore+=*.class,*.jar,.git
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git'
let g:ctrlp_show_hidden = 1
let g:asyncfinder_ignore_files = "['*.swp', '*.class']"
let g:asyncfinder_ignore_dirs = "['*.AppleDouble*','*.DS_Store*','*.git*','*.hg*','*.bzr*','*target*']"

" Highlight trailing whitespace
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd BufRead,InsertLeave * match ExtraWhitespace /\s\+$/
" Set up highlight group & retain through colorscheme changes
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
map <silent> <LocalLeader>ws :highlight clear ExtraWhitespace<CR>

let g:ctrlp_show_hidden = 1

" Sane window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-n> :bnext<CR>
nnoremap <C-b> :bprev<CR>
