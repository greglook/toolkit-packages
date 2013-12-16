" Vim syntax file
" Language:     Getting Things Done (gtd) organization files
" Maintainer:   Greg Look
" Filenames:    *.gtd
" Version:      1.0

" Quit when a syntax file was already loaded.
if exists("b:current_syntax")
    finish
endif

highlight gtdPerson ctermfg=Green
highlight gtdTag ctermfg=Cyan
highlight gtdContext ctermfg=Magenta
highlight gtdDate ctermfg=Yellow
highlight gtdUri term=underline ctermfg=DarkMagenta
highlight gtdList term=bold ctermfg=DarkCyan

highlight gtdCategory term=bold ctermfg=Blue
highlight gtdProject term=bold ctermfg=Yellow
highlight gtdProjectBase ctermfg=DarkGrey
highlight gtdProjectItem ctermfg=White
highlight gtdAction term=bold ctermfg=Red
highlight gtdPending term=bold ctermfg=DarkRed


syntax match gtdPerson /@\w\+/
syntax match gtdTag /#\w\+/
syntax match gtdContext /:\w\+:/
syntax match gtdDate /<\d\d\d\d-\d\d-\d\d.*>/ms=s+1,me=e-1
syntax match gtdUri /\[\[.*\]\]/ms=s+2,me=e-2
syntax match gtdList /^\s*-\s/

syntax match Comment /^\s*\/\/.*$/
syntax match gtdCategory /^===.*$/
syntax match gtdProject /^\*.*$/ contains=gtdPerson,gtdTag
syntax match gtdProjectBase /^\*\*.*$/ contains=gtdProjectItem
syntax match gtdProjectItem /\*[^*].*$/ contained
syntax match gtdAction /^! .*$/ contains=gtdPerson,gtdTag,gtdContext,gtdDate
syntax match gtdPending /^\~ .*$/ contains=gtdPerson,gtdTag,gtdContext,gtdDate


let b:current_syntax = "gtd"
