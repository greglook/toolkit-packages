" Loads the Vundle Vim plugin manager. To install:
" 1) Clone the vundle repo:
" $ git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
"
" 2) Load Vundle in ~/.vimrc:
" source ~/.vim/vundle.vim
"
" 3) Run :PluginInstall in vim.

filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#begin()

Plugin 'gmarik/vundle'

" General
Plugin 'tpope/vim-surround'
Plugin 'scrooloose/nerdtree'

" Clojure
Plugin 'guns/vim-clojure-static'
Plugin 'raymond-w-ko/vim-niji'
Plugin 'paredit.vim'

" Other syntax
Plugin 'ledger/vim-ledger'
Plugin 'kchmck/vim-coffee-script'
Plugin 'cespare/vim-toml'
Plugin 'docker/docker', {'rtp': '/contrib/syntax/vim/'}
Plugin 'solarnz/thrift.vim'
Plugin 'b4b4r07/vim-hcl'


call vundle#end()
filetype plugin indent on

" Shortcuts

" NERDTree
map <C-n> :NERDTreeToggle<CR>
