---
author: Andrew B. Collier
date: 2015-09-04T08:23:56Z
tags: ["Julia"]
title: 'MonthOfJulia Day 5: Collections'
---

<!--more-->

Julia caters for various collection types including tuples and arrays, dictionaries, sets, dequeues, priority queues and heaps. There's a lot of functionality distributed across these different structures, so we'll only skim the surface and pick out a few interesting bits and pieces.

An `Array` is really the most important workhorse collection (IMHO). Julia can handle arrays of arbitrary dimension, but we'll only have a look at the most commonly used, which are 1D and 2D.
  
{{< highlight julia >}}
julia> x = [-7, 1, 2, 3, 5]
5-element Array{Int64,1}:
 -7
  1
  2
  3
  5
julia> typeof(x)
Array{Int64,1}
julia> eltype(x)
Int64
julia> y = [3, "foo", 'a'] # Elements can be of mixed type
3-element Array{Any,1}:
   3
    "foo"
 'a'
julia> typeof(y) # Type of the Array itself
Array{Any,1}
julia> eltype(y) # Type of the elements in the Array
Any
{{< /highlight >}}
  
Type promotion is applied to an array with mixed content (like the second example above, which contains an integer, a string and a character), elevating the element type to a common ancestor, which in the example is `Any`.

The usual indexing operations apply, noting that in Julia indices are 1-based.
  
{{< highlight julia >}}
julia> x[1] # First element
-7
julia> getindex(x, [1, 3]) # Alternative syntax
2-element Array{Int64,1}:
 -7
  2
julia> x[end] # Last element
5
julia> x[end-1] # Penultimate element
3
julia> x[2:4] # Slicing
3-element Array{Int64,1}:
 1
 2
 3
julia> x[2:4] = [1, 5, 9] # Slicing with assignment
3-element Array{Int64,1}:
 1
 5
 9
{{< /highlight >}}

An `Array` can be treated like a stack or queue, where additional items can be popped from or pushed onto the "end" of the collection. Functions `shift!()` and `unshift!()` do analogous operations to the "front" of the collection.
  
{{< highlight julia >}}
julia> pop!(x) # Returns last element and remove it from array.
5
julia> push!(x, 12) # Append value to end of array.
5-element Array{Int64,1}:
 -7
  1
  5
  9
 12
julia> append!(x, 1:3) # Append one array to the end of another array.
8-element Array{Int64,1}:
 -7
  1
  5
  9
 12
  1
  2
  3
{{< /highlight >}}

What about a 2D array (or matrix)? Not too many surprises here. With reference to the examples above we can see that a 1D array is effectively a column vector.

{{< highlight julia >}}
3x3 Array{Int64,2}:
 1 2 3
 4 5 6
 7 8 9
julia> N = [1 2; 2 3; 3 4]
3x2 Array{Int64,2}:
 1 2
 2 3
 3 4
julia> M[2,2] # [row,column]
5
julia> M[1:end,1]
3-element Array{Int64,1}:
 1
 4
 7
julia> M[1,:] # : is the same as 1:end
1x3 Array{Int64,2}:
 1 2 3
{{< /highlight >}}

Collections are copied by reference. A shallow copy can be created with `copy()`. If you want a truly distinct collection of objects you need to use `deepcopy()`.

And now a taste of the other collection types, starting with the tuple.
  
{{< highlight julia >}}
julia> a, b, x, text = 1, 2, 3.5, "Hello"
(1,2,3.5,"Hello")
julia> a, b = b, a # I never get tired of this!
(1,2)
{{< /highlight >}}
  
A dictionary is just a collection of key-value pairs.
  
{{< highlight julia >}}
julia> stuff = {"number" => 43, 1 => "zap!", 2.5 => 'x'}
Dict{Any,Any} with 3 entries:
  "number" => 43
  2.5      => 'x'
  1        => "zap!"
julia> stuff["number"]
43
{{< /highlight >}}
  
Sets are unordered collections which are not indexed and do not allow duplicates.
  
{{< highlight julia >}}
julia> S1 = Set([1, 2, 3, 4, 5]) # Set{Int64}
Set{Int64}({4,2,3,5,1})
julia> S2 = Set({3, 4, 5, 6, 7}) # Set{Any}
Set{Any}({7,4,3,5,6})
julia> union(S1, S2)
Set{Any}({7,4,2,3,5,6,1})
julia> intersect(S1, S2)
Set{Int64}({4,3,5})
julia> setdiff(S2, S1)
Set{Any}({7,6})
{{< /highlight >}}

We'll see more about collections when we look at Julia's functional programming capabilities, which will be in the next but one installment. In the meantime you can find the full code for today's flirtation with Julia on [github](https://github.com/DataWookie/MonthOfJulia).
