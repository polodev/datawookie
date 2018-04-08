---
author: Andrew B. Collier
date: 2014-06-12T12:33:34Z
tags: ["R", "running"]
title: Twins, Tripods and Phantoms at the Comrades Marathon
---

Having picked up a viral infection days before this year's Comrades Marathon, on 1 June I was left with time on my hands and somewhat desperate for any distraction. So I spent some time looking at my archive of Comrades data and considering some new questions. For example, what are the chances of two runners passing through halfway and the finish line at exactly the same time? How likely is it that three runners achieve the same feat?

<!--more-->

My data for the 2013 up run gives times with one second precision, so these questions could be answered if I relaxed the constraints from "exactly the same time" to "within one second of each other". We'll call such simultaneous pairs of runners "twins" and simultaneous threesomes will be known as "tripods". How many twins are there? How many tripods? The answers are somewhat surprising. What's even more surprising is another category: "phantoms".

If you are not interested in the details of the analysis (and I'm guessing that you probably aren't), [please skip forward to the pictures and analysis](#twins).

## Looking at the Data

The first step is to subset the data, leaving a data frame containing only the times at halfway and the finish, indexed by a unique runner key.

{{< highlight r >}}
> simultaneous = subset(splits,
+                      year == 2013 & !is.na(medal))[, c("key", "drummond.time", "race.time")]
> simultaneous = simultaneous[complete.cases(simultaneous),]
> #
> rownames(simultaneous) = simultaneous$key
> simultaneous$key <- NULL
> head(simultaneous)
         drummond.time race.time
4bdcb291        320.15    712.42
4e488aab        294.65    656.90
ab59fc97        304.62    643.67
89d3e09b        270.32    646.78
fc728816        211.27    492.95
7b761740        274.60    584.37
{{< /highlight >}}

Next we calculate the "distance" (this is a distance in time and not in space) between runners, which is effectively the squared difference between the halfway and finish times for each pair of runners. This yields a rather large matrix with rows and columns labelled by runner key. These data are then transformed into a format where each row represents a pair of runners.

{{< highlight r >}}
> simultaneous = dist(simultaneous)
> library(reshape2)
> simultaneous = melt(as.matrix(simultaneous))
> head(simultaneous)
      Var1     Var2   value
1 4bdcb291 4bdcb291   0.000
2 4e488aab 4bdcb291  61.093
3 ab59fc97 4bdcb291  70.483
4 89d3e09b 4bdcb291  82.408
5 fc728816 4bdcb291 244.992
6 7b761740 4bdcb291 135.910
{{< /highlight >}}

We can immediately see that there are some redundant entries. We need to remove the matrix diagonal (obviously the times match when a runner is compared to himself!) and keep only one half of the matrix.

{{< highlight r >}}
> simultaneous = subset(simultaneous, as.character(Var1) < as.character(Var2))
{{< /highlight >}}

Finally we retain only the records for those pairs of runners who crossed both mats simultaneously (in retrospect, this could have been done earlier!).

{{< highlight r >}}
> simultaneous = subset(simultaneous, value == 0)
> head(simultaneous)
            Var1     Var2 value
623174  5217dfc9 75a78d04     0
971958  d8c9c403 e6e0d6e3     0
2024105 2e8f7778 9acc46ee     0
2464116 5f18d86f 9a1697ff     0
2467712 63033429 9a1697ff     0
3538608 54a92b96 f574be97     0
{{< /highlight >}}

We can then merge in the data for race numbers and names, leaving us with an (anonymised) data set that looks like this:

{{< highlight r >}}
> simultaneous = simultaneous[order(simultaneous$race.time),]
> head(simultaneous)[, c(4, 6, 8)]
    race.number.x race.number.y race.time
133         59235         56915  07:54:21
9           26132         23470  08:06:55
62          44008         31833  08:25:58
61          25035         36706  08:35:42
54          28868         25910  08:46:42
26          47703         31424  08:47:08
> tail(simultaneous)[, c(4, 6, 8)]
   race.number.x race.number.y race.time
71         54689         16554  11:55:59
60          8846         23003  11:56:26
44          9235         49251  11:56:47
38         53354         53352  11:56:56
28         19268         59916  11:57:49
20         22499         40754  11:58:26
{{< /highlight >}}

## Twins {#twins}

As it turns out, there are a remarkably large number of Comrades twins. In the 2013 race there were more than 100 such pairs. So they are not as rare as I had assumed they would be.

## Tripods {#tripods}

Although there were relatively many Comrades twins, there were only two tripods. In both cases, all three members of the tripod shared the same surname, so they are presumably related.

The members of the first tripod all belong to the same running club, two of them are in the 30-39 age category and the third is in the 60+ group. There's a clear family resemblance, so I'm guessing that they are father and sons. Dad had gathered 9 medals, while the sons had 2 and 3 medals respectively. What a day they must have had together!

<img src="/img/2014/06/tripod-11832.png">

The second tripod also consisted of three runners from the same club. Based on gender and age groups, I suspect that they are Mom, Dad and son. The parents had collected 8 medals each, while junior had 3. What a privilege to run the race with your folks! Lucky guy.

<img src="/img/2014/06/tripod-53713.png">

And now things get more interesting...

## Phantom #1

The runner with race number 26132 appears to have run all the way from Durban to Pietermaritzburg with runner 23470! Check out the splits below.

<img src="/img/2014/06/splits-26132.png">

<img src="/img/2014/06/splits-23470.png">

Not only did they pass through halfway and the finish at the same time, but they crossed _every_ mat along the route at _precisely_ the same time. Yet, somewhat mysteriously, there is no sign of 23470 in the race photographs...

<img src="/img/2014/06/phantom-26132-A.png">

<img src="/img/2014/06/phantom-26132-B.png">

<img src="/img/2014/06/phantom-26132-C.png">

You might notice that there is another runner with 26132 in all three of the images above. That's not 23470. He has race number 28151 and he is not the phantom! His splits below show that he only started running with 26132 somewhere between Camperdown and Polly Shortts.

<img src="/img/2014/06/splits-28151.png">

If you [search the race photographs](http://www.jetlineactionphoto.com/) for the phantom's race number (23470), you will find that there are no pictures of him at all! That's right, nineteen photographs of 26132 and not a single photograph of 23470.

## Phantom #2

The runner with race number 53367 was also accompanied by a phantom with race number 27587. Again, as can be seen from the splits below, these two crossed every mat on the course at _precisely_ the same time.

<img src="/img/2014/06/splits-53367.png">

<img src="/img/2014/06/splits-27587.png">

Yet, despite the fact that 53367 is quite evident in the race photos, there is no sign of 27587.

<img src="/img/2014/06/phantom-53367-B.png">

<img src="/img/2014/06/phantom-53367-C.png">

<img src="/img/2014/06/phantom-53367-D.png">

<img src="/img/2014/06/phantom-53367-A.png">

I would have expected to see a photograph of 53367 embracing his running mate at the finish, yet we find him pictured with two other runners. In fact, if you [search the race photographs](http://www.jetlineactionphoto.com/) for 27587 you will find that there are no photographs of him at all. You will, however, find twelve photographs of 53367.

## Conclusion

Well done to the tripods, I think you guys are awesome! As for the phantoms (and their running mates), you have some explaining to do. <!-- How did the phantom race numbers end up in the results? Who carried the phantom timing chips over the mats? -->
