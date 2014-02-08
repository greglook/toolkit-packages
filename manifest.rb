# Manifest of available toolkit packages.

# scripts and utilities
package 'tools',    :default => true
package 'keychain', :dotfiles => ['zsh']

# shell configuration
package 'input',     :dotfiles => true, :default => true
package 'bash',      :dotfiles => true, :when => ( File.basename(ENV['SHELL']) == 'bash' )
package 'zsh',       :dotfiles => true, :when => ( File.basename(ENV['SHELL']) == 'zsh'  )
package 'cygwin',    :dotfiles => true, :when => ( File.exist? '/Cygwin.bat' )
package 'solarized', :dotfiles => ['vim', 'zsh']

# application settings
package 'git',     :dotfiles => true, :when => installed?('git')
package 'lein',    :dotfiles => true, :when => installed?('lein')
package 'tmux',    :dotfiles => true, :when => installed?('tmux')
package 'vim',     :dotfiles => true, :when => installed?('vim')
package 'vundle',  :into => '.vim'
package 'synergy', :into => 'util/synergy'

# programming languages
package 'rbenv', :dotfiles => true, :when => File.directory?(File.join(ENV['HOME'], '.rbenv'))

# misc packages
package 'gentoo', :into => 'util/gentoo'
package 'gtd',    :dotfiles => ['vim']
