---
author: Andrew B. Collier
date: 2014-08-09T10:46:06Z
tags: ["R"]
title: 'Commitments of Traders: Moves in the Last Week'
---

In my [previous post](http://www.exegetic.biz/blog/2014/05/what-can-we-learn-from-the-commitments-of-traders-report/) I gave some background information on the Commitments of Traders report along with a selection of summary plots.

<!--more-->

One of the more interesting pieces of information that one can glean from these reports is the shift in trading sentiment from week to week. Below is a plot reflecting the relative change in the number of long and short positions held by traders in each of the sectors (Commercial, Non-Commercial and Non-Reportable).

The changes are normalised to the total number of positions (both long and short) held in the previous week. To illustrate how this works, consider the JPY.

{{< highlight r >}}
> tail(subset(OP, name == "JPY" & sector == "Commercial"), 2)
      name       date     sector   long   shrt
11842  JPY 2014-05-13 Commercial 125523 -35537
11845  JPY 2014-05-20 Commercial 117310 -48851
{{< /highlight >}}

This indicates that the number of positions that are long relative to the JPY has decreased while the number of positions that are short on the JPY (given by a negative number) has increased. Both of these changes are consistent with the fact that traders are selling the JPY in favour of other currencies.

A synopsis of these data for a range of currencies is given in the plot below. This is how the plot works. Again we will consider Commercial trades involving the JPY. We are thus looking at the second to last row and first column. Here there are two cells: long trades on the left and short trades on the right. The coloured bars indicate the relative change for long (blue) and short (orange) trades. The relative changes are normalised to the total number of trades for the currency and sector in the previous week. We can see here that the orange bar is broader than the blue bar indicating that the change in short trades is larger than the change in long trades. The grey boxes show the 95% confidence interval for the expected range of these changes. The closer the bars come to the edge of the boxes, the more significant the change. So, in this case, the change in the number of short trades is significant and is probably an indication of a change in sentiment regarding the JPY.

If anyone is interested in updated charts like this, please just let me know.

<img src="/img/2014/05/140520-weekly-change.png">
