---
draft: true
title: 'Setting up Hortonworks HDP on VirtualBox'
date: 2017-06-29T09:00:00+00:00
author: Andrew B. Collier
excerpt_separator: <!-- more -->
layout: post
categories:
  - Big Data
tags:
  - VirtualBox
  - Hortonworks
---

In VirtualBox go to File -> Import Appliance. Select the file that you downloaded.

https://hortonworks.com/tutorial/sandbox-deployment-and-install-guide/section/1/

![]({{ site.baseurl }}/static/img/2017/06/virtualbox-import-appliance-hortonworks-hdp.png)
![]({{ site.baseurl }}/static/img/2017/06/virtualbox-appliance-settings-hortonworks-hdp.png)
![]({{ site.baseurl }}/static/img/2017/06/virtualbox-launch-hortonworks-hdp.png)

When you try to start the new image you might get the following error. This suggests that you'll need to tweak your BIOS.

![]({{ site.baseurl }}/static/img/2017/06/virtualbox-vt-x-disabled.png)

In addition to the error above, you might also have noted that you were only able to specify 32 bit versions of the operating system.

![]({{ site.baseurl }}/static/img/2017/06/virtualbox-only-32-bit.png)

Both of these issues can be resolved by rebooting your machine and enabling suitable virtualisation options in your BIOS. You can read more about this issue [here](https://askubuntu.com/questions/308937/cannot-install-ubuntu-in-virtualbox-due-to-this-kernel-requires-an-x86-64-cpu). Once you've done that you should be able to select a 64 bit operating system and you shouldn't see the error dialog again.

<!--
You might also be prompted to modify the base memory for the image.

![]({{ site.baseurl }}/static/img/2017/06/virtualbox-base-memory.png)
-->
