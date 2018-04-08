---
author: Andrew B. Collier
date: 2017-07-04T09:30:00Z
tags: ["Linux", "Hadoop"]
title: Installing Hadoop on Ubuntu
---

This is what I did to set up Hadoop on my Ubuntu machine.

<!--more-->

<!-- https://www.digitalocean.com/community/tutorials/how-to-install-hadoop-in-stand-alone-mode-on-ubuntu-16-04 -->

1. Install the Java Development Kit.
	{{< highlight bash >}}
$ sudo apt-get install default-jdk
{{< /highlight >}}
2. Download the latest release of Hadoop [here](http://hadoop.apache.org/releases.html).
3. Unpack the archive.
	{{< highlight bash >}}
$ tar -xvf hadoop-2.8.0.tar.gz
{{< /highlight >}}
4. Move the resulting folder.
	{{< highlight bash >}}
$ sudo mv hadoop-2.8.0 /usr/local/hadoop
{{< /highlight >}}
5. Find the location of the Java package.
	{{< highlight bash >}}
$ readlink -f /usr/bin/java | sed "s#bin/java##"
/usr/lib/jvm/java-8-openjdk-amd64/jre/
{{< /highlight >}}
6. Edit the Hadoop configuration file at `/usr/local/hadoop/etc/hadoop/hadoop-env.sh` and set `JAVA_HOME`.
	{{< highlight text >}}
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre/
{{< /highlight >}}
7. Test.
{{< highlight bash >}}
$ /usr/local/hadoop/bin/hadoop version
{{< /highlight >}}

If the final command returns some information about Hadoop then the installation was successful.