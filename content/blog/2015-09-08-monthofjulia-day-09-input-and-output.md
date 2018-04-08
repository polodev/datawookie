---
author: Andrew B. Collier
date: 2015-09-08T05:30:12Z
tags: ["Julia"]
title: 'MonthOfJulia Day 9: Input/Output'
---

<!--more-->

Your code won't be terribly interesting without ways of getting data in and out. Ways to do that with Julia will be the subject of today's post.

<img src="/img/2015/09/Julia-Logo-IO.png" >

## Console IO

Direct output to the Julia terminal is done via `print()` and `println()`, where the latter appends a newline to the output.
  
{{< highlight julia >}}
julia> print(3, " blind "); print("mice!\n")
3 blind mice!
julia> println("Hello World!")
Hello World!
{{< /highlight >}}
  
Terminal input is something that I never do, but it's certainly possible. `readline()` will read keyboard input until the first newline.
  
{{< highlight julia >}}
julia> response = readline();
Yo!
julia> response
"Yo!\n"
{{< /highlight >}}

## Reading and Writing with a Stream

Writing to a file is pretty standard. Below we create a suitable name for a temporary file, open a stream to that file, write some text to the stream and then close it.
  
{{< highlight julia >}}
filename = tempname()
fid = open(filename, "w")
write(fid, "Some temporary text...")
close(fid)
{{< /highlight >}}
  
`print()` and `println()` can also be used in the same way as `write()` for sending data to a stream. `STDIN`, `STDOUT` and `STDERR` are three predefined constants for standard console streams.

There are various approaches to reading data from files. One of which would be to use code similar to the example above. Another would be to do something like this (I've truncated the output because it really is not too interesting after a few lines):
  
{{< highlight julia >}}
julia> open("/etc/passwd") do fid
           readlines(fid)
       end
46-element Array{Union(UTF8String,ASCIIString),1}:
 "root:x:0:0:root:/root:/bin/bash\n"
 "daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin\n"
 "bin:x:2:2:bin:/bin:/usr/sbin/nologin\n"
 "sys:x:3:3:sys:/dev:/usr/sbin/nologin\n"
 "sync:x:4:65534:sync:/bin:/bin/sync\n"
{{< /highlight >}}
  
Here `readlines()` returns the entire contents of the file as an array, where each element corresponds to a line of content. `readall()` would return everything in a single string. A somewhat different approach would be to use `eachline()` which creates an iterator allowing you to process each line of the file individually.

## Delimited Files

Data can be read from a delimited file using `readdlm()`, where the delimiter is specified explicitly. For a simple Comma Separated Value (CSV) file it's more direct to simply use `readcsv()`.
  
{{< highlight julia >}}
julia> passwd = readdlm("/etc/passwd", ':');
julia> passwd[1,:]
1x7 Array{Any,2}:
 "root" "x" 0.0 0.0 "root" "/root" "/bin/bash"
{{< /highlight >}}
  
The analogues `writedlm()` and `writcecsv()` are used for writing delimited data.

These functions will be essential if you are going to use Julia for data analyses. There is also functionality for reading and writing data in a variety of other formats like [xls and xlsx](https://github.com/davidanthoff/ExcelReaders.jl), [HDF5](https://github.com/timholy/HDF5.jl) (see embedded media below from JuliaCon2015), [Matlab](https://github.com/simonster/MAT.jl) and [Numpy](https://github.com/fhs/NPZ.jl) data files and [WAV audio files](https://github.com/dancasimiro/WAV.jl).

<iframe width="560" height="315" src="https://www.youtube.com/embed/B9JKSWdpOn8" frameborder="0" allowfullscreen></iframe>

## File Manipulation

Julia implements a full range of file manipulation methods (documented [here](http://julia.readthedocs.org/en/latest/stdlib/file/)), most of which have names similar to their UNIX counterparts.

A few other details of my dalliance with Julia's input/output functionality can be found on [github](https://github.com/DataWookie/MonthOfJulia).
