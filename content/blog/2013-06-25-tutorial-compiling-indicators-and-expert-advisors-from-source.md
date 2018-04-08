---
author: Andrew B. Collier
date: 2013-06-25T06:41:10Z
title: 'Tutorial: Compiling Indicators and Expert Advisors from Source'
---

When you receive the code for an expert advisor or indidator which we have developed for you, it will come in a package consisting of include files (with a .mqh extension) and source code files (with a .mq4 extension). So, what do you do with them?

<!--more-->

## Why You Need to Have the Source Files

Before we go into the steps involved in compiling the source files, perhaps it would make sense to tell you why you should get the source code rather than simple the executable (.ex4 extension) files. Sure, dealing with the executable is easier: you just stick it in the correct directory and off you go. However, only having the executable can present a number of problems:

1. If you want to make modifications to the code in the future, then this is only possible if you have the source code.
2. It is difficult (or impossible) to track down problems in the implementation if you are not able to audit the source code.
3. Different versions of the MetaTrader platform appear to produce slightly different .ex4 files. Although this does not happen often, an .ex4 file compiled on one version of MetaTrader does not work on another version. So if you are planning on updating your installation of MetaTrader in the future (which is very probable) then you will need to have the source to get around these compatability issues.
4. Often the documentation is given in the form of comments in the code. Certainly this is the way that the code _should_ be written. To read the commentary, you need to have the source!

## Putting Files into Correct Directories

The first thing that you need to do is move these files to the correct directories. Find the MetaTrader install directory (it will be somewhere under C:Program Files). Within this directory there will be an experts/ subdirectory. Now, do the following:

1. Open the experts/ subdirectory.
2. Put expert advisor .mq4 files into this directory (red in the image below).
3. Put indicator .mq4 files into the indicators/ subdirectory (blue in the image below).
4. Put the .mqh files into the include/ subdirectory (green in the image below).

How do you differentiate between expert advisor and indicator .mq4 files? Quite simple: the latter will have either

{{< highlight text >}}
#property indicator_separate_window
{{< /highlight >}}

or

{{< highlight text >}}  
#property indicator_chart_window
{{< /highlight >}}

near to the top of the file.

<img src="/img/2013/06/Windows-7-Running-Oracle-VM-VirtualBox_071.png" width="100%">

## Compiling the Source Code

Once everything is in the right place, all that remains is to compile the source code. Open the MetaEditor (you can do this by pressing MetaEditor button in the task bar of the MetaTrader terminal). Now use the file browser on the right of the window to find the .ma4 file that you are interested in. Open the file and then press the Compile button (yellow oval in window below).

<img src="/img/2013/06/Windows-7-Running-Oracle-VM-VirtualBox_070.png" width="100%">

Check the Errors tab in the bottom panel of the window. If all goes according to plan (no errors and not too many warnings!) then you will find that the freshly compiled expert advisor or indicator is now available to run from the MetaTrader terminal.

Happy trading!
