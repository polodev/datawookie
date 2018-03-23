---
id: 2206
title: '#MonthOfJulia Day 23: Data Structures'
date: 2015-09-28T15:00:02+00:00
author: Andrew B. Collier
layout: post
guid: http://www.exegetic.biz/blog/?p=2206
excerpt_separator: <!-- more -->
categories:
  - Julia
tags:
  - '#julialang'
  - '#MonthOfJulia'
  - Data Structure
  - deque
  - Julia
  - queue
  - stack
---

<!-- more -->

<img src="{{ site.baseurl }}/static/img/2015/09/Julia-Logo-DataStructure.png" >

Although Julia has integrated support for various [data structures](https://en.wikipedia.org/wiki/Data_structure) (arrays, tuples, dictionaries, sets), it doesn't exhaust the full gamut of ptions. More exotic structures (like queues and deques, stacks, counters, heaps, [tries](https://en.wikipedia.org/wiki/Trie) and variations on sets and dictionaries) are implemented in the [DataStructures](https://github.com/JuliaLang/DataStructures.jl) package.

As always we start by loading the required package.
  
{% highlight julia %}
julia> using DataStructures
{% endhighlight %}

I won't attempt to illustrate all structures offered by the package (that would make for an absurdly dull post), but focus instead on queues and counters. The remaining types are self-explanatory and well illustrated in the package documentation.

## Queue

Let's start off with a queue. The data type being queued must be specified at instantiation. We'll make a queue which can hold items of `Any` type. Can't get more general than that.
  
{% highlight julia %}
julia> queue = Queue(Any);
{% endhighlight %}
  
The rules of a queue are such that new items are always added to the back. Adding items is done with `enqueue!()`.
  
{% highlight julia %}
julia> enqueue!(queue, "First in.");
julia> for n in [2:4]; enqueue!(queue, n); end
julia> enqueue!(queue, "Last in.")
Queue{Deque{Any}}(Deque [{"First in.",2,3,4,"Last in."}])
julia> length(queue)
5
{% endhighlight %}
  
The queue now holds five items. We can take a look at the items at the front and back of the queue using `front()` and `back()`. Note that indexing does not work on a queue (that would violate the principles of queuing!).
  
{% highlight julia %}
julia> front(queue)
First in."
julia> back(queue)
"Last in."
{% endhighlight %}
  
Finally we can remove items from the front of the queue using `dequeue!()`. The queue implements [FIFO](https://en.wikipedia.org/wiki/FIFO_(computing_and_electronics)) (which is completely different from the other form of [FIFO](https://en.wikipedia.org/wiki/Fit_in_or_fuck_off), which I only discovered today).
  
{% highlight julia %}
julia> dequeue!(queue)
"First in."
{% endhighlight %}

## Counter

The `counter()` function returns an `Accumulator` object, which is used to assemble item counts.
  
{% highlight julia %}
julia> cnt = counter(ASCIIString)
Accumulator{ASCIIString,Int64}(Dict{ASCIIString,Int64}())
{% endhighlight %}
  
Using a Noah's Ark example we'll count the instances of different types of domestic animals.
  
{% highlight julia %}
julia> push!(cnt, "dog") # Add 1 dog
1
julia> push!(cnt, "cat", 3) # Add 3 cats
3
julia> push!(cnt, "cat") # Add another cat (returns current count)
4
ulia> push!(cnt, "mouse", 5) # Add 5 mice
5
{% endhighlight %}
  
Let's see what the counter looks like now.
  
{% highlight julia %}
julia> cnt
Accumulator{ASCIIString,Int64}(["mouse"=>5,"cat"=>4,"dog"=>1])
{% endhighlight %}
  
We can return (and remove) the count for a particular item using `pop!()`.
  
{% highlight julia %}
julia> pop!(cnt, "cat")
4
julia> cnt["cat"] # How many cats do we have now? All gone.
0
{% endhighlight %}
  
And simply accessing the count for an item is done using `[]` indexing notation.
  
{% highlight julia %}
julia> cnt["mouse"] # But we still have a handful of mice.
5
{% endhighlight %}

I've just finished reading through the second early access version of [Julia in Action](https://www.manning.com/books/julia-in-action) by Chris von Csefalvay. In the chapter on Strings the author present a nice example in which he counts the times each character speaks in Shakespeare's Hamlet. I couldn't help but think that this would've been even more elegant using an `Accumulator`.

Tomorrow we'll take a look at an extremely useful data structure: a graph. Until then, feel free to check out the full code for today on [github](https://github.com/DataWookie/MonthOfJulia).

<center>
  <a href="http://www.explainxkcd.com/wiki/index.php/835:_Tree"><img src="http://imgs.xkcd.com/comics/tree.png" /></img></a>
</center>
