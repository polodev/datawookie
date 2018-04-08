---
author: Andrew B. Collier
date: 2015-10-06T15:00:36Z
tags: ["Julia"]
title: 'MonthOfJulia Day 29: Distances'
---

<!--more-->

<img src="/img/2015/09/Julia-Logo-Distances.png" >

Today we'll be looking at the [Distances](https://github.com/JuliaStats/Distances.jl) package, which implements a range of distance metrics. This might seem a rather obscure topic, but distance calculation is at the core of all clustering techniques (which are next on the agenda), so it's prudent to know a little about how they work.

Note that there is a Distance package as well (singular!), which was deprecated in favour of the Distances package. So please install and load the latter.
  
{{< highlight julia >}}
julia> using Distances
{{< /highlight >}}

We'll start by finding the distance between a pair of vectors.
  
{{< highlight julia >}}
julia> x = [1., 2., 3.];
julia> y = [-1., 3., 5.];
{{< /highlight >}}
  
A simple application of Pythagora's Theorem will tell you that the Euclidean distance between the tips of those vectors is 3. We can confirm our maths with Julia though. The general form of a distance calculation uses `evaluate()`, where the first argument is a distance type. Common distance metrics (like Euclidean distance) also come with convenience functions.
  
{{< highlight julia >}}
julia> evaluate(Euclidean(), x, y)
3.0
julia> euclidean(x, y)
3.0
{{< /highlight >}}
  
We can just as easily calculate other metrics like the city block (or Manhattan), cosine or [Chebyshev](https://en.wikipedia.org/wiki/Chebyshev_distance) distances.
  
{{< highlight julia >}}
julia> evaluate(Cityblock(), x, y)
5.0
julia> cityblock(x, y)
5.0
julia> evaluate(CosineDist(), x, y)
0.09649209709474871
julia> evaluate(Chebyshev(), x, y)
2.0
{{< /highlight >}}

Moving on to distances between the columns of matrices. Again we'll define a pair of matrices for illustration.
  
{{< highlight julia >}}
julia> X = [0 1; 0 2; 0 3];
julia> Y = [1 -1; 1 3; 1 5];
{{< /highlight >}}
  
With `colwise()` distances are calculated between corresponding columns in the two matrices. If one of the matrices has only a single column (see the example with `Chebyshev()` below) then the distance is calculated between that column and all columns in the other matrix.
  
{{< highlight julia >}}
julia> colwise(Euclidean(), X, Y)
2-element Array{Float64,1}:
 1.73205
 3.0
julia> colwise(Hamming(), X, Y)
2-element Array{Int64,1}:
 3
 3
julia> colwise(Chebyshev(), X[:,1], Y)
2-element Array{Float64,1}:
 1.0
 5.0
{{< /highlight >}}
  
We also have the option of using `pairwise()` which gives the distances between all pairs of columns from the two matrices. This is precisely the distance matrix that we would use for a cluster analysis.
  
{{< highlight julia >}}
julia> pairwise(Euclidean(), X, Y)
2x2 Array{Float64,2}:
 1.73205 5.91608
 2.23607 3.0
julia> pairwise(Euclidean(), X)
2x2 Array{Float64,2}:
 0.0 3.74166
 3.74166 0.0
julia> pairwise(Mahalanobis(eye(3)), X, Y) # Effectively just the Euclidean metric
2x2 Array{Float64,2}:
 1.73205 5.91608
 2.23607 3.0
julia> pairwise(WeightedEuclidean([1.0, 2.0, 3.0]), X, Y)
2x2 Array{Float64,2}:
 2.44949 9.69536
 3.74166 4.24264
{{< /highlight >}}
  
As you might have observed from the last example above, it's also possible to calculate weighted versions of some of the metrics.

Finally a less contrived example. We'll look at the distances between observations in the [iris](https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/iris.html) data set. We first need to extract only the numeric component of each record and then transpose the resulting matrix so that observations become columns (rather than rows).
  
{{< highlight julia >}}
julia> using RDatasets
julia> iris = dataset("datasets", "iris");
julia> iris = convert(Array, iris[:,1:4]);
julia> iris = transpose(iris);
julia> dist_iris = pairwise(Euclidean(), iris);
julia> dist_iris[1:5,1:5]
5x5 Array{Float64,2}:
 0.0 0.538516 0.509902 0.648074 0.141421
 0.538516 0.0 0.3 0.331662 0.608276
 0.509902 0.3 0.0 0.244949 0.509902
 0.648074 0.331662 0.244949 0.0 0.648074
 0.141421 0.608276 0.509902 0.648074 0.0
{{< /highlight >}}
  
The full distance matrix is illustrated below as a heatmap using Plotly. Note how the clearly define blocks for each of the iris species setosa, versicolor, and virginica.

<div>
  <a href="https://plot.ly/~collierab/90/" target="_blank" title="Distance Matrix for Iris Data" style="display: block; text-align: center;"><img src="https://plot.ly/~collierab/90.png" alt="Distance Matrix for Iris Data" style="max-width: 100%;width: 800px;height: 600px;"  width="800" height="600" onerror="this.onerror=null;this.src='https://plot.ly/404.png';" /></a><br />
</div>

Tomorrow we'll be back to look at clustering in Julia.
