---
author: Andrew B. Collier
date: 2014-05-17T03:12:02Z
tags: ["R", "running"]
title: 'Race Statistics for Comrades Marathon Novice Runners: Corrigendum'
---

There was some significant bias in the histogram from my previous post: the data from all years were lumped together. This is important because as of 2003 (when the Vic Clapham medal was introduced) the final cutoff for the Comrades Marathon was extended from 11:00 to 12:00. In 2000 they also applied an extended cutoff.

<!--more-->

I have consequently partitioned the data according to "strict" and "extended" cutoffs.

{{< highlight r >}}
> novices$extended = factor(novices$year == 2000 | novices$year >= 2003,
+                           labels = c("Strict Cutoff", "Extended Cutoff"))
{{< /highlight >}}

<img src="/img/2014/05/novice-finish-times-hist1.png">

This paints a much more representative picture of the distribution of finish times now that the race has been extended to 12 hours.

The allocation of medals is complicated by the fact that new medals have been introduced at different times over recent years. Specifically, the Bill Rowan medal was first awarded in 2000, then the Vic Clapham medal was introduced in 2003 and, finally, 2007 saw the first Wally Hayward medals.

{{< highlight r >}}
> novices$period = cut(novices$year, breaks = c(1900, 2000, 2003, 2007, 3000), right = FALSE,
+                      labels = c("before 2000", "2000 to 2002", "2003 to 2006", "after 2007"))
>
> novice.medals = table(novices$medal, novices$period)
> novice.medals = scale(novice.medals, scale = colSums(novice.medals), center = FALSE) * 100
> options(digits = 1)
> (novice.medals = t(novice.medals))
              
                Gold Wally Hayward Silver Bill Rowan Bronze Vic Clapham
  before 2000   0.07          0.00   4.80       0.00  95.13        0.00
  2000 to 2002  0.09          0.00   2.66      12.76  84.49        0.00
  2003 to 2006  0.15          0.00   4.05      17.51  47.63       30.66
  after 2007    0.08          0.03   2.60      12.28  46.40       38.62
{{< /highlight >}}

So, currently, around 46% of novices get a Bronze medal while slightly fewer, about 37%, get a Vic Clapham medal. A significant fraction, just over 12%, achieve a Bill Rowan, while only 2.6% get a Silver medal. The number of Wally Hayward and Gold medals among novices is very small indeed.

### Acknowledgement

Thanks to Daniel for pointing out this issue!
