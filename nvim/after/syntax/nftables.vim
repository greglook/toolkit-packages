" Customizations for nftables syntax

" Jinja support
"if filereadable(stdpath('config') . '/syntax/jinja.vim')
    syntax include @Jinja syntax/jinja.vim
    syn region jinjaTagBlock matchgroup=PreProc start=/{%[-+]\?/ end=/[-+]\?%}/ extend containedin=ALLBUT,jinjaTagBlock,jinjaVarBlock,jinjaComment contains=@Jinja
    syn region jinjaVarBlock matchgroup=PreProc start=/{{-\?/ end=/-\?}}/ extend containedin=ALLBUT,jinjaTagBlock,jinjaVarBlock,jinjaComment contains=@Jinja
    syn region jinjaComment matchgroup=PreProc start="{#" end="#}" extend containedin=ALLBUT,jinjaTagBlock,jinjaVarBlock contains=@Jinja
"endif
