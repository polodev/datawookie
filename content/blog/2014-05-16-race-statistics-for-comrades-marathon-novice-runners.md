---
author: Andrew B. Collier
date: 2014-05-16T05:22:05Z
tags: ["R", "running"]
title: Race Statistics for Comrades Marathon Novice Runners
---

Most novice Comrades Marathon runners finish the race on their first attempt and the majority of them walk (shuffle, crawl?) away with Bronze medals.

<!--more-->

## What is a Novice?

To paraphrase the dictionary, a _novice_ is "a person who is new to or inexperienced in the circumstances in which he or she is placed; a beginner". In the context of the Comrades Marathon this definition can be interpreted in a few ways:

1. a runner who has never run the Comrades Marathon (has never started the race); 
2. a runner who has never completed the Comrades Marathon (has never finished the race); or 
3. a runner who has not completed both an "up" and a "down" Comrades Marathon.

For the purposes of this article I will be adopting the first definition. This is probably the one of most interest to runners who are embarking on their first Comrades journey.

## Identifying a Novice

I'll be using the same data sets that I have discussed in [previous articles](https://datawookie.netlify.com/tags/running/). Before we focus on the data for the novices we'll start by just retaining the fields of interest.

{{< highlight r >}}
> novices = results[, c("key", "year", "category", "gender", "medal", "medal.count", "status", "ftime")]
> head(novices)
       key year     category gender       medal medal.count   status   ftime
1 100030f4 2008 Ages 20 - 29 Female Vic Clapham           1 Finished 11.3728
2 100030f4 2009 Ages 20 - 29 Female        <NA>           1      DNF      NA
3 100030f4 2013 Ages 20 - 29 Female        <NA>           1      DNS      NA
4 10007cb6 2005 Ages 26 - 39   Male      Bronze           1 Finished  9.1589
5 10007cb6 2006 Ages 30 - 39   Male  Bill Rowan           2 Finished  8.2564
6 10007cb6 2007 Ages 30 - 39   Male  Bill Rowan           3 Finished  8.0344
{{< /highlight >}}

To satisfy our definition of novice we'll need to exclude the "did not start" (DNS) records.

{{< highlight r >}}
> novices = subset(novices, status != "DNS")
> head(novices)
       key year     category gender       medal medal.count   status   ftime
1 100030f4 2008 Ages 20 - 29 Female Vic Clapham           1 Finished 11.3728
2 100030f4 2009 Ages 20 - 29 Female        <NA>           1      DNF      NA
4 10007cb6 2005 Ages 26 - 39   Male      Bronze           1 Finished  9.1589
5 10007cb6 2006 Ages 30 - 39   Male  Bill Rowan           2 Finished  8.2564
6 10007cb6 2007 Ages 30 - 39   Male  Bill Rowan           3 Finished  8.0344
7 10007cb6 2008 Ages 30 - 39   Male  Bill Rowan           4 Finished  8.8514
{{< /highlight >}}

Some runners do not finish the race on their first attempt but they bravely come back to run the race again. We will retain only the first record for each runner, because the second time they attempt the race they are (according to our definition) no longer novices since already have some race experience.

{{< highlight r >}}
> novices <- novices[order(novices$year),]
> novices <- novices[which(!duplicated(novices$key)),]
{{< /highlight >}}

## Percentage of Novice Finishers

I suppose that the foremost question going through the minds of many Comrades novices is "Will I finish?".

{{< highlight r >}}
> table(novices$status) / nrow(novices) * 100

Finished      DNF 
  80.035   19.965 
{{< /highlight >}}

Well, there's some good news: around 80% of all novices finish the race. Those are quite compelling odds. Of course, a number of factors can influence the success of each individual, but if you have done the training and you run sensibly, then the odds are in your favour.

## Medal Distribution for Novice Finishers

What medal is a novice most likely to receive?

{{< highlight r >}}
> table(novices$medal) / nrow(subset(novices, !is.na(medal))) * 100

         Gold Wally Hayward        Silver    Bill Rowan        Bronze   Vic Clapham 
    0.0829671     0.0051854     4.0264976     5.6469490    79.4708254    10.7675754
{{< /highlight >}}

The vast majority (again around 80%) claim a Bronze medal. There are also a significant proportion (just over 10%) who miss the eleven hour cutoff and get a Vic Clapham medal. Around 6% of novices achieve a Bill Rowan medal and a surprisingly large fraction, just over 4%, manage to finish in a Silver medal time of under seven and a half hours. There are very few Wally Hayward and Gold medals won by novices. The odds for a novice Gold medal are around one in 1200, all else being equal (which it very definitely isn't!).

## Distribution of Novice Finishing Times

<img src="/img/2014/05/novice-finish-times-hist.png">

As one would expect, the chart slopes up towards the right: progressively more runners come in later in the day. There is very clear evidence of clustering of runners just before the medal cutoffs at 07:30, 09:00, 11:00 and 12:00. There is also a peak before the psychological cutoff at 10:00.

## Take Away Message

The data for previous years indicates that the outlook for novices is rather good. 80% of them will finish the race and, of those, around 80% will receive Bronze medals.

How can you help ensure that you have a successful race? Here are some of the things I would think about:

1. Start slowly. It's going to be a long day. 
2. Take regular walking breaks and start doing this early on. A few minutes' recovery will power you up for a number of kms. 
3. Stay hydrated. Take something at every water table. Just don't overdo it. 
4. Be inspired by the other runners: they all have the guts to indulge in this madness with you and every one of them is fighting their own battle. 
5. Enjoy the support: the hordes of people beside the road have come out to see YOU run by. And they all want you to finish. 
6. Enjoy the day: as far as entertainment is concerned, the Comrades Marathon is about the best value for money that you can get.

See you in Pietermaritzburg at 05:30 on 1 June!

**Note:** There's an error in this post which is corrected [here]({{< relref "2014-05-17-race-statistics-for-comrades-marathon-novice-runners-corrigendum.md" >}}).

### Acknowledgement

Thanks to Daniel for suggesting this article.
