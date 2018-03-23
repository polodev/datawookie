---
author: Andrew B. Collier
date: 2017-12-04T03:00:00Z
excerpt_separator: <!-- more -->
tags:
- Cloud
- AWS
title: Creating an Amazon Machine Image
url: /2017/12/04/creating-amazon-machine-image/
---

Creating an Amazon Machine Image (AMI) makes it quick and simple to rebuild a specific EC2 setup. This post illustrates the process by creating an AMI with `ethminer` and NVIDIA GPU drivers. Of course you'd never use this for mining Ether because the hardware costs are still too high!

<!--more-->

## Spin Up an Instance

First we'll need to create an EC2 instance. We'll request a `g2.2xlarge` spot instance with the Ubuntu 16.04 base AMI. Once the request has been fulfilled and the instance is active we can connect via SSH.

{{< highlight text >}}
$ ssh ubuntu@ec2-34-224-101-229.compute-1.amazonaws.com
{{< / highlight >}}

Now the fun begins.

## Installing Prerequisites

Update the APT cache.

{{< highlight text >}}
$ sudo apt-get update -y
{{< / highlight >}}

Install `make`, `gcc` and the kernel header files. We'll need these to build the NVIDIA driver.

{{< highlight text >}}
$ sudo apt-get install -y make gcc linux-headers-$(uname -r)
{{< / highlight >}}

## Installing NVIDIA Driver

{% comment %}
You can install these drivers from a PPA?

Don't we have a post about installing these drivers already? I think it noted that there was a problem suspending laptop afterwards.

{{< highlight bash >}}
sudo apt-get install nvidia-cuda-dev nvidia-cuda-toolkit nvidia-nsight
{{< / highlight >}}
{% endcomment %}

Download the NVIDIA drivers and run the installer.

{{< highlight text >}}
$ wget http://us.download.nvidia.com/XFree86/Linux-x86_64/367.106/NVIDIA-Linux-x86_64-367.106.run
$ sudo /bin/bash ./NVIDIA-Linux-x86_64-367.106.run
{{< / highlight >}}

Accept the license conditions. There will be a couple of warnings, which you can safely ignore. Choose to run `nvidia-xconfig`. When the installer has finished, reboot.

{{< highlight text >}}
$ sudo reboot
{{< / highlight >}}

Obviously your connection will be broken during the reboot, so reconnect. Check that the drivers are installed and a GPU detected.

{{< highlight text >}}
$ nvidia-smi -q | head

==============NVSMI LOG==============

Timestamp                           : Sun Dec  3 17:29:33 2017
Driver Version                      : 367.106

Attached GPUs                       : 1
GPU 0000:00:03.0
    Product Name                    : GRID K520
    Product Brand                   : Grid
{{< / highlight >}}

Looks good!

## Install ethminer

Next we'll install `ethminer`. We could build it from source, but there's a precompiled binary available too, so let's go with that.

{{< highlight text >}}
$ wget https://github.com/ethereum-mining/ethminer/releases/download/v0.12.0/ethminer-0.12.0-Linux.tar.gz
{{< / highlight >}}

Unpack and move the binary into a location on the execution path.

{{< highlight text >}}
$ tar -zxvf ethminer-0.12.0-Linux.tar.gz
$ sudo mv bin/ethminer /usr/local/bin/
{{< / highlight >}}

Check that it works.

{{< highlight text >}}
$ ethminer --version
ethminer version 0.12.0
Build: Linux/g++/Release
{{< / highlight >}}

## Clean Up

Before we create the AMI, quickly clean up the `ubuntu` home folder. No sense in leaving cruft lying around.

## Create the AMI

The process of creating an AMI takes place on the EC2 dashboard, so head back there in your browser.

1. Select Instances from the menu on the left and choose the instance that we've been working on.
2. From the Actions dropdown, select Image and then Create Image.
3. Give it a suitable name and description.

![]({{ site.baseurl }}/static/img/2017/12/aws-ec2-create-image.png)

{:start="4"}
4. Press <kbd class="bg-primary">Create Image</kbd>.

![]({{ site.baseurl }}/static/img/2017/12/aws-ec2-pending-image.png)

{:start="5"}
5. Select AMIs from the menu on the left. The newly created AMI should now be listed.
6. At this stage you can safely terminate the instance we've been working on.

You can now easily create new EC2 instances provisioned with this freshly minted AMI.

![]({{ site.baseurl }}/static/img/2017/12/aws-ec2-select-image.png)

## Going Public

Unless you specifically wany to keep your shiny new AMI to yourself, you probably want to make it publicly accessible.

1. Select AMIs from the menu on the left. Choose your new AMI.
2. From the Actions dropdown, select Modify Image Permissions.
3. Change the radio button from Private to Public.
4. Press <kbd class="bg-primary">Save</kbd>.

Share it with your friends. Bask in the warm glow of making other people's lives easier.

One thing to note: AWS will create a snapshot for this AMI and you will be billed for storage of this snapshot. It's not prohibitively expensive, but it's also not free.