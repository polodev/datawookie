---
author: Andrew B. Collier
date: 2014-06-06T13:16:20Z
tags: ["R"]
title: Concatenating a list of data frames
---

It's something that I do surprisingly often: concatenating a list of data frames into a single (possibly quite enormous) data frame. Until now my naive solution worked pretty well. However, today I needed to deal with a list of over 6 million elements. The result was hours of page thrashing before my R session finally surrendered. I suppose I should be happy that my hard disk survived.

<!--more-->

I did a bit of research and found that there are a few solutions which are much (much!) more efficient.

## The Problem

Let's create some test data: a list consisting of 100 000 elements, each of which is a small data frame.

{{< highlight r >}}
> data <- list()
> 
> N <- 100000
>
> for (n in 1:N) {
+   data[[n]] = data.frame(index = n, char = sample(letters, 1), z = runif(1))
+ }
> data[[1]]
  index char        z
1     1    t 0.221784
{{< /highlight >}}

## The Naive Solution

My naive solution to the problem was to use a combination of `do.call()` and `rbind()`. It gets the job done.

{{< highlight r >}}
> head(do.call(rbind, data))
  index char          z
1     1    h 0.56891292
2     2    x 0.90331644
3     3    z 0.53675079
4     4    h 0.04587779
5     5    o 0.08608656
6     6    l 0.26410506
{{< /highlight >}}

## Alternative Solutions #1 and #2

The plyr package presents two options.

{{< highlight r >}}
> library(plyr)
> 
> head(ldply(data, rbind))
  index char          z
1     1    h 0.56891292
2     2    x 0.90331644
3     3    z 0.53675079
4     4    h 0.04587779
5     5    o 0.08608656
6     6    l 0.26410506
> head(rbind.fill(data))
  index char          z
1     1    h 0.56891292
2     2    x 0.90331644
3     3    z 0.53675079
4     4    h 0.04587779
5     5    o 0.08608656
6     6    l 0.26410506
{{< /highlight >}}

Both of these also do the job nicely.

## Alternative Solution #3

The revised package dplyr provides some alternative solutions.

{{< highlight r >}}
> library(dplyr)
> 
> head(rbind_all(data))
  index char          z
1     1    g 0.98735847
2     2    i 0.01427801
3     3    x 0.39046394
4     4    h 0.86044470
5     5    e 0.83855702
6     6    v 0.51332403
Warning message:
In rbind_all(data) : Unequal factor levels: coercing to character
{{< /highlight >}}

A second function, `rbind_list()`, takes individual elements to be concatenated as arguments (rather than a single list).

**Update:** `bind_rows()` will concatenate data frames, matching columns by name.

## Alternative Solution #4

Finally, a solution from the data.table package.

{{< highlight r >}}
> library(data.table)
> 
> head(rbindlist(data))
   index char          z
1:     1    h 0.56891292
2:     2    x 0.90331644
3:     3    z 0.53675079
4:     4    h 0.04587779
5:     5    o 0.08608656
6:     6    l 0.26410506
{{< /highlight >}}

## Benchmarking

All of these alternatives produce the correct result. The solution of choice will be the fastest one (and the one causing the minimum of page thrashing!).

{{< highlight r >}}
> library(rbenchmark)
> 
> benchmark(do.call(rbind, data), ldply(data, rbind), rbind.fill(data), rbind_all(data), rbindlist(data))
                  test replications  elapsed relative user.self sys.self user.child sys.child
1 do.call(rbind, data)          100 18943.38  609.308  11204.84     1.72         NA        NA
2   ldply(data, rbind)          100 16131.18  518.854   6529.10     1.56         NA        NA
3     rbind.fill(data)          100  4836.31  155.558   1936.55     0.37         NA        NA
4      rbind_all(data)          100  1627.84   52.359    111.79     0.10         NA        NA
5      rbindlist(data)          100    31.09    1.000     12.53     0.12         NA        NA
{{< /highlight >}}

## Thoughts on Performance

The naive solution uses the `rbind.data.frame()` method which is slow because it checks that the columns in the various data frames match by name and, if they don't, will re-arrange them accordingly. `rbindlist()`, by contrast, does not perform such checks and matches columns by position.

`rbindlist()` is implemented in C, while `rbind.data.frame()` is coded in R.

In the most recent version of data.table (1.9.3, currently available from [r-forge](http://datatable.r-forge.r-project.org/ "r-forge")), `rbindlist()` has two new arguments. One of them, use.names, forces `rbindlist()` to match column names and so works more like `rbind.data.frame()`, but is coded in C so it is more efficient. Another related argument, fill, causing missing columns to be filled with NA.

Both of the plyr solutions are an improvement on the naive solution. However, the dplyr solution is better than either of them. Relative to all of the other solutions, `rbindlist()` is far superior. It's blisteringly fast. Little wonder that my naive solution bombed out with a list of 6 million data frames. Using `rbindlist()`, however, it was done before I had finished my cup of coffee.

### Acknowledgements

Thanks to the various folk who provided feedback, which was used to expand and improve this post.
