---
author: Andrew B. Collier
date: 2015-06-19T12:18:20Z
excerpt_separator: <!-- more -->
id: 1555
tags:
- AWS
- EC2
title: 'Amazon EC2: Adding Swap'
url: /2015/06/19/amazon-ec2-adding-swap/
---

So, after [upgrading to R 3.2.0](http://www.exegetic.biz/blog/2015/06/amazon-ec2-upgrading-r/) on my EC2 instance, I was installing newer versions of various packages and I ran into a problem with dplyr: virtual memory exhausted!

Seemed like a good time to add some swap.

<!--more-->

## Adding Swap and Turning it On

First become root and then make some swap files. I am in favour of creating a few smaller swap files rather than a single monolithic one.

{{< highlight bash >}}
# dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
# dd if=/dev/zero of=/var/swap.2 bs=1M count=1024
# dd if=/dev/zero of=/var/swap.3 bs=1M count=1024
{{< / highlight >}}

Another way to create swap files is by using `fallocate`, which actually provides a more intuitive interface.

{{< highlight bash >}}
# fallocate -l 1G /var/swap.1
{{< / highlight >}}

To make sure that these files are secure, change the access permissions.

{{< highlight bash >}}
# chmod 600 /var/swap.[123]
{{< / highlight >}}

Next you'll set up a swap area on each of these files.

{{< highlight bash >}}
# /sbin/mkswap /var/swap.1
# /sbin/mkswap /var/swap.2
# /sbin/mkswap /var/swap.3
{{< / highlight >}}

Finally activate as many of the swap files as you require to give you sufficient virtual memory. I just needed one for starters.

{{< highlight bash >}}
# /sbin/swapon /var/swap.1
{{< / highlight >}}

If you want the swap space to be activated again after reboot then you will need to add an entry to `/etc/fstab`. More information can be found [here](http://danielgriff.in/2014/add-swap-space-to-ec2-to-increase-performance-and-mitigate-failure/).

## Turning it Off Again

When you are done with the memory intensive operations you might want to disable the swap files.

{{< highlight bash >}}
# /sbin/swapoff /var/swap.1
{{< / highlight >}}

Here's everything in a Gist (using just a single swap file and setting its size from an environment variable).

<script src="https://gist.github.com/DataWookie/1b17eac75ccab1172aa79c7756761f6a.js"></script>