---
author: Andrew B. Collier
date: 2015-09-16T14:00:26Z
tags: ["Julia"]
title: 'MonthOfJulia Day 15: Time Series'
---

<!--more-->

<img src="/img/2015/09/Julia-Logo-TimeSeries.png">

Yesterday we looked at Julia's support for tabular data, which can be represented by a `DataFrame`. The [`TimeSeries`](https://github.com/JuliaStats/TimeSeries.jl) package implements another common data type: [time series](https://en.wikipedia.org/wiki/Time_series). We'll start by loading the `TimeSeries` package, but we'll also add the `Quandl` package, which provides an interface to a rich source of time series data from [Quandl](https://www.quandl.com/).

{{< highlight julia >}}
julia> using TimeSeries
julia> using Quandl
{{< /highlight >}}

We'll start by getting our hands on some data from Yahoo Finance. By default these data will be of type `TimeArray`, although it is possible to explicitly request a `DataFrame` instead,

{{< highlight julia >}}
julia> google = quandl("YAHOO/GOOGL"); # GOOGL at (default) daily intervals
julia> typeof(google)
TimeArray{Float64,2,DataType} (constructor with 1 method)
julia> apple = quandl("YAHOO/AAPL", frequency = :weekly); # AAPL at weekly intervals
julia> mmm = quandl("YAHOO/MMM", from = "2015-07-01"); # MMM starting at 2015-07-01
julia> rht = quandl("YAHOO/RHT", format = "DataFrame"); # As a DataFrame
julia> typeof(rht)
DataFrame (constructor with 11 methods)
{{< /highlight >}}

Having a closer look at one of the `TimeSeries` objects we find that it actually consists of multiple data series, each represented by a separate column. The `colnames` attribute gives names for each of the component series, while the `timestamp` and `values` attributes provide access to the data themselves. We'll see more convenient means for accessing those data in a moment.

{{< highlight julia >}}
julia> google
100x6 TimeArray{Float64,2,DataType} 2015-04-24 to 2015-09-15

             Open     High     Low      Close    Volume    Adjusted Close
2015-04-24 | 580.05   584.7    568.35   573.66   4608400   573.66
2015-04-27 | 572.77   575.52   562.3    566.12   2403100   566.12
2015-04-28 | 564.32   567.83   560.96   564.37   1858900   564.37
2015-04-29 | 560.51   565.84   559.0    561.39   1681100   561.39
⋮
2015-09-10 | 643.9    654.9    641.7    651.08   1384600   651.08
2015-09-11 | 650.21   655.31   647.41   655.3    1736100   655.3
2015-09-14 | 655.63   655.92   649.5    652.47   1497100   652.47
2015-09-15 | 656.71   668.85   653.34   665.07   1761800   665.07
julia> names(google)
4-element Array{Symbol,1}:
 :timestamp
 :values
 :colnames
 :meta
julia> google.colnames
6-element Array{UTF8String,1}:
 "Open"
 "High"
 "Low"
 "Close"
 "Volume"
 "Adjusted Close"
julia> google.timestamp[1:5]
5-element Array{Date,1}:
 2015-04-24
 2015-04-27
 2015-04-28
 2015-04-29
 2015-04-30
julia> google.values[1:5,:]
5x6 Array{Float64,2}:
 580.05   584.7    568.35   573.66   4.6084e6   573.66
 572.77   575.52   562.3    566.12   2.4031e6   566.12
 564.32   567.83   560.96   564.37   1.8589e6   564.37
 560.51   565.84   559.0    561.39   1.6811e6   561.39
 558.56   561.11   546.72   548.77   2.362e6    548.77
{{< /highlight >}}

The TimeArray type caters for a full range of indexing operations which allow you to slice and dice those data to your exacting requirements. `to()` and `from()` extract subsets of the data before or after a specified instant.

