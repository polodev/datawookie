---
author: Andrew B. Collier
date: 2015-09-24T16:00:13Z
tags: ["Julia"]
title: 'MonthOfJulia Day 21: Differential Equations'
---

<!--more-->

<img src="/img/2015/09/Julia-Logo-Pendulum.png" >

[Yesterday](http://wp.me/p3pzmk-yh) we had a look at Julia's support for Calculus. The next logical step is to solve some [differential equations](https://en.wikipedia.org/wiki/Differential_equation). We'll look at two packages today: Sundials and ODE.

## Sundials

The [`Sundials`](https://github.com/julialang/sundials.jl) package is based on a [library](https://computation.llnl.gov/casc/sundials/main.html) which implements a number of solvers for differential equations. First off you'll need to install that library. In Ubuntu this is straightforward using the package manager. Alternatively you can [download](http://computation.llnl.gov/casc/sundials/download/download.php) the source distribution.

{{< highlight text >}}
$ sudo apt-get install libsundials-serial-dev
{{< /highlight >}}

Next install the Julia package and load it.

{{< highlight julia >}}
julia> Pkg.add("Sundials")
julia> using Sundials
{{< /highlight >}}

To demonstrate we'll look at a standard "textbook" problem: a damped harmonic oscillator (mass on a spring with friction). This is a second order differential equation with general form

$$
\ddot{x} + a \dot{x} + b x = 0
$$

where \\(x\\) is the displacement of the oscillator, while \\(a\\) and \\(b\\) characterise the damping coefficient and spring stiffness respectively. To solve this numerically we need to convert it into a system of first order equations:

$$
\begin{aligned}
\dot{x} &= v \\ \dot{v} &= - a v - b x  
\end{aligned}
$$

We'll write a function for those relationships and assign specific values to \\(a\\) and \\(b\\).

{{< highlight julia >}}
julia> function oscillator(t, y, ydot)
           ydot[1] = y[2]
           ydot[2] = - 3 * y[1] - y[2] / 10
       end
oscillator (generic function with 2 methods)
{{< /highlight >}}

Next the initial conditions and time steps for the solution.

{{< highlight julia >}}
julia> initial = [1.0, 0.0];                        # Initial conditions
julia> t = float([0:0.125:30]);                     # Time steps
{{< /highlight >}}

And finally use `cvode()` to integrate the system.

{{< highlight julia >}}
julia> xv = Sundials.cvode(oscillator, initial, t);
julia> xv[1:5,:]
5x2 Array{Float64,2}:
 1.0 0.0
 0.97676 -0.369762
 0.908531 -0.717827
 0.799076 -1.02841
 0.65381 -1.28741
{{< /highlight >}}

The results for the first few time steps look reasonable: the displacement (left column) is decreasing and the velocity (right column) is becoming progressively more negative. To be sure that the solution has the correct form, have a look at the [Gadfly](http://wp.me/p3pzmk-tE) plot below. The displacement (black) and velocity (blue) curves are 90° out of phase, as expected, and both gradually decay with time due to damping. Looks about right to me!

<img src="/img/2015/09/damped-harmonic-oscillator.png" >

## ODE

The [`ODE`](https://github.com/JuliaLang/ODE.jl) package provides a selection of solvers, all of which are implemented with a consistent interface (which differs a bit from Sundials).

{{< highlight julia >}}
julia> using ODE
{{< /highlight >}}

Again we need to define a function to characterise our differential equations. The form of the function is a little different with the ODE package: rather than passing the derivative vector by reference, it's simply returned as the result. I've consider the same problem as above, but to spice things up I added a sinusoidal driving force.

{{< highlight julia >}}
julia> function oscillator(t, y)
           [y[2]; - a * y[1] - y[2] / 10 + sin(t)]
       end
oscillator (generic function with 2 methods)
{{< /highlight >}}

We'll solve this with `ode23()`, which is a second order adaptive solver with third order error control. Because it's adaptive we don't need to explicitly specify all of the time steps, just the minimum and maximum.

{{< highlight julia >}}
julia> a = 1; # Resonant
julia> T, xv = ode23(oscillator, initial, [0.; 40]);
julia> xv = hcat(xv...).'; # Vector{Vector{Float}} -> Matrix{Float}
{{< /highlight >}}

The results are plotted below. Driving the oscillator at the resonant frequency causes the amplitude of oscillation to grow with time as energy is transferred to the oscillating mass.

<img src="/img/2015/09/resonant-harmonic-oscillator.png" >

If we move the oscillator away from resonance the behavior becomes rather interesting.

{{< highlight julia >}}
julia> a = 3; # Far from resonance
{{< /highlight >}}

Now, because the oscillation and the driving force aren't synchronised (and there's a non-rational relationship between their frequencies) the displacement and velocity appear to change irregularly with time.

<img src="/img/2015/09/non-resonant-harmonic-oscillator.png" >

How about a [double pendulum](https://en.wikipedia.org/wiki/Double_pendulum) (a pendulum with a second pendulum suspended from its end)? This seemingly simple system exhibits a rich range of dynamics. It's behaviour is sensitive to initial conditions, one of the characteristics of chaotic systems.

[<img src="/img/2015/09/Double-Pendulum.svg" width="294" height="398" >](https://en.wikipedia.org/wiki/Double_pendulum#/media/File:Double-Pendulum.svg)

First we set up the first order equations of motion. The details of this system are explained in the video below.

{{< highlight julia >}}
julia> function pendulum(t, y)
           Y = [
           6 * (2 * y[3] - 3 * cos(y[1] - y[2]) * y[4]) / (16 - 9 * cos(y[1] - y[2])^2);
           6 * (8 * y[4] - 3 * cos(y[1] - y[2]) * y[3]) / (16 - 9 * cos(y[1] - y[2])^2)
           ]
           [
           Y[1];
           Y[2];
           - (Y[1] * Y[2] * sin(y[1] - y[2]) + 3 * sin(y[1])) / 2;
           - (sin(y[2]) - Y[1] * Y[2] * sin(y[1] - y[2])) / 2;
           ]
       end
pendulum (generic function with 1 method)
{{< /highlight >}}

Define initial conditions and let it run...

{{< highlight julia >}}
julia> initial = [pi / 4, 0, 0, 0]; # Initial conditions -> deterministic behaviour
T, xv = ode23(pendulum, initial, [0.; 40]);
{{< /highlight >}}

<iframe width="560" height="315" src="https://www.youtube.com/embed/fZKrUgm9R1o" frameborder="0" allowfullscreen></iframe>

Below are two plots which show the results. The first is a time series showing the angular displacement of the first (black) and second (blue) mass. Next is a phase space plot which shows a different view of the same variables. It's clear to see that there is a regular systematic relationship between them.

<img src="/img/2015/09/pendulum-time-deterministic.png" >

<img src="/img/2015/09/pendulum-phase-deterministic.png" >

Next we'll look at a different set of initial conditions. This time both masses are initially located above the primary vertex of the pendulum. This represents an initial configuration with much more potential energy.

{{< highlight julia >}}
julia> initial = [3/4 * pi, pi, 0, 0]; # Initial conditions -> chaotic behaviour
{{< /highlight >}}

The same pair of plots now illustrate much more interesting behaviour. Note the larger range of angles, θ<sub>2</sub>, achieved by the second bob. With these initial conditions the pendulum is sufficiently energetic for it to "flip over". Look at the video below to get an idea of what this looks like with a real pendulum.

<img src="/img/2015/09/pendulum-time-chaotic.png" >

<img src="/img/2015/09/pendulum-phase-chaotic.png" >

<iframe width="560" height="315" src="https://www.youtube.com/embed/AwT0k09w-jw" frameborder="0" allowfullscreen></iframe>

It's been a while since I've played with any Physics problems. That was fun. The full code for today is available at [github](https://github.com/DataWookie/MonthOfJulia). Come back tomorrow when I'll take a look at Optimisation in Julia.
