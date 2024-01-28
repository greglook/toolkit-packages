" Vim settings for Ledger files.

let g:ledger_date_format = '%Y-%m-%d'

" Mint sourcing macro
"let @m='VG,rGI; source: mint|'

" Link insertion macro
let @l=':read !random 16i    ; link: '
let @t=':read !random 16i        ; transfer: '

" Fold settings
function LedgerFoldLevel()
    let h = matchstr(getline(v:lnum), '^;; ==\+')
    if empty(h)
        return '='
    else
        return '>' . (len(h) - 4)
    endif
endfunction

function! LedgerFoldText()
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
setlocal foldexpr=LedgerFoldLevel()
setlocal foldtext=LedgerFoldText()
