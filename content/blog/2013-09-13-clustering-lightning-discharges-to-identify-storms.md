---
author: Andrew B. Collier
date: 2013-09-13T07:09:59Z
tags: ["talk: standard"]
title: Clustering Lightning Discharges to Identify Storms
---

A [short talk](https://speakerdeck.com/exegetic/clustering-lightning-into-storms) that I gave at the LIGHTS 2013 Conference (Johannesburg, 12 September 2013). The slides are relatively devoid of text because I like the audience to hear the content rather than read it. The central message of the presentation is that clustering lightning discharges into storms is not a trivial task, but still a worthwhile challenge because it can lead to some very interesting science!

<!--more-->

<script async class="speakerdeck-embed" data-id="71c2f290fdbb0130f6d8022f0de05eea" data-ratio="1.33507170795306" src="//speakerdeck.com/assets/embed.js"></script>

I evaluated both k-means and hierarchical clustering techniques but stuck with the latter because it was easier to formulate a dissimilarity matrix using great circle (as opposed to Euclidean) distances than to try and force the k-means algorithm to calculate geographic distances. In retrospect, I could have used pam() from the cluster package to do clustering around medoids (and which also uses a dissimilarity matrix). In addition, this would have the advantage of being somewhat more computationally efficient, but experimenting with that will have to wait for another day.
