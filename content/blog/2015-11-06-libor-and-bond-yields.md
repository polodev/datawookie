---
author: Andrew B. Collier
date: 2015-11-06T15:00:40Z
tags: ["R"]
title: LIBOR and Bond Yields
---

I've just been looking at the historical relationship between the [London Interbank Offered Rate (LIBOR)](https://en.wikipedia.org/wiki/Libor) and government bond yields. LIBOR data can be found at [Quandl](https://www.quandl.com/) and comes in CSV format, so it's pretty simple to digest. The bond data can be sourced from the [US Department of the Treasury](http://www.treasury.gov/resource-center/data-chart-center/interest-rates/Pages/TextView.aspx?data=yieldYear&year=2015). It comes as XML and requires a little more work.

{{< highlight r >}}
> treasury.xml = xmlParse('data/treasury-yield.xml')
> xml.field = function(name) {
+   xpathSApply(xmlRoot(treasury.xml), paste0('//ns:entry/ns:content//d:', name),
+               function(x) {xmlValue(x)},
+               namespaces = c(ns = 'http://www.w3.org/2005/Atom',
+                              d = 'http://schemas.microsoft.com/ado/2007/08/dataservices'))
+ }
> bonds = data.frame(
+   date = strptime(xml.field('NEW_DATE'), format = '%Y-%m-%dT%H:%M:%S', tz = 'GMT'),
+   yield_1m = as.numeric(xml.field('BC_1MONTH')),
+   yield_6m = as.numeric(xml.field('BC_6MONTH')),
+   yield_1y = as.numeric(xml.field('BC_1YEAR')),
+   yield_5y = as.numeric(xml.field('BC_5YEAR')),
+   yield_10y = as.numeric(xml.field('BC_10YEAR'))
+ )
{{< /highlight >}}

Once I had a data frame for each time series, the next step was to convert them each to [xts](https://cran.r-project.org/web/packages/xts/index.html) objects. With the data in xts format it was a simple matter to enforce temporal overlap and merge the data into a single time series object. The final step in the analysis was to calculate the linear coefficient, or beta, for a least squares fit of LIBOR on bond yield. This was to be done with both a 1 month and a 1 year moving window. Both of these could be achieved quite easily using `rollapply()` from the [zoo](https://cran.r-project.org/web/packages/zoo/index.html) package.

Below is the visualisation which I quickly put together on [Plotly](https://plot.ly/). Again I am profoundly impressed by just how easy this service is to use and how magnificent the interactive results are.

<iframe width="100%" height="400" frameborder="0" scrolling="no" src="https://plot.ly/~collierab/229.embed"></iframe>