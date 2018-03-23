---
title: 'Installing Hadoop on Ubuntu'
date: 2017-07-04T09:30:00+00:00
author: Andrew B. Collier
excerpt_separator: <!-- more -->
layout: post
categories: Linux
tags:
  - Ubuntu
  - Hadoop
---

This is what I did to set up Hadoop on my Ubuntu machine.

<!-- more -->

<!-- https://www.digitalocean.com/community/tutorials/how-to-install-hadoop-in-stand-alone-mode-on-ubuntu-16-04 -->

1. Install the Java Development Kit.
{% highlight bash %}
$ sudo apt-get install default-jdk
{% endhighlight %}
{:start="2"}
2. Download the latest release of Hadoop [here](http://hadoop.apache.org/releases.html).
3. Unpack the archive.
{% highlight bash %}
$ tar -xvf hadoop-2.8.0.tar.gz
{% endhighlight %}
{:start="4"}
4. Move the resulting folder.
{% highlight bash %}
$ sudo mv hadoop-2.8.0 /usr/local/hadoop
{% endhighlight %}
{:start="5"}
5. Find the location of the Java package.
{% highlight bash %}
$ readlink -f /usr/bin/java | sed "s#bin/java##"
/usr/lib/jvm/java-8-openjdk-amd64/jre/
{% endhighlight %}
{:start="6"}
6. Edit the Hadoop configuration file at `/usr/local/hadoop/etc/hadoop/hadoop-env.sh` and set `JAVA_HOME`.
{% highlight text %}
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre/
{% endhighlight %}
{:start="7"}
7. Test.
{% highlight bash %}
$ /usr/local/hadoop/bin/hadoop version
{% endhighlight %}

If the final command returns some information about Hadoop then the installation was successful.