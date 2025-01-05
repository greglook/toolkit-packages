" Customizations for Beancount syntax

highlight beanDate guifg=White

highlight! link beanMeta String
highlight! link beanTag Special

" highlight TODOs in comments
syn region beanComment start="\s*;" end="$" keepend contains=beanMarker,beanTODO
syntax keyword beanTODO contained TODO FIXME
highlight link beanTODO Todo
