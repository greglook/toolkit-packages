" Custom color scheme.
"
" Author: Greg Look


" ----- INITIALIZE COLORSCHEME -----

set background=dark

hi clear
if exists("syntax_on")
  syntax reset
endif

let colors_name = "slake"



" ----- HELPER FUNCTIONS -----

" Chooses the best color string, given the current terminal capabilities
" Arguments should be a 16-palette color and a 256-palette color. If only 8
" colors are supported, the 'basic' version of the 16 color will be used.
function! s:chooseColor(c16, ...)
    if &t_Co >= 256
        if a:0
            return a:1
        else
            return a:c16
        endif
    elseif &t_Co >= 16
        return a:c16
    elseif &t_Co == 8
        if a:c16 > 7
            return a:c16 - 8
        else
            return a:c16
        endif
    endif
endfunction


" Sets foreground highlight color for different terminal types.
function! s:hifg(group, c16, ...)
    if a:0 >= 2
        exe "highlight " . a:group . " guifg=" . a:2
    endif
    if a:0
        exe "highlight " . a:group . " ctermfg=" . s:chooseColor(a:c16, a:1)
    else
        exe "highlight " . a:group . " ctermfg=" . s:chooseColor(a:c16)
    endif
endfunction


" Sets background highlight color for different terminal types.
function! s:hibg(group, c16, ...)
    if a:0 >= 2
        exe "highlight " . a:group . " guibg=" . a:2
    endif
    if a:0
        exe "highlight " . a:group . " ctermbg=" . s:chooseColor(a:c16, a:1)
    else
        exe "highlight " . a:group . " ctermbg=" . s:chooseColor(a:c16)
    endif
endfunction


" Sets multiple highlight styles for different terminal types.
function! s:histyle(group, ...)
    if a:0 >= 1
        exe "highlight " . a:group . " term=" . a:1
    endif
    if a:0 >= 2
        exe "highlight " . a:group . " cterm=" . a:2
    endif
    if a:0 >= 3
        exe "highlight " . a:group . " gui=" . a:3
    endif
endfunction



" ----- SCHEME COLORS -----

"let s:base0       = "244"
"let s:base1       = "245"
"let s:yellow      = "136"
"let s:cyan        = "37"
"let s:green       = "64"
" ...



" ----- INTERFACE HIGHLIGHTING -----

" Basic Colors
call s:hifg("Normal",        7     ) | call s:hibg("Normal",        0, 232)
call s:hifg("NonText",       7, 250) | call s:hibg("NonText",       0     )
call s:hifg("LineNr",        3, 221) | call s:hibg("LineNr",        0, 235)
call s:hifg("StatusLine",    0, 236) | call s:hibg("StatusLine",    7     )
call s:hifg("StatusLineNC",  0, 236) | call s:hibg("StatusLineNC",  0     )
call s:hifg("VertSplit",     7, 232) | call s:hibg("VertSplit",     0, 236)
call s:hifg("Folded",       13     ) | call s:hibg("Folded",        5)


" Cursor Colors
call s:hifg("Cursor",        0     ) | call s:hibg("Cursor",        7     )
                                       call s:hibg("CursorColumn",  0     )
                                       call s:hibg("CursorLine",    0     ) | call s:histyle("CursorLine", "none", "underline")
                                       call s:hibg("MatchParen",    4,  20) | call s:histyle("MatchParen", "reverse", "bold")
                                       call s:hibg("Visual",        8,  52) | call s:histyle("Visual", "reverse")


" Other colors
call s:hifg("SpecialKey",   13     )
call s:hifg("Title",        12     )
                                       call s:hibg("ErrorMsg",      1)


" ----- SYNTAX HIGHLIGHTING -----

"hi Ignore       ctermfg=232

"hi Special      ctermfg=Red
"hi Statement    ctermfg=154
"hi Keyword      ctermfg=Yellow
"hi Identifier   ctermfg=Cyan
"hi Function     ctermfg=33

"hi Constant     ctermfg=33
"hi Type         ctermfg=208
"hi String       ctermfg=37
"hi Number       ctermfg=207
"hi Regexp       ctermfg=21

"hi Todo         ctermfg=Black   ctermbg=Yellow  cterm=bold



" Basic Highlighting
call s:hifg("Comment", 6)
"       *Comment         any comment

"call s:hifg("Constant",  6, s:cyan)
"       *Constant        any constant
"        String          a string constant: "this is a string"
"        Character       a character constant: 'c', '\n'
"        Number          a number constant: 234, 0xff
"        Boolean         a boolean constant: TRUE, false
"        Float           a floating point constant: 2.3e10

"call s:hifg("Identifier",  4, s:blue)
"       *Identifier      any variable name
"        Function        function name (also: methods for classes)

"call s:hifg("Statement", 10, s:green)
"       *Statement       any statement
"        Conditional     if, then, else, endif, switch, etc.
"        Repeat          for, do, while, etc.
"        Label           case, default, etc.
"        Operator        "sizeof", "+", "*", etc.
"        Keyword         any other keyword
"        Exception       try, catch, throw

call s:hifg("PreProc", 6, 81)
"       *PreProc         generic Preprocessor
"        Include         preprocessor #include
"        Define          preprocessor #define
"        Macro           same as Define
"        PreCondit       preprocessor #if, #else, #endif, etc.

