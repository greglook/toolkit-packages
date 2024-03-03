let g:beancount_separator_col = 65

" Shortcuts to align amounts
nnoremap <buffer> <leader>= :AlignCommodity<CR>
vnoremap <buffer> <leader>= :AlignCommodity<CR>

" Automatically align amounts when typing a decimal
inoremap <buffer> . .<C-\><C-O>:AlignCommodity<CR>

" Fold settings
function BeancountFoldLevel()
    let h = matchstr(getline(v:lnum), '^;; ==\+')
    if empty(h)
        return '='
    else
        return '>' . (len(h) - 4)
    endif
endfunction

function! BeancountFoldText()
    " Count the number of transactions in the fold
    let lnum = v:foldstart + 1
    let txcnt = 0

    while lnum <= v:foldend
        if getline(lnum) =~ '^\d\d\d\d-\d\d-\d\d '
            let txcnt += 1
        endif
        let lnum += 1
    endwhile

    " How many columns do we have to work with
    let columns = (winwidth(0) == 0 ? 80 : winwidth(0)) - &foldcolumn
    if &number
        let columns -= max([len(line('w$'))+1, &numberwidth])
    endif

    " Take first line of fold and trim for left side text
    let ltext = substitute(getline(v:foldstart), '\(^;;\s\+\|\s\+=*\s*$\)', '', 'g')
    let lwidth = strdisplaywidth(ltext)

    " Right text shows transaction count
    let rtext = printf(' %d txn ', txcnt)
    let rwidth = strdisplaywidth(rtext)

    let foldtext = ltext . ' '

    " Fill inner space across screen
    let fillcnt = columns - lwidth - rwidth - 1
    if 0 < fillcnt
        let foldtext .= repeat('·', fillcnt) . rtext
    endif

    return foldtext
endfunction

setlocal foldmethod=expr
setlocal foldexpr=BeancountFoldLevel()
setlocal foldtext=BeancountFoldText()
