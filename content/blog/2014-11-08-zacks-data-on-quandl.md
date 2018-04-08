---
author: Andrew B. Collier
date: 2014-11-08T10:03:16Z
tags: ["R"]
title: Zacks Data on Quandl
---

<img src="/img/2014/11/zacks-logo.png">

Data from Zacks Research have just been made available on Quandl. Registered Quandl users have free preview access to these data, which cover the following:

* [Earnings Estimates](https://www.quandl.com/ZEE): forward-looking consensus forecasts; 
* [Earnings Surprises](https://www.quandl.com/ZES): estimated future and actual historical earnings; 
* [Earnings Announcements](https://www.quandl.com/ZEA): predictions for earnings announcement dates, parameters, and supplementary data; 
* [Sales Estimates](https://www.quandl.com/ZSE): analogous to earnings estimates, but for sales; 
* [Dividend Data](https://www.quandl.com/ZDIV): dividend history and future announcement dates.

These data describe over 5000 publicly traded US and Canadian companies and are updated daily.

## Finding the Data

If you are not already a registered Quandl user, now is the time to sign up. You will find links to all of the data sets mentioned above from the [Quandl vendors](https://www.quandl.com/vendors) page. Then, for example, from the [Earnings Estimates](https://www.quandl.com/ZEE) page you can search for a particular company. I selected [Hewlett Packard](https://www.quandl.com/ZEE/HPQ_A-Hewlett-Packard-Co-HPQ-Current-Annual-Earnings-EPS-Estimates), which links to a page giving summary data on the Earnings per Share (EPS) for the next three years. These data are presented both in tabular format as well as an interactive plot.

<img src="/img/2014/11/Zacks-HP-EPS.png" width="100%">

Browsing the data via the Quandl web site gives you a good appreciation of what is available and the general characteristics of the data. However, to do something meaningful you would probably want to download data into an offline analysis package.

## Getting the Data into R

I am going to focus on accessing the data through R using the Quandl package.

{{< highlight r >}}
library(Quandl)
{{< /highlight >}}

Obtaining the data is remarkably simple. First you need to authenticate yourself.

{{< highlight r >}}
> Quandl.auth("ZxixTxUxTxzxyxwxFxyx")
{{< /highlight >}}

You will find your authorisation token under the Account Settings on the Quandl web site.

Grabbing the data is done via the Quandl() function, to which you need to provide the appropriate data set code.

<img src="/img/2014/11/Quandl-menu.png">

Beneath the data set code you will also find a number of links which will popup the precise code fragment required for downloading the data in a variety of formats and on a selection of platforms (notable amongst these are R, Python and Matlab although there are interfaces for a variety of other platforms too).

{{< highlight r >}}
> # Annual estimates
> #
> Quandl("ZEE/HPQ_A", trim_start="2014-10-31", trim_end="2017-10-31")[,1:5]
        DATE EPS_MEAN_EST EPS_MEDIAN_EST EPS_HIGH_EST EPS_LOW_EST
1 2017-10-31         3.90          3.900         3.90        3.90
2 2016-10-31         4.09          4.100         4.31        3.87
3 2015-10-31         3.94          3.945         4.01        3.88
4 2014-10-31         3.73          3.730         3.74        3.70

> # Quarterly estimates
> #
> Quandl("ZEE/HPQ_Q", trim_start="2014-10-31", trim_end="2017-10-31")[,1:5]
> HP[,1:5]
        DATE EPS_MEAN_EST EPS_MEDIAN_EST EPS_HIGH_EST EPS_LOW_EST
1 2015-10-31         1.10           1.10         1.14        1.04
2 2015-07-31         0.97           0.98         1.00        0.94
3 2015-04-30         0.95           0.95         1.00        0.91
4 2015-01-31         0.92           0.92         1.00        0.85
5 2014-10-31         1.05           1.05         1.07        1.03
{{< /highlight >}}

Here we see a subset of the EPS data available for Hewlett Packard, giving the maximum and minimum as well as the mean and median projections of EPS at both annual and quarterly resolution.

Next we'll look at a comparison of historical actual and estimated earnings.

{{< highlight r >}}
> Quandl("ZES/HPQ", trim_start="2011-11-21", trim_end="2014-08-20")[,1:6]
         DATE EPS_MEAN_EST EPS_ACT EPS_ACT_ADJ EPS_AMT_DIFF_SURP EPS_PCT_DIFF_SURP
1  2014-08-20         0.89    0.89       -0.37              0.00              0.00
2  2014-05-22         0.88    0.88       -0.22              0.00              0.00
3  2014-02-20         0.85    0.90       -0.16              0.05              5.88
4  2013-11-26         1.00    1.01       -0.28              0.01              1.00
5  2013-08-21         0.87    0.86       -0.15             -0.01             -1.15
6  2013-05-22         0.81    0.87       -0.32              0.06              7.41
7  2013-02-21         0.71    0.82       -0.19              0.11             15.49
8  2012-11-20         1.14    1.16       -4.65              0.02              1.75
9  2012-08-22         0.99    1.00       -5.50              0.01              1.01
10 2012-05-23         0.91    0.98       -0.18              0.07              7.69
11 2012-02-22         0.87    0.92       -0.18              0.05              5.75
12 2011-11-21         1.13    1.17       -1.05              0.04              3.54
{{< /highlight >}}

Looking at the last column gives the EPS surprise amount (difference between the actual and estimated EPS) as a percentage. It's clear that the estimates are generally rather good.

The last thing that we are going to look at is dividend data.

{{< highlight r >}}
> Quandl("ZDIV/HPQ", trim_start="2014-11-07", trim_end="2014-11-07")[,1:6]
       AS_OF DIV_ANNOUNCE_DATE DIV_EX_DATE DIV_PAY_DATE DIV_REC_DATE DIV_AMT
1 2014-11-07          20140717    20140908     20141001     20140910    0.16
{{< /highlight >}}

Here we see that a $0.16 per share dividend was announced on 17 July 2014 and paid on 1 October 2014.

Having access to these data for a wide range of companies promises to be an enormously useful resource. Unfortunately access to the preview data is fairly limited, but if you plan on making full use of the data, then the premium access starting at $100 per month seems like a reasonable deal.
