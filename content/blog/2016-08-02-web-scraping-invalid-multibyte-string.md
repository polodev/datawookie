---
author: Andrew B. Collier
date: 2016-08-02T15:00:15Z
tags: ["R", "Web Scraping"]
title: Web Scraping and "invalid multibyte string"
---

A couple of my collaborators have had trouble using `read_html()` from the [xml2 package](https://cran.r-project.org/web/packages/xml2/index.html) to access [this Wikipedia page](https://en.wikipedia.org/wiki/List_of_countries_by_population_(United_Nations)). <!--more--> Specifically they have been getting errors like this:

{{< highlight r >}}
Error in utils::type.convert(out[, i], as.is = TRUE, dec = dec) :
  invalid multibyte string at '<e2><94>'
{{< /highlight >}}

Since I couldn't reproduce these errors on my machine it appeared to be something relating to their particular machine setup. Looking at their locale provided a clue:

{{< highlight r >}}
> Sys.getlocale()
[1] "LC_COLLATE=Korean_Korea.949;LC_CTYPE=Korean_Korea.949;LC_MONETARY=Korean_Korea.949;
LC_NUMERIC=C;LC_TIME=Korean_Korea.949"
{{< /highlight >}}

whereas on my machine I have:

{{< highlight r >}}
> Sys.getlocale()
[1] "LC_CTYPE=en_ZA.UTF-8;LC_NUMERIC=C;LC_TIME=en_ZA.UTF-8;LC_COLLATE=en_ZA.UTF-8;
LC_MONETARY=en_ZA.UTF-8;LC_MESSAGES=en_ZA.UTF-8;LC_PAPER=en_ZA.UTF-8;LC_NAME=C;LC_ADDRESS=C;
LC_TELEPHONE=C;LC_MEASUREMENT=en_ZA.UTF-8;LC_IDENTIFICATION=C"
{{< /highlight >}}

The document that they were trying to scrape is encoded in UTF-8, which I see in my locale but not in theirs. Perhaps changing locale will sort out the problem? Since the `en_ZA` locale is a bit of an acquired taste (unless you're South African, in which case it's _de rigueur_!), the following should resolve the problem:

{{< highlight r >}}
> Sys.setlocale("LC_CTYPE", "en_US.UTF-8")
{{< /highlight >}}

It's possible that command might produce an error stating that it cannot be honoured by your system. Do not fear. Try the following (which seems to work almost universally!):

{{< highlight r >}}
Sys.setlocale("LC_ALL", "English")
{{< /highlight >}}

Try scraping again. Your issues should be resolved.
