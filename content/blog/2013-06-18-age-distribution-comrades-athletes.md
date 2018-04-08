---
author: Andrew B. Collier
date: 2013-06-18T11:06:48Z
tags: ["R", "running"]
title: Age Distribution of Comrades Marathon Athletes
---

I can clearly remember watching the end of the 1989 Comrades Marathon on television and seeing Wally Hayward coming in just before the final gun, completing the epic race at the age of 80! I was in awe.

Since I have been delving into the Comrades Marathon data, this got me thinking about the typical age distribution of athletes taking part. The plot below indicates the ages of athletes who finished the race, going all the way back to 1984. You can clearly spot the two years when Wally Hayward ran (1988 and 1989). My data indicates that he was only 79 on the day of the 1989 Comrades Marathon, but I am not going to quibble over a year and I am more than happy to accept that he was 80!

<!--more-->

<img src="/img/2013/06/age-year-boxplot.png">

It is interesting to see that there is a consistent increase in the ages of both male and female finishers, as reflected by both the median and [interquartile range (IQR)](http://en.wikipedia.org/wiki/Interquartile_range).

The detailed distribution of ages across the period 1984 to 2013 is shown below. The median age of finishers is 37 years. Although in recent years the minimum age has been set at 20, in earlier times younger athletes were allowed to run the race. There are a significant number of runners in their 60s, but far fewer in their 70s. Only 163 runners older than 70 have finished the race since 1984.

<img src="/img/2013/06/age-histogram.png">

What about the effect of age on individual finish times? Men appear to perform best between 20 and 30 years of age, with a gradual but consistent decrease in performance with advancing years. Things are not quite as clear cut with the female runners, where those in the 30 to 40 age bracket appear to perform fractionally better than those between the ages of 20 and 30.

<img src="/img/2013/06/gender-age-time-boxplot.png">

Naturally these races times translates into medal allocations. The mosaic plot below shows both the distribution of runners across the various age categories as well as the medal allocations within those categories. The majority of runners are between 30 and 40 years of age and the most commonly awarded medal is the Bronze.

<img src="/img/2013/06/status-medal-age-mosaicplot.png" width="100%">

Finally, a breakdown of the gross number of medals awarded between 1984 and 2013. This includes data for the last 30 years and so is an extension of my [previous analysis](http://www.exegetic.biz/blog/2013/06/comrades-marathon-2013-medal-allocations/). Here it must be borne in mind that the Bill Rowan medal was only introduced in 2000, the Vic Clapham medal in 2003 and the Wally Hayward medal in 2007.

<img src="/img/2013/06/medal-allocations-age-gender.png">
