---
author: Andrew B. Collier
date: 2015-06-19T11:45:55Z
tags: ["R", "AWS"]
title: 'Amazon EC2: Upgrading R'
---

After installing R and Shiny on my EC2 instance I discovered that the default version of R was a little dated and I wanted to update to R 3.2.0. It's not terribly complicated, but here are the steps I took.

<!-- https://gist.github.com/DataWookie/3d0b395735703852317b198b30e83645 -->
<script src="https://gist.github.com/DataWookie/3d0b395735703852317b198b30e83645.js"></script>

When you launch R you should find that it is the sparkling new version.

Now you will want to update all of the packages too, so launch R (as root) and then do:

{{< highlight r >}}
> update.packages(lib.loc = "/usr/local/lib/R/site-library", ask = FALSE)
{{< /highlight >}}

If you have packages installed in a user library, you should update those too.

Finally, if you run into memory problems with the package updates, then you'll need to [add a swap file](http://www.exegetic.biz/blog/2015/06/amazon-ec2-adding-swap/).