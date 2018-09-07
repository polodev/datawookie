---
author: Andrew B. Collier
date: 2018-09-07T02:00:00Z
tags: ["R"]
title: "Diagnosing RStudio Startup Issues"
---

Yesterday I tried to start RStudio and something weird happened: the window launched but it was blank and unresponsive.

I tried `dpkg --remove` and then re-installed. Same problem.

I tried `dpkg --remove` followed by `dpkg --purge` and then re-installed. Same problem.

I renamed by `.R` folder. Still the same problem.

A sense of desperation was beginning to set in: most of my projects rely on RStudio.

After trying a selection of other options I consulted the Internet Oracle and learned that I could get additional diagnostics using

{{< highlight bash >}}
rstudio --run-diagnostics
{{< /highlight >}}

That produced a lot of useful information. Most useful was the fact that RStudio was getting permission denied on `~/.rstudio-desktop`. A little further investigation revealed that the ownership on that folder had been modified (I have been messing around with some RStudio Docker images!), replacing UID 1000 with UID 500. A quick `chown` and the problem was resolved.

If you have problems running RStudio, give `--run-diagnostics` a try.