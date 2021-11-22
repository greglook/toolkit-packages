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
