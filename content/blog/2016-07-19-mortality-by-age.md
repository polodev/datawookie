---
author: Andrew B. Collier
date: 2016-07-19T16:00:02Z
tags: ["R"]
title: Mortality Rate by Age
---

Working further with the mortality data from <http://www.cdc.gov/>, I've added a breakdown of deaths by age and gender to the [lifespan package](https://github.com/DataWookie/lifespan) on GitHub.

<!--more-->

Here's a summary plot:

<img src="/img/2016/07/deaths-by-age.png" >

{{< highlight r >}}
> library(lifespan)
> NYEARS = length(unique(deaths$year))
> ggplot(deathsage, aes(x = age, y = count / NYEARS / 1000)) +
+   geom_area(aes(fill = sex), position = &quot;identity&quot;, alpha = 0.5) +
+   geom_line(aes(group = sex)) +
+   # facet_wrap(~ sex, ncol = 1) +
+   labs(x = &quot;Age&quot;, y = &quot;Deaths per Year [thousands]&quot;) +
+   scale_x_continuous(breaks = seq(0, 150, 10), limits = c(0, 120)) +
+   theme_minimal() + theme(legend.title = element_blank())
{{< /highlight >}}

There are a few interesting observations to be made. We'll start with the most obvious:

* on average, females live longer than males; 
* modal age at death is 81 for males and 86 for females; 
* there are more infant deaths among males than females (probably linked to [greater number of male births](http://www.exegetic.biz/blog/2016/07/birth-month-by-gender/)); and 
* there is a rapid escalation in deaths among teenage males (consistent with fact that teenage males are more likely to commit suicide, be involved in fatal vehicle accidents, or be victims of homicide). </ul> 
Another way of looking at the same data is with a stacked area plot. It's more difficult to see compare genders, but gives a better indication of the overall mortality rate.

<img src="/img/2016/07/deaths-by-age-stacked.png" >
