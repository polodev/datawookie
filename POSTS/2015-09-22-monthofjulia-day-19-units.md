---
author: Andrew B. Collier
categories:
- Julia
date: 2015-09-22T16:00:07Z
excerpt_separator: <!-- more -->
guid: http://www.exegetic.biz/blog/?p=2203
id: 2203
tags:
- '#julialang'
- '#MonthOfJulia'
- Julia
- SI
- Units
title: '#MonthOfJulia Day 19: Units'
url: /2015/09/22/monthofjulia-day-19-units/
---

<!--more-->

<img src="/img/2015/09/Julia-Logo-SIUnits.png" >

The packages we'll be looking at today should bring joy to the hearts of all Physical Scientists. Actually they should make any flavour of Scientist happy.

<blockquote>
It is natural for man to relate the units of distance by which he travels to the dimensions of the globe that he inhabits. Thus, in moving about the earth, he may know by the simple denomination of distance its proportion to the whole circuit of the earth. This has the further advantage of making nautical and celestial measurements correspond. The navigator often needs to determine, one from the other, the distance he has traversed from the celestial arc lying between the zeniths at his point of departure and at his destination. It is important, therefore, that one of these magnitudes should be the expression of the other, with no difference except in the units. But to that end, the fundamental linear unit must be an aliquot part of the terrestrial meridian. ... Thus, the choice of the metre was reduced to that of the unity of angles.
<cite>Pierre-Simon Laplace</cite> 
</blockquote>

## SIUnits

The `SIUnits`[](https://github.com/Keno/SIUnits.jl) package provides unit-checked operations for quantities expressed in [SI units](https://en.wikipedia.org/wiki/International_System_of_Units).

{{< highlight julia >}}
julia> using SIUnits
julia> using SIUnits.ShortUnits
{{< /highlight >}}

It supports both long and short forms of units and all the expected arithmetic operations.

{{< highlight julia >}}
julia> 1KiloGram + 2kg
3 kg
julia> 4Meter - 2m
2 m
julia> 4m / 2s
2.0 m s⁻¹
{{< /highlight >}}

Note that it only recognises the American spelling of "meter" and not the (IMHO correct) "metre"! But this is a small matter. And I don't want to engage in any religious wars.

Speaking of small matters, it's possible to define new units of measure. Below we'll define the [micron](https://en.wikipedia.org/wiki/Micrometre) and [Angstrom](https://en.wikipedia.org/wiki/Angstrom) along with their conversion functions.

{{< highlight julia >}}
julia> import Base.convert
julia> Micron = SIUnits.NonSIUnit{typeof(Meter),:µm}()
µm
julia> convert(::Type{SIUnits.SIQuantity},::typeof(Micron)) = Micro*Meter
convert (generic function with 461 methods)
julia> Angstrom = SIUnits.NonSIUnit{typeof(Meter),:Å}()
Å
julia> convert(::Type{SIUnits.SIQuantity},::typeof(Angstrom)) = Nano/10*Meter
convert (generic function with 462 methods)
{{< /highlight >}}

And now we can freely use these new units in computations.

{{< highlight julia >}}
julia> 5Micron
5 µm
julia> 1Micron + 1m
1000001//1000000 m
julia> 5200Angstrom # Green light
5200 Å
{{< /highlight >}}

Read on below to find out about the `Physical` package.

[![](http://imgs.xkcd.com/comics/converting_to_metric.png)](http://www.explainxkcd.com/wiki/index.php/526:_Converting_to_Metric)

## Physical

The `Physical` package is documented [here](https://github.com/ggggggggg/Physical.jl). Apparently it's not as performant as `SIUnits` but it does appear to have a wider scope of functionality. We'll use it to address an issue raised on [Day 17](http://www.exegetic.biz/blog/2015/09/monthofjulia-day-17-datasets-from-r/): converting between Imperial and Metric units.

Let's kick off by loading the package.

{{< highlight julia >}}
using Physical
{{< /highlight >}}

There's a lot of functionality available, but we are going to focus on just one thing: converting pounds and inches into kilograms and metres. First we define a pair of derived units. To do this, of course, we need to know the appropriate conversion factors!

{{< highlight julia >}}
julia> Inch = DerivedUnit("in", 0.0254*Meter)
1 in 
julia> Pound = DerivedUnit("lb", 0.45359237*Kilogram)
1 lb 
{{< /highlight >}}

We can then freely change the average heights and weights that we saw earlier from Imperial to Metric units.

{{< highlight julia >}}
julia> asbase(66Inch)
1.6764 m 
julia> asbase(139Pound)
63.04933943 kg 
{{< /highlight >}}

On a related note I've just put together a package of [physical constants](https://github.com/DataWookie/PhysicalConstants.jl) for Julia.

{{< highlight julia >}}
julia> using PhysicalConstants
julia> PhysicalConstants.MKS.SpeedOfLight
2.99792458e8
julia> PhysicalConstants.MKS.Teaspoon
4.92892159375e-6
{{< /highlight >}}

Did you know that a teaspoon was 4.92892 millilitres? There I was, wallowing in my ignorance, thinking that it was 5 millilitres. Pfffft. Silly me. There are

<img src="/img/2015/09/teaspoon-volume.png" >

Units can be a contentious issue. Watch the video below to see what Richard Feynman had to say about the profusion of units used by Physicists to measure energy. Also check out the full code for today along with the index to the entire series of [#MonthOfJulia](https://twitter.com/search?q=%23MonthOfJulia&src=typd) posts on [github](https://github.com/DataWookie/MonthOfJulia).

<blockquote>
For those who want some proof that physicists are human, the proof is in the idiocy of all the different units which they use for measuring energy.
<cite>Richard P. Feynman</cite>
</blockquote>

<iframe width="560" height="315" src="https://www.youtube.com/embed/roX2NXDUTsM" frameborder="0" allowfullscreen></iframe>