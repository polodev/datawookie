## Shell Prompt
draft: true

export PS1="\[\e[32m\]\W\n\[\e[m\]\[\e[34m\]\\$\[\e[m\] "

## Window Size

1280x720

$ wmctrl -r ":SELECT:" -e 0,-1,-1,1280,720

Then just click on the window that you want to resize.

You might not get a window that is precisely this size in pixels because the size of a terminal window is an integral number of rows and columns.

1920x1080

## Terminal Font

Monospace Regular 12 pt