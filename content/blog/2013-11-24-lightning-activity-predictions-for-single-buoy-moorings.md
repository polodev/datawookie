---
author: Andrew B. Collier
date: 2013-11-24T03:25:57Z
tags: ["talk: standard"]
title: Lightning Activity Predictions For Single Buoy Moorings
---

A [short talk](https://speakerdeck.com/exegetic/lightning-activity-predictions-for-single-buoy-moorings) that I gave at the LIGHTS 2013 Conference (Johannesburg, 12 September 2013). The slides are a little short on text because I like the audience to hear the content rather than read it. The objective with this project was to develop a model which would predict the occurrence of lightning in the vicinity of a Single Buoy Mooring (SBM). Analysis and visualisations were all done in R. I used data from the [World Wide Lightning Location Network](http://webflash.ess.washington.edu/) (WWLLN) and considered four possible models: Neural Network, Conditional Inference Tree, Support Vector Machine and Random Forest. Of the four, Random Forests produced the best performance. The preliminary results from the Random Forests model are very promising: there is good agreement between predicted and observed lightning occurrence in the vicinity of the SBM.

<!--more-->

<script async class="speakerdeck-embed" data-id="211cb4d0fdbc0130468d062acf92b5fe" data-ratio="1.33507170795306" src="//speakerdeck.com/assets/embed.js"></script>
