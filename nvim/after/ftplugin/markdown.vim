" Vim settings for Markdown files.

function MarkdownLevel()
    let h = matchstr(getline(v:lnum), '^#\+')
    if empty(h)
        return "="
    else
        return ">" . len(h)
    endif
endfunction

setlocal foldexpr=MarkdownLevel()
setlocal foldmethod=expr

let g:markdown_fenced_languages = ['html', 'python', 'lua', 'vim', 'typescript', 'javascript', 'clojure']
