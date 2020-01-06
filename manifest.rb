# Manifest of available toolkit packages.

# scripts and utilities
package 'tools',    :default => true
package 'keychain', :dotfiles => ['zsh']

# shell configuration
package 'input', :default => true,        :dotfiles => true
package 'bash',  :when => shell?('bash'), :dotfiles => true
package 'zsh',   :when => shell?('zsh'),  :dotfiles => true

# application settings
package 'git',  :when => installed?('git'),  :into => '.config/git'
package 'tmux', :when => installed?('tmux'), :dotfiles => ['tmux.conf', 'zsh']
package 'vim',  :when => installed?('vim'),  :dotfiles => true

# programming languages
package 'lein',  :when => installed?('lein'),           :dotfiles => true
package 'rbenv', :when => file?(ENV['HOME'], '.rbenv'), :dotfiles => true

# misc packages
package 'gtd', :dotfiles => ['vim']
