---
title: "Variable Names: Camel Case to Underscore Delimited"
date: 2017-11-20T04:30:00+00:00
author: Andrew B. Collier
excerpt_separator: <!-- more -->
layout: post
tags:
  - '#rstats'
  - 'R Recipe'
---

A project I'm working on has a bunch of different data sources. Some of them have column names in Camel Case. Others are underscore delimited. My OCD rebels at this disarray and demands either one or the other.

If it were just a few columns and I was only going to have to do this once, then I'd probably just quickly do it by hand. But there are many columns and it's very likely that there'll be more data in the future and the process will need to be repeated.

Seems like something that should be easy to automate.

<!-- more -->

I'm sure that there are a variety of ways to attack this problem, but this is a quick hack that worked for me. It relies on a regular expression negative lookbehind to prevent matching to the first letter if it's a capital.

{% highlight r %}
data %>% setNames(names(.) %>% str_replace_all("(?<!^)([A-Z]+)", "_\\1") %>% str_to_lower())
{% endhighlight %}

My first attempt matched `"(?<!^)([A-Z])"` but I changed this to `"(?<!^)([A-Z]+)"` in order to deal with column names like `GroupID`.