call s:hifg("Type", 10)
"       *Type            int, long, char, etc.
"        StorageClass    static, register, volatile, etc.
"        Structure       struct, union, enum, etc.
"        Typedef         A typedef

call s:hifg("Special", 9)
"       *Special         any special symbol
"        SpecialChar     special character in a constant
"        Tag             you can use CTRL-] on this
"        Delimiter       character that needs attention
"        SpecialComment  special things inside a comment
"        Debug           debugging statements

"exe "hi! Underlined"     .s:fmt_none   .s:fg_violet .s:bg_none
"       *Underlined      text that stands out, HTML links

"exe "hi! Ignore"         .s:fmt_none   .s:fg_none   .s:bg_none
"       *Ignore          left blank, hidden  |hl-Ignore|

"exe "hi! Error"          .s:fmt_bold   .s:fg_red    .s:bg_none
"       *Error           any erroneous construct

"exe "hi! Todo"           .s:fmt_bold   .s:fg_magenta.s:bg_none
"       *Todo            anything that needs extra attention; mostly the
"                        keywords TODO FIXME and XXX


"exe "hi! SpecialKey"     .s:fmt_bold   .s:fg_base00 .s:bg_base02
"exe "hi! StatusLine"     .s:fmt_none   .s:fg_base1  .s:bg_base02 .s:fmt_revbb
"exe "hi! StatusLineNC"   .s:fmt_none   .s:fg_base00 .s:bg_base02 .s:fmt_revbb
"exe "hi! Visual"         .s:fmt_none   .s:fg_base01 .s:bg_base03 .s:fmt_revbb
"exe "hi! Directory"      .s:fmt_none   .s:fg_blue   .s:bg_none
"exe "hi! ErrorMsg"       .s:fmt_revr   .s:fg_red    .s:bg_none
"exe "hi! IncSearch"      .s:fmt_stnd   .s:fg_orange .s:bg_none
"exe "hi! Search"         .s:fmt_revr   .s:fg_yellow .s:bg_none
"exe "hi! MoreMsg"        .s:fmt_none   .s:fg_blue   .s:bg_none
"exe "hi! ModeMsg"        .s:fmt_none   .s:fg_blue   .s:bg_none
"exe "hi! Question"       .s:fmt_bold   .s:fg_cyan   .s:bg_none
"exe "hi! VertSplit"      .s:fmt_none   .s:fg_base00 .s:bg_base00
"exe "hi! Title"          .s:fmt_bold   .s:fg_orange .s:bg_none
"exe "hi! VisualNOS"      .s:fmt_stnd   .s:fg_none   .s:bg_base02 .s:fmt_revbb
"exe "hi! WarningMsg"     .s:fmt_bold   .s:fg_red    .s:bg_none
"exe "hi! WildMenu"       .s:fmt_none   .s:fg_base2  .s:bg_base02 .s:fmt_revbb
"exe "hi! Folded"         .s:fmt_undr   .s:fg_base0  .s:bg_base02
"exe "hi! FoldColumn"     .s:fmt_none   .s:fg_base0  .s:bg_base02
"exe "hi! DiffAdd"        .s:fmt_none   .s:fg_green  .s:bg_base02
"exe "hi! DiffChange"     .s:fmt_none   .s:fg_yellow .s:bg_base02
"exe "hi! DiffDelete"     .s:fmt_none   .s:fg_red    .s:bg_base02
"exe "hi! DiffText"       .s:fmt_none   .s:fg_blue   .s:bg_base02
"exe "hi! SignColumn"     .s:fmt_none   .s:fg_base0
"exe "hi! Conceal"        .s:fmt_none   .s:fg_blue   .s:bg_none
"exe "hi! SpellBad"       .s:fmt_curl   .s:fg_none   .s:bg_none
"exe "hi! SpellCap"       .s:fmt_curl   .s:fg_none   .s:bg_none
"exe "hi! SpellRare"      .s:fmt_curl   .s:fg_none   .s:bg_none
"exe "hi! SpellLocal"     .s:fmt_curl   .s:fg_none   .s:bg_none
"exe "hi! Pmenu"          .s:fmt_none   .s:fg_base0  .s:bg_base02  .s:fmt_revbb
"exe "hi! PmenuSel"       .s:fmt_none   .s:fg_base01 .s:bg_base2   .s:fmt_revbb
"exe "hi! PmenuSbar"      .s:fmt_none   .s:fg_base2  .s:bg_base0   .s:fmt_revbb
"exe "hi! PmenuThumb"     .s:fmt_none   .s:fg_base0  .s:bg_base03  .s:fmt_revbb
"exe "hi! TabLine"        .s:fmt_undr   .s:fg_base0  .s:bg_base02
"exe "hi! TabLineFill"    .s:fmt_undr   .s:fg_base0  .s:bg_base02
"exe "hi! TabLineSel"     .s:fmt_undr   .s:fg_base01 .s:bg_base2   .s:fmt_revbbu
"exe "hi! CursorColumn"   .s:fmt_none   .s:fg_none   .s:bg_base02
"exe "hi! CursorLine"     .s:fmt_undr   .s:fg_none   .s:bg_base02
"exe "hi! ColorColumn"    .s:fmt_none   .s:fg_none   .s:bg_base02
"exe "hi! Cursor"         .s:fmt_none   .s:fg_base03 .s:bg_base0
"exe "hi! MatchParen"     .s:fmt_bold   .s:fg_red    .s:bg_base01



