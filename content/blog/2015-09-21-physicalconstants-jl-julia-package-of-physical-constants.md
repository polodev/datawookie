---
id: 2318
title: 'PhysicalConstants.jl: Julia Package of Physical Constants'
date: 2015-09-21T15:00:04+00:00
author: Andrew B. Collier
layout: post
excerpt_separator: <!-- more -->
categories:
  - Julia
tags:
  - '#julialang'
  - Julia
---
PhysicalConstants is a Julia package which has the values of a range of physical constants. Currently MKS and CGS units are supported.

<!-- more -->

## Installation

The package can be installed directly from its [github repository](https://github.com/DataWookie/PhysicalConstants.jl):

{% highlight julia %}
Pkg.clone("https://github.com/DataWookie/PhysicalConstants.jl")
{% endhighlight %}

## Usage

Usage is pretty straightforward. Start off by loading the package.

{% highlight julia %}
julia> using PhysicalConstants
{% endhighlight %}

Now, for example, access Earth's gravitational acceleration in MKS units.

{% highlight julia %}
julia> PhysicalConstants.MKS.GravAccel
9.80665
{% endhighlight %}
  
Or in CGS units.

{% highlight julia %}
julia> PhysicalConstants.CGS.GravAccel
980.665
{% endhighlight %}
  
Or, finally, in Imperial units.

{% highlight julia %}
julia> PhysicalConstants.Imperial.GravAccel
32.174049
{% endhighlight %}
