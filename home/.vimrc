" Use vim
set nocompatible
filetype off

" vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#rc()
set shell=/bin/bash
Plugin 'gmarik/Vundle.vim'

" plugins
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdtree'
Plugin 'desert-warm-256'
Plugin 'jinfield/vim-nginx'
Plugin 'bling/vim-airline'
Plugin 'fatih/vim-go'
Plugin 'kien/ctrlp.vim'
Plugin 'john2x/flatui.vim'
Plugin 'digitaltoad/vim-jade'
Plugin 'kchmck/vim-coffee-script'
Plugin 'scrooloose/nerdcommenter'

"Finish vundle setup
filetype plugin indent on     " required!
syntax on

"Custom keymaps
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

"NERDTree Workaround - otherwise if you :bd the nt buffer it gets saddy
map <silent> <LocalLeader>nt :call g:WorkaroundNERDTreeToggle()<CR>

function! g:WorkaroundNERDTreeToggle()
  if exists("b:NERDTree")
    :NERDTreeToggle
  else
    :NERDTree
  endif
endfunction

"Preferences
set ruler
set history=50
set showcmd
set incsearch
set autowrite
set nobackup
set nowritebackup
set noswapfile
set number
set textwidth=0 tabstop=2 shiftwidth=2 softtabstop=2 expandtab
set t_Co=256
set backspace=2
set hidden
set wildignore+=*.class,*.jar,.git,*.swp
set noshowmode

" search highlighting
set hlsearch
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>


" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" ctrlp
let g:ctrlp_max_files=0
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git|build\'
let g:ctrlp_show_hidden = 1
let g:asyncfinder_ignore_files = "['*.swp', '*.class']"
let g:asyncfinder_ignore_dirs = "['*.AppleDouble*','*.DS_Store*','*.git*','*.hg*','*.bzr*','*target*']"

" Sane window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Window resizing mappings /*{{{*/
nnoremap <S-Up> <C-w>+<CR>
nnoremap <S-Down> <C-w>-<CR>
nnoremap <S-Left> <C-w><<CR>
nnoremap <S-Right> <C-w>><CR>
