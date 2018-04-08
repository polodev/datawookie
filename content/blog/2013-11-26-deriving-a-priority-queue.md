---
author: Andrew B. Collier
date: 2013-11-26T05:48:20Z
tags: ["R"]
title: Deriving a Priority Queue from a Plain Vanilla Queue
---

Following up on my recent post about [implementing a queue as a reference class](http://www.exegetic.biz/blog/2013/11/implementing-a-queue-as-a-reference-class/), I am going to derive a [Priority Queue](https://en.wikipedia.org/wiki/Priority_queue) class.

<!--more-->

# Inheritance

The syntax for Reference Class inheritance is quite intuitive.

{{< highlight r >}}
PriorityQueue <- setRefClass("PriorityQueue",
                             contains = "Queue",
                             fields = list(
                               priorities = "numeric"
                             ),
                             methods = list(
                               push = function(item, priority) {
                                 'Inserts element into the queue, reordering according to priority.'
                                 callSuper(item)
                                 priorities <<- c(priorities, priority)
                                 #
                                 order = order(priorities, decreasing = TRUE, partial = size():1)
                                 #
                                 data <<- data[order]
                                 priorities <<- priorities[order]
                               },
                               #
                               pop = function() {
                                 'Removes and returns head of queue (or raises error if queue is empty).'
                                 if (size() == 0) stop("queue is empty!")
                                 priorities <<- priorities[-1]
                                 callSuper()
                               })
)
{{< /highlight >}}

We need to modify only two of the methods. The most important of these is insert(), which is where all of the important stuff happens! I've added an additional parameter, priority, which gives the relative importance of the item to be inserted (with larger values indicating greater importance). The items are sorted according to priority, where items of higher priority are shifted to the front of the queue. Amongst items which have the same priority, the order of insertion is retained. The pop() method also needs modification: when items are removed from the queue, the corresponding priority is also discarded.

# Priority Queue in Action

We create an instance of the Priority Queue and then insert four items with varying levels of importance.

{{< highlight r >}}
> q4 <- PriorityQueue$new()
>
> q4$push("first", 1)
> q4$push("second", 2)
> q4$push("third", 1)
> q4$push("fourth", 3)
{{< /highlight >}}

According to the logic outlined above, the item "fourth" should move to the front of the queue since it has the highest priority. It will be followed by "second" which has next highest priority. Finally we have "first" and "second", which have the same priority and thus retain the order in which they were inserted.

{{< highlight r >}}
> q4$priorities
[1] 3 2 1 1
> q4$data
[[1]]
[1] "fourth"

[[2]]
[1] "second"

[[3]]
[1] "first"

[[4]]
[1] "third"
{{< /highlight >}}

Next we can start extracting items from the queue. As expected, item "fourth" comes out first, followed in turn by "second", "first" and "third". The methods which were inherited without modification work as expected.

{{< highlight r >}}
> q4$pop()
[1] "fourth"
> q4$priorities
[1] 2 1 1
> 
> q4$pop()
[1] "second"
> q4$peek()
[1] "first"
> q4$poll()
[1] "first"
> 
> q4$pop()
[1] "third"
> q4$priorities
numeric(0)
> q4$poll()
NULL
{{< /highlight >}}

This code is now published in the [liqueueR](https://github.com/DataWookie/liqueueR) package.
