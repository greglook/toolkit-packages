" Vim syntax file
" Language:     Jinja include
" Filenames:    *.j2
" Version:      0.1

syn keyword jinjaStatement containedin=jinjaVarBlock,jinjaTagBlock,jinjaNested contained and if else in not or recursive as import
syn keyword jinjaStatement containedin=jinjaVarBlock,jinjaTagBlock,jinjaNested contained is filter skipwhite nextgroup=jinjaFilter
syn keyword jinjaSpecial containedin=jinjaVarBlock,jinjaTagBlock,jinjaNested contained false true none False True None loop super caller varargs kwargs

syn match jinjaVariable containedin=jinjaVarBlock,jinjaTagBlock,jinjaNested contained /[a-zA-Z_][a-zA-Z0-9_]*/
syn match jinjaOperator "|" containedin=jinjaVarBlock,jinjaTagBlock,jinjaNested contained skipwhite nextgroup=jinjaFilter
syn match jinjaFilter contained /[a-zA-Z_][a-zA-Z0-9_]*/
syn match jinjaFunction contained /[a-zA-Z_][a-zA-Z0-9_]*/
syn match jinjaBlockName contained /[a-zA-Z_][a-zA-Z0-9_]*/

syn region jinjaString containedin=jinjaVarBlock,jinjaTagBlock,jinjaNested contained start=/"/ skip=/\(\\\)\@<!\(\(\\\\\)\@>\)*\\"/ end=/"/
syn region jinjaString containedin=jinjaVarBlock,jinjaTagBlock,jinjaNested contained start=/'/ skip=/\(\\\)\@<!\(\(\\\\\)\@>\)*\\'/ end=/'/
syn match jinjaNumber containedin=jinjaVarBlock,jinjaTagBlock,jinjaNested contained /[0-9]\+\(\.[0-9]\+\)\?/

syn match jinjaOperator containedin=jinjaVarBlock,jinjaTagBlock,jinjaNested contained /[+\-*\/<>=!,:]/
syn match jinjaPunctuation containedin=jinjaVarBlock,jinjaTagBlock,jinjaNested contained /[()\[\]]/
syn match jinjaOperator containedin=jinjaVarBlock,jinjaTagBlock,jinjaNested contained /\./ nextgroup=jinjaAttribute
syn match jinjaAttribute contained /[a-zA-Z_][a-zA-Z0-9_]*/

syn region jinjaNested matchgroup=jinjaOperator start="(" end=")" transparent display containedin=jinjaVarBlock,jinjaTagBlock,jinjaNested contained
syn region jinjaNested matchgroup=jinjaOperator start="\[" end="\]" transparent display containedin=jinjaVarBlock,jinjaTagBlock,jinjaNested contained
syn region jinjaNested matchgroup=jinjaOperator start="{" end="}" transparent display containedin=jinjaVarBlock,jinjaTagBlock,jinjaNested contained
syn region jinjaTagBlock matchgroup=jinjaTagDelim start=/{%[-+]\?/ end=/[-+]\?%}/ containedin=ALLBUT,jinjaTagBlock,jinjaVarBlock,jinjaString,jinjaNested,jinjaComment
syn region jinjaVarBlock matchgroup=jinjaVarDelim start=/{{-\?/ end=/-\?}}/ containedin=ALLBUT,jinjaTagBlock,jinjaVarBlock,jinjaString,jinjaNested,jinjaComment
syn region jinjaComment matchgroup=jinjaCommentDelim start="{#" end="#}" containedin=ALLBUT,jinjaTagBlock,jinjaVarBlock,jinjaString,jinjaComment

highlight def link jinjaPunctuation jinjaOperator
highlight def link jinjaAttribute jinjaVariable
highlight def link jinjaFunction jinjaFilter

highlight def link jinjaTagDelim jinjaTagBlock
highlight def link jinjaVarDelim jinjaVarBlock
highlight def link jinjaCommentDelim jinjaComment
highlight def link jinjaRawDelim jinja

highlight def link jinjaSpecial Special
highlight def link jinjaOperator Normal
highlight def link jinjaRaw Normal
highlight def link jinjaTagBlock PreProc
highlight def link jinjaVarBlock PreProc
highlight def link jinjaStatement Statement
highlight def link jinjaFilter Function
highlight def link jinjaBlockName Function
highlight def link jinjaVariable Identifier
highlight def link jinjaString Constant
highlight def link jinjaNumber Constant
highlight def link jinjaComment Comment
