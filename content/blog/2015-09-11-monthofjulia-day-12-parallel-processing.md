---
author: Andrew B. Collier
date: 2015-09-11T13:00:43Z
tags: ["Julia"]
title: 'MonthOfJulia Day 12: Parallel Processing'
---

<!--more-->

<img src="/img/2015/09/Julia-Logo-Parallel.png" >

As opposed to many other languages, where parallel computing is bolted on as an afterthought, Julia was designed from the start with parallel computing in mind. It has a number of native features which lend themselves to efficient implementation of parallel algorithms. It also has packages which facilitate cluster computing (using [MPI](https://github.com/JuliaParallel/MPI.jl), for example). We won't be looking at those, but focusing instead on coroutines, generic parallel processing and parallel loops.

## Coroutines

[Coroutines](https://en.wikipedia.org/wiki/Coroutine) are not strictly parallel processing (in the sense of "many tasks running at the same time") but they provide a lightweight mechanism for having multiple tasks defined (if not active) at once. According to Donald Knuth, coroutines are generalised subroutines (with which we are probably all familiar).

<blockquote>
Under these conditions each module may be made into a _coroutine_; that is, it may be coded as an autonomous program which communicates with adjacent modules as if they were input or output subroutines. Thus, coroutines are subroutines all at the same level, each acting as if it were the master program when in fact there is no master program. There is no bound placed by this definition on the number of inputs and outputs a coroutine may have.
  
<cite>Conway, <a href="http://dl.acm.org/citation.cfm?doid=366663.366704">Design of a Separable Transition-Diagram Compiler</a>, 1963.</cite>
</blockquote> 

Coroutines are implemented using `produce()` and `consume()`. In a moment you'll see why those names are appropriate. To illustrate we'll define a function which generates elements from the [Lucas sequence](https://en.wikipedia.org/wiki/Lucas_number). For reference, the first few terms in the sequence are 2, 1, 3, 4, 7, ... If you know about Python's generators then you'll find the code below rather familiar.
  
{{< highlight julia >}}
julia> function lucas_producer(n)
           a, b = (2, 1)
           for i = 1:n
               produce(a)
               a, b = (b, a + b)
           end
        end
lucas_producer (generic function with 1 method)
{{< /highlight >}}
  
This function is then wrapped in a `Task`, which has state `:runnable`.
  
{{< highlight julia >}}
julia> lucas_task = Task(() -> lucas_producer(10))
Task (runnable) @0x0000000005b5ee60
julia> lucas_task.state
:runnable
{{< /highlight >}}
  
Now we're ready to start consuming data from the `Task`. Data elements can be retrieved individually or via a loop (in which case the `Task` acts like an iterable object and no `consume()` is required).
  
{{< highlight julia >}}
julia> consume(lucas_task)
2
julia> consume(lucas_task)
1
julia> consume(lucas_task)
3
julia> for n in lucas_task
           println(n)
       end
4
7
11
18
29
47
76
{{< /highlight >}}
  
Between invocations the `Task` is effectively asleep. The task temporarily springs to life every time data is requested, before becoming dormant once more.

It's possible to simultaneously set up an arbitrary number of coroutine tasks.

## Parallel Processing

Coroutines don't really feel like "parallel" processing because they are not working simultaneously. However it's rather straightforward to get Julia to metaphorically juggle many balls at once. The first thing that you'll need to do is launch the interpreter with multiple worker processes.
  
{{< highlight text >}}
$ julia -p 4
{{< /highlight >}}
  
There's always one more process than specified on the command line (we specified the number of worker processes; add one for the master process).
  
{{< highlight julia >}}
julia> nprocs()
5
julia> workers() # Identifiers for the worker processes.
4-element Array{Int64,1}:
 2
 3
 4
 5
{{< /highlight >}}
  
We can launch a job on one of the workers using `remotecall()`.
  
{{< highlight julia >}}
julia> W1 = workers()[1];
julia> P1 = remotecall(W1, x -> factorial(x), 20)
RemoteRef(2,1,6)
julia> fetch(P1)
2432902008176640000
{{< /highlight >}}
  
`@spawn` and `@spawnat` are macros which launch jobs on individual workers. The `@everywhere` macro executes code across all processes (including the master).
  
{{< highlight julia >}}
julia> @everywhere p = 5
julia> @everywhere println(@sprintf(&quot;ID %d: %f %d&quot;, myid(), rand(), p))
ID 1: 0.686332 5
        From worker 4: ID 4: 0.107924 5
        From worker 5: ID 5: 0.136019 5
        From worker 2: ID 2: 0.145561 5
        From worker 3: ID 3: 0.670885 5
{{< /highlight >}}

## Parallel Loop and Map

To illustrate how easy it is to set up parallel loops, let's first consider a simple serial implementation of a Monte Carlo technique to estimate π.
  
{{< highlight julia >}}
julia> function findpi(n)
           inside = 0
           for i = 1:n
               x, y = rand(2)
               if (x^2 + y^2 <= 1)
                   inside +=1
               end
           end
           4 * inside / n
       end
findpi (generic function with 1 method)
{{< /highlight >}}
  
The quality of the result as well as the execution time (and memory consumption!) depend directly on the number of samples.
  
{{< highlight julia >}}
julia> @time findpi(10000)
elapsed time: 0.051982841 seconds (1690648 bytes allocated, 81.54% gc time)
3.14
julia> @time findpi(100000000)
elapsed time: 9.533291187 seconds (8800000096 bytes allocated, 42.97% gc time)
3.1416662
julia> @time findpi(1000000000)
elapsed time: 95.436185105 seconds (88000002112 bytes allocated, 43.14% gc time)
3.141605352
{{< /highlight >}}
  
The parallel version is implemented using the `@parallel` macro, which takes a reduction operator (in this case `+`) as its first argument.
  
{{< highlight julia >}}
julia> function parallel_findpi(n)
           inside = @parallel (+) for i = 1:n
               x, y = rand(2)
               x^2 + y^2 <= 1 ? 1 : 0
           end
           4 * inside / n
       end
parallel_findpi (generic function with 1 method)
{{< /highlight >}}
  
There is some significant overhead associated with setting up the parallel jobs, so that the parallel version actually performs worse for a small number of samples. But when you run sufficient samples the speedup becomes readily apparent.
  
{{< highlight julia >}}
julia> @time parallel_findpi(10000)
elapsed time: 0.45212316 seconds (9731736 bytes allocated)
3.1724
julia> @time parallel_findpi(100000000)
elapsed time: 3.870065625 seconds (154696 bytes allocated)
3.14154744
julia> @time parallel_findpi(1000000000)
elapsed time: 39.029650365 seconds (151080 bytes allocated)
3.141653704
{{< /highlight >}}
  
For reference, these results were achieved with 4 worker processes on a DELL laptop with the following CPU:
  
{{< highlight text >}}
root@propane: #lshw | grep product | head -n 1
          product: Intel(R) Core(TM) i7-4600M CPU @ 2.90GHz
{{< /highlight >}}

More information on parallel computing facilities in Julia can be found in the [documentation](http://docs.julialang.org/en/stable/manual/parallel-computing/). As usual the code for today's Julia journey can be found on [github](https://github.com/DataWookie/MonthOfJulia).

<iframe width="560" height="315" src="https://www.youtube.com/embed/JoRn4ryMclc" frameborder="0" allowfullscreen></iframe>

<iframe width="560" height="315" src="https://www.youtube.com/embed/XJAQ24NS458" frameborder="0" allowfullscreen></iframe>
