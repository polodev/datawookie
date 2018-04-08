---
author: Andrew B. Collier
date: 2015-09-07T05:29:04Z
tags: ["Julia"]
title: 'MonthOfJulia Day 8: Iteration, Conditionals and Exceptions'
---

<!--more-->

[Yesterday](http://wp.me/p3pzmk-wG) I had a look at Julia's support for Functional Programming. Naturally it also has structures for conventional program flow like conditionals, iteration and exception handling.

## Conditionals

Conditionals allow you to branch the course of execution on the basis of one or more logical outcomes.

{{< highlight julia >}}
julia> n = 8;
julia> if (n > 7) # The parentheses are optional.
           println("high")
       elseif n < 3
           println("low")
       else
           println("medium")
       end
high
{{< /highlight >}}

The [ternary conditional operator](https://en.wikipedia.org/wiki/Ternary_operation) provides a compact syntax for a conditional returning one of two possible values.
  
{{< highlight julia >}}
julia> if n > 3 0 else 1 end # Conditional.
0 
julia> n > 3 ? 0 : 1 # Ternary conditional.
0 
{{< /highlight >}}
  
I'm still a little gutted that R does not have a ternary operator. Kudos to Python for at least having [something similar](http://pythoncentral.io/one-line-if-statement-in-python-ternary-conditional-operator/), even if the syntax is somewhat convoluted.

## Iteration

There are a few different ways of achieving iteration in Julia. The simplest of these is the humble `for` loop.
  
{{< highlight julia >}}
julia> for n in [1:10]
           println("number $n.")
       end
number 1.
number 2.
number 3.
number 4.
number 5.
number 6.
number 7.
number 8.
number 9.
number 10.
{{< /highlight >}}

In the code above we used the range operator, `:`, to construct an iterable sequence of integers between 1 and 10. This might be a good place to take a moment to look at ranges, which might not work in quite the way you'd expect. To get the range to actually expand into an array you need to enclose it in `[]`, otherwise it remains a `Range` object.
  
{{< highlight julia >}}
julia> typeof(1:7)
UnitRange{Int64} (constructor with 1 method)
julia> typeof([1:7])
Array{Int64,1}
julia> 1:7
1:7
julia> [1:7]
7-element Array{Int64,1}:
 1
 2
 3
 4
 5
 6
 7
{{< /highlight >}}

A `for` loop can iterate over any iterable object, including strings and dictionaries. Using `enumerate()` in conjunction with a for loop gives a compact way to number items in a collection.

The `while` construct gives a slightly different approach to iteration and is probably most useful when combined with `continue` and `break` statements which can be used to skip over iterations or prematurely exit from the loop.

## Exceptions

The details of exception handling are well covered in the [documentation](http://docs.julialang.org/en/stable/manual/control-flow/#man-exception-handling), so I'll just provide a few examples. Functions generate exceptions when something goes wrong.
  
{{< highlight julia >}}
julia> factorial(-1)
ERROR: DomainError
 in factorial_lookup at combinatorics.jl:26
 in factorial at combinatorics.jl:35
julia> super(DomainError)
Exception
{{< /highlight >}}
  
All exceptions are derived from the `Exception` base class.

An exception is explicitly launched via `throw()`. To handle the exception in an elegant way you'll want to enclose that dodgy bit of code in a `try` block.
  
{{< highlight julia >}}
julia> !(n) = n < 0 ? throw(DomainError()) : n < 2 ? 1 : n * !(n-1)
! (generic function with 7 methods)
julia> !10
3628800
julia> !0
1
julia> !-1
ERROR: DomainError
 in ! at none:1
julia> try
           !-1
       catch
           println("Well, that did't work!")
       end
Well, that did't work!
{{< /highlight >}}

Exceptional conditions can be flagged by the `error()` function. Somewhat less aggressive are `warn()` and `info()`.

I've dug a little deeper into conditionals, loops and exceptions in the code on [github](https://github.com/DataWookie/MonthOfJulia).
