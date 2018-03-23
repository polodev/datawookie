---
id: 1724
title: Shiny Bayesian Updates
date: 2015-07-24T12:13:15+00:00
author: Andrew B. Collier
layout: post
excerpt_separator: <!-- more -->
tags:
- Bayesian Statistics
- '#rstats'
---
Reading [Bayesian Computation with R](http://www.springer.com/us/book/9780387922973) by Jim Albert (Springer, 2009) inspired a fit of enthusiasm. Admittedly, I was on a plane coming back from Amsterdam and looking for distractions. I decided to put together a Shiny app to illustrate successive Bayesian updates. I had not yet seen anything that did this to my satisfaction. I like to think that my results come pretty close.

<!-- more -->

You can find the app [here](https://datawookie.shinyapps.io/Bayesian-Beta/). Below is a screenshot.

<img src="{{ site.baseurl }}/static/img/2015/07/bayesian-beta.png">

Basically the idea is:

1. start with a [beta](https://en.wikipedia.org/wiki/Beta_distribution) prior (you specify the α and β parameters); 
2. enter the results of an experiment (number of trials and the number of successes); then 
3. the associated likelihood and resulting posterior distribution are displayed; 
4. the prior is updated from the posterior distribution by pressing the "Update" button; 
5. repeat at your leisure.

I also wanted to mention a [related article](http://ryannel.co.za/blog/visualizing-bayes-theorem/) by my friend and colleague, Ryan Nel, which contains some very cool visuals.

Hope that somebody finds this useful and interesting. Feedback would be appreciated.