" Use vim
set nocompatible
filetype off
set shell=/bin/sh

let $GOBIN = '/Users/nathanc/dev/go/bin'
let $GOPATH .= ":/Users/nathanc/dev/go"

" vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#rc()
Plugin 'gmarik/Vundle.vim'

" all hail tpop
Plugin 'tpope/vim-fugitive'       " git
Plugin 'tpope/vim-unimpaired'     " git
Plugin 'tpope/vim-surround'

" Other plugins
Plugin 'scrooloose/nerdtree'      " nerdtree
Plugin 'scrooloose/nerdcommenter' " comments \ci
Plugin 'kien/ctrlp.vim'           " ctrlp
Plugin 'xolox/vim-easytags'       " ctags (:UpdateTags)
Plugin 'xolox/vim-misc'           " necessary for easytags
Plugin 'Valloric/YouCompleteMe'   " auto complete
Plugin 'rking/ag.vim'             " ag
Plugin 'vim-airline/vim-airline-themes' "Airline!
Plugin 'majutsushi/tagbar'        "tag bar!
Plugin 'milkypostman/vim-togglelist' " toggle quickfix list
Plugin 'sirver/ultisnips'         " snippets engine
Plugin 'honza/vim-snippets'       " snippets
Plugin 'ervandew/supertab'        " supertab (so ultisips and ycm play nice)

" language support
Plugin 'elzr/vim-json'            " Thank you, Json
Plugin 'digitaltoad/vim-jade'     " jade
Plugin 'fatih/vim-go'             " golang
Plugin 'vim-ruby/vim-ruby'        " ruby
Plugin 'elixir-lang/vim-elixir'   " elixir

" pretties
Plugin 'altercation/vim-colors-solarized'


"Finish vundle setup
filetype plugin indent on 
syntax on


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
setlocal isk+=?

" Filetype keymaps
autocmd Filetype elixir map <silent> <LocalLeader>t :!mix test<CR>
autocmd Filetype elixir map <silent> <LocalLeader>r :!iex -S mix<CR>

"vim 

" buffers
map <silent> <LocalLeader><LocalLeader> :ls<CR>


" local replace
nnoremap gr gd[{V%::s/<C-R>///gc<left><left><left>

" global replace
nnoremap gR gD:%s/<C-R>///gc<left><left><left>

" NERDTree ignores
let g:NERDTreeIgnore=['build$','tags']

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
set textwidth=0 tabstop=2 shiftwidth=2 softtabstop=2 noexpandtab
set t_Co=256
set backspace=2
set hidden
set wildignore+=*.class,*.jar,.git,*.swp,node_modules
set noshowmode

" search highlighting
set hlsearch
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>


" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " ag settings
  let g:ag_working_path_mode = "r"
  map <silent> <LocalLeader>ag :Ag<CR>

  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  "let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  "let g:ctrlp_use_caching = 0
endif

" ctrlp
let g:ctrlp_extensions = ['tag' ]
let g:ctrlp_max_files=0
let g:ctrlp_working_path_mode = 'r'

" Let's try this with git

let g:ctrlp_user_command = [
    \ '.git', 'cd %s && git ls-files . -co --exclude-standard',
    \ 'find %s -type f'
    \ ]
let g:ctrlp_show_hidden = 1

" easytags
let g:easytags_async = 1
let g:easytags_file = "./tags"
let g:easytags_opts = ['--tag-relative=yes']

" ultisnips 
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsListSnippets="<s-tab>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" solarized
set background=dark
let g:solarized_termcolors=256
colorscheme solarized

"  airline
let g:airline#extensions#tabline#enabled = 0
let g:airline_powerline_fonts = 1
let g:airline_theme='tomorrow'
" Always show 2 status lines for airline
set laststatus=2
" vim-go
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_fmt_command = "goimports"
let g:go_autodetect_gopath = 0
let g:go_bin_path = "/Users/nathanc/dev/go/bin"
" vim go filetype commands
au FileType go nmap <Leader>gi <Plug>(go-info)
au FileType go nmap <Leader>gr :GoRename<CR>
au FileType go nmap <Leader>gm :GoImplements<CR>
au FileType go nmap <Leader>gl :GoMetaLinter<CR>
au FileType go nmap <Leader>gp :GoPlay<CR>
au FileType go nmap <Leader>gv :GoFreevars<CR>
au FileType go nmap <Leader>gs :GoCallstack<CR>
au FileType go nmap <Leader>gg :GoReferrers<CR>
au FileType go nmap <Leader>gh <Plug>(go-doc-browser)

" tagbar shortcut
nmap <F8> :TagbarToggle<CR>
let g:tagbar_autoclose = 1
let g:tagbar_compact = 1

" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

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
