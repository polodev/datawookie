---
author: Andrew B. Collier
date: 2017-04-09T09:00:00Z
tags: ["R"]
title: Relationship between Race Distance and Gender Ratio
---

<!--more-->

In an article entitled "[Could women outrun men in ultramarathon races?](http://journals.lww.com/acsm-msse/pages/articleviewer.aspx?year=1997&issue=02000&article=00013&type=abstract)", Jenefer Bam and her collaborators explored the hypothesis that running performance of men and women converge with increasing race distance, and suggested that women have superior fatigue resistance.

<img src="/img/2017/04/bam-women-outrun-men.png" style="border:5px solid black;">

It'd be great to independently validate these results using data from [racently](http://www.racently.com/), but it presently does not have data for distances greater than 68 km. These data will become available in the future though.

However, I'm able to explore a similar gender related question using the racently data.

## What's Happening in America

But first let's take a look at some results published by [Running USA](http://www.runningusa.org/).

<img src="/img/2017/04/running-usa-count-year-gender.png" >

The plot above indicates that in America there has been a steady escalation in the number of athletes taking part in running events from 1990 through to a peak in 2013, whereafter there was a slight decline. However, in addition to the increase in overall numbers, something interesting has been happening with gender ratio. Back in 1990 races were dominated by men: only 25% of runners were female. However, in 2010 the gender balance swung in favour of women and there have been more women than men taking part in running events since then.

## Compared to South Africa

Data from racently indicates that something similar has been taking place in South Africa: since 2009 the relative proportion of female runners has been consistently growing. They have not reached parity yet, but the trend suggests that this is just a few years away.

<img src="/img/2017/04/racently-gender-ratio-year.png" >

But this is only half the story.

## Specific Races

Let's look more closely at a few specific races, ones where multiple distances are on offer.

We'll start with the Stella Royal, hosted by the [Stella Athletic Club](https://www.racently.com/club/c16a5320-fa47-5530-d958-3c34fd356ef5/) on 19 March 2017. The plot below compares the gender representation for the [10 km](https://www.racently.com/race/31e06566-d242-45c7-8ddd-211cb56d93c0/) and [25 km](https://www.racently.com/race/86971f52-e2eb-4352-8c49-0f1901dc60d7/) events. Whereas female runners only made up 31% of the field for the 25 km event, the proportion was 60%for the 10 km event.

<img src="/img/2017/04/racently-gender-disparity-stella-royal.png" >

A second example: the Maritzburg Marathon hosted by the [Natal Carbineers](https://www.racently.com/club/02e74f10-e032-7ad8-68d1-38f2b4fdd6f0/) on 26 February 2017. A number of distances were on offer, but we'll look specifically at the [10 km](https://www.racently.com/race/75dc2088-7ded-4fd6-9129-ad6819645222/) and [42.2 km](https://www.racently.com/race/9e8c9a32-d645-424b-a5ce-491f2e4ac314/) races. Here only 24% of the field was female for the longer race, while the shorter event was 65% female.

There seems to be a pattern emerging!

<img src="/img/2017/04/racently-gender-disparity-maritzburg.png" >

One final example, the Umgeni Water Marathon hosted by the [Collegians Harriers](https://www.racently.com/club/17e62166-fc85-86df-a4d1-bc0e1742c08b/) and [Howick Athletic Club](https://www.racently.com/club/7cbbc409-ec99-0f19-c78c-75bd1e06f215/) on 12 March 2017. Here we find that the field for the 42.2 km event was only 17% female, while for the 15 km the proportion of female runners soared to 69%.

<img src="/img/2017/04/racently-gender-disparity-umgeni-water.png" >

It would be a mistake to generalise on the basis of the three examples presented above. But, since racently has data for many more races, we are able to compile some fairly robust statistics from a larger population.

<blockquote>
One swallow does not a summer make, nor one fine day...
<cite>Aristotle</cite>
</blockquote>

## Including More Races

The boxplot below reflects the gender ratio (number of women divided by the number of men) for a number of races over various distances. The pattern is quite clear, with fields for longer races strongly dominated by male runnners, but women generally outnumbering men in shorter events.

<img src="/img/2017/04/racently-gender-proportion-distance.png" >

This presents an interesting paradox: although the work of Bam and collaborators suggests that women are potentially superior to men over longer distances, it appears that they still have a preference for shorter races.

Why? I do not know. I'm just going to put it down to the enigmatic nature of women. And, for the moment, I'm happy with that.