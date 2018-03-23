---
id: 2645
title: Julia on Windows behind a Firewall.
date: 2015-10-13T07:39:09+00:00
author: Andrew B. Collier
layout: post
excerpt_separator: <!-- more -->
categories:
  - Julia
---
I work on a Windows machine behind a corporate firewall during the day. It's not optimal, but [@rlnel](https://twitter.com/rlnel) kindly passed this information on to me, which has made the situation far more tolerable.

<!-- more -->

If your firewall blocks SSH then do the following in the command shell:

{% highlight bash %}
$ git config -global url."https://github.com/".insteadOf git@github.com:
{% endhighlight %}
  
That'll tell git to use HTTPS rather than SSH.

I also had some issues with Julia installing packages onto a network drive. To ensure that they are installed onto your C: drive:

{% highlight julia %}
julia> ENV["HOMEDRIVE"] = "C:"
julia> ENV["HOME"] = "C:\\Users\\userName";
julia> Pkg.init()
{% endhighlight %}
  
Obviously you need to substitute something appropriate for `userName`.

If you want to make those changes permanent, enter them in a `.juliarc.jl` file on the network drive.
