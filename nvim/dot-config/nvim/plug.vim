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
Plug 'folke/tokyonight.nvim'
Plug 'machakann/vim-sandwich'
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}
Plug 'mzlogin/vim-markdown-toc', {'for': 'markdown'}

" Clojure
Plug 'guns/vim-clojure-static', {'for': 'clojure'}
Plug 'raymond-w-ko/vim-niji', {'for': 'clojure'}
Plug 'kovisoft/paredit', {'for': 'clojure'}

" Other syntax
Plug 'greglook/vim-nftables', {'for': 'nft'}
Plug 'ledger/vim-ledger', {'for': 'ledger'}
Plug 'nathangrigg/vim-beancount', {'for': 'beancount'}
Plug 'cespare/vim-toml', {'for': 'toml'}
Plug 'b4b4r07/vim-hcl', {'for': 'hcl'}
Plug 'chr4/nginx.vim', {'for': 'nginx'}
Plug 'vim-scripts/ebnf.vim'

" Colors
Plug 'folke/tokyonight.nvim'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }

call plug#end()

filetype plugin indent on

" Shortcuts
map <C-n> :NERDTreeToggle<CR>
