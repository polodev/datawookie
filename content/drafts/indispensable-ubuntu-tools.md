DISK ACTIVITY
draft: true

sudo iotop --only

FINDING CONTENTS OF PACKAGE:

apt-file list <package-name>

FINDING WHAT PACKAGE A FILE IS FROM:

$ locate GL/glu.h
/usr/include/GL/glu.h
$ dpkg -S /usr/include/GL/glu.h
libglu1-mesa-dev:amd64: /usr/include/GL/glu.h

RESIZING WINDOW

wmctrl -l
wmctrl -i -r 0x032000c5 -e 0,0,0,1100,750

PACKAGES

List available packages

apt-cache pkgnames

See https://www.tecmint.com/useful-basic-commands-of-apt-get-and-apt-cache-for-package-management/

SHELL

http://azer.bike/journal/10-linux-commands-every-developer-should-know/

### Keeping Track of Processes

top

htop

### `watch`

watch -n 5 free
