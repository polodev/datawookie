---
author: Andrew B. Collier
date: 2016-08-23T15:00:49Z
tags: ["R", "Gambling"]
title: 'Sportsbook Betting (Part 3): Evolving Odds'
---

<img src="/img/2016/08/rio-2016-800m-women.jpg" >

In previous instalments in this series I have not taken into account how odds can change over time.

<!--more-->

There are two main reasons for such a change:

1. a significant variation in the distribution of bets being placed on the various outcomes of the event (and the bookmakers' thus trying to "balance" their books); and 
2. other occurrences which have a direct effect on the probable outcome of the event.

The first of these is difficult to examine since bookmakers generally do not reveal the required data. The second is more accessible. We'll consider one particular example.

## Olympic Women's 800 metre Race

We'll take a look at data for the [women's 800 metre race](https://en.wikipedia.org/wiki/Athletics_at_the_2016_Summer_Olympics_%E2%80%93_Women%27s_800_metres) at the 2016 Olympic Games in Rio de Janeiro. Again the odds were scraped from Oddschecker using the [gambleR package](https://github.com/DataWookie/gambleR). I set up a batch job to grab those odds at 10 minute intervals. In retrospect that was overkill since the odds were static over much longer time scales. However, in principle, the odds for an event might change almost continuously as new information becomes available.

The plot below reflects how the bookmakers' odds for the various athletes in contention for this event changed from the time that I started logging data on 15 August 2016 through to the final event on 20 August 2016. There were some problems with the scraping job on 15 and 16 August, which accounts for the periods of scarce data. Also there were periods before the heats as well as after the heats and the semi-finals where no odds data were available. Since there was a high degree of overplotting I have jittered the data to make the individual traces visible.

<img src="/img/2016/08/F-800m-odds.png" >

The vertical dashed lines indicate the time of the heats (10:55 on 17 August 2016), the semi-finals (21:15 on 18 August 2016) and the final (21:15 on 20 August 2016). All times are in [UTC-3](https://en.wikipedia.org/wiki/UTC%E2%88%9203:00), the local time zone in Rio de Janiero.

A total of 64 athletes took part in eight heats, after which the field was reduced to 24 athletes. These remaining athletes competed in three semi-finals to leave a field of only 8 athletes for the final. The phenomenal [Caster Semenya](https://en.wikipedia.org/wiki/Caster_Semenya) trounced her competitors to win the final in 1:55.28.

<img src="/img/2016/08/F-800m-final-positions.png" >

Looking at the odds plotted above it's clear that Semenya was the favourite to win from the start. A wager on her was almost a sure win, but the rewards were pretty small. There was some variability in the remaining athletes. After the heats and semi-finals odds were no longer quoted for those athletes eliminated from the competition. The odds against Joanna Jóźwik, an outsider prior to the competition, dropped substantially after the heats and semi-finals based on her excellent performance in both. The odds against Margaret Wambui also dropped after the semi-finals based on her comfortable victory. The odds for the remaining athletes who competed in the finals increased somewhat after the heats and semi-finals.

It's apparent from the stepwise revisions in the odds in this event that they are not being continuously adjusted to take into account changes in the betting preferences of punters. In this case it seems that only the relative performance of the athletes in the races leading up to the final event had any influence on the odds.
