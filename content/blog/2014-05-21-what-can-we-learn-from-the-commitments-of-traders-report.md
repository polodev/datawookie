---
author: Andrew B. Collier
date: 2014-05-21T12:21:12Z
title: What Can We Learn from the Commitments of Traders Report?
---

The Commitments of Traders (COT) report is issued weekly by the Commodity Futures Trading Commission (CFTC). It reflects the level of activity in the futures markets. The report, which is issued every Friday, contains the data from the previous Tuesday.

<!--more-->

Amongst other data, the COT report gives the total number of long and short positions aggregated across three sectors:

* Commercial traders (also "hedgers") are "...engaged in business activities hedged by the use of the futures or option markets", 
* Non-Commercial traders (the "large speculators", mainly hedge funds and banks) and 
* Non-Reportable traders (the "small speculators").

In general the largest positions are retained by Commercial traders who either produce or consume the underlying commodity or instrument. The speculators do not produce or consume, but buy or sell the futures contract in order to profit from changes in price. Speculators will not hold a contract to maturity. Large speculators hold positions with sizes which are above the threshold for reporting to the CFTC. Small speculators hold positions which are not large enough to require reporting to the CFTC.

## Report Availability

The reports are available in either [long](http://www.cftc.gov/files/dea/cotarchives/2014/futures/deacmelf050614.htm) or [short](http://www.cftc.gov/files/dea/cotarchives/2014/futures/deacmesf050614.htm) format from the [CFTC web site](http://www.cftc.gov/MarketReports/CommitmentsofTraders/HistoricalViewable/index.htm). Just select the date you are interested in and you will be taken through to a page where you can select from a range of reports. In addition to the viewable reports, you can also get the [data as a CSV or xls file](http://www.cftc.gov/MarketReports/CommitmentsofTraders/HistoricalCompressed/index.htm).

<img src="/img/2014/05/cftc-report-options.png">

We will be focusing on FOREX, so we will be principally interested in the reports relating to the Chicago Mercantile Exchange.

## Long and Short Positions

The plot below reflects the number of long (blue) and short (red) positions for a selection of currencies broken down into the three sectors mentioned above. All of these positions are traded against the USD. The superimposed black lines indicate the net number of long and short positions. Things to note here are that the Commercial and Non-Commercial sectors are generally trading in opposite directions and that the Non-Reportable sector constitutes much smaller volumes, but these account for the detailed balance between the Commercial and Non-Commercial trades.

<img src="/img/2014/05/140513-open-positions.png" width="100%">

In this plot USD is always treated as the counter currency. So, for JPY we are actually looking at positions on JPY/USD. Of course, the JPY is not quoted like this against the USD. So, for pairs like USD/CAD, USD/CHF and USD/JPY we need to reverse the sense of the positions above. This will be sorted out though below when we consider individual currency pairs.

## Open Interest

Open Interest is the total number of current contracts. Since every long position is offset by a short position, the Open Interest is equal to the total number of either long or short positions. It shows the overall volume of contracts and is an indication of market interest. The black lines in the plot indicate the Open Interest for each currency and the red lines show the change from week to week.

<img src="/img/2014/05/140513-open-interest.png">

These data become more interesting when we link them to the appropriate FOREX rates.

## EUR/USD

<img src="/img/2014/05/140513-EURUSD.png">

The top panel reflects the daily closing price for EUR/USD. The second panel shows the total open interest (black) and weekly change in open interest (red). The third panel shows the net number of positions held by each of the sectors. Here positive values indicate that a sector is net long, while negative values represent net short positions. The fourth panel is an indication of sentiment and reflects what portion of positions for each sector are either long or short. A completely bullish value indicates that a sector is 100% long, while a completely bearish value represents 100% short. A value close to 0% occurs when there is a balance between long and short positions.

## GBP/USD

<img src="/img/2014/05/140513-GBPUSD.png">

## USD/JPY

<img src="/img/2014/05/140513-USDJPY.png">

The fact that USD is the base currency and JPY is the counter currency has been taken into account by negating the data in the third and fourth panels.

## Discussion

It has been suggested that small speculators are generally wrong. It is also held that Commercial traders have the best understanding of market conditions and are thus more likely to be right. I am not convinced that the data above support these hypotheses.

Although, it is interesting to note relationships between COT and FOREX prices in retrospect. The COT data can only become useful if one can use them as a predictive tool. I will be considering ways of doing this in future posts.
