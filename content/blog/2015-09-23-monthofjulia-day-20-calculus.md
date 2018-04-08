---
author: Andrew B. Collier
date: 2015-09-23T14:00:57Z
tags: ["Julia"]
title: 'MonthOfJulia Day 20: Calculus'
---

<!--more-->

<img src="/img/2015/09/Julia-Logo-Calculus.png">

[Mathematica](http://www.wolfram.com/mathematica/) is the de facto standard for symbolic differentiation and integration. But many other languages also have great facilities for Calculus. For example, R has the `deriv()` function in the base `stats` package as well as the [numDeriv](https://cran.r-project.org/web/packages/numDeriv/), [Deriv](https://cran.r-project.org/web/packages/Deriv/) and [Ryacas](https://cran.r-project.org/web/packages/Ryacas/) packages. Python has [NumPy](http://www.numpy.org/) and [SymPy](http://www.sympy.org/en/index.html).

Let's check out what Julia has to offer.

## Numerical Differentiation

First load the [Calculus](https://github.com/johnmyleswhite/Calculus.jl) package.

{{< highlight julia >}}
julia> using Calculus
{{< /highlight >}}

The derivative() function will evaluate the numerical derivative at a specific point.

{{< highlight julia >}}
julia> derivative(x -> sin(x), pi)
-0.9999999999441258
julia> derivative(sin, pi, :central)			# Options: :forward, :central or :complex
-0.9999999999441258
{{< /highlight >}}

There's also a prime notation which will do the same thing (but neatly handle higher order derivatives).

{{< highlight julia >}}
julia> f(x) = sin(x);
julia> f'(0.0) # cos(x)
0.9999999999938886
julia> f''(0.0) # -sin(x)
0.0
julia> f'''(0.0) # -cos(x)
-0.9999977482682358
{{< /highlight >}}

There are functions for second derivatives, gradients (for multivariate functions) and Hessian matrices too. Related packages for derivatives are [ForwardDiff](https://github.com/JuliaDiff/ForwardDiff.jl) and [ReverseDiffSource](https://github.com/JuliaDiff/ReverseDiffSource.jl).

## Symbolic Differentiation

Symbolic differentiation works for univariate and multivariate functions expressed as strings.

{{< highlight julia >}}
julia> differentiate("sin(x)", :x)
:(cos(x))
julia> differentiate("sin(x) + exp(-y)", [:x, :y])
2-element Array{Any,1}:
 :(cos(x))
 :(-(exp(-y)))
{{< /highlight >}}

It also works for expressions.

{{< highlight julia >}}
julia> differentiate(:(x^2 \* y \* exp(-x)), :x)
:((2x) \* y \* exp(-x) + x^2 \* y \* -(exp(-x)))
julia> differentiate(:(sin(x) / x), :x)
:((cos(x) * x - sin(x)) / x^2)
{{< /highlight >}}

Have a look at the [JuliaDiff](http://www.juliadiff.org/) project which is aggregating resources for differentiation in Julia.

## Numerical Integration

Numerical integration is a snap.

{{< highlight julia >}}
julia> integrate(x -> 1 / (1 - x), -1 , 0)
0.6931471805602638
{{< /highlight >}}

Compare that with the analytical result. Nice.

{{< highlight julia >}}
julia> diff(map(x -> - log(1 - x), [-1, 0]))
1-element Array{Float64,1}:
 0.693147
{{< /highlight >}}

By default the integral is evaluated using [Simpson's Rule](https://en.wikipedia.org/wiki/Simpson%27s_rule). However, we can also use [Monte Carlo integration](https://en.wikipedia.org/wiki/Monte_Carlo_integration).

{{< highlight julia >}}
julia> integrate(x -> 1 / (1 - x), -1 , 0, :monte_carlo)
0.6930203819567551
{{< /highlight >}}

<img src="/img/2015/09/Sympy-logo.png">

## Symbolic Integration

There is also an interface to the [Sympy](http://www.sympy.org/en/index.html) Python library for symbolic computation. Documentation can be found [here](http://mth229.github.io/symbolic.html). You might want to restart your Julia session before loading the SymPy package.

{{< highlight julia >}}
julia> using Sympy
{{< /highlight >}}

Revisiting the same definite integral from above we find that we now have an analytical expression as the result.

{{< highlight julia >}}
julia> integrate(1 / (1 - x), (x, -1, 0))
log(2)
julia> convert(Float64, ans)
0.6931471805599453
{{< /highlight >}}

To perform symbolic integration we need to first define a symbolic object using `Sym()`.

{{< highlight julia >}}
julia> x = Sym("x");              # Creating a "symbolic object"
julia> typeof(x)
Sym (constructor with 6 methods)
julia> sin(x) |> typeof           # f(symbolic object) is also a symbolic object
Sym (constructor with 6 methods)
{{< /highlight >}}

There's more to be said about symbolic objects (they are the basis of pretty much everything in SymPy), but we are just going to jump ahead to constructing a function and integrating it.

{{< highlight julia >}}
julia> f(x) = cos(x) - sin(x) * cos(x);
julia> integrate(f(x), x)
     2
  sin (x)
- ─────── + sin(x)
     2
{{< /highlight >}}

What about an integral with constant parameters? No problem.

{{< highlight julia >}}
julia> k = Sym("k");
julia> integrate(1 / (x + k), x)
log(k + x)
{{< /highlight >}}

We have really only grazed the surface of SymPy. The capabilities of this package are deep and broad. Seriously worthwhile checking out the documentation if you are interested in symbolic computation.

[<img src="/img/2015/09/newton_and_leibniz.png">](https://xkcd.com/626/)

I'm not ready to throw away my dated version of Mathematica just yet, but I'll definitely be using this functionality often. Come back tomorrow when I'll take a look at solving differential equations with Julia.
