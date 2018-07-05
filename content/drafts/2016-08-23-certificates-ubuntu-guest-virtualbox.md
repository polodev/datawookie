---
draft: true
id: 4083
title: Certificates with Ubuntu Guest on VirtualBox
date: 2016-08-23T15:00:56+00:00
author: Andrew B. Collier
layout: post
guid: http://www.exegetic.biz/blog/?p=4083
categories:
  - Linux
  - R
  - R Tip
  - Ubuntu
tags:
  - devtools
  - Ubuntu
  - VirtualBox
---
Just made a sparkling new install of Ubuntu 16.04 in VirtualBox on a Windows machine. Feeling much better about having a decent environment to work in, but somewhat irritated by the certificates issues I encountered when I started to run the browser. The machine in question is sitting behind a gnarly firewall and proxy, which I suspect are the source of the problem.

Even more irritated by the fact that I don't seem to be able to install R packages from GitHub.
  
{% highlight r %}
  
> devtools::install_github("ropensci/RSelenium")
  
    
Peer certificate cannot be authenticated with given CA certificates
  
{% endhighlight %}

Clearly there's a problem with certificates. I also need to use `--ignore-certificate-errors` when running `chromium-browser`, which points to the same issue.

Here's a work-around. It does not resolve the general issue with certificates, but at least allows installs from GitHub in R.
  
{% highlight r %}
  
> httr::set\_config(httr::config(ssl\_verifypeer = 0L))
  
{% endhighlight %}

Note that this is by no means a fix to the problem, but it'll allow you to get your work done while you're getting your hands on the required certificates to properly sort it out.
