---
author: Andrew B. Collier
date: 2015-09-02T02:44:27Z
tags: ["Julia"]
title: 'MonthOfJulia Day 3: Variables and Data Types'
---

<!--more-->

Most coding involves the assignment and manipulation of variables. Julia is dynamically typed, which means that you don't need to declare explicitly a variable's data type. It also means that a single variable name can be associated with different data types at various times. Julia has a sophisticated, yet extremely flexible, system for dealing with data types. covered in great detail by the [official documentation](http://julia.readthedocs.org/en/latest/manual/types/). My notes below simply highlight some salient points I uncovered while digging around.

One of the major drawbacks of dynamically typed languages is that they generally sacrifice performance for convenience. This does not apply with Julia, as explained in the quote below.

<blockquote>
The landscape of computing has changed dramatically over the years. Modern scientific computing environments such as MATLAB, R, Mathematica, Octave, Python (with NumPy), and SciLab have grown in popularity and fall under the general category known as dynamic languages or dynamically typed languages. In these programming languages, programmers write simple, high-level code without any mention of types like int, float or double that pervade statically typed languages such as C and Fortran.

Julia is dynamically typed, but it is different as it approaches statically typed performance. New users can begin working with Julia as they did in the traditional numerical computing languages, and work their way up when ready. In Julia, types are implied by the computation itself together with input values. As a result, Julia programs are often completely generic and compute with data of different input types without modification—a feature known as “polymorphism.”

<cite><a href="http://arxiv.org/abs/1411.1607">Julia: A Fresh Approach to Numerical Computing</a></cite>
</blockquote>

## Variables and Assignment

Variable assignment and evaluation work in precisely the way you'd expect.

{{< highlight julia >}}
julia> x = 3
3
julia> x^2
9
{{< /highlight >}}

Julia supports Unicode, so ß, Ɛ and Ȁ are perfectly legitimate (although possibly not too sensible) variable names.

{{< highlight julia >}}
julia> ß = 3; 2ß
6
{{< /highlight >}}

Chained and simultaneous assignments are possible.

{{< highlight julia >}}
julia> a = b = c = 5
5
julia> d, e = 3, 5
(3,5)
{{< /highlight >}}

Multiple expressions can be combined into a single compound expression. Julia supports both verbose and compact syntax.

{{< highlight julia >}}
julia> x = begin
         p = 2
         q = 3
         p + q
       end
5
julia> x = (p = 2; q = 3; p + q)
5
{{< /highlight >}}

Constants, declared as `const`, are immutable variables (forgive the horrendous contradiction, but I trust that you know what I mean!).

{{< highlight julia >}}
julia> const SPEED_OF_LIGHT = 299792458;
{{< /highlight >}}

Somewhat disconcertingly it is possible to change the value of a constant. You just can't change its type. This restriction has more to do with performance than anything else.

There are numerous predefined constants too.

{{< highlight julia >}}
julia> pi
π = 3.1415926535897...
julia> e
e = 2.7182818284590...
julia> VERSION
v"0.3.10"
{{< /highlight >}}

## Data Types

<blockquote>
The practical implications of picking number types are pretty important. Efficient programming requires you to use the least amount of memory.
<cite><a href="https://www.manning.com/books/julia-in-action-cx1-cx">Julia in Action</a> by Chris von Csefalvay</cite> 
</blockquote>

Julia has an extensive [type hierachy](http://sidekick.windforwings.com/2013/03/print-julia-type-tree-with-juliatypesjl.html) with its root at the universal `Any` type. You can query the current data type for a variable using `typeof()`. As mentioned above, this is dynamic and a variable can readily be reassigned a value with a different type.

{{< highlight julia >}}
julia> x = 3.5;
julia> typeof(x)
Float64
julia> x = "I am a string";
julia> typeof(x)
ASCIIString (constructor with 2 methods)
{{< /highlight >}}

There are various other functions for probing the type hierarchy. For example, you can use `isa()` to check whether a variable or constant is of a particular type.

{{< highlight julia >}}
julia> isa(x, ASCIIString)
true
julia> isa(8, Int64)
true
julia> isa(8, Number)
true
julia> isa(8, ASCIIString)
false
{{< /highlight >}}

So we see that 8 is both a `In64` and a `Number`. Not only does that make mathematical sense, it also suggests that there is a relationship between the `In64` and `Number` data types. In fact `Int64` is a subtype of `Signed`, which derives from `Integer`, which is a subtype of `Real`, which derives from `Number`...

{{< highlight julia >}}
julia> super(Int64)
Signed
julia> super(Signed)
Integer
julia> super(Integer)
Real
julia> super(Real)
Number
{{< /highlight >}}

Formally this can be written as

{{< highlight julia >}} 
julia> Int64 <: Signed <: Integer <: Real <: Number
true
{{< /highlight >}}

where `<:` is the "derived from" operator. We can explore the hierarchy in the opposite direction too, where `subtypes()` descends one level in the type hierarchy.

{{< highlight julia >}}
julia> subtypes(Integer)
5-element Array{Any,1}:
 BigInt
 Bool
 Char
 Signed
 Unsigned
{{< /highlight >}}

### Numeric Types

Julia supports integers between Int8 and Int128, with Int32 or Int64 being the default depending on the hardware and operating system. A "U" prefix indicates unsigned variants, like UInt64. Arbitrary precision integers are supported via the BigInt type.

Floating point numbers are stored by Float16, Float32 and Float64 types. Arbitrary precision floats are supported via the BigFloat type. Single and double precision floating point constants are given with specific syntax.

{{< highlight julia >}}
julia> typeof(1.23f-1)
Float32
julia> typeof(1.23e-1)
Float64
{{< /highlight >}}

In Julia complex and rational numbers are parametric types, for example `Complex{Float32}` and `Rational{Int64}`. More information on complex and rational numbers in Julia can be found in the [documentation](http://julia.readthedocs.org/en/latest/manual/complex-and-rational-numbers/).

{{< highlight julia >}}
julia> (3+4im)^2
-7 + 24im
julia> typeof(3+4im)
Complex{Int64} (constructor with 1 method)
julia> typeof(3.0+4im)
Complex{Float64} (constructor with 1 method)
julia> typeof(3//4)
Rational{Int64} (constructor with 1 method)
{{< /highlight >}}

An encyclopaedic selection of [mathematical operations](http://docs.julialang.org/en/stable/manual/mathematical-operations/) is supported on numeric types.

{{< highlight julia >}}
julia> 1 + 2
3
julia> 1 / 2
0.5
julia> div(5, 3), 5 % 3
(1,2)
julia> sqrt(2)
1.4142135623730951
{{< /highlight >}}

### Characters and Strings

Julia distinguishes between strings and characters. Strings are enclosed in double quotes, while individual characters are designated by single quotes. Strings are immutable and can be either ASCII (type `ASCIIString`) or unicode (type `UTF8String`). The indexing operator `[]` is used to extract slices from within strings. Evaluating variables within a string is done with a syntax which will be familiar to most shell warriors.

{{< highlight julia >}}
julia> name = "Julia"
"Julia"
julia> name[4]
'i'
julia> name[end]
'a'
julia> length(name)
5
julia> "My name is $name and I'm $(2015-2012) years old."
"My name is Julia and I'm 3 years old."
{{< /highlight >}}

There is a lot of functionality attached to the String class. To get an idea of the range, have a look at the output from `methodswith(String)`.

Julia supports Perl [regular expressions](http://www.regular-expressions.info/reference.html). Regular expression objects are of type `Regex` and defined by a string preceded by the character 'r' and possibly followed by a modifier character ('i', 's', 'm' or 'x').

{{< highlight julia >}}
julia> username_regex = r"^[a-z0-9_-]{3,16}$"
r"^[a-z0-9_-]{3,16}$"
julia> ismatch(username_regex, "my-us3r_n4m3")
true
julia> ismatch(username_regex, "th1s1s-wayt00_l0ngt0beausername")
false
julia> hex_regex = r"#?([a-f0-9]{6}|[a-f0-9]{3})"i;
julia> m = match(hex_regex, "I like the color #c900b5.")
RegexMatch("#c900b5", 1="c900b5")
julia> m.match
"#c900b5"
julia> m.offset
18
{{< /highlight >}}

[<img src="/img/2015/09/consecutive_vowels.png">](http://imgs.xkcd.com/comics/consecutive_vowels.png)

Explicit type conversion works either by using `convert()` or the lower-case type name as a function.

{{< highlight julia >}}
julia> convert(Float64, 3)
3.0
julia> float64(3)
3.0
julia> int64(2.5)
3
julia> string(2.5)
"2.5"
{{< /highlight >}}

## Type Specifications

Although Julia is dynamically typed, it's still possible (and often desireable) to stipulate the type for a particular variable. Furthermore, from a performance perspective it's beneficial that a variable retains a particular type once it has been assigned. This is known as [type stability](http://www.johnmyleswhite.com/notebook/2013/12/06/writing-type-stable-code-in-julia/). We'll find out more about these issues when we look at defining functions in Julia.

As before, my detailed notes on today's foray into Julia can be found on [github](https://github.com/DataWookie/MonthOfJulia).
