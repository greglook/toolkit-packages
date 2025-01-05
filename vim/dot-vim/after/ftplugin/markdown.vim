" Vim settings for markdown files.

" use <localleader>1/2/3 to add headings
nnoremap <buffer> <localleader>1 yypVr=
nnoremap <buffer> <localleader>2 yypVr-
nnoremap <buffer> <localleader>3 I### <ESC>

" wrap at 80 characters
set textwidth=80
set wrapmargin=2
