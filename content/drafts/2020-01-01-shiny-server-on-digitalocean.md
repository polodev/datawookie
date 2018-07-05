---
draft: true
title: "Installing Shiny Server on DigitalOcean"
author: Andrew B. Collier
layout: post
categories:
  - R
tags:
  - R
  - Shiny
---

These instructions pertain to an Ubuntu 16.04.1 LTS instance on Digital Ocean. With some adaption they can be applied to other Ubuntu systems too.

All of these actions will require you to work as the `root` user.

<img src="{{ site.baseurl }}/static/img/2017/03/rstudio-logo.png">

### Prerequisites

First add the CRAN repository to your system as described [here](https://cran.rstudio.com/bin/linux/ubuntu/README.html). This involves adding a line to `/etc/apt/sources.list`.

{% highlight text %}
deb https://cloud.r-project.org/bin/linux/ubuntu xenial/
{% endhighlight %}

Next add the public key used to sign packages on CRAN.

{% highlight text %}
# apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
{% endhighlight %}

Now update and install the required packages.

{% highlight text %}
# apt-get update
# apt-get install r-base r-base-dev
{% endhighlight %}

Then fire up R and install the `shiny` package.

{% highlight r %}
> install.packages('shiny', repos='https://cran.rstudio.com/')
{% endhighlight %}

### Install Shiny Server

Download the Open Source distribution of Shiny Server.

{% highlight text %}
# wget https://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-1.5.1.834-amd64.deb
{% endhighlight %}

Install.

{% highlight text %}
# dpkg -i shiny-server-1.5.1.834-amd64.deb
{% endhighlight %}

This will also start the Shiny Server. Check that it's running.

{% highlight text %}
# ps xaf | grep shiny
{% endhighlight %}

Once you've got it running it'd be prudent to read the [Shiny Server Administrator's Guide](http://docs.rstudio.com/shiny-server/).