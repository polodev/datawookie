---
author: Andrew B. Collier
date: 2015-06-04T09:44:08Z
tags: ["R"]
title: 'R Recipe: RStudio and UNC Paths'
---

<!-- https://support.rstudio.com/hc/en-us/community/posts/200657076-Also-load-the-user-s-Rprofile-when-opening-a-project-with-a-project-specific-Rprofile -->

<!-- NOTE: It seems that AppSense was necessary for the contents of .Renviron to be persisted between sessions. -->

RStudio does not like [Uniform Naming Convention (UNC)](http://en.wikipedia.org/wiki/Path_%28computing%29) paths. This can be a problem if, for example, you install it under Citrix. The solution is to create a suitable environment file.

<!--more-->

## Environment File

Create an `.Renviron` file with the following contents:

{{< highlight r >}}
R_LIBS_USER="H:/myCitrixFiles/Documents/R/win-library/3.2"
R_USER="H:/myCitrixFiles/Documents"
{{< /highlight >}}

Your choice of folders might be slightly different (especially if you are using a different version of R!), but it should be essentially the same as that above.

## Default Working Folder

Of course, it's important that RStudio can _find_ your `.Renviron` file. By default it looks in your home folder. To check on your home folder location, open a new R session and then do the following:

{{< highlight r >}}
> Sys.getenv("HOME")
> Sys.getenv("R_USER")
{{< /highlight >}}

The result of both commands should be the same, probably a `Documents` folder on the `C:` drive. This is where you need to stash your `.Renviron` file.

## Profile File

You can also create a `.Rprofile` file in the same folder. The contents of this file will be executed at startup, but after any environment changes specified in `.Renviron`.

To change your initial working folder to `H:`, your `.Rprofile` would look like this:

{{< highlight r >}}
setwd("H:")
{{< /highlight >}}