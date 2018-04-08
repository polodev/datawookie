---
author: Andrew B. Collier
date: 2016-02-11T07:33:16Z
tags: ["R"]
title: Automating R scripts under Windows
---

Setting up an automated job under Linux is a cinch thanks to [cron](https://en.wikipedia.org/wiki/Cron). Doing the same under Windows is a little more tricky, but still eminently doable.

<!--more-->

I found this tutorial helpful:

<iframe width="560" height="315" src="https://www.youtube.com/embed/UDKy5_SQy2o" frameborder="0" allowfullscreen></iframe>

That got me 99% of the way there. I wrote a batch file to trigger the script. The critical element was changing to the correct location before invoking R.

{{< highlight shell >}}
@echo off
cd "C:\Users\AndrewCo\Projects\"
R CMD BATCH script.R
{{< /highlight >}}
