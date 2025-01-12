" Vim syntax file for Hyprland configs

if exists("b:current_syntax")
  finish
endif

syn iskeyword @,45

" Commas are pretty universal delimiters
syn match HyprComma ","
highlight link HyprComma Delimiter

" Primitive Values
syn keyword HyprLogical on off true false
syn match HyprNumber "\(\w-*\)\@4<![+-]\?\d\+\(\.\d\+\)\?\(%\|deg\)\?" display
syn match HyprResolution "\(\w-*\)\@4<!\d\+x\d\+" display
syn match HyprColor "rgba\?([^)]*)\?" contains=HyprNumber,HyprHex,HyprComma
syn match HyprHex "[0-9a-f]\{3,}" contained

highlight link HyprLogical Boolean
highlight link HyprNumber Number
highlight link HyprResolution Number
highlight link HyprColor Function
highlight link HyprHex Constant

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

" monitor = name, resolution, position, scale[, options...]
syn match HyprCommandMonitor "\(^\s*\)\@24<=monitor\s*=.*" contains=HyprCommandEquals,HyprComma,HyprCommandMonitorName,HyprCommandMonitorKeyword,HyprNumber,HyprResolution,HyprLogical
syn match HyprCommandMonitorName "\(=\s*\)\@20<=\s*[^,]\+" contained
syn keyword HyprCommandMonitorKeyword contained preferred highres highrr auto auto-right auto-left auto-up auto-down disable transform mirror bitdepth vrr

highlight link HyprCommandMonitor HyprCommandLine
highlight link HyprCommandMonitorName String
highlight link HyprCommandMonitorKeyword Keyword

" bind = MODS, key, [description,] dispatcher, params
syn match HyprCommandBind "\(^\s*\)\@24<=bind[lroenmtisdp]*\s*=.*" contains=HyprCommandEquals,HyprComma,HyprCommandBindMods,HyprComment
",HyprCommandBindKey,HyprCommandBindDescription,HyprCommandBindDispatcher,HyprCommandBindParams
syn keyword HyprKeyModifier SUPER SHIFT CTRL CONTROL ALT CAPS MOD2 MOD3 MOD4 MOD5
syn match HyprCommandBindMods "\(=\s*\)\@20<=\s*[^,]\+," contained contains=HyprVar,HyprKeyModifier,HyprComma nextgroup=HyprCommandBindKey
syn match HyprCommandBindKey "\s*[^,]\+," contained contains=HyprVar,HyprComma nextgroup=HyprCommandBindDispatcher
syn match HyprCommandBindDispatcher "\s*[^,]\+\(,\|$\)" contained contains=HyprVar,HyprComma nextgroup=HyprCommandBindParams
syn match HyprCommandBindParams "\s*[^,#]\+$" contained contains=HyprVar

highlight link HyprCommandBind HyprCommandLine
highlight link HyprKeyModifier Identifier
highlight link HyprCommandBindKey String
highlight link HyprCommandBindDescription String
highlight link HyprCommandBindDispatcher Statement
highlight link HyprCommandBindParams None

" env = name,value
syn match HyprCommandEnv "\(^\s*\)\@24<=env\s*=.*" contains=HyprCommandEquals,HyprComma,HyprCommandEnvVar,HyprCommandEnvValue
syn match HyprCommandEnvVar "\(=\s*\)\@20<=\s*[^,]\+," contained contains=HyprComma nextgroup=HyprCommandEnvValue
syn match HyprCommandEnvValue "\(,\s*\)\@20<=.*$" contained contains=HyprVar

highlight link HyprCommandEnv HyprCommandLine
highlight link HyprCommandEnvVar None
highlight link HyprCommandEnvValue String

" Comments
" Last to take priority
syn match HyprComment "\(#\|\/\/\).*$" contains=HyprTodo
syn match HyprTodo "\(TODO\|FIXME\|NOTE\|XXX\)" contained

highlight link HyprComment Comment
highlight link HyprTodo Todo
