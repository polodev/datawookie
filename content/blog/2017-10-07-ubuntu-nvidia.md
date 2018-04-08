---
author: Andrew B. Collier
date: 2017-10-07T07:00:00Z
tags: ["Linux", "GPU"]
title: Installing NVIDIA Graphics Driver on Ubuntu
---

{{< comment >}}
https://linuxconfig.org/how-to-install-the-latest-nvidia-drivers-on-ubuntu-16-04-xenial-xerus
{{< /comment >}}

Recipe for installing the NVIDIA binary drivers on Ubuntu.

<!--more-->

## Hardware Check

First check your hardware: which graphics card do you have?

{{< highlight bash >}}
$ sudo lshw -numeric -C display | grep -E "(product|vendor)"
{{< /highlight >}}

According to that I have a [GeForce 930MX](https://www.geforce.com/hardware/notebook-gpus/geforce-930mx) card.

{{< highlight text >}}
       product: Intel Corporation [8086:5916]
       vendor: Intel Corporation [8086]
       product: GM108M [GeForce 930MX] [10DE:134E]
       vendor: NVIDIA Corporation [10DE]
{{< /highlight >}}

## Driver Version

Next head over to the [driver download page](http://www.nvidia.com/Download/index.aspx) on the NVIDIA site. Find your card and hit Search

![](/img/2017/10/nvidia-drivers.png)

The next page will tell you what driver version you should be running. You can download the driver from here but we are going to use the [PPA](https://help.launchpad.net/Packaging/PPA) instead.

![](/img/2017/10/nvidia-drivers-download.png)

## Driver Download

First add the PPA.

{{< highlight bash >}}
$ sudo add-apt-repository ppa:graphics-drivers/ppa
$ sudo apt update
{{< /highlight >}}

Then download and install.

{{< highlight bash >}}
$ sudo apt-get install nvidia-384
{{< /highlight >}}

After a reboot you'll be able to access the settings dialog.

{{< highlight bash >}}
$ nvidia-settings
{{< /highlight >}}

![](/img/2017/10/nvidia-settings.png)

Somewhat disappointingly, after I installed these drivers I had issues with suspending my laptop.
