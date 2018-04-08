---
author: Andrew B. Collier
date: 2013-05-06T08:56:35Z
title: Support & Resistance Indicator
---

I was recently browsing through the variety of of [MetaTrader](http://www.metatrader4.com/) indicators for [support and resistance](http://en.wikipedia.org/wiki/Support_and_resistance) levels. None of them ticked all of my boxes. Either they were not aesthetically pleasing (making a mess of my pristine charts) or they failed to produce what I consider to be reasonable levels. So, embracing my pioneering spirit, I set out to fashion my own indicator, one which will ultimately tick all of my boxes!

Sample output from v1.2 of my support-resistance indicator is shown below for the weekly chart of GBPUSD.

<img src="/img/2013/05/support-resistance-GBPUSD-W1.png" >

I am pretty happy with this as a starting point. At present it caters for

* up to 10 levels of either support or resistance;
* labelling of levels;
* only updating on new candle (reduces computation load).

There are some obvious refinements, which I will implement shortly. Foremost among these is the elimination of "trivial" levels (e.g., the first support level).
