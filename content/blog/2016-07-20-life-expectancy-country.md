---
author: Andrew B. Collier
date: 2016-07-20T16:00:27Z
tags: ["R"]
title: Life Expectancy by Country
---

I was rather inspired by this plot on Wikipedia's [List of Countries by Life Expectancy](https://en.wikipedia.org/wiki/List_of_countries_by_life_expectancy).

<!--more-->

<img src="/img/2016/07/country-life-expectancy-wikipedia.png" >

Shouldn't be too hard to reproduce with a bit of scraping. Here are the results (click on the static image to view the interactive plot):

<img src="/img/2016/07/country-life-expectancy.png" >

The bubble plot above compares female and male life expectancies for a number of countries. The diagonal line corresponds to equal female and male life expectancy. The size of each bubble is proportional to the corresponding country's population while its colour indicates its continent. Countries in Africa generally have the lowest life expectancies, while those in Europe are generally the highest. Since all of the bubbles are located above the diagonal, we find that females consistently live longer than males, regardless of country.

And finally, here's the code:

<script src="https://gist-it.appspot.com/github/DataWookie/lifespan/blob/master/scripts/scrape-wikipedia.R?footer=minimal"></script>

Check out a [similar analysis done using Julia](https://www.ivankuznetsov.com/2016/08/life-expectancy-by-country.html).
