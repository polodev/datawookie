---
author: Andrew B. Collier
date: 2014-05-10T15:05:55Z
tags: ["R", "running"]
title: 'Comrades Marathon Negative Splits: The Plot Thickens'
---

I have been thinking a little more about those [mysterious negative splits](http://www.exegetic.biz/blog/2014/05/comrades-marathon-negative-splits-and-cheating/). Not too surprisingly, this thinking happened while I was out running along the Durban beachfront this morning.

<!--more-->

Let's have a look at the ten most extreme negative splits from Comrades Marathon 2013:

{{< highlight r >}}
> split.ratio.2013 = subset(split.ratio, year == 2013)
> #
> split.ratio.2013 = head(split.ratio.2013[order(split.ratio.2013$ratio),], 10)
> #
> rownames(split.ratio.2013) <- 1:nrow(split.ratio.2013)
> split.ratio.2013[, c(-2, -7)]
   year      key drummond.time race.time     ratio
1  2013 3c0ea3bc        368.12    636.50 -0.270929
2  2013 e22d8c74        359.00    633.17 -0.236305
3  2013 5cd624eb        354.87    640.05 -0.196365
4  2013 4d5a86d7        359.45    659.88 -0.164186
5  2013  61fa6b5        345.33    644.38 -0.134025
6  2013 e5d6fa0e        344.33    649.83 -0.112778
7  2013 63a33c8d        368.88    696.88 -0.110830
8  2013 e445f2d1        340.15    647.20 -0.097310
9  2013 fed967de        338.67    647.77 -0.087303
10 2013 553aeb62        364.02    697.90 -0.082780
{{< /highlight >}}

Below are the splits data for these runners (in the same order as the table above).

<img src="/img/2014/05/2013-missing-splits.png">

The top one you have seen before (it was presented in my [previous post](http://www.exegetic.biz/blog/2014/05/comrades-marathon-negative-splits-and-cheating/)). And, as previously noted, this runner's time was not captured by the mat at either Camperdown or Polly Shortts. But if we look at the runner with the next most extreme negative split (e22d8c74) we see that the same thing happened: mysteriously he too was missed by those timing mats. The mats must have been having a bad day. The next two major negative splits (5cd624eb and 4d5a86d7): same story, no times at either of those mats. The next runner (61fa6b5) was captured on all five timing mats. And if we look at his splits, he is getting progressively faster during the course of the race. I suspect that this guy actually just had a very well planned and executed race. But the following runner on the list (e5d6fa0e) has also managed to elude both the mats in the second half of the race. Very strange indeed. The final four runners all have splits registered for every timing mat. And, again, if you look at their pace for each of the legs, it is not too hard to believe that these runners were playing by the rules and just had a very good day on the road.

So, of the top ten runners with extreme negative splits, five of them (yes, that's 50%) inexplicably missed both timing mats in the second half of the race. Coincidence? I think not.
