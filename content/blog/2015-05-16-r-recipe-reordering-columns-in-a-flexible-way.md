---
id: 1450
title: 'R Recipe: Reordering Columns in a Flexible Way'
date: 2015-05-16T06:20:37+00:00
author: Andrew B. Collier
layout: post
excerpt_separator: <!-- more -->
categories:
  - Data Science
tags:
  - data.frame
  - '#rstats'
  - 'R Recipe'
---

<!-- more -->

Suppose you have a data frame with a number of columns.

{% highlight r %}
> names(trading)
[1] "OpenDate" "CloseDate" "Symbol" "Action" "Lots" "SL" "TP" "OpenPrice"
[9] "ClosePrice" "Commission" "Swap" "Pips" "Profit" "Gain" "Duration" "Trader"
[17] "System"
{% endhighlight %}

You want to put the Trader and System columns first but you also want to do this in a flexible way. One approach would be to specify column numbers.

{% highlight r %}
> trading = trading[, c(16:17, 1:15)]
> names(trading)
[1] "Trader" "System" "OpenDate" "CloseDate" "Symbol" "Action" "Lots" "SL"
[9] "TP" "OpenPrice" "ClosePrice" "Commission" "Swap" "Pips" "Profit" "Gain"
[17] "Duration"
{% endhighlight %}

This does the job but it's not very flexible. After all, the number of columns might change. Rather do it by specifying column names.

{% highlight r %}
> refcols <- c("Trader", "System")
> #
> trading <- trading[, c(refcols, setdiff(names(trading), refcols))]
> names(trading)
[1] "Trader" "System" "OpenDate" "CloseDate" "Symbol" "Action" "Lots" "SL"
[9] "TP" "OpenPrice" "ClosePrice" "Commission" "Swap" "Pips" "Profit" "Gain"
[17] "Duration"
{% endhighlight %}
