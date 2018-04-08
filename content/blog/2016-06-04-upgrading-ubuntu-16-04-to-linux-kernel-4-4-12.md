---
author: Andrew B. Collier
date: 2016-06-04T08:35:57Z
tags: ["Linux"]
title: Upgrading Ubuntu 16.04 to Linux Kernel 4.4.12
---

I've had a few minor hardware issues with the default kernel in Ubuntu 16.04. For example, hibernate does not work on my laptop. So, in an effort to resolve these problems, I upgraded from the 4.4.0 version of the kernel to 4.4.12. Nothing tricky involved, but here's the process.

Grab the headers and image.

{{< highlight bash >}}
$ wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.4.12-xenial/linux-headers-4.4.12-040412-generic_4.4.12-040412.201606011712_amd64.deb  
$ wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.4.12-xenial/linux-headers-4.4.12-040412_4.4.12-040412.201606011712_all.deb  
$ wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.4.12-xenial/linux-image-4.4.12-040412-generic_4.4.12-040412.201606011712_amd64.deb
{{< /highlight >}}
  
Then, become root and install the kernel.
  
{{< highlight bash >}}
# dpkg -i linux-headers-4.4\*.deb linux-image-4.4\*.deb
{{< /highlight >}}
  
All hardware snags resolved. Enjoy!
