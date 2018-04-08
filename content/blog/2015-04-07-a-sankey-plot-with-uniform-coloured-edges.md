---
author: Andrew B. Collier
date: 2015-04-07T11:16:35Z
tags: ["R"]
title: A Sankey Plot with Uniform Coloured Edges
---

Following up on my [previous post](http://www.exegetic.biz/blog/2014/08/plotting-flows-with-riverplot/) about generating Sankey plots with the riverplot package. It's also possible to generate plots which have constant coloured edges.

<!--more-->

Here's how (using some of the data structures from the previous post too):

{{< highlight r >}}
edges$col = sample(palette, size = nrow(edges), replace = TRUE)
edges$edgecol <- "col"
river <- makeRiver(nodes, edges)
style <- list(nodestyle= "invisible")
{{< /highlight >}}

<img src="/img/2015/04/riverplot-example-constant-edge.png">
