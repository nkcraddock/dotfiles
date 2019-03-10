"----------------------------------------------------------------------
set nocompatible

execute pathogen#infect()

filetype plugin indent on

"----------------------------------------------------------------------
" Searching
"----------------------------------------------------------------------

" Infer the case
set infercase

" Ignore the case
set ignorecase

" Use case if the search has uppercase
set smartcase

" Show matches as the patter is typed
set incsearch

" Highlight search results inline
set hlsearch

" Use magic for regular expressions
set magic

" Stop highlighting search matches
map <silent> <Space> :nohlsearch<Bar>:echo<CR>

"----------------------------------------------------------------------
" UI
"----------------------------------------------------------------------
" Never wrap words
set nowrap

" Center the current line
"set so=999

" Avoid garbled characters in Chinese language windows OS
let $LANG='en'
set langmenu=en
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

" wildmenu for vim command completion
"set wildmenu
"set wildmode=longest:full,full

" Highlight the current line
set cursorline

" Show the line number
set number

" Ignore files that are stupid that i hate 
set wildignore+=*.o,*~,*.pyc,*.class,*.jar,.git,*.swp,node_modules,*/.DS_Store

" Show line, column. and position
set ruler

" Remember a lot of history
set history=500

" Show commands in the status line
set showcmd

" Never show me a fold column
set foldcolumn=0

" Never make sounds ever. Ever.
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Hide a buffer if its abandoned
set hidden

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

"----------------------------------------------------------------------
" Text and tabs
"----------------------------------------------------------------------

" Use spaces
set expandtab

" Pretend that spaces are as good as tabs
set smarttab

" 2 spaces for tabs
set shiftwidth=2
set softtabstop=2
set tabstop=2

" Only linebreak on something absurd
set linebreak
set textwidth=250

" Always show 2 status lines 
set laststatus=2

" terminal clear uses the bg color
set t_ut=

"----------------------------------------------------------------------
" Colors and Pretties
"----------------------------------------------------------------------

" Try to use solarized8 if we have it
set t_Co=256
try
  colorscheme solarized8
catch
  try
    "colorscheme desert
  catch
  endtry
endtry


" 

" Whatever colorscheme we want it should be dark
set background=dark

" Syntax highlighting
syntax enable

" use utf8
set encoding=utf8

" unix file type default
set ffs=unix,dos,mac

"----------------------------------------------------------------------
" Backups, Files, Autowrite
"----------------------------------------------------------------------

" Autowrite files on most commands
set autowrite

" Disable backups and such
set nobackup
set nowritebackup
set noswapfile

"----------------------------------------------------------------------
" Window navigation and resizing and such
"----------------------------------------------------------------------
" Sane window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Window resizing mappings /*{{{*/
nnoremap <S-Up> <C-w>+
nnoremap <S-Down> <C-w>-
nnoremap <S-Left> <C-w><
nnoremap <S-Right> <C-w>>

