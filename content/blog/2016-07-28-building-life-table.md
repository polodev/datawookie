---
author: Andrew B. Collier
date: 2016-07-28T15:00:26Z
tags: ["R"]
title: Building a Life Table
---

<!--more-->

After writing my previous post, [Mortality by Year and Age](http://www.exegetic.biz/blog/2016/07/mortality-year-age/), I've become progressively more interested in the mortality data. Perhaps those actuaries are onto something? I found [this report](http://apps.who.int/iris/handle/10665/62916), which has a wealth of pertinent information. On p. 13 the report gives details on constructing a [Life Table](https://en.wikipedia.org/wiki/Life_table), which is one of the fundamental tools in Actuarial Science. The [lifespan package](https://github.com/DataWookie/lifespan) has all of the data required to construct a Life Table, so I created a `lifetable` data frame which has those data broken down by gender.

{{< highlight r >}}
> library(lifespan)
> subset(lifetable, sex == "M") %>% head
  x sex     lx      dx         qx
1 0   M 100000 596.534 0.00596534
2 1   M  99403 256.848 0.00258389
3 2   M  99147 174.077 0.00175575
4 3   M  98973 114.213 0.00115398
5 4   M  98858  83.082 0.00084041
6 5   M  98775  71.536 0.00072423
> subset(lifetable, sex == "F") %>% head
    x sex     lx      dx         qx
133 0   F 100000 452.585 0.00452585
134 1   F  99547 203.525 0.00204450
135 2   F  99344 130.223 0.00131083
136 3   F  99214  84.746 0.00085418
137 4   F  99129  62.055 0.00062600
138 5   F  99067  54.475 0.00054988
{{< /highlight >}}

The columns in the data above should be interpreted as follows:

* `lx` is the number of people who have survive to age `x`, based on an initial cohort of 100 000 people; 
* `dx` is the expected number of people in the cohort who die aged `x` on their last birthday; and 
* `qx` is the probability that someone aged `x` will die before reaching age `x+1`.

A plot gives a high level overview of the data. Below `lx` is plotted as a function of age. Click on the image to access an interactive [Plotly](https://plot.ly/~collierab/463/life-table/) version. The cohort size has been renormalised so that `lx` is expressed as a percent. It's readily apparent that the attrition rate is much higher for males than females, and that very few people survive beyond the age of 105.

[<img src="/img/2016/07/life-table.png" >](https://plot.ly/~collierab/463/life-table/)

Using these data we can also calculate some related conditional probabilities. For example, what is the probability that a person aged 70 will live for at least another 5 years?

{{< highlight r >}}
> survival(70, 5)
      F       M
0.87916 0.80709
{{< /highlight >}}

Another example, what is the probability that a person aged 70 will live for at least another 5 years but then die in the 10 years after that?

{{< highlight r >}}
> survival(70, 5, 10)
      F       M
0.37472 0.46714
{{< /highlight >}}

Interesting stuff! Everything indicates that in terms of longevity, females have the upper hand.

Somebody made the following witty comment on LinkedIn in response to my previous post:

<blockquote>
> Just good to know that death risk visibly decreases after 100y/o. This helps. 
</blockquote>

Well, yes and no. In an absolute sense your risk of dying after the age of 100 is relatively low. But the reason for this is that the probability of you actually making it to the age of 100 is low. If, however, you do manage to achieve this monumental age, then your risk of dying is rather high.

{{< highlight r >}}
> survival(100)
      F       M
0.65813 0.60958
{{< /highlight >}}

So men aged 100 have 39% probability of dying before reaching the age of 101, while the probability for women is 34%.

Note that there are also life table data in the [babynames package](https://github.com/hadley/babynames).
