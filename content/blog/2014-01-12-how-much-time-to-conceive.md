---
author: Andrew B. Collier
date: 2014-01-12T16:33:27Z
tags: ["R"]
title: How Much Time to Conceive?
---

This morning my wife presented me with a rather interesting statistic: a healthy couple has a 25% chance of conception every month [1], and that this should result in a 75% to 85% chance of conception after a year. This sounded rather interesting and it occurred to me that it really can't be that simple. There are surely a lot of variables which influence this probability. Certainly age should be a factor and, after a short search, I found some more age-specific information which indicated that for a woman in her thirties, the probability is only around 15% [2,3].

<!--more-->

I suspect that one of the most important questions that people ask when they make the decision to have a child is: how long is it going to take us to get pregnant? The probabilities mentioned above should provide an answer to this question. But these probabilities are estimates at best (albeit, no doubt, educated estimates!) and are associated with some not insignificant uncertainties. So, how important is the value of the monthly probability in determining the time to conception?

# Conception as a Bernoulli Experiment

First let's take a look at what these probabilities mean. If we adopt the first probability mentioned above, then every month there will be a 25% chance of conception. To be clear, this is the probability of conception in any one month regardless of how long a couple has been trying. A process with a simple success or failure outcome like this is known as a [Bernoulli trial](https://en.wikipedia.org/wiki/Bernoulli_trial).

{{< highlight r >}}
> P1 = 0.25
> 1 - P1
[1] 0.75
{{< /highlight >}}

So, after the first month there is a 75% chance that conception will not have occurred. This seems pretty clear for the first month, but what about the second month? Well, all else being equal, the probability of conceiving in the second month should be just the same as that in the first month: 25%. However, this does not take into account the fact that the first month was not successful. The probability of only conceiving during the second month is the product of two probabilities: the probability of not conceiving in the first month and the probability of conceiving in any one month.

{{< highlight r >}}
> (P2 = (1 - P1) * P1)
[1] 0.1875
> (1 - P1) * (1 - P1)
[1] 0.5625
{{< /highlight >}}

There is thus a 18.75% chance of only conceiving during the second month and a 56.25% chance of still not being pregnant by the end of the second month. However, the total probability of having conceived in either the first or second months has improved:

{{< highlight r >}}
> P1 + P2
[1] 0.4375
{{< /highlight >}}

We can take this a step further: what about the third month? Here we need to take into account the probability of not conceiving in either of the first two months.

{{< highlight r >}}
> (P3 = (1 - P1) \* (1 - P1) \* P1)
[1] 0.14062
> P1 + P2 + P3
[1] 0.57812
> (1 - P1) \* (1 - P1) \* (1 - P1)
[1] 0.42188
{{< /highlight >}}

The probability of only falling pregnant in the third month is thus just over 14%, but the chance of conception in any one of the first three months has risen to just less than 58%. So, already, the odds are looking pretty good.

The fact that the conception probability decreases with each new month is not sinister. It is simply taking into account the fact that conception might already have happened and so extra months will not be necessary. So, in fact, this declining probability is good news!

