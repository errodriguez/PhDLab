#! /usr/bin/env bash
#
# LSCOLORS.scd v1.0.0
#
# Colors settings for a Unix BASH environment in OS X/macOS.
# 
## IPN-CIC:Eduardo René Rodríguez Ávila:PhD Research:July 2017
###############################################################################

#+ From ls(1) man page:
#&
#& The value of LSCOLORS describes what color to use for which attribute when
#& colors are enabled with CLICOLOR.  This string is a concatenation of pairs
#& of the format fb, where f is the foreground color and b is the background
#& color. The color designators are as follows:
#&
#&    a     black
#&    b     red
#&    c     green
#&    d     brown
#&    e     blue
#&    f     magenta
#&    g     cyan
#&    h     light grey
#&    A     bold black, usually shows up as dark grey
#&    B     bold red
#&    C     bold green
#&    D     bold brown, usually shows up as yellow
#&    E     bold blue
#&    F     bold magenta
#&    G     bold cyan
#&    H     bold light grey; looks like bright white
#&    x     default foreground or background
#&
#& The above are standard ANSI colors.  The actual display may differ depending
#& on the color capabilities of the terminal in use.

#* The order of the attributes
#& are as follows:
#&
#&               directory
#&               | symbolic link
#&               | | socket
#&               | | | pipe
#&               | | | | executable
#&               | | | | | block special
#&               | | | | | | character special
#&               | | | | | | | executable with setuid bit set
#&               | | | | | | | | executable with setgid bit set
#&               | | | | | | | | | writable directory by others and sticky bit
#&               | | | | | | | | | | directory without sticky bit
#&               | | | | | | | | | | |
export LSCOLORS="GxACxCDCDxxCFCBxbxxGeG"
