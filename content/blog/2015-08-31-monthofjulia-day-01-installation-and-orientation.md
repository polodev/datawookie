---
author: Andrew B. Collier
date: 2015-08-31T07:32:57Z
tags: ["Julia"]
title: 'MonthOfJulia Day 1: Installation and Orientation'
---

<!--more-->

As a long-term R user I've found that there are few tasks (analytical or otherwise) that R cannot immediately handle. Or be made to handle after a bit of hacking! However, I'm always interested in learning new tools. A month or so ago I attended a talk entitled _Julia's Approach to Open Source Machine Learning_ by [John Myles White](https://twitter.com/johnmyleswhite) at ICML in Lille, France. What John told us about Julia was impressive and intriguing. I felt compelled to take a closer look. Like most research tasks, my first stop was the [Wikipedia entry](https://en.wikipedia.org/wiki/Julia_(programming_language)), which was suitably informative.

And so I embarked on a Month of Julia. Over the next 30 days (give or take a few) I will be posting about my experiences as a new Julia user. I'll start with some of the language basics and then dig into a few of the supplementary packages. Today I'll start with installation and a quick tour of the interpreter.

## Background Reading

If you have the time and patience you'll find it instructive to read these:

* Bezanson, Edelman, Karpinski, and Shah, [Julia: A Fresh Approach to Numerical Computing](http://arxiv.org/abs/1411.1607), arXiv, 1411.1607, 2014. 
* Bezanson, Karpinski, Shah, and Edelman, [Julia: A Fast Dynamic Language for Technical Computing](http://arxiv.org/abs/1209.5145), arXiv, 1209.5145, 2012.

But, if you're like me, then you'll get half way through the first paper and have the overpowering urge to start tinkering. Don't delay. Tinker away.

You should undoubtedly read the papers in their entirety once the first wave of tinkering subsides.

## Installation

I'm running Ubuntu 15.04, so this will be rather specific. Installation was extremely simple (handled entirely by the package manager) and it looks like other platforms are similarly straightforward (check the [Downloads](http://julialang.org/downloads/) page). I will be using Julia version 0.3.10.

<img src="/img/2015/08/julia-install.png" >

I'm not quite sure why I was in the `Pictures` folder when I kicked off the install, but this is by no means a requirement!

The Julia interpreter is launched by typing `julia` at the command prompt. At launch it displays a nice logo which, incidentally, can be reproduced at any time for your amusement and pleasure using `Base.banner()`.

<img src="/img/2015/08/julia-default-terminal.png" >

The default colours in the interpreter are not going to work for me, so I tracked down the configuration file (`~/.juliarc.jl`) and made some changes. Ah, that's better.

**Update (2018/07/21):** The above approach will not work with contemporary Ubuntu. Here's what you should do instead:

1. Go to <https://julialang.org/downloads/> and download a generic Linux binary appropriate for your machine. In my case this was an archive named `julia-0.6.4-linux-x86_64.tar.gz`.
2. Extract the archive.

    {{< highlight bash >}}
$ cd /opt/
$ sudo tar -zxvf ~/Downloads/julia-0.6.4-linux-x86_64.tar.gz
{{< /highlight >}}

3. Link the resulting executable into the `PATH`. The path to the Julia executable will likely be different depending on the version.

    {{< highlight bash >}}
$ cd /usr/bin/
$ sudo ln -s /opt/julia-9d11f62bcb/bin/julia
{{< /highlight >}}

4. Start Julia.

    {{< highlight bash >}}
$ julia
{{< /highlight >}}

## Interacting with the Julia Interpreter

The Julia [REPL](https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop) is designed for interaction. I will pick out a few of the key features (you can find further details [here](http://docs.julialang.org/en/stable/manual/interacting-with-julia/)).

* By default the value of an expression is echoed back as the "answer". You can suppress this behaviour by ending the expression with a semicolon. 
* The value of the previous expression can be retrieved with the `ans` variable. 
* You activate the help system by typing `?` at the prompt or by using `help()`. 
* You can also search through the help documents using `apropos()`.

<img src="/img/2015/08/julia-help-system.png" >

* You can get immediate access to the system shell by typing `;` at the prompt.

![](/img/2015/08/julia-command-shell.jpg)

* You can search back through your command history using the "normal" <kbd>Ctrl</kbd>-<kbd>r</kbd> shell binding. 
* <kbd>Ctrl</kbd>-<kbd>l</kbd> will clear the contents of the console. 
* Use <kbd>Ctrl</kbd>-<kbd>d</kbd> to exit the interpreter. 
* Tab completion rocks: use it! (It works with Unicode too, by some sort of strange magic! Check out the table of [Tab completion sequences](http://docs.julialang.org/en/stable/manual/unicode-input/). Then try typing `x\^2` followed by Tab. When I first saw that this worked I almost wet my pants.)

If you're like me then you'll want to put your code into script files. Julia scripts normally have a ".jl" extension and are executed in the interpreter either by specifying the script name on the command line like this:

{{< highlight text >}}
$ julia test-script.jl
{{< /highlight >}}

or from within the interpreter using

{{< highlight text >}}
julia> include('test-script.jl')
{{< /highlight >}}

## Keeping Up to Date

To ensure that you have the most recent released version of Julia (not necessarily available through the default Ubuntu repositories), you can add specific PPAs.

{{< highlight text >}}
$ sudo add-apt-repository ppa:staticfloat/juliareleases
$ sudo add-apt-repository ppa:staticfloat/julia-deps
$ sudo apt-get update
{{< /highlight >}}

## Code Samples

I'll be posting code samples on [GitHub](https://github.com/DataWookie/MonthOfJulia).

More to come tomorrow. In the meantime though, do yourself a favour and watch the videos below.

<iframe width="560" height="315" src="https://www.youtube.com/embed/gQ1y5NUD_RI" frameborder="0" allowfullscreen></iframe>

<iframe width="560" height="315" src="https://www.youtube.com/embed/xUP3cSKb8sI" frameborder="0" allowfullscreen></iframe>

<iframe width="560" height="315" src="https://www.youtube.com/embed/vWkgEddb4-A" frameborder="0" allowfullscreen></iframe>

<iframe width="560" height="315" src="https://www.youtube.com/embed/I3JH5Bg46yU" frameborder="0" allowfullscreen></iframe>
