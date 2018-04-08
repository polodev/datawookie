---
author: Andrew B. Collier
date: 2015-04-03T09:00:24Z
tags: ["R"]
title: Bags, Balls and the Hypergeometric Distribution
---

<!--more-->

A friend came to me with a question. The original question was a little complicated, but in essence it could be explained in terms of the familiar [urn problem](http://en.wikipedia.org/wiki/Urn_problem). So, here's the problem: you have an urn with 50 white balls and 9 black balls. The black balls are individually numbered. Balls are drawn from the urn without replacement. What is the probability that

1. the last ball drawn from the urn is a black ball (Event 1) and 
2. when the urn is refilled, the first ball drawn will be the same black ball (Event 2).

My colleague thought that this would be an _extremely_ rare event. My intuition also suggested that it would be rather unlikely. As it turns out, we were both surprised.

## Theoretical Approach

First we'll set up the parameters for the problem.

{{< highlight r >}}
> NBALLS = 59
> NWHITE = 50
> NBLACK = NBALLS - NWHITE
{{< /highlight >}}

We can calculate the probabilities for each of the events independently. Let's start with Event 2 since it's simpler: the probability of selecting a particular ball from the urn.

{{< highlight r >}}
> P2 = 1 / NBALLS
> P2
[1] 0.01694915
{{< /highlight >}}

The probability of Event 1 is a little more complicated. The [Hypergeometric distribution](http://en.wikipedia.org/wiki/Hypergeometric_distribution) describes the probability of achieving a specific number of successes in a specific number of draws from a finite population without replacement. It's precisely the distribution that we are after! We want to know the probability of drawing all of the white balls and all but one of the black balls, so that the last ball remaining is black.

{{< highlight r >}}
> P1 = dhyper(NWHITE, NWHITE, NBLACK, NBALLS-1)
> P1
[1] 0.1525424
{{< /highlight >}}

I think that's where my intuition let me down, because my feeling was that this number should have been smaller. The joint probability for the two events is then around 0.26%.

{{< highlight r >}}
> P1 * P2
[1] 0.002585464
{{< /highlight >}}

## Simulation Approach

Feeling a little uncomfortable with the theoretical result and suspecting that I might have done something rash with the Hypergeometric distribution, I decided to validate the result with a simulation.

{{< highlight r >}}
> BAG <- c(rep(NA, NWHITE), 1:NBLACK)
> 
> NSIM <- 1000000
> 
> hits <- lapply(1:NSIM, function(n) {
+   last <- sample(BAG)[NBALLS]
+   first <- sample(BAG, 1)
+   #
+   last == first
+ })
> #
> hits <- unlist(hits)
> #
> # The resulting vector has entries with the following possible values
> #
> # TRUE -> last ball is black and is the same ball that comes out first from repopulated bag
> # FALSE -> last ball is black and first ball from repopulated ball is black but different
> # NA -> either of these balls is white
> #
> hits <- ifelse(is.na(hits), FALSE, hits)
{{< /highlight >}}

I also wanted to generate [Binomial confidence intervals](http://en.wikipedia.org/wiki/Binomial_proportion_confidence_interval) for the simulated result.

{{< highlight r >}}
> library(binom)
> stats <- binom.confint(x = cumsum(hits), n = 1:NSIM, methods = "wilson")
{{< /highlight >}}

The simulated results are plotted below with the theoretical result indicated by the dashed line. The pale blue ribbon indicates the range of the 95% confidence interval.

<img src="/img/2015/03/black-white-balls.png">

Looks like both theory and simulation confirm that my intuition was wrong. I'd prefer not to say just how badly wrong it was.

Postscript: after the excitement of the Hypergeometric distribution had subsided, it occurred to me that the symmetry of the problem allowed for a simpler solution. The probability of Event 1 is actually the same as the probability of drawing any one of the black balls _first_ out of a full urn. Don't believe me?

{{< highlight r >}}
> NBLACK / NBALLS
[1] 0.1525424
{{< /highlight >}}
