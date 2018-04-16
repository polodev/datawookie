---
author: Andrew B. Collier
date: 2015-09-15T13:00:23Z
tags: ["Julia"]
title: 'MonthOfJulia Day 14: Data'
---

<!--more-->

<img src="/img/2015/09/Julia-Logo-DataFrame.png" >

## DataFrames

The `DataFrame` type in Julia is not dissimilar to the analogous types in R and Python/[pandas](http://pandas.pydata.org/). It provides a way of grouping data which is convenient for analysis and reminiscent of a database table.

I'm assuming that you've already installed the [DataFrames](http://juliadata.github.io/DataFrames.jl/latest/) package. If not, take a look at [yesterday's post](http://www.exegetic.biz/blog/2015/09/monthofjulia-day-13-packages/). The first step is then to load it up:

{{< highlight julia >}}
julia> using DataFrames
{{< /highlight >}}

Next we can start assembling our data. A `DataFrame` can be built up one field at a time (as is done in the example below) or by passing all of the data at once to the constructor.

{{< highlight julia >}}
julia> people = DataFrame();
julia> people[:name] = ["Andrew", "Claire", "Bob", "Alice"];
julia> people[:gender] = [0, 1, 0, 1];
julia> people[:age] = [43, 35, 27, 32];
julia> people
4x3 DataFrame
| Row | name     | gender | age |
|-----|----------|--------|-----|
| 1   | "Andrew" | 0      | 43  |
| 2   | "Claire" | 1      | 35  |
| 3   | "Bob"    | 0      | 27  |
| 4   | "Alice"  | 1      | 32  |
{{< /highlight >}}

`names()` and `eltypes()` provide a high level overview of the data, giving the names and data types respectively for each column.

{{< highlight julia >}}
julia> names(people)
3-element Array{Symbol,1}:
 :name
 :gender
 :age
julia> eltypes(people)
3-element Array{Type{T<:Top},1}:
 ASCIIString
 Int64
 Int64
{{< /highlight >}}

You can dig deeper with `describe()`, which gives a simple statistical summary of each column. It does essentially the same thing as `summary()` in R.

Indexing operations allow you to access the data in various ways. There's also `head()` and `tail()`, which return the first and last few records in the data.

{{< highlight julia >}}
julia> people[:age]
4-element DataArray{Int64,1}:
 43
 35
 27
 32
julia> people[2]
4-element DataArray{Int64,1}:
 1
 1
julia> people[:,2]
4-element DataArray{Int64,1}:
 1
 1
julia> people[1,:]
1x3 DataFrame
| Row | name     | gender | age |
|-----|----------|--------|-----|
| 1   | "Andrew" | 0      | 43  |
{{< /highlight >}}

You can apply a range of operations to columns. Note, however, that there is a subtle difference in syntax: while `==` is the normal equality operator, `.==` is the element-wise equality operator which must be applied to columns in order to make element-by-element comparisons. A similar syntax pertains to other operators like `.<=` and `.>`.

{{< highlight julia >}}
julia> people[:gender] = ifelse(people[:gender] .== 1, 'F', 'M');
julia> people
4x3 DataFrame
| Row | name     | gender | age |
|-----|----------|--------|-----|
| 1   | "Andrew" | 'M'    | 43  |
| 2   | "Claire" | 'F'    | 35  |
| 3   | "Bob"    | 'M'    | 27  |
| 4   | "Alice"  | 'F'    | 32  |
julia> people[:gender] .== 'M'
4-element DataArray{Bool,1}:
 true
 false
 true
 false
julia> people[:age] .<= 40
4-element DataArray{Bool,1}:
 false
 true
 true
 true
{{< /highlight >}}

Of course you're not likely to construct any serious collection of data manually. It's more likely to come from a database or file. There are various ways to accomplish this. The simplest is reading from a delimited file.

{{< highlight julia >}}
julia> passwd = readtable("/etc/passwd", separator = ':', header = false);
julia> names!(passwd, [symbol(i) for i in ["username", "passwd", "UID", "GID",
                                           "comment", "home", "shell"]]);
julia> passwd[1:5,:]
5x7 DataFrame
| Row | username | passwd | UID | GID   | comment  | home        | shell               |
|-----|----------|--------|-----|-------|----------|-------------|---------------------|
| 1   | "root"   | "x"    | 0   | 0     | "root"   | "/root"     | "/bin/bash"         |
| 2   | "daemon" | "x"    | 1   | 1     | "daemon" | "/usr/sbin" | "/usr/sbin/nologin" |
| 3   | "bin"    | "x"    | 2   | 2     | "bin"    | "/bin"      | "/usr/sbin/nologin" |
| 4   | "sys"    | "x"    | 3   | 3     | "sys"    | "/dev"      | "/usr/sbin/nologin" |
| 5   | "sync"   | "x"    | 4   | 65534 | "sync"   | "/bin"      | "/bin/sync"         |
{{< /highlight >}}

Note how `names!()` was used to alter the column names. There are other ways of loading data from a delimited text file that will handle column names more elegantly. We'll get to those in a few days time.

Watch the video below and then read further to find out about the `DataArrays` package.

<iframe width="560" height="315" src="https://www.youtube.com/embed/XRClA5YLiIc" frameborder="0" allowfullscreen></iframe>

## DataArrays

Data are seldom perfect and missing values are not uncommon. Now, you might use some a particular numerical value (like -9999, for example) to indicate a missing datum. However, this is a bit of a kludge, difficult to maintain and open to ambiguity. The [`DataArrays`](https://github.com/JuliaStats/DataArrays.jl) package introduces the singleton NA type which can be used to unambiguously indicate missing data.

A vector with missing data is created using the `@data` macro.

{{< highlight julia >}}
julia> using DataArrays
julia> x = @data([1, 2, 3, 4, NA, 6])
6-element DataArray{Int64,1}:
 1
 2
 3
 4
 NA
 6
{{< /highlight >}}

Functions `anyna()` and `allna()` can be used to test whether any or all of the elements of a vector are missing.

Two ways of dealing with NAs are to either drop them or replace them with another value.

{{< highlight julia >}}
julia> dropna(x)
5-element Array{Int64,1}:
 1
 2
 3
 4
 6
julia> convert(Array, x, -1)
6-element Array{Int64,1}:
 1
 2
 3
 4
 -1
 6
{{< /highlight >}}

Data frames have support for NAs already baked in.

{{< highlight julia >}}
julia> people[:age][2] = NA;
julia> people
4x3 DataFrame
| Row | name     | gender | age |
|-----|----------|--------|-----|
| 1   | "Andrew" | 'M'    | 43  |
| 2   | "Claire" | 'F'    | NA  |
| 3   | "Bob"    | 'M'    | 27  |
| 4   | "Alice"  | 'F'    | 32  |
julia> mean(people[:age])
NA
julia> mean(dropna(people[:age]))
34.0
{{< /highlight >}}

Note how `dropna()` was used to calculate the mean of the non-missing data.

<iframe width="560" height="315" src="https://www.youtube.com/embed/elBmK-6s6bo" frameborder="0" allowfullscreen></iframe>

## Metaprogramming with a DataFrame

The [`DataFramesMeta`](https://github.com/JuliaStats/DataFramesMeta.jl) package provides a handful of macros for applying metaprogramming techniques to data frames. For example:

{{< highlight julia >}}
julia> using DataFramesMeta
julia> @with(passwd, maximum(:UID))
65534
julia> @select(people, :gender)
4x1 DataFrame
| Row | gender |
|-----|--------|
| 1   | 'M'    |
| 2   | 'F'    |
| 3   | 'M'    |
| 4   | 'F'    |
{{< /highlight >}}

Further examples can be found on the [github](https://github.com/DataWookie/MonthOfJulia) page for MonthOfJulia.

<iframe width="560" height="315" src="https://www.youtube.com/embed/QLWhsZ3yzBk" frameborder="0" allowfullscreen></iframe>