We could extend this process indefinitely, but there is a simpler way. What we are looking at is an application of the [Negative binomial distribution](https://en.wikipedia.org/wiki/Negative_binomial_distribution) (but see Postscript below).

# Getting Pregnant and the Negative Binomial Distribution

The Negative binomial distribution describes the number of failures before a success in a Bernoulli experiment.

{{< highlight r >}}
> # Success in the first month (0 failures)
> #
> dnbinom(0, size = 1, prob = 0.25)
[1] 0.25
> #
> # Success in the second month (1 failure)
> #
> dnbinom(1, size = 1, prob = 0.25)
[1] 0.1875
> #
> # Success in the third month (2 failures)
> #
> dnbinom(2, size = 1, prob = 0.25)
[1] 0.14062
{{< /highlight >}}

You'll see that these probabilities agree perfectly with those calculated somewhat more laboriously above. Now, with very little pain, we can calculate the probability of falling pregnant in any given month. Let's consider a two year period.

{{< highlight r >}}
> NMONTH = 24
> 
> pbase = 0.25
> 
> (ptry <- dnbinom(0:NMONTH, size = 1, prob = pbase))
[1] 0.25000000 0.18750000 0.14062500 0.10546875 0.07910156 0.05932617 0.04449463
[8] 0.03337097 0.02502823 0.01877117 0.01407838 0.01055878 0.00791909 0.00593932
[15] 0.00445449 0.00334087 0.00250565 0.00187924 0.00140943 0.00105707 0.00079280
[22] 0.00059460 0.00044595 0.00033446 0.00025085
{{< /highlight >}}

This gives the probabilities for each of 25 successive months. We want to accumulate these values as well to get the total probability of falling pregnant within a given time period.

{{< highlight r >}}
> pregnant <- transform(data.frame(months = 0:NMONTH, ptry),
+                       psum = cumsum(ptry))
> pregnant
months       ptry    psum
1       0 0.25000000 0.25000
2       1 0.18750000 0.43750
3       2 0.14062500 0.57812
4       3 0.10546875 0.68359
5       4 0.07910156 0.76270
6       5 0.05932617 0.82202
7       6 0.04449463 0.86652
8       7 0.03337097 0.89989
9       8 0.02502823 0.92492
10      9 0.01877117 0.94369
11     10 0.01407838 0.95776
12     11 0.01055878 0.96832
13     12 0.00791909 0.97624
14     13 0.00593932 0.98218
15     14 0.00445449 0.98664
16     15 0.00334087 0.98998
17     16 0.00250565 0.99248
18     17 0.00187924 0.99436
19     18 0.00140943 0.99577
20     19 0.00105707 0.99683
21     20 0.00079280 0.99762
22     21 0.00059460 0.99822
23     22 0.00044595 0.99866
24     23 0.00033446 0.99900
25     24 0.00025085 0.99925
{{< /highlight >}}

Here the ptry column gives the probability for any particular month and the psum column gives the total probability up to and including that month. After two years the probability is very close to one: almost certain success!

This seems like a good time for a plot.

{{< highlight r >}}
> ggplot(pregnant, aes(x = months)) +
+   geom_line(aes(y = ptry)) +
+   geom_line(aes(y = psum), linetype = "dashed") +
+   geom_hline(yintercept = 1, linetype = "dotted") +
+   ylab("Probability") + xlab("Months") +
+   scale_y_continuous(labels = percent) +
+   scale_x_continuous(breaks = seq(0, NMONTH, 3)) +
+   theme_classic()
{{< /highlight >}}

<img src="/img/2014/01/probability-month.png">

Here the solid line is the probability of conception in a particular month and the dashed line is the cumulative probability, which gets pretty close to one after about a year. Of course, this plot is based on the assumption that the probability in any given month is 25%. And, as mentioned before, this number is only approximate. It would be helpful to see how this basic probability affects the long term prospects.

First we will construct data corresponding to increasing probabilities in steps of 2.5% all the way up to 50%. This upper boundary is extremely optimistic and likely to apply in practice to only a very small fraction of couples!

{{< highlight r >}}
> pbase = seq(0, 0.5, 0.025)[-1]
>
> pregnant <- data.frame(pbase = rep(pbase, each = NMONTH+1), months = 0:NMONTH)
>
> library(plyr)
>
> pregnant = ddply(pregnant, .(pbase, months), summarize,
+                  psum = sum(dnbinom(0:months, size = 1, prob = pbase)))
{{< /highlight >}}

Now we can take these data and produce a visualisation.

{{< highlight r >}}
> library(ggplot2)
> library(scales)
> library(RColorBrewer)
> 
> ggplot(pregnant, aes(x = months, y = pbase, z = psum)) +
+   geom_tile(aes(fill = psum)) +
+   #
+   # Options for colour scale: GnBu, Blues
+   #
+   scale_fill_gradientn(colours = brewer.pal(4, "GnBu"), limits = c(0, 1),
+                     name = "Success", labels = percent) +
+   scale_y_continuous(labels = percent) +
+   scale_x_continuous(breaks = seq(0, NMONTH, 3)) +
+   coord_cartesian(xlim = c(-1, NMONTH+1)) +
+   stat_contour(breaks = seq(0, 1, 0.1)) +
+   geom_point(data = data.frame(wait = 1 / pbase, pbase, psum = 0),
+         aes(x = wait, y = pbase)) +
+   geom_hline(yintercept = 0.25, linetype = "dashed") +
+   ylab("Probability") + xlab("Months") +
+   theme_classic()
{{< /highlight >}}

<img src="/img/2014/01/probability-month-variable.png">

As before, months are plotted along the x-axis. Now, however, the y-axis reflects the probability of conception in any one month. The value of 25% that we have been using is indicated by the horizontal dashed line. The colour scale then shows the cumulative probability. Contours are superimposed at intervals of 10% extending from 10% up to 90%.

If the probability per month is 50% then the cumulative probability rises to 90% in only three months. If, however, the monthly probability is only 10% then it will take almost two years for the cumulative probability to get to 90%. As the monthly probability drops below 10% the rate at which the cumulative probability increases gets progressively slower. But it does continue to escalate from month to month. The points on the plot indicate the expected number of months required before conception. With a monthly probability of 50%, it should on average require only two months. With lower monthly probabilities of 25% and 10%, the waiting time should be 4 and 10 months respectively. On average though, so results may (will!) vary.

So the moral of the story is, regardless of what the monthly probability of conception is, just keep on trying!

# Postscript

A couple of folk have kindly pointed out to me that using the negative binomial distribution for this application is a little hyperbolic and, of course, they are right! This is certainly a case of brain-fart on my part. The geometric distribution, a degenerate case of the negative binomial distribution, is quite sufficient. To make the distinction clear, the geometric distribution considers the number of failures before a single success (so, for example, FALSE FALSE FALSE TRUE would be three failures before a success) while the negative binomial distribution considers the number of failures before a particular number (which could be one!) of successes (so, for example, FALSE FALSE TRUE FALSE FALSE TRUE TRUE would be four failures before three successes were attained).

## References

1. [Basal Body Temperature](http://www.baby2see.com/preconception/basal_body_temperature.html) 
2. [Age and fertility: Getting pregnant in your 30s](http://www.babycenter.com/0_age-and-fertility-getting-pregnant-in-your-30s_1494695.bc) 
3. [What are the Odds of Conceiving and Having a Baby?](http://www.babymed.com/getting-pregnant/what-are-the-odds-conceiving-conception)
