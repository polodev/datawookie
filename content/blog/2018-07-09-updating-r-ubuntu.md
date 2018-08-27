---
author: Andrew B. Collier
date: 2018-07-09T01:00:00Z
tags: ["R"]
title: Updating R on Ubuntu
---

Today I finally got around to updating my R to 3.5 (or, more specifically, 3.5.1). The complete instructions for doing the update on Ubuntu are available [here](https://cran.r-project.org/bin/linux/ubuntu/). I've paraphrased them below.

<!--more-->

## Authentication Key

To ensure the integrity of files, add the appropriate public key to your system. You may have already done this, in which case you can skip this step.

{{< highlight bash >}}
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
{{< /highlight >}}

## APT Sources

Edit `/etc/apt/sources.list` and add the line appropriate to your distribution of Ubuntu.

{{< highlight bash >}}
# 18.04
deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/
# 16.04
deb https://cloud.r-project.org/bin/linux/ubuntu xenial-cran35/
# 14.04
deb https://cloud.r-project.org/bin/linux/ubuntu trusty-cran35/
{{< /highlight >}}

## Update and Install

Once you've updated the list of repositories it's time to refresh your local package list and then install the latest version of R.

{{< highlight bash >}}
sudo apt-get update
sudo apt-get install r-base r-base-dev
#
# To update any R libraries installed via APT.
#
sudo apt-get upgrade
{{< /highlight >}}

## Remove System Packages

You will probably have some packages that were previously installed with using APT. It would make sense to get rid of these now and simply installed updated versions into your local library.

{{< highlight bash >}}
sudo apt-get remove -y 'r-cran-*'
{{< /highlight >}}

You might have manually installed some packages into `/usr/local/lib/R/site-library` as well, so it's probably worthwhile removing those now too.

## Update Packages

Start the R interpreter. Note that the version number has been bumped. Now update all installed packages. That can take a while, depending on the number of packages you have installed.

{{< highlight R >}}
update.packages(ask = FALSE)
{{< /highlight >}}

Almost all of my packages updated seamlessly using the above. However, there were a handful that I needed to install manually.