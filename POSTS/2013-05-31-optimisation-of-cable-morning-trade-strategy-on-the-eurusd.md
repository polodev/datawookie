---
author: Andrew B. Collier
categories:
- FOREX
- Trading
date: 2013-05-31T03:05:32Z
excerpt_separator: <!-- more -->
id: 199
tags:
- EA
- Expert Advisor
- FOREX
- MetaTrader
- MQL4
- optimisation
title: Optimisation of Cable Morning Trade Strategy on the EURUSD
url: /2013/05/31/optimisation-of-cable-morning-trade-strategy-on-the-eurusd/
---

As promised, I optimised the Cable Morning Trade strategy on the EURUSD. I varied only the trading times (ostensible the open and close of the market) to start with.

<img src="{{ site.baseurl }}/static/img/2013/05/cabmorn-optimisation-EURUSD.gif">

The entry time is on the x-axis and the exit time is on the y-axis. There is a clear preference for opening trades between 08:00 and 20:00 GMT. There is little structure along the y-axis indicating that the exit time is not too important. This suggests that the majority of trades reach their profit target rather than being forcibly closed at the end of the day.
