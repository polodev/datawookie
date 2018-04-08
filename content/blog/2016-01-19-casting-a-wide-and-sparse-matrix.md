---
author: Andrew B. Collier
date: 2016-01-19T11:22:27Z
tags: ["R"]
title: Casting a Wide (and Sparse) Matrix in R
---

I routinely use `melt()` and `cast()` from the reshape2 package as part of my data munging workflow. Recently I've noticed that the data frames I've been casting are often extremely sparse. Stashing these in a dense data structure just feels wasteful. And the dismal drone of page thrashing is unpleasant.

So I had a look around for an alternative. As it turns out, it's remarkably easy to cast a sparse matrix using `sparseMatrix()` from the Matrix package. Here's an example.

First we'll put together some test data.

{{< highlight r >}}
> set.seed(11)
> 
> N = 10
> 
> data = data.frame(
+   row = sample(1:3, N, replace = TRUE),
+   col = sample(LETTERS, N, replace = TRUE),
+   value = sample(1:3, N, replace = TRUE))
> 
> data = transform(data,
+                  row = factor(row),
+                  col = factor(col))
{{< /highlight >}}

It's just a data.frame with two fields which will be transformed into the rows and columns of the matrix and a third field which gives the values to be stored in the matrix.

{{< highlight r >}}
> data
   row col value
1    1   E     1
2    1   L     3
3    2   X     2
4    1   W     2
5    1   T     1
6    3   O     2
7    1   M     2
8    1   I     1
9    3   E     1
10   1   M     2
{{< /highlight >}}

Doing the cast is pretty easy using `sparseMatrix()` because you specify the row and column for every entry inserted into the matrix. Multiple entries for a single cell (like the highlighted records above) are simply summed, which is generally the behaviour that I am after anyway.

{{< highlight r >}}
> library(Matrix)
> 
> data.sparse = sparseMatrix(as.integer(data$row), as.integer(data$col), x = data$value)
>
> colnames(data.sparse) = levels(data$col)
> rownames(data.sparse) = levels(data$row)
{{< /highlight >}}

And here's the result:

{{< highlight r >}}
> data.sparse
3 x 8 sparse Matrix of class "dgCMatrix"
  E I L M O T W X
1 1 1 3 4 . 1 2 .
2 . . . . . . . 2
3 1 . . . 2 . . .
{{< /highlight >}}
