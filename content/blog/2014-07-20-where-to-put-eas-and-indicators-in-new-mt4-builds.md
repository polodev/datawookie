---
author: Andrew B. Collier
date: 2014-07-20T07:42:59Z
title: Where to Put EAs and Indicators in New MT4 Builds
---

If you are creating an EA or indicator from scratch, then the MetaTrader editor places the files in the correct location and the terminal is automatically able to find them. However, if the files originate from a third party then you will need to know where to insert them so that they show up in the terminal. For older builds of MetaTrader 4 the directory structure was fairly simple. <!--more--> Everything was to be found in a folder under _Program Files_. Its contents looked like this:

<img src="/img/2014/07/MT4-old-folders-windows.png">

EAs would go in the _experts_ folder, while indicators would go one level further down in the _indicators_ sub-folder.

But everything is different with the new builds of MetaTrader 4.

## Windows

On Windows (and here I am referring specifically to Windows 7, although the setup will be similar on other flavours) the structure of the MetaTrader folder (still found under _Program Files_) now looks like this:

<img src="/img/2014/07/MT4-new-folders-windows.png">

There seems to be something missing, right? Where do the EA and indicator files go? To find these you will need to look elsewhere. There is now a separate directory hierarchy for each user, in which these files are stored. Browsing under the _AppData_ folder for your user you should find

<img src="/img/2014/07/MT4-personal-folder-windows.png">

Locating this folder can be a little tricky. First look under _Users_ to find the folder associated with your user name. Within this folder you may or may not be able to see an _AppData_ folder. If you can't see it then you will need to reveal hidden files by changing the folder options.

<img src="/img/2014/07/folder-options-hidden-files.png">

Once you have dug down to your _Terminal_ folder it should contain a set of sub-folders like this:

<img src="/img/2014/07/MT4-personal-folder-contents-windows.png">

If you descend further into one of those obscurely named folders, then you will find further sub-folders.

<img src="/img/2014/07/MT4-personal-instance-contents-windows.png">

Finally, within the _MQL4_ folder, you will find this:

<img src="/img/2014/07/MT4-mt4-folder-windows.png">

The _Experts_ and _Indicators_ folders are where you will insert those EAs and indicators.

## Linux

If you are running MetaTrader under Wine on Linux, then the new directory structure looks like this:

<img src="/img/2014/07/MT4-new-folders-linux.png">

Evidently the structure is a little simpler here, because all of the files and directories are still lumped in a single location. The _Experts_ and _Indicators_ directories are to be found under _MQL4_.
