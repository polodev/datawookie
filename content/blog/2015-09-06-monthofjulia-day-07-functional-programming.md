---
author: Andrew B. Collier
date: 2015-09-06T02:06:29Z
tags: ["Julia"]
title: 'MonthOfJulia Day 7: Functional Programming'
---

<!--more-->

<blockquote>
In computer science, functional programming is a programming paradigm that treats computation as the evaluation of mathematical functions and avoids changing-state and mutable data. It is a declarative programming paradigm, which means programming is done with expressions. In functional code, the output value of a function depends only on the arguments that are input to the function, so calling a function f twice with the same value for an argument x will produce the same result f(x) each time. Eliminating side effects, i.e. changes in state that do not depend on the function inputs, can make it much easier to understand and predict the behavior of a program, which is one of the key motivations for the development of functional programming.
<cite><a href="https://en.wikipedia.org/wiki/Functional_programming">Wikipedia: Functional Programming</a></cite>
</blockquote>

Functional Programming is characterised by higher order functions which accept other functions as arguments. Typically a Functional Programming language has facilities for anonymous "lambda" functions and ways to apply map, reduce and filter operations. Julia ticks these boxes.

We've seen anonymous functions before, but here's a quick reminder of the syntax:
  
{{< highlight julia >}}
julia> x -> x^2
(anonymous function)
{{< /highlight >}}

Let's start with `map()` which takes a function as its first argument followed by one or more collections. The function is then [mapped](https://en.wikipedia.org/wiki/Map_(higher-order_function)) onto each element of the collections. The first example below applies an anonymous function which squares its argument.
  
{{< highlight julia >}}
julia> map(x -> x^2, [1:5])
5-element Array{Int64,1}:
  1
  4
  9
 16
 25
julia> map(/, [16, 9, 4], [8, 3, 2])
3-element Array{Float64,1}:
 2.0
 3.0
 2.0
{{< /highlight >}}
  
The analogues for this operation in Python and R are `map()` and `mapply()` or `Map()` respectively.

`filter()`, as its name would suggest, [filters](https://en.wikipedia.org/wiki/Filter_(higher-order_function)) out elements from a collection for which a specific function evaluates to true. In the example below the function `isprime()` is applied to integers between 1 and 50 and only the prime numbers in that range are returned.
  
{{< highlight julia >}}
julia> filter(isprime, [1:50])
15-element Array{Int64,1}:
  2
  3
  5
  7
 11
 13
 17
 19
 23
 29
 31
 37
 41
 43
 47
{{< /highlight >}}
  
The equivalent operation in Python and R is carried out using `filter()` and `Filter()` respectively.

The [fold](https://en.wikipedia.org/wiki/Fold_(higher-order_function)) operation is implemented by `reduce()` which builds up its result by applying a bivariate function across a collection of objects and using the result of the previous operation as one of the arguments. Hmmmm. That's a rather convoluted definition. Hopefully the link and examples below will illustrate. The related functions, `foldl()` and `foldr()`, are explicit about the order in which their arguments are associated.
  
{{< highlight julia >}}
julia> reduce(/, 1:4)
0.041666666666666664
julia> ((1 / 2) / 3) / 4
0.041666666666666664
{{< /highlight >}}
  
The fold operation is applied with `reduce()` and `Reduce()` in Python and R respectively.

Finally there's a shortcut to achieve both [map and reduce](https://en.wikipedia.org/wiki/MapReduce) together.
  
{{< highlight julia >}}
julia> mapreduce(x -> x^2, +, [1:5])
55
julia> (((1^2 + 2^2) + 3^2) + 4^2) + 5^2
55
{{< /highlight >}}

A few extra bits and pieces about Functional Programming with Julia can be found on [github](https://github.com/DataWookie/MonthOfJulia).
