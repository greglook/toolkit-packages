#!/bin/bash

# Pipe this into the following commands to test and execute, respectively:
# $ xargs sudo apt-get --dry-run remove
# $ xargs sudo apt-get -y purge

CURRENT_KERNEL=$(uname -r | cut -d - -f 1,2)

dpkg -l 'linux-*' \
    | awk '/^ii/ { print $2 }' \
    | grep -v $CURRENT_KERNEL \
    | grep -e '[0-9]' \
    | grep -E '(image|headers)'
