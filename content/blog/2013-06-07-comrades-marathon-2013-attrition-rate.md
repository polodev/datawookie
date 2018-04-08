---
author: Andrew B. Collier
date: 2013-06-07T06:58:17Z
tags: ["R"]
title: Comrades Marathon Attrition Rate
---

It is a bit of a mission to get the complete data set for this year's [Comrades Marathon](http://www.comrades.com). The full results are easily accessible, but come as an HTML file. Embedded in this file are links to the splits for individual athletes. So with a bit of scripting wizardry it is also possible to download the HTML files for each of the individual athletes. Parsing all of these yields the complete result set, which is the starting point for this analysis.

<!--more-->

The first interesting thing that I found was that according to the main results page there were 19907 entrants (this is also the number quoted in the <a href="http://comrades.runnersworld.co.za/2013-comrades-marathon-highlights/">2013 Comrades Marathon Highlights</a>). However, there were only detailed data for 19903 individual athletes. This immediately aroused my suspicions, so I had a look for duplicate race numbers and, guess what? Yup! There were four: 57234, 54243, 16266 and 25315. If you don't believe me, check out the results for yourself. Here are the relevant data:

<table>
  <tr>
    <th>
      Position
    </th>
    <th>
      Race Number
    </th>
    <th>
      Name
    </th>
    <th>
      Time
    </th>
  </tr>
  <tr>
    <td>
      1980
    </td>
    <td>
      57234
    </td>
    <td>
      Izelle Pretorius
    </td>
    <td>
      09:16:02
    </td>
  </tr>
  <tr>
    <td>
      1981
    </td>
    <td>
      57234
    </td>
    <td>
      Justin Powrie
    </td>
    <td>
      09:16:02
    </td>
  </tr>
  <tr>
    <td>
      3179
    </td>
    <td>
      54243
    </td>
    <td>
      Daniel Matseme
    </td>
    <td>
      09:56:55
    </td>
  </tr>
  <tr>
    <td>
      3180
    </td>
    <td>
      54243
    </td>
    <td>
      Headman Magadeni
    </td>
    <td>
      09:56:55
    </td>
  </tr>
  <tr>
    <td>
      3786
    </td>
    <td>
      16266
    </td>
    <td>
      Doctor Masina
    </td>
    <td>
      10:17:56
    </td>
  </tr>
  <tr>
    <td>
      3787
    </td>
    <td>
      16266
    </td>
    <td>
      Doctor Patrick Masina
    </td>
    <td>
      10:17:56
    </td>
  </tr>
  <tr>
    <td>
    </td>
    <td>
      25315
    </td>
    <td>
      Paulus Mpho
    </td>
    <td>
       DNF
    </td>
  </tr>
  <tr>
    <td>
    </td>
    <td>
      25315
    </td>
    <td>
      Ludwe Tsoliwe
    </td>
    <td>
       DNF
    </td>
  </tr>
</table>

That's interesting: for each duplicated race number there are two names, both of which have the same finishing time and are assigned independent positions in the field. I don't know what has happened here, but there is clearly a glitch in the data being provided by the CMA. Logic suggests that in each case there was in fact just one runner and so the overall position data are not correct. Not a big issue, but if you came in after position 1980, then your real position may be out by a few places.

Moving on to something more relevant: attrition. Of the 19903 _independent_ entrants, I find that only 10185 finished. Again this number differs from the official number by 3 (this is because of the duplication issue mention above!). But many of those entrants didn't even start the race. There were 6008 entrants who did not make it to the City Hall in Durban on Sunday morning. Of the 13895 athletes who were there when the start gun went off, only 10183 made it to the finish line before the 12 hour cutoff. This means that the total attrition rate was 26.7%: just over one quarter of the field didn't make it! In view of the carnage that I witnessed on Sunday, I would have expected this number to be a lot higher!

Let's break this down by gender. The figure below shows the proportion of athletes who did not start (DNS), did not finish (DNF), and who did actually finish the race as a function of gender. The DNS data are the categories "not yet started", "pre-race withdrawal" and "substituted". The DNF data also include "disqualified" and "started and running".

<img src="/img/2013/06/status-gender-spineplot1.png">

So what can we take away from this plot? Here are the main points:

* men made up 78.0% of the entrants;
* women accounted for 20.3% of those that crossed the start line;
* men made up 80.8% of the finishers.

The proportions are rather consistent! But this is only one way of looking at the data. What about if we consider the proportions within each gender? Then the picture is slightly different:

* 28.7% of the male entrants did not start the race (compared with 35.6% of the females);
* 74.3% of the males who started also reached the finish line before the gun (as opposed to 69.4% for females).

I am not going to interpret these results any further. I know which side my bread is buttered. Draw your own conclusions.

Next we look at the same data but broken down according to age category. Here the 40-49 age group was the best for getting to the starting line. Obviously they (and I include myself here) have learned that if you don't start, then you certainly can't finish! Ahem. Moving on. Of those that did start, runners in the 20-29 age group fared the best with 81.3% finishing. Things got progressively worse from there with the percentage of finishers dropping from 79.6% in the 30-39 group, to 73.5% in the 40-49 group, 61.6% in the 50-59 group and only 45.1% in the 60 and older group. Still damn impressive for the senior runners, but the youngsters appear to have fared best on the day. Perhaps they are more tolerant to warm weather?

<img src="/img/2013/06/status-category-spineplot2.png">

Now, let's put all of this together, looking at gender, age group and finishing status. There is a lot more information and it is a little difficult to make sense of all of it at once. But here are the salient points:

  * men in all three of the 30-39, 40-49 and 50-59 age groups were equally likely to start;
  * <span style="line-height: 14px;">men in the 30-39 age group were most likely to finish;</span>
  * among the women, those in the 40-49 age group were the most likely to start;
  * of the women that did start, the 30-39 age group was most likely to finish.

Looks like 30-39 is the prime time to be running the Comrades. That's not to say that I am past my prime. Hell no! Not at all.

<img src="/img/2013/06/status-category-gender-mosaicplot.png">

Over the next few days I will look at the following questions:

  * <span style="line-height: 14px;">what is the effect of running a negative split on overall time? and</span>
  * how does the finishing rate vary with time? Is there evidence of a "diamond carat" effect?
