" Loads the Vundle Vim plugin manager. To install:
" 1) Clone the vundle repo:
" $ git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
"
" 2) Load Vundle in ~/.vimrc:
" source ~/.vim/vundle.vim
"
" 3) Run :BundleInstall in vim.

filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-surround'

" Clojure
"Bundle 'tpope/vim-fireplace'
Bundle 'guns/vim-clojure-static'
"Bundle 'jpalardy/vim-slime'
Bundle 'amdt/vim-niji'
Bundle 'paredit.vim'

" Coffeescript
Bundle 'kchmck/vim-coffee-script'

" Ledger
Bundle 'ledger/vim-ledger'

filetype plugin indent on


" Config

let g:slime_target = "tmux"
"let g:slime_default_config = {"socket_name": "default", "target_pane": "1"}


" Shortcuts

" fugitive shortcuts
nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gd :Gdiff<cr>
nnoremap <leader>gl :Glog<cr>
