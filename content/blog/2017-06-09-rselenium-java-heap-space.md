---
author: Andrew B. Collier
date: 2017-06-09T05:45:00Z
tags: ["R", "Web Scraping", "Selenium"]
title: RSelenium and Java Heap Space
---

I'm in the process of deploying a scraper on a DigitalOcean instance. The scraper uses [RSelenium](http://ropensci.github.io/RSelenium/) with the [PhantomJS](http://phantomjs.org/) browser. I ran into a problem though. Although it worked flawlessly on my local machine, on the remote instance it broke with the following error:

{{< highlight text >}}
Selenium message:Java heap space

Error:   Summary: UnknownError
   Detail: An unknown server-side error occurred while processing the command.
   class: java.lang.OutOfMemoryError
   Further Details: run errorDetails method
Execution halted
{{< /highlight >}}

Clearly Java a memory issue.

Since the Selenium server is being launched from within R, I did not have direct access to the `java` command line options. However, setting an environment variable to increase the heap space resolved the problem.

{{< highlight bash >}}
$ export _JAVA_OPTIONS="-Xmx1g"
{{< /highlight >}}

The scraper is now chugging along happily and I'm moving on with my day.
