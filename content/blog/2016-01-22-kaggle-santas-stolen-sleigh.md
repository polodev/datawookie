---
author: Andrew B. Collier
date: 2016-01-22T15:00:43Z
tags: ["R"]
title: 'Kaggle: Santa''s Stolen Sleigh'
---

This morning I read Wendy Kan's interesting post on [Creating Santa's Stolen Sleigh](http://blog.kaggle.com/2016/01/19/creating-santas-stolen-sleigh-kaggles-annual-optimization-competition/). I hadn't really thought too much about the process of constructing an optimisation competition, but Wendy gave some interesting insights on the considerations involved in designing a competition which was both fun and challenging but still computationally feasible without military grade hardware.

This seems like an opportune time to jot down some of my personal notes and also take a look at the results. I know that this sort of discussion is normally the prerogative of the winners and I trust that my ramblings won't be viewed as presumptuous.

<!--more-->

[Santa's Stolen Sleigh](https://www.kaggle.com/c/santas-stolen-sleigh) closed on 8 January 2016. At the top of the leaderboard:

<img src="/img/2016/01/kaggle-santas-sleigh-winners.png" width="100%">

Well done, what a phenomenal effort! Check out the interview with [Woshialex & Weezy](http://blog.kaggle.com/2016/01/28/santas-stolen-sleigh-winners-interview-2nd-place-woshialex-weezy/).

## Problem Summary

The problem could be summarised as follows: 100 000 Christmas gifts have to be delivered from the North Pole to various locations across the Earth while minimising the [Weighted Reindeer Weariness](https://www.kaggle.com/c/santas-stolen-sleigh/details/evaluation), a metric depending on weight carried and distance travelled. Distances were to be calculated using the [Haversine formula](https://en.wikipedia.org/wiki/Haversine_formula) which takes into account the curvature of the Earth's quasi-spherical surface. Each gift had a weight between 1 and 50 (units unspecified). In addition the sleigh itself had a weight of 10 (same unspecified and obviously rather magical units) and a weight capacity of 1000.

<blockquote>... when the sleigh weight was too small, there's no incentive to merge any trips.
<cite>Wendy Kan</cite>
</blockquote>

The problem could be decomposed into two parts:

1. partition the gifts into trips, where the total weight of gifts to be delivered on any particular trip must satisfy the weight constraint of the sleigh; and 
2. choose the order in which the gifts should be delivered on each trip.

A solution would jointly solve both parts in such a way as to minimise Weighted Reindeer Weariness. It's a variation of the [Travelling Salesman Problem](https://simple.wikipedia.org/wiki/Travelling_salesman_problem). In the course of doing some preliminary research I had a look at a couple of videos ([video one](https://www.youtube.com/watch?v=SC5CX8drAtU) and [video two](https://www.youtube.com/watch?v=q6fPk0--eHY)), which were definitely worth watching for some background information and ideas.

The competition was sponsored by [FICO](http://www.fico.com/), who suggested a Mixed Integer Programming formulation for the problem. FICO made their Xpress Optimization Suite available to participants.

## Exploratory Analysis

The first thing I did was to take a look at the distribution of gifts across the planet. I found that they were more or less evenly distributed across all the continents. Who would have guessed that so many good children lived in Antarctica? Perhaps there's limited scope to misbehave down there?

<blockquote>
You better watch out<br>
You better not cry<br>
Better not pout<br>
I'm telling you why<br>
Santa Claus is coming to town.<br>
<cite>Santa Claus Is Coming To Town</cite>
</blockquote>

An obvious approach to the problem was to cluster the gifts according to their proximity and then deliver these clusters of gifts on a single trip. But this approach posed a problem: generally the k-means algorithm is implemented using the Euclidean distance, which makes sense on a plane but not the surface of a sphere. Of course, a distance matrix could be calculated using the Haversine formula but this would be a pretty enormous matrix, certainly too large for my hardware.

I could, however, readily calculate the distance between each gift and its nearest neighbour, the distribution of which is displayed below. The majority of gifts are located less than 20 km from their nearest neighbour. Some are much closer, within a few hundred metres of each other. Others are significantly more distant. The summary data below indicates that the most isolated location is 2783 km from its nearest neighbour. Obviously the horizontal axis of the plot has been aggressively truncated!

{{< highlight r >}}
> summary(gifts$dist_nearest)
     Min.   1st Qu.    Median      Mean   3rd Qu.      Max. 
   0.1424   11.6500   18.1300   19.6200   25.9400 2783.0000
{{< /highlight >}}

<img src="/img/2015/12/hist-distance-to-nearest.png">

Let's look at the most isolated locations. The red points on the map below indicate gift locations which are at least 150 km distant from any other locations. Some of these are on extremely isolated pieces of land like Saint Helena, Coronation Island and the French Southern and Antarctic Lands. In terms of clustering, these points were going to be a little tricky and probably best delivered en route to somewhere else.

<img src="/img/2015/12/map-isolated.png">

## Clustering and Sorting

My first approach to solving the problem involved a simple clustering scheme. My gut feel was that in a tight cluster of gifts it would be important to deliver the heaviest ones first. I tried applying this simple heuristic to my clusters and the results were not particularly good. I then used a Genetic Algorithm (GA) to optimise the order of delivery within each cluster. The table below shows gifts allocated to two distinct trips (identified by TripId) with the order of delivery determined by the GA. These data confirmed that the best strategy was not simply to deliver the heaviest gifts first. Useful (and obvious in retrospect!).

{{< highlight r >}}
   GiftId TripId Latitude  Longitude    Weight
1   72834      1 52.08236  -99.84075 19.450129
2   31544      1 51.99433  -99.66718 16.401965
3   13514      1 51.54432 -100.80105 17.188096
4    3711      1 51.42292  -99.61607  5.959066
5   69035      1 51.42310  -99.21229  1.000000
6   50071      2 52.14381 -100.39226 10.185356
7   75708      2 52.05063 -100.09734 11.833779
8   90582      2 51.57074 -100.11467 25.335999
9   29591      2 50.94006  -98.51085 50.000000
10  94799      2 51.40380 -100.10319 10.719852
11  64255      2 51.39730  -99.99052  1.000000
12  31418      2 50.98414 -100.38163  1.000000
13   6254      2 51.37832 -100.42426  1.000000
14  40247      2 51.18464 -100.77533  9.352351
15  77396      2 51.27686 -100.77209  2.605262
16   2600      2 50.82170  -99.46544  1.000000
{{< /highlight >}}

My submission based on simple clustering with GA optimisation was fairly decent but nothing to tweet about.

<img src="/img/2015/12/kaggle-santa-submission-04.jpg">

## Great Circle Solution

Thinking further about the problem it occurred to me that it might be efficient to deliver the gifts along paths that are as straight as possible, with minimal deviations. How about attempting to deliver the gifts along a Great Circle arc? For paths originating at the pole this would be equivalent to moving out and back close to a single line of longitude. It would certainly improve one aspect of Weighted Reindeer Weariness: the distance covered.

> The minor arc of a great circle between two points is the shortest surface-path between them.<cite><a href="https://en.wikipedia.org/wiki/Great_circle">Great Circle</a>, Wikipedia</cite>

Putting this idea into practice and dividing the gifts up into longitudinal slices lead to an appreciable bump in my score.

<img src="/img/2015/12/kaggle-santa-submission-05.jpg">

My final innovation was to apply the same longitudinal slicing strategy but treat Antarctica separately. This again lead to an immediate improvement. I tried splitting off other areas of the globe, like Australia, but this didn't yield positive results.

<img src="/img/2015/12/kaggle-santa-submission-06.jpg">

So in the end my clustering had very little to do with gifts that were close together but instead grouped gifts which lay close to a meridional path originating at the North Pole. Definitely not the ideal approach, but one based on good physical principles and yielding a solution which was both robust and quick to compute.

I then shifted my attention to optimising the order of delivery within each quasi-meridional group. I started off with a GA, which worked pretty well but seemed a bit pedestrian in producing innovation. I then tried [2-opt](https://en.wikipedia.org/wiki/2-opt) as an alternative but found that it didn't make too much difference. Perhaps this was due to the linear arrangement of gifts? In the end I returned to the GA and just let that grind away until the competition closed, in the process trimming my score down to 12482212142. Progress was slow...

Below are some of the delivery routes designed using this approach. The size of the dots is proportional to weight and the dashed lines indicate the order of delivery. The first panel is an example in which it was optimal to simply deliver the gifts according to descending latitude. This worked well because all of the gifts lay very close to a straight line and no major lateral deviations were required. This ordering was, in fact, the starting point for my GA optimisation. The remaining panels show examples where it was more efficient to delay delivery of some of the gifts until the return journey. Notably, these were gifts with lower weight, where a relatively small penalty was incurred by delaying their delivery, but much was gained by delivering other gifts first.

<table>
    <tr>
        <td>
        <img src="/img/2015/12/crop-trip-plot-710.png">
        </td>
        <td>
        <img src="/img/2015/12/crop-trip-plot-3.png">
        </td>
        <td>
        <img src="/img/2015/12/crop-trip-plot-501.png">
        </td>
        <td>
        <img src="/img/2015/12/crop-trip-plot-971.png">
        </td>
    </tr>
</table>

Here are some examples of delivery schedules for gifts going to Antarctica. The range of longitudes spanned by each of these trips is larger than for the trips only going to higher latitudes, but this makes sense: once you have transported the gifts over the Equator and across the Southern Ocean, most of the travelling has already been done, so a bit of latitudinal distance does not have too much impact.

<table>
    <tr>
        <td>
        <img src="/img/2015/12/crop-trip-plot-1449.png">
        </td>
        <td>
        <img src="/img/2015/12/crop-trip-plot-1467.png">
        </td>
        <td>
        <img src="/img/2015/12/crop-trip-plot-1492.png">
        </td>
        <td>
        <img src="/img/2015/12/crop-trip-plot-1566.png">
        </td>
    </tr>
</table>

Okay, that's enough about my attempts, let's take a quick look at the leaderboard.

## Leaderboard Analysis {#leaderboard}

It's apparent that the winner's final solution was a significant improvement on his initial submissions. In fact, it's interesting to see that his first three scores were 29121011015, 29120957549 and 29120751717 (all of which were a long way from the money at that stage of the competition) before plummeting to 13442292734. A series of smaller improvements whittled his score down to the final winning value of 12384507107.

On average competitors made around 7 submissions. Of the 1127 competitors, 275 made only a single submission (this was also the most common submission count). The relationship between submission count and best score is plotted below. Note that the submission counts here can differ from those reflected on the leaderboard: only submissions which resulted in an improved score are included below, whereas the leaderboard reflects the total number of submissions made, irrespective of whether they resulted in an improvement. It's evident that those who made more submissions generally ended up with better final scores. There's a couple of anomalies at 26 and 39 submissions caused by a pair of competitors who showed remarkable persistence.

Finally, looking at the number of submissions per day, we see that the rate is more or less constant (averaging around 200 per day) up until the final day of the competition when things spiked appreciably up to 510 submissions. Of those final day entries, 128 were submitted in the last hour and 5 in the final 30 seconds. The winner made his final submission around 8 minutes before the final bell.

Well, that's about it. It was a really great competition. Fortunately there'll be another similar one later on this year: yet another reason to look forward to Christmas.