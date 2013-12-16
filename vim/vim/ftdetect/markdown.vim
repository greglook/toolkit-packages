" Detection rules for markdown files

au! BufNewFile,BufRead *.m*down set filetype=markdown
au! BufNewFile,BufRead *.md     set filetype=markdown
au! BufNewFile,BufRead README   set filetype=markdown
