---
author: Andrew B. Collier
date: 2017-08-23T04:00:00Z
tags: ["R"]
title: Route Asymmetry in Google Maps
---

I have been retrieving some route information using [Rodrigo Azuero](https://twitter.com/razuero)'s [`gmapsdistance`](https://github.com/rodazuero/gmapsdistance) package and noted that there was some asymmetry in the results: the time and distance for the trip from A to B was not necessarily always the same as the time and distance for the trip from B to A. Although in retrospect this seems self-evident, it merited further investigation.

<!--more-->

Let's consider two locations in my old neighbourhood:

- 115 St Andrew's Drive, Durban North, 4051, South Africa --- **A** and
- 25 Gainsborough Drive, Athlone, Durban North, 4051, South Africa --- **B**.

To use those locations as the origin and destination arguments for `gmapsdistance()` we'll first need to do some minor encoding, replacing spaces with `+`.

{{< highlight r >}}
> A = gsub(" ", "+", "115 St Andrew's Drive, Durban North, 4051, South Africa")
> B = gsub(" ", "+", "25 Gainsborough Drive, Athlone, Durban North, 4051, South Africa")
{{< /highlight >}}

For reproducibility we'll stipulate a specific date and time (this only has any effect if you've provided a Google Maps API key, otherwise it will be silently ignored).

{{< highlight r >}}
> DEPARTURE = as.integer(as.POSIXct("2017-08-23 18:00:00"))
{{< /highlight >}}

Now we can calculate the distances and times for trips in either direction. First look at the trip from A to B.

{{< highlight r >}}
> library(gmapsdistance)
> gmapsdistance(A, B, departure = DEPARTURE, mode = "driving")
$Time
[1] 405

$Distance
[1] 2931

$Status
[1] "OK"
{{< /highlight >}}

Then the trip in the opposite direction, from B to A.

{{< highlight r >}}
> gmapsdistance(B, A, departure = DEPARTURE, mode = "driving")
$Time
[1] 412

$Distance
[1] 2931

$Status
[1] "OK"
{{< /highlight >}}

We see that the distance in both cases is the same (which stands to reason if the same route was taken in both directions) but that the times are different: 6:45 (405 seconds) from A to B and 6:52 (412 seconds) from B to A.

The difference is more pronounced if we consider different levels of congestion by using the `traffic_model` argument. In an optimistic scenario the travel times in both directions are shorter but the disparity increases from 7 seconds to 17 seconds. Under pessimistic conditions both trips become slower and the difference extends to 20 seconds.

<table class="table table-condensed">
	<tr class="info">
		<th><code>traffic_model</code></th>
		<th>A &rarr; B</th>
		<th>B &rarr; A</th>
		<th>&Delta;</th>
	</tr>
	<tr>
		<td><code>best_guess</code></td>
		<td>405</td>
		<td>412</td>
		<td>7</td>
	</tr>
	<tr>
		<td><code>optimistic</code></td>
		<td>341</td>
		<td>358</td>
		<td>17</td>
	</tr>
	<tr>
		<td><code>pessimistic</code></td>
		<td>489</td>
		<td>509</td>
		<td>20</td>
	</tr>
</table>

To gain further insight into these results I took a look at the routes considered by Google Maps. For the trip from A to B the recommended route passes through some congested areas but looks good for the most part.

![](/img/2017/08/maps-route-a-to-b.png)

The recommended course from B to A travels along the same route in reverse, but now we see that there are more extended congested segments. This would account for the slightly longer travel time.

![](/img/2017/08/maps-route-b-to-a.png)

This exercise has given me a lot of confidence in the result returned by `gmapsdistance` and confirmed my previous thinking about Google Maps: damn clever technology!