---
author: Andrew B. Collier
date: 2015-09-21T16:00:12Z
tags: ["Julia"]
title: 'MonthOfJulia Day 18: Plotting'
---

<!--more-->

<img src="/img/2015/09/Julia-Logo-Plotting.png">

There's a variety of options for [plotting in Julia](https://en.wikibooks.org/wiki/Introducing_Julia/Plotting). We'll focus on those provided by [`Gadfly`](http://www.gadflyjl.org/) and [`Plotly`](http://github.com/plotly/Plotly.jl) and.

## Gadfly

Gadfly is the flavour of the month for plotting in Julia. It's based on the [Grammar of Graphics](http://www.springer.com/us/book/9780387245447), so users of [ggplot2](http://ggplot2.org/) should find it familiar.

[<img src="/img/2015/08/gadfly-logo.svg">](http://www.gadflyjl.org/)

To start using Gadfly we'll first need to load the package. To enable generation of PNG, PS, and PDF output we'll also want the [`Cairo`](http://github.com/JuliaLang/Cairo.jl) package.

{{< highlight julia >}}
julia> using Gadfly
julia> using Cairo
{{< /highlight >}}

You can easily generate plots from data vectors or functions.

{{< highlight julia >}}
julia> plot(x = 1:100, y = cumsum(rand(100) - 0.5), Geom.point, Geom.smooth)
julia> plot(x -> x^3 - 9x, -5, 5)
{{< /highlight >}}

Gadfly plots are by default rendered onto a new tab in your browser. These plots are mildly interactive: you can zoom and pan across the plot area. You can also save plots directly to files of various formats.

{{< highlight julia >}}
julia> dampedsin = plot([x -> sin(x) / x], 0, 50)
julia> draw(PNG("damped-sin.png", 800px, 400px), dampedsin)
{{< /highlight >}}

<img src="/img/2015/09/damped-sin.png">

Let's load up some data from the `nlschools` dataset in R's `MASS` package and look at the relationship between language score test and IQ for pupils broken down according to whether or not they are in a mixed-grade class.

{{< highlight julia >}}
julia> using RDatasets
julia> plot(dataset("MASS", "nlschools"), x="IQ", y="Lang", color="COMB",
            Geom.point, Geom.smooth(method=:lm), Guide.colorkey("Multi-Grade"))
{{< /highlight >}}

<img src="/img/2015/09/nlschools.png">

Those two examples just scratched the surface. Gadfly can produce histograms, boxplots, ribbon plots, contours and violin plots. There's detailed documentation with numerous examples on the [homepage](http://www.gadflyjl.org/).

Watch the video below (Daniel Jones at JuliaCon 2014) then read on about Plotly.

<iframe width="560" height="315" src="https://www.youtube.com/embed/Wsn5SZDkMeI" frameborder="0" allowfullscreen></iframe>

## Plotly

The [`Plotly`](https://plot.ly/julia/) package provides a complete interface to [plot.ly](https://plot.ly/), an online plotting service with interfaces for Python, R, MATLAB and now Julia. To get an idea of what's possible with plot.ly, check out their [feed](https://plot.ly/feed/). The first step towards making your own awesomeness with be loading the package.

{{< highlight julia >}}
using Plotly
{{< /highlight >}}

Next you should set up your plot.ly credentials using `Plotly.set_credentials_file()`. You only need to do this once because the values will be cached.

Data series are stored in Julia dictionaries.

{{< highlight julia >}}
julia> p1 = ["x" => 1:10, "y" => rand(0:20, 10), "type" => "scatter", "mode" => "markers"];
julia> p2 = ["x" => 1:10, "y" => rand(0:20, 10), "type" => "scatter", "mode" => "lines"];
julia> p3 = ["x" => 1:10, "y" => rand(0:20, 10), "type" => "scatter", "mode" => "lines+markers"];
{{< /highlight >}}

{{< highlight julia >}}
julia> Plotly.plot([p1, p2, p3], ["filename" => "basic-line", "fileopt" => "overwrite"])
Dict{String,Any} with 5 entries:
  "error"    => ""
  "message"  => ""
  "warning"  => ""
  "filename" => "basic-line"
  "url"      => "https://plot.ly/~collierab/17"
{{< /highlight >}}

You can either open the URL provided in the result dictionary or do it programatically:

{{< highlight julia >}}
julia> Plotly.openurl(ans["url"])
{{< /highlight >}}

<img src="/img/2015/09/plotly-scatter.png">

By making small jumps through similar hoops it's possible to create some rather intricate visualisations like the 3D scatter plot below. For details of how that was done, check out my code on [github](https://github.com/DataWookie/MonthOfJulia).

<img src="/img/2015/09/plotly-3d-scatter.png">

That was a static version of the plot. However, one of the major perks of Plotly is that the plots are interactive. Plus you can embed them in your site and it will, in turn, benefit from the interactivity. Feel free to interact vigorously with the plot below.

<iframe width="900" height="800" frameborder="0" scrolling="no" src="//plot.ly/~collierab/34.embed"></iframe>

## Google Charts

There's also a fledgling interface to [Google Charts](https://developers.google.com/chart/?hl=en).

Obviously plotting and visualisation in Julia are hot topics. Other plotting packages worth checking out are [`PyPlot`](https://github.com/stevengj/PyPlot.jl), [`Winston`](http://github.com/nolta/Winston.jl) and [`Gaston`](http://github.com/mbaz/Gaston.jl). Come back tomorrow when we'll take a look at using physical units in Julia.

<iframe width="560" height="315" src="https://www.youtube.com/embed/TpFcd-nklCs" frameborder="0" allowfullscreen></iframe>

<iframe width="560" height="315" src="https://www.youtube.com/embed/a8wFVOoZOpk" frameborder="0" allowfullscreen></iframe>

<iframe width="560" height="315" src="https://www.youtube.com/embed/hdCURYg05jE" frameborder="0" allowfullscreen></iframe>

<iframe width="560" height="315" src="https://www.youtube.com/embed/RVnYRk_6wvE" frameborder="0" allowfullscreen></iframe>
