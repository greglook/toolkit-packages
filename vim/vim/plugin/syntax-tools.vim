" Vim macro to display info about the highlighting groups applied to the
" text under the cursor.

function! SyntaxInfo()

    let tid = synID(line("."), col("."), 0) | " ID of the top-level (possibly transparent) syntax
    let sid = synID(line("."), col("."), 1) | " visible syntax applied to the text
    let eid = synIDtrans(sid)               | " effective ID used to actually color the text

    let info = ""

    let info .=    " top<" . synIDattr(tid, "name") . ">"
    let info .= " syntax<" . synIDattr(sid, "name") . ">"
    let info .=  " group<" . synIDattr(eid, "name") . ">"

    let ctermfg = synIDattr(eid, "fg", "cterm") | if ( ctermfg != -1 ) && !empty(ctermfg) | let info .= " ctermfg=" . ctermfg | endif
    let ctermbg = synIDattr(eid, "bg", "cterm") | if ( ctermbg != -1 ) && !empty(ctermbg) | let info .= " ctermbg=" . ctermbg | endif

    let cterm = ""
    if !empty(synIDattr(eid, "bold",      "cterm")) | let cterm .= ",bold"      | endif
    if !empty(synIDattr(eid, "italic",    "cterm")) | let cterm .= ",italic"    | endif
    if !empty(synIDattr(eid, "reverse",   "cterm")) | let cterm .= ",reverse"   | endif
    if !empty(synIDattr(eid, "standout",  "cterm")) | let cterm .= ",standout"  | endif
    if !empty(synIDattr(eid, "underline", "cterm")) | let cterm .= ",underline" | endif
    if !empty(cterm) | let info .= " cterm=" . cterm[1:] | endif

    echo info
endfunction

nnoremap <leader>` :call SyntaxInfo()<CR>
