" Vim syntax file for Hyprland configs

if exists("b:current_syntax")
  finish
endif

" Commas are pretty universal delimiters
syn match HyprComma ","
highlight link HyprComma Delimiter

" Primitive Values
syn match HyprNumber "\(\w-*\)\@4<![+-]\?\d\+\(\.\d\+\)\?\(%\|deg\)\?" display
syn match HyprResolution "\(\w-*\)\@4<!\d\+x\d\+" display
syn match HyprColor "rgba\?([^)]*)\?" contains=HyprNumber,HyprHex,HyprComma
syn match HyprHex "[0-9a-f]\{3,}" contained

highlight link HyprNumber Number
highlight link HyprResolution Number
highlight link HyprColor Function
highlight link HyprHex Constant

" Keywords
syn iskeyword @,45

syn keyword HyprLogical on off true false
syn keyword HyprKeyModifier SUPER SHIFT CTRL CONTROL ALT CAPS MOD2 MOD3 MOD4 MOD5

highlight link HyprLogical Boolean
highlight link HyprKeyModifier Identifier

" Variables
syn match HyprVar "\$[a-zA-Z][a-zA-Z0-9_]*" display

highlight link HyprVar Define

" Categories
syn match HyprCategoryName "\w\+" contained
syn match HyprCategoryStart "\s*\w\+\s\+{" contains=HyprCategoryName
syn match HyprCategoryEnd "\s*}"

highlight link HyprCategoryName Statement
highlight link HyprCategoryStart Delimiter
highlight link HyprCategoryEnd Delimiter

" General Command Syntax
syn match HyprCommandLine "\(^\s*\)\@24<=\S\+\s*=" contains=HyprCommandEquals
syn match HyprCommandEquals "=" contained

highlight link HyprCommandLine Statement
highlight link HyprCommandEquals Delimiter

" Specific Commands
" ...

" Comments
" Last to take priority
syn match HyprComment "\(#\|\/\/\).*$" contains=HyprTodo
syn match HyprTodo "\(TODO\|FIXME\|NOTE\|XXX\)" contained

highlight link HyprComment Comment
highlight link HyprTodo Todo
