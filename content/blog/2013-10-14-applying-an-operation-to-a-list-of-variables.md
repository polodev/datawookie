---
author: Andrew B. Collier
date: 2013-10-14T06:12:52Z
tags: ["R"]
title: Applying the Same Operation to a Number of Variables
---

Just a quick note on a short hack that I cobbled together this morning. I have an analysis where I need to perform the same set of operations to a list of variables. In order to do this in a compact and robust way, I wanted to write a loop that would run through the variables and apply the operations to each of them in turn. This can be done using get() and assign().

# Simple Illustration

To illustrate the procedure, I will use the simple example of squaring the numerical values stored in three variables. First we initialise the variables.

{{< highlight r >}}
> x = 1
> y = 2
> z = 3
{{< /highlight >}}

Then we loop over the variable names (as strings), creating a temporary copy of each one and applying the operation to the copy. Then the copy is assigned back to the original variable.

{{< highlight r >}}
> for (n in c("x", "y", "z")) {
+   v = get(n)
+   #
+   v = v**2
+   #
+   assign(n, v)
+ }
{{< /highlight >}}

Finally we check that the operation has been executed as expected.

{{< highlight r >}}
> x
[1] 1
> y
[1] 4
> z
[1] 9
{{< /highlight >}}

This is perhaps a little wasteful in terms of resources (creating the temporary variables), but does the job. Obviously in practice you would only implement this sort of solution if there were either a large number of variables to be transformed or the transformation required a relatively complicated set of operations.

# Alternative Implementations

Following up on the numerous insightful responses to this post, there are a number of other ways of skinning the same cat. But, I should point out that the solution above is still optimal for my particular application where I had a series of operations to be applied to each of the variables, some of which involved conditional branches, making a solution using vectorised operations rather messy. Furthermore, I did not want to have to pack and unpack from a list.

# Usage Case

To give a better idea of the type of scenario that I was looking at, consider a situation in which you have a number of data frames. Let's call them A, B, C and D. The data in each is similar, yet each pertains to a distinct population. And, for whatever reason, you want to keep these data separate rather than consolidating them into a single data frame. Now suppose further that you wanted to perform a set of operations on each of them:

* retain only a subset of the columns; 
* rename the remaining columns; and 
* derive new columns using transformations of the existing columns.

Using the framework above you could achieve all of these objectives without any replication of code.
