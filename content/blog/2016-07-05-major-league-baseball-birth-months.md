---
id: 3611
title: Major League Baseball Birth Months
date: 2016-07-05T17:00:27+00:00
author: Andrew B. Collier
layout: post
excerpt_separator: <!-- more -->
tags:
  - chi-squared test
  - ggplot2
  - '#rstats'
---

<!-- more -->

<blockquote>
The cutoff date for almost all nonschool baseball leagues in the United States is July 31, with the result that more major league players are born in August than in any other month.
<cite>Malcolm Gladwell, <em>Outliers</em></cite>
</blockquote>

A quick analysis to confirm Gladwell's assertion above. Used data scraped from [www.baseball-reference.com](http://www.baseball-reference.com/). Here's the evidence:

<figure>
  <img src="{{ site.baseurl }}/static/img/2016/07/baseball-birthdays.png">
  <figcaption class="wp-caption-text">Distribution of birth months for Major League Baseball players.</figcaption>
</figure>

We can make a quick check to see whether the non-uniformity is statistically significant.

{% highlight r %}
> chisq.test(table(baseball$month))

  Chi-squared test for given probabilities

data:  table(baseball$month)
X-squared = 135, df = 11, p-value <2e-16
{% endhighlight %}

Yup, it appears to be highly significant.

Obviously the length of the months should make a small difference on the number of births. For example, all else being equal we would expect there to be more births in August (with 31 days) than in July (with only 30 days). We can be a bit more rigorous and take month lengths into account too.

{% highlight r %}
> chisq.test(table(baseball$month), p = month$length / sum(month$length))

  Chi-squared test for given probabilities

data:  table(baseball$month)
X-squared = 115, df = 11, p-value <2e-16
{% endhighlight %}

Looks like the outcome is the same: there is a significant non-uniformity in the birth months of Major League Baseball players.
