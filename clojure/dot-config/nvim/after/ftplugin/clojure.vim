" Vim settings for Clojure files.

" Call out newer functions in clojure.core
let g:clojure_syntax_keywords = {
    \ 'clojureMacro': ["defproject"],
    \ 'clojureFunc': ["any?", "boolean?", "bytes?", "inst?", "uuid?", "uri?",
    \                 "pos-int?", "nat-int?", "NaN?", "infinite?",
    \                 "simple-ident?", "simple-keyword?", "simple-symbol?",
    \                 "qualified-ident?", "qualified-keyword?", "qualified-symbol?",
    \                 "parse-boolean", "parse-double", "parse-long", "parse-uuid",
    \                 "random-uuid", "abs", "update-keys", "update-vals",
    \                 "halt-when", "iteration",
    \                 "swap-vals!", "reset-vals!", "requiring-resolve", "ex-cause", "ex-message"]
    \ }

" Increase max lines for indent tracking
let g:clojure_maxlines = 10000
let g:paredit_maxlines = 10000

" Shortcut to fix the current file
nnoremap <leader>cs :call cljstyle#fix()<cr>

" FIXME: use cljstyle for formatting
"setlocal equalprg=cljstyle\ pipe
"nnoremap <leader>cs gg=G''<cr>
