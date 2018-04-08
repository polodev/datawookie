---
author: Andrew B. Collier
date: 2016-07-16T17:00:52Z
tags: ["R"]
title: Birth Month by Gender
---

Based on some feedback to a [previous post](http://www.exegetic.biz/blog/2016/07/most-probable-birth-month/) I normalised the birth counts by the (average) number of days in each month. As pointed out by a reader, the results indicate a gradual increase in the number of conceptions during (northern hemisphere) Autumn and Winter, roughly up to the end of December. Normalising the data to give births per day also shifts the peak from August to September.

<!--more-->

<img src="/img/2016/07/births-per-day.png">

{{< highlight r >}}
> library(lifespan)
> library(dplyr)
> month.days <- data.frame(
+   month = month.abb,
+   days = c(31, 28.25, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)
+ )
> group_by(births, month) %>% summarise(count = sum(count)) %>%
+   merge(month.days) %>%
+   mutate(perday = count / days) %>%
+   ggplot(aes(x = month, y = perday / 1000)) +
+   geom_bar(stat = "identity", fill = "#39A75E") +
+   labs(x = "", y = "Total Births per Day [thousands]") +
+   theme_classic()
{{< /highlight >}}

I also broke the births data down by gender. The September peak persists for both genders but something else that's interesting pops out: there are consistently more boys being born than girls. The average ratio of boys to girls between 1994 and 2014 is 1.048. The slightly higher birth rate for boys is a [well known phenomenon](https://en.wikipedia.org/wiki/Human_sex_ratio). The ratio [varies somewhat between countries](https://en.wikipedia.org/wiki/List_of_countries_by_sex_ratio), with the global value being around 1.07.

<img src="/img/2016/07/births-boxplot.png">

{{< highlight r >}}
> group_by(births, year, month, sex) %>% summarise(count = sum(count)) %>%
+   merge(month.days) %>%
+   mutate(perday = count / days) %>% ggplot() +
+   geom_boxplot(aes(x = month, y = perday, fill = sex)) +
+   labs(x = "", y = "Births per Day") +
+   theme_classic() + theme(legend.title = element_blank())
{{< /highlight >}}

That ratio is remarkably consistent from month to month and year to year.

<img src="/img/2016/07/births-gender-ratio.png">

{{< highlight r >}}
> library(reshape2)
> group_by(births, year, month, sex) %>% summarise(count = sum(count)) %>%
+   dcast(year + month ~ sex) %>% mutate(ratio = M/F) %>%
+   ggplot() +
+   geom_boxplot(aes(x = year, y = ratio, group = year)) +
+   labs(x = "", y = "Monthly Birth Ratio: Boys/Girls") +
+   theme_classic() + theme(legend.title = element_blank())
{{< /highlight >}}