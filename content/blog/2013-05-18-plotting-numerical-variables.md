---
author: Andrew B. Collier
date: 2013-05-18T10:38:33Z
tags: ["R"]
title: 'Plotting numerical variables'
---

In the [previous installment](http://www.exegetic.biz/blog/2013/05/introducing-r-descriptive-statistics/) we generated some simple descriptive statistics for the National Health and Nutrition Examination Survey data. Now we are going to move on to an area in which R really excels: making plots and visualisations. <!--more--> There are a variety of systems for plotting in R, but we will start off with base graphics.

First, make a simple scatter plot of mass against height.

{{< highlight r >}}  
plot(DS0012$height, DS0012$mass, ylab = "mass [kg]", xlab = "height [m]")
{{< /highlight >}}

This clearly shows the relationship between these two variables, however, there is a high degree of overplotting.

<img src="/img/2013/05/mass-height.png">

We can improve the overplotting situation by making the points solid but partially transparent.

{{< highlight r >}}
plot(DS0012$height, DS0012$mass, ylab = "mass [kg]", xlab = "height [m]",
pch = 19, col = rgb(0, 0, 0, 0.05))
{{< /highlight >}}

That's much better: now we can see more structure in the data.

<img src="/img/2013/05/mass-height-alpha.png">

Now let's look at the distribution of the BMI data using a [histogram](http://en.wikipedia.org/wiki/Histogram).

{{< highlight r >}}
hist(DS0012$BMI, main = "Distribution of Body Mass Index", col = "lightblue",
xlab = "BMI", prob = TRUE)
lines(density(DS0012$BMI))
abline(v = mean(DS0012$BMI), lty = "dashed", col = "red")
{{< /highlight >}}

I have thrown in a few bells and whistles here: a [kernel density estimate](http://en.wikipedia.org/wiki/Kernel_density_estimation) of the underlying distribution and a vertical dashed line at the mean value of BMI.

<img src="/img/2013/05/histogram-bmi.png">

Hexagon binning produces a two dimensional analog of the histogram which can be used to further improve on the visualisation of the mass versus height data above. One option is to use the hexbin package. However, in this case I prefer the output from the ggplot2 package.

{{< highlight r >}}
library(ggplot2)
ggplot(DS0012, aes(x=height,y=mass)) + geom_hex(bins=20) + xlab("height [m]") +
ylab("mass [kg]")
{{< /highlight >}}

The syntax for ggplot2 is quite different to that of the base R graphics. It takes quite a lot of getting used to, but it is well worth the effort because it is extremely powerful. The appearance of the ggplot2 output is also rather novel.

<img src="/img/2013/05/hexbin-mass-height.png">

Well, that was a very quick and high level overview of some of the plotting capabilities in R. Next time we will take a look at plots generated using categorical variables.
