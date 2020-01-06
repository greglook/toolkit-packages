" Neovim plugin management using vim-plug.
"
" 1) Clone the repo:
"    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" 2) Source this file in the nvim config.
" 3) Run `:PlugInstall`


"filetype off

" Specify a directory for plugins
call plug#begin(stdpath('data') . '/plugs')

" General
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}

" Clojure
Plug 'guns/vim-clojure-static', {'for': 'clojure'}
Plug 'raymond-w-ko/vim-niji', {'for': 'clojure'}
Plug 'kovisoft/paredit', {'for': 'clojure'}

" Other syntax
Plug 'ledger/vim-ledger', {'for': 'ledger'}
Plug 'cespare/vim-toml', {'for': 'toml'}
Plug 'docker/docker', {'for': 'docker', 'rtp': '/contrib/syntax/vim/'}
Plug 'solarnz/thrift.vim', {'for': 'thrift'}
Plug 'b4b4r07/vim-hcl', {'for': 'hcl'}

call plug#end()

filetype plugin on
filetype indent on

" Shortcuts
map <C-n> :NERDTreeToggle<CR>
