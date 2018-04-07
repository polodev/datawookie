---
author: Andrew B. Collier
date: 2016-08-08T15:00:52Z
tags: ["R"]
title: 'feedeR: Reading RSS and Atom Feeds from R'
---

I'm working on a project in which I need to systematically parse a number of [RSS](https://en.wikipedia.org/wiki/RSS) and [Atom](https://en.wikipedia.org/wiki/Atom_(standard)) feeds from within R. I was somewhat surprised to find that no package currently exists on CRAN to handle this task. So this presented the opportunity for a bit of DIY.

You can find the fruits of my morning's labour [here](https://github.com/DataWookie/feedeR).

<!--more-->

## Installing and Loading

The package is currently hosted on GitHub.

{{< highlight r >}}
> devtools::install_github("DataWookie/feedeR")
> library(feedeR)
{{< /highlight >}}

## Reading a RSS Feed

Although Atom is supposed to be a better format from a technical perspective, RSS is relatively ubiquitous. The vast majority of blogs provide an RSS feed. We'll look at the feed exposed by [R-bloggers](https://www.r-bloggers.com).

{{< highlight r >}}
> rbloggers <- feed.extract("https://feeds.feedburner.com/RBloggers")
> names(rbloggers)
[1] "title" "link" "updated" "items"
{{< /highlight >}}

There are three metadata elements pertaining to the feed.

{{< highlight r >}}
> rbloggers[1:3]
$title
[1] "R-bloggers"

$link
[1] "https://www.r-bloggers.com"

$updated
[1] "2016-08-06 09:15:54 UTC"
{{< /highlight >}}

The actual entries on the feed are captured in the `items` element. For each entry the `title`, publication `date` and `link` are captured. There are often more fields available for each entry, but these three are generally present.

{{< highlight r >}}
> nrow(rbloggers$items)
[1] 8
> head(rbloggers$items, 3)
                                                              title                date
1                                                       readr 1.0.0 2016-08-05 20:25:05
2 Map the Life Expectancy in United States with data from Wikipedia 2016-08-05 19:48:53
3 Creating Annotated Data Frames from GEO with the GEOquery package 2016-08-05 19:35:45
                                                                                           link
1                                                       https://www.r-bloggers.com/readr-1-0-0/
2 https://www.r-bloggers.com/map-the-life-expectancy-in-united-states-with-data-from-wikipedia/
3 https://www.r-bloggers.com/creating-annotated-data-frames-from-geo-with-the-geoquery-package/
{{< /highlight >}}

## Reading an Atom Feed

Atom feeds are definitely in the minority, but this format is still used by a number of popular sites. We'll look at the feed from [The R Journal](https://journal.r-project.org/).

{{< highlight r >}}
> rjournal <- feed.extract("http://journal.r-project.org/rss.atom")
{{< /highlight >}}

The same three elements of metadata are present.

{{< highlight r >}}
> rjournal[1:3]
$title
[1] "The R Journal"

$link
[1] "http://journal.r-project.org"

$updated
[1] "2016-07-23 13:16:08 UTC"
{{< /highlight >}}

Atom feeds do not appear to consistently provide the date on which each of the entries was originally published. The `title` and `link` fields are always present though!

{{< highlight r >}}
> head(rjournal$items, 3)
                                                                                title date
1                         Heteroscedastic Censored and Truncated Regression with crch   NA
2 An Interactive Survey Application for Validating Social Network Analysis Techniques   NA
3            quickpsy: An R Package to Fit Psychometric Functions for Multiple Groups   NA
                                                                     link
1  http://journal.r-project.org/archive/accepted/messner-mayr-zeileis.pdf
2        http://journal.r-project.org/archive/accepted/joblin-mauerer.pdf
3 http://journal.r-project.org/archive/accepted/linares-lopez-moliner.pdf
{{< /highlight >}}

## Outlook

I'm still testing this across a selection of feeds. If you find a feed that breaks the package, please [let me known](https://github.com/DataWookie/feedeR/issues) and I'll debug as necessary.
