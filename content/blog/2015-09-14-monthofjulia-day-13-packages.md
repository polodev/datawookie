---
author: Andrew B. Collier
date: 2015-09-14T13:00:17Z
tags: ["Julia"]
title: 'MonthOfJulia Day 13: Packages'
---

<!--more-->

<img src="/img/2015/08/Julia-Logo-Packages.png" >

A lot of Julia's functionality is implemented as add on packages (or "modules"). An extensive (though possibly not exhaustive) list of available packages can be found at <http://pkg.julialang.org/>. If you browse through that list I can guarantee that you will find a number of packages that pique your curiosity. How to install them? Read on.

Package management is handled via `Pkg`. `Pkg.dir()` will tell you where the installed packages are stored on your file system. Before installing any new packages, always call `Pkg.update()` to update your local metadata and repository (it will update any installed packages to the their most recent version).

<img src="/img/2015/08/julia-package-management.png" >

## Adding a Package

Installing a new package is done with `Pkg.add()`. Any dependencies are handled automatically during the install process.
  
{{< highlight julia >}}
julia> Pkg.add("VennEuler")
INFO: Cloning cache of VennEuler from git://github.com/HarlanH/VennEuler.jl.git
INFO: Installing VennEuler v0.0.1
INFO: Building NLopt
INFO: Building Cairo
INFO: Package database updated
{{< /highlight >}}

`Pkg.available()` generates a complete list of all available packages while `Pkg.installed()` or `Pkg.status()` can be used to find the versions of installed packages.
  
{{< highlight julia >}}
julia> Pkg.installed()["VennEuler"]
v"0.0.1"
julia> Pkg.installed("VennEuler")
v"0.0.1"
{{< /highlight >}}

`Pkg.pin()` will fix a package at a specific version (no updates will be applied). `Pkg.free()` releases the effects of `Pkg.pin()`.

## Package Contents

The `using` directive loads the functions exported by a package into the global namespace. You can get a view of the capabilities of a package by typing its name followed by a period and then hitting the Tab key. Alternatively, `names()` will give a list of symbols exported by a package.
  
{{< highlight julia >}}
julia> using VennEuler
julia> names(VennEuler)
9-element Array{Symbol,1}:
 :optimize
 :render
 :optimize_iteratively
 :VennEuler
 :EulerObject
 :EulerState
 :make_euler_object
 :EulerSpec
 :random_state
{{< /highlight >}}

The package manager provides a host of other functionality which you can read about [here](http://julia.readthedocs.org/en/latest/manual/packages/). Check out the videos below to find out more about Julia's package ecosystem. From tomorrow I'll start looking at specific packages. To get yourself prepared for that, why not go ahead and install the following packages: [Cpp](http://github.com/timholy/Cpp.jl), [PyCall](http://github.com/stevengj/PyCall.jl), [DataArrays](http://github.com/JuliaStats/DataArrays.jl), [DataFrames](http://github.com/JuliaStats/DataFrames.jl) and [RCall](http://github.com/JuliaStats/RCall.jl).
