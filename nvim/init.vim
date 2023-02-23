" Neovim Configuration


" ----- GENERAL SETTINGS -----

set modeline              " allow modelines
set modelines=20          " check the first 20 lines in a file

" allow backspacing over everything
set backspace=indent,eol,start
"map!  <BS>

" load plugins
if filereadable(stdpath('data') . '/site/autoload/plug.vim')
    exec 'source ' . stdpath('config') . '/plug.vim'
endif



" ----- APPEARANCE -----

" custom color scheme
colorscheme slake

" enable syntax highlighting
syntax on

" some general settings
"set cursorline
set laststatus=2
set number
set ruler
set showmatch
set showmode
set showcmd
"set visualbell

" do not wrap lines
set nowrap
set textwidth=0

" scroll when the cursor is within 5 lines of the edge of the window
set scrolloff=5
set sidescroll=10

" use rational split locations for new windows
set splitbelow
set splitright

" when comparing files, keep them synced and ignore whitespace
set diffopt=filler,iwhite

" configure code folding
"set foldcolumn=2          " set a column incase we need it
"set foldlevel=0           " show contents of all folds
"set foldmethod=indent     " use indent unless overridden


" ----- INDENTATION -----

" autoindent new lines
set autoindent

" indent with four-space tabs by default
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" display full-width tabs when using list
set listchars=trail:~
set listchars+=tab:>-
set list


" ----- SEARCHING -----

" make all-lower-case searches case-insensitive
set ignorecase
set smartcase

" search defaults
set gdefault
set incsearch
set hlsearch


" ----- SHORTCUTS -----

" use comma as the leader key
let mapleader = ","

" quick shortcut to clear search highlights
nnoremap <leader><space> :noh<cr>

" strip trailing whitespace from the file
nnoremap <leader>s :%s/\s\+$//<cr>
" add this to unhighlight things: :let @/=''<cr>

" select text which was just pasted
nnoremap <leader>v V`]

" reverse the highlighted lines
command! -bar -range=% Reverse <line1>,<line2>g/^/m<line1>-1|nohl
vnoremap <leader>r :Reverse<cr>

" find diff merge lines
nnoremap <leader>m /[<=>]\{7}<cr>

" insert memes
nnoremap <leader>ed A ಠ_ಠ<esc>
nnoremap <leader>es A ¯\_(ツ)_/¯<esc>
nnoremap <leader>etf A (╯°□°）╯︵ ┻━┻ <esc>

" use tab to jump to matching enclosure pairs
nnoremap <tab> %
vnoremap <tab> %


" ----- AUTOCOMPLETION -----

" allow autocompletion for commands and menus
set wildmode=longest,list,full
set wildmenu

" ignore VCS directories
set wildignore+=.git,.svn

" suffixes that get lower priority when doing tab completion for filenames
set suffixes=~,.bak,.swp,.o,.so,.ko,.class,.log


" ----- FILETYPE SETTINGS -----

filetype plugin indent on

" disable syntax error highlighting of C++ keywords in Java files
let java_allow_cpp_keywords = 1


" ----- UTILITIES -----

function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

function! SynGroup()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun

nnoremap <leader>us :call SynStack()<cr>
nnoremap <leader>ug :call SynGroup()<cr>