" quickfix auto-resizer 
au FileType qf call AdjustWindowHeight(3, 5)
function! AdjustWindowHeight(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction


"----------------------------------------------------------------------
" Some Random Stuff
"----------------------------------------------------------------------

" local replace
nnoremap gr gd[{V%::s/<C-R>///gc<left><left><left>

" global replace
nnoremap gR gD:%s/<C-R>///gc<left><left><left>


"""""""""""""""""
"Custom keymaps
map <silent> <LocalLeader>mm :make!<CR>
map <silent> <LocalLeader>mt :make! test<CR>
map <silent> <LocalLeader>mr :make! run<CR>
map <silent> <LocalLeader>rr :!rake<CR>
map <silent> <LocalLeader>rt :!rake test<CR>
map <silent> <LocalLeader>jk  :r !pbpaste<CR>
map <silent> <LocalLeader>jj  :%w !pbcopy<CR>
nmap <silent> <LEFT> :cprev<CR>
nmap <silent> <RIGHT> :cnext<CR>

" buffers
map <silent> <LocalLeader><LocalLeader> :ls<CR>

"----------------------------------------------------------------------
" Plugins
"----------------------------------------------------------------------

" Put plugins and dictionaries in this dir (also on Windows)
let vimDir = '$HOME/.vim'
let &runtimepath.=','.vimDir


"-----------
" vim-fugitive (git)
"
nnoremap <Leader>gg :G<CR>
nnoremap <Leader>ga :Git add %:p<CR><CR>
nnoremap <Leader>gr :Git reset %:p<CR><CR>
nnoremap <Leader>gR :Git reset<CR><CR>
nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>gc :Gcommit -S -v -q<CR>
nnoremap <Leader>gC :Gcommit -S -v -q %:p<CR>
nnoremap <Leader>gd :Gvdiff<CR>
nnoremap <Leader>gl :silent! Glog<CR>:bot copen<CR>
nnoremap <Leader>gb :Gblame<CR>

"-----------
" vim-terraform
"
let g:terraform_align=1
let g:terraform_fmt_on_save=1


"-----------
" emmet
"
let g:user_emmet_leader_key=','

"
"-----------
" NERDTree
"
" NERDTree ignores
let g:NERDTreeIgnore=['build$','tags']

" Auto-open nerdtree on open
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" NERDTree mappings
map <silent> <LocalLeader>ne :call g:WorkaroundNERDTreeFind()<CR>
function! g:WorkaroundNERDTreeFind()
  try | NERDTreeFind | catch | silent! NERDTree | silent! NERDTreeFind | endtry
endfunction

"NERDTree Workaround - otherwise if you :bd the nt buffer it gets saddy
map <silent> <LocalLeader>nt :call g:WorkaroundNERDTreeToggle()<CR>
function! g:WorkaroundNERDTreeToggle()
  try | NERDTreeToggle | catch | silent! NERDTree | endtry
endfunction

"-----------
" ctrlp
"-----------
" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " ag settings
  let g:ag_working_path_mode = "r"
  map <silent> <LocalLeader>ag :Ag<CR>

  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --hidden --ignore .git --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  "let g:ctrlp_use_caching = 0
else
  " Let's try this with git
  let g:ctrlp_user_command = [
        \ '.git', 'cd %s && git ls-files . -co --exclude-standard',
        \ 'find %s -type f'
        \ ]
endif

let g:ctrlp_extensions = ['tag' ]
let g:ctrlp_max_files=0
let g:ctrlp_working_path_mode = 'r'
let g:ctrlp_show_hidden = 1



"----------
" airline
"----------
let g:airline#extensions#tabline#enabled = 0
let g:airline_powerline_fonts = 1
let g:airline_theme = "minimalist"

"----------
" vim-go
"----------
let g:go_fmt_command = "goimports"
let g:go_list_type = "quickfix"

let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_generate_tags = 1

" Auto-lint on save
let g:go_metalinter_autosave = 1
let g:go_metalinter_autosave_enabled = ['vet']

let g:go_auto_type_info = 1
let g:go_info_mode = 'gocode'

" Shortcuts
augroup go
  set updatetime=100
  autocmd!

  " Show by default 4 spaces for a tab
  autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4

  " :GoBuild and :GoTestCompile
  autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>

  " :GoTest
  autocmd FileType go nmap <leader>t  <Plug>(go-test)

  " :GoRun
  autocmd FileType go nmap <leader>r  <Plug>(go-run)

  " :GoDoc
  autocmd FileType go nmap <Leader>d <Plug>(go-doc)

  " :GoCoverageToggle
  autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)

  " :GoInfo
  autocmd FileType go nmap <Leader>i <Plug>(go-info)

  " :GoMetaLinter
  autocmd FileType go nmap <Leader>l <Plug>(go-metalinter)

  " :GoDef but opens in a vertical split
  autocmd FileType go nmap <Leader>v <Plug>(go-def-vertical)
  " :GoDef but opens in a horizontal split
  autocmd FileType go nmap <Leader>s <Plug>(go-def-split)

  " :GoAlternate  commands :A, :AV, :AS and :AT
  autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
  autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
  autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
  autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')

augroup END

" build_go_files is a custom function that builds or compiles the test file.
" It calls :GoBuild if its a Go file, or :GoTestCompile if it's a test file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction


"---------
" tagbar
"---------
" tagbar shortcut
nmap <F8> :TagbarToggle<CR>
let g:tagbar_autoclose = 1
"let g:tagbar_compact = 1
let g:tagbar_show_linenumbers = 1
let g:tagbar_type_javascript = {
      \ 'ctagstype': 'javascript',
      \ 'kinds': [
      \ 'A:arrays',
      \ 'P:properties',
      \ 'T:tags',
      \ 'O:objects',
      \ 'G:generator functions',
      \ 'F:functions',
      \ 'C:constructors/classes',
      \ 'M:methods',
      \ 'V:variables',
      \ 'I:imports',
      \ 'E:exports',
      \ 'S:styled components'
      \ ]}
let g:tagbar_type_typescript = {
  \ 'ctagstype': 'typescript',
  \ 'kinds': [
    \ 'c:classes',
    \ 'n:modules',
    \ 'f:functions',
    \ 'v:variables',
    \ 'v:varlambdas',
    \ 'm:members',
    \ 'i:interfaces',
    \ 'e:enums',
  \ ]
\ }

"------------------
" YouCompleteMe
"------------------
" make YCM compatible with UltiSnips (using supertab)
"let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
"let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
"let g:SuperTabDefaultCompletionType = '<C-n>'
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_autoclose_preview_window_after_completion = 1

"---------
" livedown - markdown preview
"---------
let g:livedown_open = 1
let g:livedown_port = 9010
let g:livedown_browser = "google-chrome"
map <silent> <Leader>md :LivedownToggle<CR>

"---------
" quramy/tsuquyomi - typescript integration
"---------
let g:tsuquyomi_completion_detail = 1
let g:tsuquyomi_disable_quickfix = 1
let g:syntastic_typescript_checkers = ['tsuquyomi'] " You shouldn't use 'tsc' checker.
autocmd FileType typescript setlocal completeopt+=menu,preview

"----------------------------------------------------------------------
" Clipboard and undo history
"----------------------------------------------------------------------

" Enable to copy to clipboard for operations like yank, delete, change and put
if has('unnamedplus')
  set clipboard^=unnamed
  set clipboard^=unnamedplus
endif

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
  let myUndoDir = expand(vimDir . '/undodir')
  " Create dirs
  call system('mkdir ' . vimDir)
  call system('mkdir ' . myUndoDir)
  let &undodir = myUndoDir
  set undofile
endif
