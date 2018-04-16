---
author: Andrew B. Collier
date: 2015-05-28T07:52:49Z
tags: ["R", "running"]
title: Comrades Marathon Medal Predictions
---

<!--more-->

<img src="/img/2015/05/IMG_5239.png">

With only a few days to go until race day, most [Comrades Marathon](http://www.comrades.com/) athletes will focusing on resting, getting enough sleep, hydrating, eating and giving a wide berth to anybody who looks even remotely ill.

They will probably also be thinking a lot about Sunday's race. What will the weather be like? Will it be cold at the start? (Unlikely since it's been so warm in Durban.) How will they feel on the day? Will they manage to find their seconds along the route? 

For the more performance oriented among them (and, let's face it, that's most runners!), there will also be thoughts of what time they will do on the day and what medal they'll walk away with. I've considered ways for projecting finish times in a [previous article](http://www.exegetic.biz/blog/2015/04/comrades-marathon-finish-predictions/). Today I'm going to focus on a somewhat simpler goal: making a Comrades Marathon medal prediction.

In the process I have put together a small application which will make medal predictions based on recent race times.

<a href="https://datawookie.shinyapps.io/Comrades-Medal-Predictions/" target="_blank">
  <img src="/img/2015/05/medal-prediction-interface.png">
</a>

I'm not going to delve too deeply into the details, but if you really don't have the patience, feel free to [skip forward](#results) to the results or click on the image above, which will take you to the application. If you have trouble accessing the application it's probable that you are sitting behind a firewall that is blocking it. Try again from home.

## Raw Data

The data for this analysis were compiled from a variety of sources. I scraped the medal results off the [Comrades Marathon Results Archive](http://results.ultimate.dk/comrades/resultshistory/front/index.php). Times for other distances were cobbled together from [Two Oceans Marathon Results](http://www.twooceansmarathon.org.za/events/info/results), [RaceTec Results](http://www.racetecresults.com/startpage.aspx?CId=35) and the home pages of some well organised running clubs.

The distribution of the data is broken down below as a function of gender, Comrades Marathon medal and other distances for which I have data. For instance, I have data for 45 female runners who got a Bronze medal and for whom a 32 km race time was available.

<img src="/img/2015/05/medal-race-distance-count.png">

Unfortunately the data are pretty sparse for Gold, Wally Hayward and Silver medalists, especially for females. I'll be collecting more data over the coming months and the coverage in these areas should improve. Athletes that are contenders for these medals should have a pretty good idea of what their likely prospects are anyway, so the model is not likely to be awfully interesting for them. This model is intended more for runners who are aiming at a Bill Rowan, Bronze or Vic Clapham medal.

## Decision Tree

The first step in the modelling process was to build a decision tree. Primarily this was to check whether it was feasible to predict a medal class based on race times for other distances (I'm happy to say that it was!). The secondary motivation was to assess what the most important variables were. The resulting tree is plotted below. Open this plot in a new window so that you can zoom in on the details. As far as the labels on the tree are concerned, "min" stands for "minimum" time over the corresponding distance and times (labels on the branches) are given in decimal hours.

<img src="/img/2015/05/medal-ctree.png" width="100%">

The first thing to observe is that the most important predictor is 56 km race time. This dominates the first few levels in the tree hierachy. Of slightly lesser importance is 42.2 km race time, followed by 25 km race time. It's interesting to note that 32 km and 10 km results does no feature at all in the tree, probably due to the relative scarcity of results over these distances in the data.

Some specific observations from the tree are:

* Male runners who can do 56 km in less than 03:30 have around 20% chance of getting a Gold medal. 
* Female runners who can do 56 km in less than 04:06 have about 80% chance of getting a Gold medal. 
* Runners who can do 42.2 km in less than about 02:50 are very likely to get a Silver medal. 
* Somewhat more specifically, runners who do 56 km in less than 05:53 and 42.2 km in more than 04:49 are probably in line for a Vic Clapham.

Note that the first three observations above should be taken with a pinch of salt since, due to a lack of data, the model is not well trained for Gold, Wally Hayward and Silver medals.

You'd readily be forgiven for thinking that this decision tree is an awfully complex piece of apparatus for calculating something as simple as the colour of your medal.

Well, yes, it is. And I am going to make it simpler for you. But before I make it simpler, I am going to make it slightly more complicated.

## A Forest of Decision Trees

Instead of just using a single decision tree, I built a [Random Forest](http://en.wikipedia.org/wiki/Random_forest) consisting of numerous trees, each of which was trained on a subset of the data. Unfortunately the resulting model is not as easy to visualise as a single decision tree, but the results are far more robust.

## Medal Prediction Application {#results}

To make this a little more accessible I bundled the model up in a [Shiny](http://shiny.rstudio.com/) application which I deployed [here](https://datawookie.shinyapps.io/Comrades-Medal-Predictions/). Give it a try. You'll need to enter the times you achieved over one or more race distances during the last few months. Note that these are _race_ times, not training run times. The latter are not good predictors for your Comrades medal.

Let's have a quick look at some sample predictions. Suppose that you are a male athlete who has recent times of 00:45, 01:45, 04:00 and 05:00 for 10, 21.1, 42.2 and 56 km races respectively, then according to the model you have a 77% probability of getting a Bronze medal and around 11% chance of getting either a Bill Rowan or Vic Clapham medal. There's a small chance (less than 1%) that you might be in the running for a Silver medal.

<img src="/img/2015/05/medal-predictions-bog-standard.png">

What about a male runner who recently ran 03:20 for 56 km? There is around 20% chance that he would get a Gold medal. Failing that he would most likely (60% chance) get a Silver.

<img src="/img/2015/05/medal-predictions-gold-male.png">

If you happen to have race results for the last few years that I could incorporate into the model, please get in touch. I'm keen to collaborate on improving this tool.
