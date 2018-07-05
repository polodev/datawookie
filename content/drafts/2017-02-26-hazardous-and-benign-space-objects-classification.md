---
draft: true
title: 'Hazardous and Benign Space Objects: Classification'
author: andrew
type: post
date: 2017-02-26T08:23:33+00:00
categories:
  - R
  - Science
  - Space
tags:
  - ggplot2
  - Meteor
  - Near Earth Object
  - R

---
Let&#8217;s start off with a rather simple data set for classification. We&#8217;ll look at the classification of NEOs according to whether or not they are considered hazardous. There is a simple rule for this based on Absolute V-magnitude and MOID (have a look at my [previous post][1] for more information).

[<img src="http://162.243.184.248/wp-content/uploads/2014/04/points-magnitude-moid-hazard.png" alt="points-magnitude-moid-hazard" width="800" height="600" class="aligncenter size-full wp-image-737" srcset="http://162.243.184.248/wp-content/uploads/2014/04/points-magnitude-moid-hazard.png 800w, http://162.243.184.248/wp-content/uploads/2014/04/points-magnitude-moid-hazard-300x225.png 300w, http://162.243.184.248/wp-content/uploads/2014/04/points-magnitude-moid-hazard-768x576.png 768w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 984px) 61vw, (max-width: 1362px) 45vw, 600px" />][2]

 [1]: http://www.exegetic.biz/blog/2014/04/hazardous-and-benign-space-objects-getting-the-data/
 [2]: http://162.243.184.248/wp-content/uploads/2014/04/points-magnitude-moid-hazard.png
