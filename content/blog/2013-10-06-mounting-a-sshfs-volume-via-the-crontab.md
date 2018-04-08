---
author: Andrew B. Collier
date: 2013-10-06T06:28:26Z
tags: ["Linux"]
title: Mounting a sshfs volume via the crontab
---

I need to mount a directory from my laptop on my desktop machine using sshfs. At first I was not making the mount terribly regularly, so I did it manually each time that I needed it. However, the frequency increased over time and I was eventually mounting it every day (or multiple times during the course of a day!). This was a perfect opportunity to employ some automation.

<!--more-->

The obvious tool for the job was the crontab. I wrote an entry which triggered every minute. It checked whether the directory was already mounted and, if not, went ahead and executed the mount.

{{< highlight bash >}}
df | grep remote || sshfs username@laptop:/home/username ~/remote/
{{< /highlight >}}

The details of this command are straight forward: first run df and check whether the directory is already mounted. If it is, then no further action is required. If not, then mount the remote directory /home/username on laptop at /home/remote on my desktop.

This worked pretty well as long as laptop was available on the network. However, if it wasn't then the command would fail repeatedly and I got an annoying dialog popping up on my desktop every minute. This got rather annoying and more sophisticated logic was obviously in order!

My revised (and final solution) includes a check to see whether laptop is available on the network. If it is and the directory has not already been mounted, then the command proceeds to execute the sshfs mount.

{{< highlight bash >}}
(df | grep remote || ping -c1 laptop) && sshfs username@laptop:/home/username ~/remote/
{{< /highlight >}}
