---
author: Andrew B. Collier
date: 2015-09-21T15:00:04Z
tags: ["Julia"]
title: 'PhysicalConstants.jl: Julia Package of Physical Constants'
---

PhysicalConstants is a Julia package which has the values of a range of physical constants. Currently MKS and CGS units are supported.

<!--more-->

## Installation

The package can be installed directly from its [github repository](https://github.com/DataWookie/PhysicalConstants.jl):

{{< highlight julia >}}
Pkg.clone("https://github.com/DataWookie/PhysicalConstants.jl")
{{< /highlight >}}

## Usage

Usage is pretty straightforward. Start off by loading the package.

{{< highlight julia >}}
julia> using PhysicalConstants
{{< /highlight >}}

Now, for example, access Earth's gravitational acceleration in MKS units.

{{< highlight julia >}}
julia> PhysicalConstants.MKS.GravAccel
9.80665
{{< /highlight >}}
  
Or in CGS units.

{{< highlight julia >}}
julia> PhysicalConstants.CGS.GravAccel
980.665
{{< /highlight >}}
  
Or, finally, in Imperial units.

{{< highlight julia >}}
julia> PhysicalConstants.Imperial.GravAccel
32.174049
{{< /highlight >}}
