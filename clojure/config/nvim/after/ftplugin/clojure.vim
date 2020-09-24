" Vim settings for Clojure files.

" Call out newer functions in clojure.core
let g:clojure_syntax_keywords = {
    \ 'clojureMacro': ["defproject"],
    \ 'clojureFunc': ["any?", "bytes?", "inst?", "uuid?", "boolean?", "pos-int?", "nat-int?",
    \                 "simple-ident?", "simple-keyword?", "simple-symbol?",
    \                 "qualified-ident?", "qualified-keyword?", "qualified-symbol?",
    \                 "swap-vals!", "requiring-resolve", "ex-cause", "ex-message"]
    \ }

" Increase max lines for indent tracking
let g:clojure_maxlines = 10000

" Shortcut to fix the current file
nnoremap <leader>cs :call cljstyle#fix()<cr>

" FIXME: use cljstyle for formatting
"setlocal equalprg=cljstyle\ pipe
"nnoremap <leader>cs gg=G''<cr>
