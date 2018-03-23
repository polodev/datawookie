---
id: 1895
title: '#MonthOfJulia Day 33: Evolutionary Algorithms'
date: 2015-10-12T15:00:20+00:00
author: Andrew B. Collier
layout: post
excerpt_separator: <!-- more -->
categories:
- Julia
tags:
- '#julialang'
- '#MonthOfJulia'
- Evolutionary Computing
- Genetic Algorithm
- Julia
---

<!-- more -->

<img src="{{ site.baseurl }}/static/img/2015/09/Julia-Logo-Evolutionary.png">

There are two packages implementing evolutionary computation in Julia: [GeneticAlgorithms](https://github.com/forio/GeneticAlgorithms.jl) and [Evolutionary](https://github.com/wildart/Evolutionary.jl). Today we'll focus on the latter. The Evolutionary package already has an extensive range of functionality and is under active development. The documentation is a little sparse but the author is very quick to respond to any questions or issues you might raise.

<blockquote>
I used a GA to optimize seating assignments at my wedding reception. 80 guests over 10 tables. Evaluation function was based on keeping people with their dates, putting people with something in common together, and keeping people with extreme opposite views at separate tables. I ran it several times. Each time, I got nine good tables, and one with all the odd balls. In the end, my wife did the seating assignments.
<cite>Adrian McCarthy on <a href="http://stackoverflow.com/">stackoverflow</a></cite> 
</blockquote>

Let's get the package loaded up and then we'll be ready to begin.

{% highlight julia %}
julia> using Evolutionary
{% endhighlight %}

We'll be using a genetic algorithm to solve the [knapsack problem](https://en.wikipedia.org/wiki/Knapsack_problem). We first need to set up an objective function, which in turn requires data giving the utility and mass of each item we might consider putting in our knapsack. Suppose we have nine potential items with the following characteristics:

{% highlight julia %}
julia> utility = [10, 20, 15, 2, 30, 10, 30, 45, 50];
julia> mass = [1, 5, 10, 1, 7, 5, 1, 2, 10];
{% endhighlight %}

To get an idea of their relative worth we can look at the utility per unit mass.

{% highlight julia %}
julia> utility ./ mass
9-element Array{Float64,1}:
 10.0
  4.0
  1.5
  2.0
  4.28571
  2.0
 30.0
 22.5
  5.0
{% endhighlight %}

Evidently item 7 has the highest utility/mass ratio, followed by item 8. So these two items are quite likely to be included in an optimal solution.

The objective function is simply the total utility for a set of selected items. We impose a penalty on the total mass of the knapsack by setting the total utility to zero if our knapsack becomes too heavy (the maximum permissible mass is set to 20).

{% highlight julia %}
julia> function summass(n::Vector{Bool})
          sum(mass .* n)
        end
summass (generic function with 1 method)
julia> function objective(n::Vector{Bool})
          (summass(n) <= 20) ? sum(utility .* n) : 0
        end
objective (generic function with 1 method)
{% endhighlight %}

We'll give those a whirl just to check that they make sense. Suppose our knapsack holds items 3 and 9.

{% highlight julia %}
julia> summass([false, false, true, false, false, false, false, false, true])
20
julia> objective([false, false, true, false, false, false, false, false, true])
65
{% endhighlight %}

Looks about right. Note that we want to _maximise_ the objective function (total utility) subject to the mass constraints of the knapsack.

We're ready to run the genetic algorithm. Note that `ga()` takes as it's first argument a function which it will _minimise_. We therefore give it the reciprocal of the objective function.

{% highlight julia %}
julia> best, invbestfit, generations, tolerance, history = ga(
           x -> 1 / objective(x),                 # Function to MINIMISE
           9, # Length of chromosome
           initPopulation = collect(randbool(9)),
           selection = roulette,                  # Options: sus
           mutation = inversion,                  # Options: insertion, swap2, scramble, shifting
           crossover = singlepoint,               # Options: twopoint, uniform
           mutationRate = 0.2,
           crossoverRate = 0.5,
           ɛ = 0.1, # Elitism
           debug = false,
           verbose = false,
           iterations = 200,
           populationSize = 50,
           interim = true);
julia> best
9-element Array{Bool,1}:
  true
  true
  false
  true
  false
  false
  true
  true
  true
{% endhighlight %}

The optimal solution consists of items 1, 2, 4, 7, 8 and 9. Note that items 7 and 8 (with the highest utility per unit mass) are included. We can check up on the mass constraint and total utility for the optimal solution.

{% highlight julia %}
julia> summass(best)
20
julia> objective(best)
157
julia> 1 / invbestfit
157.0
{% endhighlight %}

Examining the debug output from `ga()` is rather illuminating (set the `debug` and `verbose` parameters to `true`). You'll want to limit the population size and number of iterations when you do this though, otherwise the information deluge can get a little out of hand. The output shows how each member of the population is initialised with the same set of values. The last field on each line is the corresponding value of the objective function.

{% highlight julia %}
INIT 1: Bool[true,true,false,true,false,true,true,false,false] : 71.99999999999885
INIT 2: Bool[true,true,false,true,false,true,true,false,false] : 71.99999999999885
INIT 3: Bool[true,true,false,true,false,true,true,false,false] : 71.99999999999885
INIT 4: Bool[true,true,false,true,false,true,true,false,false] : 71.99999999999885
INIT 5: Bool[true,true,false,true,false,true,true,false,false] : 71.99999999999885
{% endhighlight %}

Each subsequent iteration dumps output like this:

{% highlight julia %}
BEST: [1,2,4,3,5]
MATE 2+4>: Bool[true,true,false,true,true,true,true,false,false] : Bool[true,true,false,true,false,false,true,true,true]
MATE >2+4: Bool[true,true,false,true,true,true,true,true,true] : Bool[true,true,false,true,false,false,true,false,false]
MATE 5+1>: Bool[true,true,false,true,false,false,true,true,true] : Bool[true,true,false,true,false,false,true,true,true]
MATE >5+1: Bool[true,true,false,true,false,false,true,true,true] : Bool[true,true,false,true,false,false,true,true,true]
MUTATED 2>: Bool[true,true,false,true,false,false,true,false,false]
MUTATED >2: Bool[true,false,true,false,false,true,false,true,false]
MUTATED 4>: Bool[true,true,false,true,false,false,true,true,true]
MUTATED >4: Bool[true,true,false,false,true,false,true,true,true]
MUTATED 5>: Bool[true,true,false,true,false,false,true,true,true]
MUTATED >5: Bool[true,true,false,true,true,true,true,false,false]
ELITE 1=>4: Bool[true,true,false,true,false,false,true,true,true] => Bool[true,true,false,false,true,false,true,true,true]
FIT 1: 0.0
FIT 2: 79.99999999999858
FIT 3: 101.9999999999977
FIT 4: 156.99999999999451
FIT 5: 101.9999999999977
BEST: 0.006369426751592357: Bool[true,true,false,true,false,false,true,true,true], G: 8
BEST: [4,3,5,2,1]
{% endhighlight %}

We start with a list of the members from the preceding iteration in order of descending fitness (so member 1 has the highest fitness to start with). MATE records detail crossover interactions between pairs of members. These are followed by MUTATED records which specify which members undergo random mutation. ELITE records show which members are promoted unchanged to the following generation (these will always be selected from the fittest of the previous generation). Next we have the FIT records which give the fitness of each of the members of the new population (after crossover, mutation and elitism have been applied). Here we can see that the new member 1 has violated the total mass constraint and thus has a fitness of zero. Two BEST records follow. The first gives details of the single best member from the new generation. Somewhat disconcertingly the first number in this record is the reciprocal of fitness. The second BEST record again rates the members of the new generation in terms of descending fitness.

Using the history of interim results generated by `ga()` I could produce the Plotly visualisation below which shows the average and maximum fitness as a function of generation. It's clear to see how the algorithm rapidly converges on an optimal solution. Incidentally, I asked the package author to modify the code to return these interim results and he complied with a working solution within hours.

<iframe width="900" height="800" frameborder="0" scrolling="no" src="//plot.ly/~collierab/110.embed"></iframe>

In addition to genetic algorithms, the Evolutionary package also implements two other evolutionary algorithms which I will not pretend to understand. Not even for a moment. However, you might want to check out `es()` and `cmaes()` to see how well they work on your problem. For me, that's an adventure for another day.

Other related projects you should peruse:

* [Wallace](https://github.com/ChrisTimperley/Wallace.jl) (and its [homepage](http://www.christimperley.co.uk/Wallace.jl/)).

This series is drawing to a close. Still a few more things I want to write about (although I have already violated the "Month" constraint). I'll be back later in the week.

<a href="http://www.explainxkcd.com/wiki/index.php/399:_Travelling_Salesman_Problem"><img src="http://imgs.xkcd.com/comics/travelling_salesman_problem.png" /></img></a>