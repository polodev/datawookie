---
author: Andrew B. Collier
date: 2015-01-14T05:30:16Z
tags: ["R"]
title: 'Downloading Options Data in R: An Update'
---

I recently read an [article](http://mktstk.wordpress.com/2014/12/29/start-trading-like-a-quant-download-option-chains-from-google-finance-in-r/) which showed how to download Option Chain data from [Google Finance](https://www.google.com/finance) using R. <!-- Interestingly, that article appears to be a close adaption of [another article](http://www.drtomstarke.com/index.php/option-chains-from-google-finance-api) which does the same thing using Python. -->

<!--more-->

While playing around with the code from these articles I noticed a couple of things that might benefit from minor tweaks. Before I look at those though, it's worthwhile pointing out that there already is a function in [quantmod](http://www.quantmod.com/) for retrieving Option Chain data from Yahoo! Finance. What I am doing here is thus more for my own personal edification (but hopefully you will find it interesting too!).

The full code for this project (along with a number of updates subsequent to the original post) is available on [GitHub](https://github.com/DataWookie/flipsideR).

## Background

An [Option Chain](http://www.investopedia.com/terms/o/optionchain.asp) is just a list of all available options for a particular security spanning a range of expiration dates.

## The Code

First we need to load a few packages which facilitate the downloading, parsing and manipulation of the data.

{{< highlight r >}}
> library(RCurl)
> library(jsonlite)
> library(plyr)
{{< /highlight >}}

We'll be retrieving the data in [JSON](http://json.org/) format. Somewhat disturbingly the JSON data from Google Finance does not appear to be fully compliant with the JSON standards because the keys are not quoted. We'll use a helper function which will run through the data and insert quotes around each of the keys. The original code for this function looped through a list of key names. This is a little inefficient and would also be problematic if additional keys were introduced. We'll get around that by using a different approach which avoids stipulating key names.

{{< highlight r >}}
> fixJSON <- function(json){
+   gsub('([^,{:]+):', '"\\1":', json)
+ }
{{< /highlight >}}

To make the download function more concise we'll also define two URL templates.

{{< highlight r >}}
> URL1 = 'http://www.google.com/finance/option_chain?q=%s%s&output=json'
> URL2 = 'http://www.google.com/finance/option_chain?q=%s%s&output=json&expy=%d&expm=%d&expd=%d'
{{< /highlight >}}

And finally the download function itself, which proceeds through the following steps for a specified ticker symbol:

1. downloads summary data; 
* extracts expiration dates from the summary data and downloads the options data for each of those dates; 
* concatenates these data into a single structure, neatens up the column names and selects a subset.

{{< highlight r >}}
> getOptionQuotes <- function(symbol, exchange = NA) {
+   exchange = ifelse(is.na(exchange), "", paste0(exchange, ":"))
+   #
+   url = sprintf(URL1, exchange, symbol)
+   #
+   chain = tryCatch(fromJSON(fixJSON(getURL(url))), error = function(e) NULL)
+   #
+   if (is.null(chain)) stop(sprintf("retrieved document is not JSON. Try opening %s in your browser.", url))
+   #
+   # Iterate over the expiry dates
+   #
+   options = mlply(chain$expirations, function(y, m, d) {
+     url = sprintf(URL2, exchange, symbol, y, m, d)
+     expiry = fromJSON(fixJSON(getURL(url)))
+     #
+     expiry$calls$type = "Call"
+     expiry$puts$type  = "Put"
+     #
+     prices = rbind(expiry$calls, expiry$puts)
+     #
+     prices$expiry = sprintf("%4d-%02d-%02d", y, m, d)
+     prices$underlying.price = expiry$underlying_price
+     #
+     prices$retrieved = Sys.time()
+     #
+     prices
+   })
+   #
+   options = options[sapply(options, class) == "data.frame"]
+   #
+   # Concatenate data for all expiration dates and add in symbol column
+   #
+   options = cbind(data.frame(symbol), rbind.fill(options))
+   #
+   options = rename(options, c("p" = "premium", "b" = "bid", "a" = "ask", "oi" = "open.interest"))
+   #
+   for (col in c("strike", "premium", "bid", "ask")) options[, col] = suppressWarnings(as.numeric(options[, col]))
+   options[, "open.interest"] = suppressWarnings(as.integer(options[, "open.interest"]))
+   #
+   options[, c("symbol", "type", "expiry", "strike", "premium", "bid", "ask", "open.interest", "retrieved")]
+ }
{{< /highlight >}}

## Results

Let's give it a whirl. (The data below were retrieved on Saturday 10 January 2015).

{{< highlight r >}}
> AAPL = getOptionQuotes("AAPL")
> nrow(AAPL)
[1] 1442
{{< /highlight >}}

This is what the resulting data look like, with all available expiration dates consolidated into a single table:

{{< highlight r >}}
> head(AAPL)
  symbol type     expiry strike premium   bid   ask open.interest           retrieved
1   AAPL Call 2015-08-28     70   36.00 35.50 37.00             0 2015-08-22 10:03:19
2   AAPL Call 2015-08-28     75      NA 29.95 31.95             0 2015-08-22 10:03:19
3   AAPL Call 2015-08-28     80   27.20 25.50 27.05            10 2015-08-22 10:03:19
4   AAPL Call 2015-08-28     85   23.27 20.70 21.75           482 2015-08-22 10:03:19
5   AAPL Call 2015-08-28     90   16.60 16.00 16.85           605 2015-08-22 10:03:19
6   AAPL Call 2015-08-28     91   15.85 15.15 16.30             0 2015-08-22 10:03:19
> tail(AAPL)
     symbol type     expiry strike premium   bid   ask open.interest           retrieved
1043   AAPL  Put 2017-01-20    170   59.40 63.30 66.45          1275 2015-08-22 10:03:30
1044   AAPL  Put 2017-01-20    175   71.00 68.30 71.25          2213 2015-08-22 10:03:30
1045   AAPL  Put 2017-01-20    180   68.80 72.95 76.45           808 2015-08-22 10:03:30
1046   AAPL  Put 2017-01-20    185   73.55 77.75 81.15          1478 2015-08-22 10:03:30
1047   AAPL  Put 2017-01-20    190   78.30 82.50 85.35          2306 2015-08-22 10:03:30
1048   AAPL  Put 2017-01-20    195   88.50 87.35 90.25          7808 2015-08-22 10:03:30
{{< /highlight >}}

There is a load of data there. To get an idea of what it looks like we can generate a couple of plots. Below is the Open Interest as a function of Strike Price across all expiration dates. The underlying price is indicated by the vertical dashed line. As one might expect, the majority of interest is associated with the next expiration date on 17 January 2015.

<img src="/img/2015/01/open-interest-strike-price-AAPL.png">

It's pretty clear that this is not the optimal way to look at these data and I would be extremely interested to hear from anybody with a suggestion for a better visualisation. Trying to look at all of the expiration dates together is probably the largest problem, so let's focus our attention on those options which expire on 17 January 2015. Again the underlying price is indicated by a vertical dashed line.

<img src="/img/2015/01/open-interest-premium-strike-price-AAPL.png">

This is the first time that I have seriously had a look at options data, but I will now readily confess to being intrigued. Having the data readily available, there is no reason not to explore further. Details to follow.
