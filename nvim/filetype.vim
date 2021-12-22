" Custom filetype detection.

if exists("did_load_filetypes")
  finish
endif

augroup filetypedetect
  " git
  au! BufNewFile,BufRead .gitignore set filetype=conf

  " hashicorp config language
  au! BufNewFile,BufRead *.hcl set filetype=hcl
  au! BufNewFile,BufRead *.tf set filetype=hcl
  au! BufNewFile,BufRead *.tfvars set filetype=hcl

  " javascript
  au! BufNewFile,BufRead *.json set filetype=javascript

  " markdown
  au! BufNewFile,BufRead *.m*down set filetype=markdown
  au! BufNewFile,BufRead *.md set filetype=markdown
  au! BufNewFile,BufRead README set filetype=markdown

  " nftables
  au! BufNewFile,BufRead *.nft set filetype=nftables

  " python
  au! BufNewFile,BufRead *.aurora set filetype=python

  " ruby
  au! BufNewFile,BufRead Vagrantfile set filetype=ruby
  au! BufNewFile,BufRead *.pp set filetype=ruby

  " salt
  au! BufNewFile,BufRead *.sls set filetype=yaml
augroup END
