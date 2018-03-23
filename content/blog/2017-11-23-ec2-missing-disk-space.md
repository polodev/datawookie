---
title: 'EC2 Missing Disk Space'
date: 2017-11-23T07:30:00+00:00
author: Andrew B. Collier
excerpt_separator: <!-- more -->
layout: post
categories:
  - Cloud
tags:
  - AWS
  - EC2
---

This morning I created a `r3.xlarge` spot instance on EC2. The job I'm planning on running requires a good wad of data to be uploaded, which is why I chose the `r3.xlarge` instance: it's cost effective and, according to AWS, has 80 Gb of SSD storage.

So I was a little surprised when I connected to the running instance and found that the root partition was only around 8 Gb. This is what I did to claim that missing disk space.

<!-- more -->

{% highlight bash %}
$ df -h
Filesystem      Size  Used Avail Use% Mounted on
udev             15G     0   15G   0% /dev
tmpfs           3.0G  8.6M  3.0G   1% /run
/dev/xvda1      7.7G  965M  6.8G  13% /
tmpfs            15G     0   15G   0% /dev/shm
tmpfs           5.0M     0  5.0M   0% /run/lock
tmpfs            15G     0   15G   0% /sys/fs/cgroup
tmpfs           3.0G     0  3.0G   0% /run/user/1000
{% endhighlight %}

Swathes of shared memory, but that wasn't going to help. Mulling this over for a moment, it occurred to me that perhaps the remaining space had simply not been mounted.

{% highlight bash %}
$ lsblk 
NAME    MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
xvda    202:0    0   8G  0 disk 
└─xvda1 202:1    0   8G  0 part /
xvdb    202:16   0  75G  0 disk
{% endhighlight %}

Indeed, `/dev/xvdb/` had masses of untapped space!

I used `fdisk` to create a partition.

{% highlight bash %}
$ sudo fdisk /dev/xvdb
{% endhighlight %}

Just follow the steps in the `fdisk` menu to create a new primary partition. When you're done use `lsblk` to check that all is well.

{% highlight bash %}
$ lsblk 
NAME    MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
xvda    202:0    0   8G  0 disk 
└─xvda1 202:1    0   8G  0 part /
xvdb    202:16   0  75G  0 disk 
└─xvdb1 202:17   0  75G  0 part
{% endhighlight %}

We see that there is a new partition at `/dev/xvdb1` but that it is currently not mounted.

Then created an ext4 partition and mounted it.

{% highlight bash %}
$ sudo mkfs.ext4 /dev/xvdb1
$ sudo mount /dev/xvdb1 /mnt/
$ df -h
Filesystem      Size  Used Avail Use% Mounted on
udev             15G     0   15G   0% /dev
tmpfs           3.0G  8.6M  3.0G   1% /run
/dev/xvda1      7.7G  965M  6.8G  13% /
tmpfs            15G     0   15G   0% /dev/shm
tmpfs           5.0M     0  5.0M   0% /run/lock
tmpfs            15G     0   15G   0% /sys/fs/cgroup
tmpfs           3.0G     0  3.0G   0% /run/user/1000
/dev/xvdb1       74G   52M   70G   1% /mnt
{% endhighlight %}

Boom! Space issues resolved.

It's also worth mentioning that you can actually amount the full disk during the instance creation process. However, if you only spot the missing space after the fact then this will do the trick.