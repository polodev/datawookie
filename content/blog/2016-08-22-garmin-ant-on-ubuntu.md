---
id: 4061
title: Garmin ANT on Ubuntu
date: 2016-08-22T15:00:53+00:00
author: Andrew B. Collier
layout: post
guid: http://www.exegetic.biz/blog/?p=4061
categories:
  - Running
  - Ubuntu
tags:
  - Garmin
---
I finally got tired of booting up Windows to download data from my Garmin 910XT. I tried to get my old Ubuntu 15.04 system to recognise my ANT stick but failed. Now that I have a stable Ubuntu 16.04 system the time seems ripe.

<img src="{{ site.baseurl }}/static/img/2016/08/garmin-tux.jpg" width="100%">

## openant

Install `openant`, a Python library for downloading and uploading files from ANT-FS compliant devices.

1. Download the zip file from [https://github.com/Tigge/openant](https://github.com/Tigge/openant/archive/master.zip). 
2. Unpack the archive and install using

{% highlight bash %}
$ sudo python setup.py install
{% endhighlight %}

## antfs-cli
        
Install `antfs-cli`, which implements a Command Line Interface to ANT-FS.

1. Download the zip file from [https://github.com/Tigge/antfs-cli/](https://github.com/Tigge/antfs-cli/archive/master.zip). 
2. Unpack the archive and install using

{% highlight bash %}
$ sudo python setup.py install
{% endhighlight %}

3. This will automatically install `pyusb` if necessary. </ol>

## Connect Device

Connect your ANT stick and check that it is recognised by your system.

{% highlight bash %}
$ lsusb | grep Dynastream
Bus 003 Device 030: ID 0fcf:1008 Dynastream Innovations, Inc. ANTUSB2 Stick
{% endhighlight %}

The two hexadecimal numbers following `ID` in the output above are then used to load the appropriate kernel module.

{% highlight bash %}
$ sudo modprobe usbserial vendor=0x0fcf product=0x1008
{% endhighlight %}

You can also check that the corresponding device has been created.

{% highlight bash %}
$ ls -l /dev/ttyANT2
lrwxrwxrwx 1 root root 15 Aug 21 11:33 /dev/ttyANT2 -> bus/usb/003/030
{% endhighlight %}

## Pair and Enjoy

If the above has gone smoothly then you are ready to grab data from your device. Turn it on and...

{% highlight bash %}
$ antfs-cli --pair
{% endhighlight %}

You should find the resulting FIT files under a path like `~/.config/antfs-cli/3860872045/activities`. The numeric folder name is uniquely linked to your advice, so that part of the path with differ.

If you're like me then you'll probably have a bunch of FIT files that need to be uploaded to Garmin Connect. Use [this link](https://connect.garmin.com/modern/activity-sync) and select the Manual Import tab to upload multiple files at once.
