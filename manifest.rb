# Manifest of available toolkit packages.

# scripts and utilities
package 'tools', :default => true, :dotfiles => ['local']

# shell configuration
package 'input', :default => true,        :dotfiles => true
package 'bash',  :when => shell?('bash'), :dotfiles => true
package 'zsh',   :when => shell?('zsh'),  :dotfiles => true

# application settings
package 'tmux', :when => installed?('tmux'), :dotfiles => ['tmux.conf', 'zsh']
package 'vim',  :when => installed?('vim'),  :dotfiles => true
package 'nvim', :when => installed?('nvim'), :into => '.config/nvim'
package 'git',  :when => installed?('git'),  :into => '.config/git'

# programming languages
package 'clojure', :when => installed?('lein'),           :dotfiles => true
package 'rbenv',   :when => file?(ENV['HOME'], '.rbenv'), :dotfiles => true
