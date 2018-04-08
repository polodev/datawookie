---
author: Andrew B. Collier
date: 2018-02-05T07:00:00Z
excerpt_separator: <!-- more -->
title: Installing rJava on Ubuntu
draft: false
tags: ["R", "Linux"]
---

Installing the rJava package on Ubuntu is not quite as simple as most other R packages. Some quick notes on how to do it.

<!--more-->

1. Install the Java Runtime Environment (JRE).
    {{< highlight text >}}
sudo apt-get install -y default-jre
{{< /highlight >}}
2. Install the Java Development Kit (JDK).
    {{< highlight text >}}
sudo apt-get install -y default-jdk
{{< /highlight >}}
3. Update where R expects to find various Java files.
    {{< highlight text >}}
sudo R CMD javareconf
{{< /highlight >}}
4. Install the package.
    {{< highlight r >}}
> install.packages("rJava")
{{< /highlight >}}

Sorted!
