---
draft: true
title: "Testing out rredis"
author: Andrew B. Collier
layout: post
categories:
  - R
tags:
  - R
  - Shiny
---

Inspired by the talk "How to create Redis modules - unleashed" by [Elena Kolevska](https://twitter.com/elena_kolevska) at the Bulgaria Web Summit, I decided to try out Redis from R.

The rredis [vignette](https://cran.r-project.org/web/packages/rredis/vignettes/rredis.pdf) is a great place to get started.

## Installing Redis Server

{% highlight text %}
$ sudo apt install redis-server
{% endhighlight %}

## Installing rredis

Install the rredis package from CRAN. While you're about it, you'll probably want to star the corresponding [repository](https://github.com/bwlewis/rredis) on GitHub

{% highlight r %}
> install.packages("rredis")
{% endhighlight %}

## Quick Test

{% highlight r %}
> library(rredis)
> redisConnect()
> (foo = matrix(rnorm(9), nrow = 3))
          [,1]      [,2]     [,3]
[1,]  0.640649 -0.033118  1.09481
[2,] -1.941304 -0.425345 -0.89801
[3,]  0.058919 -0.871000  1.00982
> redisSet("foo", foo)
[1] "OK"
> redisKeys()
[1] "foo" "x"  
> redisGet("foo")
          [,1]      [,2]     [,3]
[1,]  0.640649 -0.033118  1.09481
[2,] -1.941304 -0.425345 -0.89801
[3,]  0.058919 -0.871000  1.00982
{% endhighlight %}

<img src="{{ site.baseurl }}/static/img/2017/04/quick-redis-test.png" >

<iframe src="https://player.vimeo.com/video/190074456" width="640" height="360" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
