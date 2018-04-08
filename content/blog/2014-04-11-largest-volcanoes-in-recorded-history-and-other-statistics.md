---
author: Andrew B. Collier
date: 2014-04-11T11:55:21Z
tags: ["R"]
title: Largest Volcanoes in Recorded History (and other statistics)
---

Around 199 years ago the largest volcano in recorded history, [Mount Tambora](http://en.wikipedia.org/wiki/Mount_Tambora "Mount Tambora"), erupted, spewing an enormous volume of molten rock and ash into the atmosphere and onto the surrounding land.

<!--more-->

<img src="/img/2014/04/Caldera_Mt_Tambora_Sumbawa_Indonesia.jpg">

How is the intensity of a volcanic eruption quantified? Most people know about the [Richter Scale](http://en.wikipedia.org/wiki/Richter_magnitude_scale "Richter Scale") which quantifies the energy released in an earthquake. The analogue for a volcanic eruption is the [Volcanic Explosivity Index](http://en.wikipedia.org/wiki/Volcanic_Explosivity_Index "Volcanic Explosivity Index") (VEI). This is a logarithmic scale ranging from 0 (non-explosive eruption) to 8 (largest volcano in history). Each ascending level indicates a tenfold increase in severity. The value of the index is determined by the ash cloud height, volume of lava and some qualitative observations. The schematic below (courtesy of Wikipedia) illustrates the interpretation of the index.

<img src="/img/2014/04/496px-VEIfigure_en.svg_.png">

## Data

Data on volcanoes and their eruptions were obtained from [Smithsonian Institution Global Volcanism Program](http://www.volcano.si.edu/search_eruption.cfm "Smithsonian Institution Global Volcanism Program"). The data came in two components: one detailing the volcanoes, the other giving the specifications of eruptions. Both were downloaded as xls files, which I converted to CSV to save space and also for quicker load times.

{{< highlight r >}}
> volcanoes <- read.csv(file.path("data", "GVP_Volcano_List.csv"), skip = 1)
> eruptions <- read.csv(file.path("data", "GVP_Eruption_Results.csv"), skip = 1)
> dim(volcanoes)
[1] 1550   12
> dim(eruptions)
[1] 10762    22
{{< /highlight >}}

Amongst the fields in the eruptions data is VEI, although there are numerous missing values.

{{< highlight r >}}
> table(eruptions$VEI, useNA = "ifany")

   0    1    2    3    4    5    6    7 <NA> 
 981 1271 3859 1103  492  176   51    7 2822 
{{< /highlight >}}

So, of the 10762 eruptions in the data, 2822 of them do not have a value for VEI.

A quick histogram shows the distribution of VEIs.

{{< highlight r >}}
> library(ggplot2)
> 
> ggplot(eruptions, aes(x = VEI)) +
+   geom_histogram() +
+   ylab("") +
+   theme_classic()
{{< /highlight >}}

We see that the vast majority of eruptions have VEI of 2, which means that they eject between 0.001 and 0.01 km<sup>3</sup> of ash and lava.

<img src="/img/2014/04/histogram-vei.png">

How frequently do volcanoes happen as a function of VEI? To get some decent statistics we will aggregate the data by century. The first thing we need to do is add a century column to the eruptions data. Then we count the number of eruptions at each VEI for every century spanned by the data.

{{< highlight r >}}
> eruptions$Century = ceiling(eruptions$Start.Year / 100)
> 
> library(plyr)
> 
> eruption.count = ddply(eruptions, .(VEI, Century), summarise, count = length(VEI))
> #
> eruption.count = subset(eruption.count, !is.na(VEI))
>
> head(eruption.count)
  VEI Century count
1   0     -95     1
2   0     -90     1
3   0     -86     1
4   0     -85     2
5   0     -84     1
6   0     -83     2
> tail(eruption.count)
    VEI Century count
527   7     -56     1
528   7     -43     1
529   7     -16     1
530   7      10     1
531   7      13     1
532   7      19     1
{{< /highlight >}}

A tiled plot of counts versus VEI and century gives a good view on the data.

{{< highlight r >}}
> ggplot(eruption.count, aes(x = Century, y = VEI, fill = log10(count))) +
+   geom_tile() +
+   scale_fill_gradientn(colours = rev(rainbow(7)),
+                        labels = 10**(0:3)) +
+   scale_x_continuous(breaks = seq(-100, 20, 20)) +
+   theme_classic() + theme(text = element_text(size = 16))
{{< /highlight >}}

<img src="/img/2014/04/tile-vei-century.png">

Now, it _seems_ that eruptions have been becoming more frequent. Of course, this is not true: we have just become better at observing them. The data for the last century are pretty robust.

{{< highlight r >}}
> subset(eruption.count, Century == 20)
    VEI Century count
95    0      20   442
124   1      20   812
208   2      20  1634
296   3      20   333
394   4      20    53
486   5      20     9
525   6      20     3
{{< /highlight >}}

We can see that there are just over 3000 eruptions with VEI of 3 or less, which corresponds to an average of around 30 per year. Eruptions with larger VEI are appreciably more rare.

Despite the somewhat perturbing frequency of these events, the majority of them happen in remote places. And they are probably remote because we wisely choose not to live too close to them!
