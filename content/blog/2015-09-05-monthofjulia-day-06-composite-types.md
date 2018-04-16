---
author: Andrew B. Collier
date: 2015-09-05T04:10:04Z
tags: ["Julia"]
title: 'MonthOfJulia Day 6: Composite Types'
---

<!--more-->

I've had a look at the basic [data types](http://www.exegetic.biz/blog/2015/09/monthofjulia-day-03-variables-and-data-types/) available in Julia as well as how these can be stashed in [collections](http://www.exegetic.biz/blog/2015/09/monthofjulia-day-05-collections/). What about customised-composite-DIY-build-your-own style types?

Composite types are declared with the `type` keyword. To illustrate we'll declare a type for storing geographic locations, with attributes for latitude, longitude and altitude. The type immediately has two methods: a default constructor and a constructor specialised for arguments with data types corresponding to those of the type's attributes. More information on constructors can be found in the [documentation](http://julia.readthedocs.org/en/latest/manual/constructors/).
  
{{< highlight julia >}}
julia> type GeographicLocation
        latitude::Float64
        longitude::Float64
        altitude::Float64
       end
julia> methods(GeographicLocation)
# 2 methods for generic function "GeographicLocation":
GeographicLocation(latitude::Float64,longitude::Float64,altitude::Float64)
GeographicLocation(latitude,longitude,altitude)
{{< /highlight >}}
  
Creating instances of this new type is simply a matter of calling the constructor. The second instance below clones the type of the first instance. I don't believe I've seen that being done with another language. (That's not to say that it's not possible elsewhere! I just haven't seen it.)
  
{{< highlight julia >}}
julia> g1 = GeographicLocation(-30, 30, 15)
GeographicLocation(-30.0,30.0,15.0)
julia> typeof(g1) # Interrogate type
GeographicLocation (constructor with 3 methods)
julia> g2 = typeof(g1)(5, 25, 165) # Create another object of the same type.
GeographicLocation(5.0,25.0,165.0)
{{< /highlight >}}
  
We can list, access and modify instance attributes.
  
{{< highlight julia >}}
julia> names(g1)
3-element Array{Symbol,1}:
 :latitude
 :longitude
 :altitude
julia> g1.latitude
-30.0
julia> g1.longitude
30.0
julia> g1.latitude = -25 # Attributes are mutable
-25.0
{{< /highlight >}}

Additional "outer" constructors can provide alternative ways to instantiate the type.
  
{{< highlight julia >}}
julia> GeographicLocation(lat::Real, lon::Real) = GeographicLocation(lat, lon, 0)
GeographicLocation (constructor with 3 methods)
julia> g3 = GeographicLocation(-30, 30)
GeographicLocation(-30.0,30.0,0.0)
{{< /highlight >}}

Of course, we can have collections of composite types. In fact, these composite types have essentially all of the rights and privileges of the built in types.
  
{{< highlight julia >}}
julia> locations = [g1, g2, g3]
3-element Array{GeographicLocation,1}:
 GeographicLocation(-25.0,30.0,15.0)
 GeographicLocation(5.0,25.0,165.0)
 GeographicLocation(-30.0,30.0,0.0)
{{< /highlight >}}

The `GeographicLocation` type declared above is a "concrete" type because it has attributes and can be instantiated. You cannot derive subtypes from a concrete type. You can, however, declare an abstract type which acts as a place holder in the type hierarchy. As opposed to concrete types, an abstract type cannot be instantiated but it can have subtypes.
  
{{< highlight julia >}}
julia> abstract Mammal
julia> type Cow <: Mammal
       end
julia> Mammal() # You can't instantiate an abstract type!
ERROR: type cannot be constructed
julia> Cow()
Cow()
{{< /highlight >}}

The `immutable` keyword will create a type where the attributes cannot be modified after instantiation.

Additional ramblings and examples of composite types can be found on [github](https://github.com/DataWookie/MonthOfJulia). Also I've just received an advance copy of [Julia in Action](https://www.manning.com/books/julia-in-action-cx1-cx) by Chris von Csefalvay which I'll be reviewing over the next week or so.

<img src="/img/2015/09/Learn_Julia_meap.jpg" >
