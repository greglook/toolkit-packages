# ZSH login configuration for rbenv.
#
# This requires rbenv to be present; to set it up, clone the repo:
# $ git clone git://github.com/sstephenson/rbenv.git ~/.rbenv
# $ git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

if [[ -s "$HOME/.rbenv" ]]; then
    unset RUBYOPT
    path=("$HOME/.rbenv/bin" $path)
    eval "$(rbenv init -)"
fi
