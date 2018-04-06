---
author: Andrew B. Collier
date: 2017-09-07T14:30:00Z
tags: ["R"]
title: Global Variables in R Packages
---

I know that global variables are from the Devil, but sometimes you just can't get around them.

I'm building a small package for a client that relies on a data file. For various reasons that file is not part of the package and can reside in different locations on users' machines. Furthermore there are users on both Windows and Linux machines.

<!--more-->

I decided to set up a global variable to store the data file path and a function to modify it.

## Naive Implementation

This is what my initial implementation looked like:

{{< highlight r >}}
data_path = "data"

set_data_path <- function(path) {
  data_path <<- path
}
{{< /highlight >}}

It seems perfectly reasonable. And, in fact, would work... were in not in a package. However, building the package and giving a try yielded an error.

{{< highlight r >}}
> set_data_path("/tmp")
Error in set_data_path("/tmp") : 
  cannot change value of locked binding for 'data_path'
{{< /highlight >}}

While investigating the problem I learned about `unlockBinding()`, which is good to know.

## Improved Implementation

It turns out that you need to use an environment to get this to work. Here is the revised (working) code:

{{< highlight r >}}
pkg.globals <- new.env()

pkg.globals$data_path <- "data"

set_data_path <- function(path) {
  pkg.globals$data_path <- path
}
{{< /highlight >}}

It's slightly more verbose, but it works!