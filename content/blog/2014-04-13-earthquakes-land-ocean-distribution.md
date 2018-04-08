---
author: Andrew B. Collier
date: 2014-04-13T10:22:54Z
tags: ["R"]
title: 'Earthquakes: Land / Ocean Distribution'
---

The next stage in my earthquake analysis project is to partition the events into groups with epicentre over land or water. <!--more--> Since our existing catalog contains the latitude and longitude for the epicentres, it was a relatively simple matter to pipe these into [gmtselect](http://www.soest.hawaii.edu/gmt/gmt/html/man/gmtselect.html "gmtselect") and label the events accordingly. The resulting data when sucked into R looks like this:

{{< highlight r >}}
> land.ocean[sample(1:nrow(land.ocean), 10),]
                           id surface
9776  pde20071224224102830_10   water
14462 pde20050127160223910_30   water
12454 pde20060716182649380_35   water
16737 pde20111122021806520_97    land
19442 pde20050110184730180_31    land
10613 pde20070802032440340_14   water
9761  pde20071227155344630_84   water
18537 pde20070825220549600_10    land
4428  pde20110214102127320_34   water
16914 pde20110521220626390_37    land
{{< /highlight >}}

These data were then merged into the existing catalog using the id field.

A quick sanity check at this point would be good.

<img src="/img/2014/04/earthquake-map-surface.png" width="100%">

That looks about right: a clear distinction between land and ocean events.

Do the magnitude and depth of earthquakes on land differ significantly from those which occur under water? Looking at the plots below suggests that there is no qualitative difference.

<img src="/img/2014/04/earthquake-magnitude-surface.png">

<img src="/img/2014/04/earthquake-depth-surface.png">

<img src="/img/2014/04/earthquake-magnitude-depth-surface.png">

Certainly it seems reasonable that an event happening deep beneath the surface of the Earth should not be affected by whether or not there is a (quite) thin layer of water on top! However, for my analysis of _secondary_ effects it is probably going to be rather significant. But more on that later.