{{< highlight julia >}}
julia> google[1:5]
5x6 TimeArray{Float64,2,DataType} 2015-04-24 to 2015-04-30

             Open     High     Low      Close    Volume    Adjusted Close
2015-04-24 | 580.05   584.7    568.35   573.66   4608400   573.66
2015-04-27 | 572.77   575.52   562.3    566.12   2403100   566.12
2015-04-28 | 564.32   567.83   560.96   564.37   1858900   564.37
2015-04-29 | 560.51   565.84   559.0    561.39   1681100   561.39
2015-04-30 | 558.56   561.11   546.72   548.77   2362000   548.77
julia> google[[Date(2015,8,7):Date(2015,8,12)]]
4x6 TimeArray{Float64,2,DataType} 2015-08-07 to 2015-08-12

             Open     High     Low      Close    Volume    Adjusted Close
2015-08-07 | 667.78   668.8    658.87   664.39   1374100   664.39
2015-08-10 | 667.09   671.62   660.23   663.14   1403900   663.14
2015-08-11 | 699.58   704.0    684.32   690.3    5264100   690.3
2015-08-12 | 694.49   696.0    680.51   691.47   2924900   691.47
julia> google["High","Low"]
100x2 TimeArray{Float64,2,DataType} 2015-04-24 to 2015-09-15

             High     Low
2015-04-24 | 584.7    568.35
2015-04-27 | 575.52   562.3
2015-04-28 | 567.83   560.96
2015-04-29 | 565.84   559.0
⋮
2015-09-10 | 654.9 641.7
2015-09-11 | 655.31 647.41
2015-09-14 | 655.92 649.5
2015-09-15 | 668.85 653.34
julia> google["Close"][3:5]
3x1 TimeArray{Float64,1,DataType} 2015-04-28 to 2015-04-30

             Close
2015-04-28 | 564.37
2015-04-29 | 561.39
2015-04-30 | 548.77
{{< /highlight >}}

We can shift observations forward or backward in time using `lag()` or `lead()`.

{{< highlight julia >}}
julia> lag(google[1:5])
4x6 TimeArray{Float64,2,DataType} 2015-04-27 to 2015-04-30

             Open     High     Low      Close    Volume    Adjusted Close
2015-04-27 | 580.05   584.7    568.35   573.66   4608400   573.66
2015-04-28 | 572.77   575.52   562.3    566.12   2403100   566.12
2015-04-29 | 564.32   567.83   560.96   564.37   1858900   564.37
2015-04-30 | 560.51   565.84   559.0    561.39   1681100   561.39
julia> lead(google[1:5], 3)
2x6 TimeArray{Float64,2,DataType} 2015-04-24 to 2015-04-27

             Open     High     Low      Close    Volume    Adjusted Close
2015-04-24 | 560.51   565.84   559.0    561.39   1681100   561.39
2015-04-27 | 558.56   561.11   546.72   548.77   2362000   548.77
{{< /highlight >}}

We can also calculate the percentage change between observations.

{{< highlight julia >}}
julia> percentchange(google["Close"], method = "log")
99x1 TimeArray{Float64,1,DataType} 2015-04-27 to 2015-09-15

             Close
2015-04-27 | -0.0132
2015-04-28 | -0.0031
2015-04-29 | -0.0053
2015-04-30 | -0.0227
⋮
2015-09-10 | 0.0119
2015-09-11 | 0.0065
2015-09-14 | -0.0043
2015-09-15 | 0.0191
{{< /highlight >}}

Well, that's the core functionality in `TimeSeries`. There are also methods for aggregation and moving window operations, as well as time series merging. You can check out some examples in the [documentation](http://timeseriesjl.readthedocs.org/en/latest/index.html) as well as on [github](https://github.com/DataWookie/MonthOfJulia). Finally, watch the video below from JuliaCon 2014.

<iframe width="560" height="315" src="https://www.youtube.com/embed/y_Psv8pUQsQ" frameborder="0" allowfullscreen></iframe>
