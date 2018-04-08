---
author: Andrew B. Collier
date: 2016-07-22T15:00:25Z
tags: ["R"]
title: Mortality by Year and Age
---

Taking another look at the data from the [lifespan](https://github.com/DataWookie/lifespan) package. Plot below shows the evolution of mortality in the US as a function of year and age.

<!--more-->

<img src="/img/2016/07/deaths-year-age.png" >

{{< highlight r >}}
> library(lifespan)
> library(ggplot2)
> ggplot(deathsage, aes(x = year, y = age)) +
+   geom_raster(aes(fill = count)) +
+   labs(x = "Year", y = "Age") +
+   scale_y_continuous(breaks = seq(0, 120, 10), limits = c(0, 110)) +
+   scale_fill_gradient("Deaths", low = "#FFFFFF") +
+   facet_wrap(~ sex) +
+   theme_minimal() +
+   theme(panel.grid = element_blank())
{{< /highlight >}}

Also, based on a suggestion from [@robjohnnoble](https://twitter.com/robjohnnoble), population data have been included in the package.

{{< highlight r >}}
> tail(population)
    year  count
112 2011 310.50
113 2012 312.86
114 2013 315.18
115 2014 317.68
116 2015 320.22
117 2016 322.48
{{< /highlight >}}
