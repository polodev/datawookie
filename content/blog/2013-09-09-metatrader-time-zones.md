---
author: Andrew B. Collier
date: 2013-09-09T14:43:38Z
title: MetaTrader Time Zones
---

Time zones on MetaTrader can be slightly confusing. There are two important time zones:

* the time zone of the broker's server and
* your local time zone.

And these need not be the same.

<!--more-->

<img src="/img/2013/09/Workspace-2_050.png">

To distinguish between the two, open up any M1 chart. The time of the most recent candle on this chart is the time on the broker's server. You can find the time zone of the server by comparing this time to [Greenwich Mean Time](http://wwp.greenwichmeantime.com/) (GMT). Similarly, you can find your local time zone by comparing the time on your computer to GMT.

So, for example, in the image above the server time was 17:31 (highlighted in blue) while my local time was 16:31 (highlighted in green). The corresponding GMT was 14:31. This means that my local time zone is GMT+2 and the time zone of the broker's server is GMT+3.

In MQL4 the server's time is accessed via CurTime() while the local time comes, not surprisingly, from LocalTime().
