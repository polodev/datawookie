---
id: 2144
title: A ggplot2 oddity
date: 2015-09-10T12:32:20+00:00
author: Andrew B. Collier
layout: post
excerpt_separator: <!-- more -->
tags:
  - '#rstats'
  - ggplot2
---

<!-- more -->

I uncovered something a little perplexing today. It helped me waste 20 minutes or so. Well, I wasted some time trying to understand the problem, but I learned something in the process. Here's the situation (reduced to a very simple use case): I have some data and a function which calls `ggplot()`.

{% highlight r %}
> points <- data.frame(x = 1:10, y = 1:10)
> 
> library(ggplot2)
> 
> make.plot = function() {
+ 	ggplot(points, aes(x = x, y = y)) + geom_point()
+ }
> make.plot()
{% endhighlight %}

That works perfectly. But suppose I define a local variable within the function and I use it to transform the plotted data.

{% highlight r %}
> make.plot = function() {
+ 	p = 5
+ 	ggplot(points, aes(x = x, y = y / p)) + geom_point()
+ }
> make.plot()
Error in eval(expr, envir, enclos) : object 'p' not found
{% endhighlight %}

Whoops! That breaks. The problem is that `ggplot()` is looking in the global environment for the variable in question. It does not see the local environment. Thanks to some [helpful posts](http://stackoverflow.com/questions/5106782/use-of-ggplot-within-another-function-in-r) on stackoverflow, I have a solution: simply pass the local environment into the `ggplot()` call.

{% highlight r %}
> make.plot = function() {
+ 	p = 5
+ 	ggplot(points, aes(x = x, y = y / p), environment = environment()) + geom_point()
+ }
> make.plot()
{% endhighlight %}
  
Works like a charm.
