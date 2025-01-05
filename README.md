Toolkit Packages
================

This is a set of personal packages for use with
[GNU Stow](https://www.gnu.org/software/stow/). These packages contain
widely-used configuration (commonly known as 'dotfiles') and various utility
scripts I've written over the years.

Usage
-----
You'll need the `stow` tool installed, typically using the system's package
manager.

```shell
# See what would be done
stow -nv pkg

# Install package files
stow pkg1 pkg2 ...

# Uninstall a package
stow -D pkg
```

License
-------
This is free and unencumbered software released into the public domain.
