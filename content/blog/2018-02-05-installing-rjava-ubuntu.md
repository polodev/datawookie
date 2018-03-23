---
title: "Installing rJava on Ubuntu"
date: 2018-02-05T07:00:00+00:00
author: Andrew B. Collier
excerpt_separator: <!-- more -->
layout: post
tags:
  - #rstats
---

Installing the rJava package on Ubuntu is not quite as simple as most other R packages. Some quick notes on how to do it.

<!-- more -->

1. Install the Java Runtime Environment (JRE).

{% highlight text %}
sudo apt-get install -y default-jre
{% endhighlight %}

{:start="2"}
2. Install the Java Development Kit (JDK).

{% highlight text %}
sudo apt-get install -y default-jdk
{% endhighlight %}

{:start="3"}
3. Update where R expects to find various Java files.

{% highlight text %}
sudo R CMD javareconf
{% endhighlight %}

{:start="4"}
4. Install the package.
{% highlight r %}
> install.packages("rJava")
{% endhighlight %}

Sorted!