---
author: Andrew B. Collier
date: 2015-09-01T05:28:44Z
tags: ["Julia"]
title: 'MonthOfJulia Day 2: Development Environments'
---

<!--more-->

The Julia REPL has a vast range of features. It's a pleasure to use and I'm perfectly happy to run Julia from the command line and edit code in gedit or vim. That's the way I operated with R before I discovered the beauty of RStudio. Let's have a look at the similar options for Julia.

## Juno

[Juno](http://junolab.org/) is the current IDE of choice for Julia. [Installation](https://github.com/JunoLab/uber-juno/blob/master/setup.md) is pretty straightforward. If you've worked in any other IDE then finding your way around Juno will be simple. If you run into any snags you can find support in the [user community](http://junolab.org/community/).

When you start Juno for the first time it opens a tutorial file called, not surprisingly, Tutorial.jl. It would be worth your while to take the few minutes required to work your way through this. The image below shows some of the tutorial content.

<img src="/img/2015/08/julia-juno-session-1.jpg" >

Useful features:

* <kbd>Ctrl</kbd>-<kbd>Space</kbd> brings up a command bar. You can access the tutorial at any time by searching here for "tutorial". 
* <kbd>Ctrl</kbd>-<kbd>Enter</kbd> evaluates the current expression and the result is displayed inline. 
* <kbd>Ctrl</kbd>-<kbd>d</kbd> will pop up the documentation for the selected function.

There are some other cool bells and whistles too. For example, while you are working through the tutorial you will evaluate `double(10)` and find that by clicking and dragging on the function argument you can change its value and the value of the expression will be updated accordingly. I've not seen that in another IDE.

You can produce inline plots and the same click-and-drag mechanism mentioned above allows you to change the parameters of the plot and see the results in real-time.

## IJulia Notebooks

You can run Julia code directly in your browser using the IJulia notebooks at [JuliaBox.org](https://www.juliabox.com/). These notebooks are based on functionality from [IPython](http://ipython.org/). You can read more about how they work [here](http://ipython.org/notebook.html).

Sign in using your Google identity. Everybody has one of those, right?

<img src="/img/2015/08/julia-juliabox.jpg" width="100%">

Open the tutorial folder and then select the 00 - Start Tutorial notebook. It's worthwhile browsing through the other parts of the tutorial too, which cover topics like plotting and metaprogramming.

<img src="/img/2015/08/julia-ijulia-notebook.jpg" width="100%">

You can access the notebook functionality locally via the [IJulia](https://github.com/JuliaLang/IJulia.jl) package. As before, these instructions pertain to Ubuntu Linux. First you'll need to install IPython.

{{< highlight text >}}
$ sudo apt-get install ipython-notebook
{{< /highlight >}}

Then install and load the IJulia package. Finally run the `notebook()` function, which will launch an IJulia notebook in your browser.

{{< highlight julia >}}
julia> Pkg.add("IJulia")
julia> using IJulia
julia> notebook()
2015-08-03 07:35:33.009 [NotebookApp] Using existing profile dir: u'/home/colliera/.ipython/profile_julia'
2015-08-03 07:35:33.013 [NotebookApp] Using system MathJax
2015-08-03 07:35:33.020 [NotebookApp] Serving notebooks from local directory: /home/colliera/
2015-08-03 07:35:33.021 [NotebookApp] 0 active kernels
2015-08-03 07:35:33.021 [NotebookApp] The IPython Notebook is running at: http://localhost:8998/
2015-08-03 07:35:33.021 [NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
Created new window in existing browser session.
{{< /highlight >}}

Alternatively you can use an IJulia notebook directly from the shell prompt.

{{< highlight julia >}}
$ ipython notebook -profile julia
{{< /highlight >}}

That's a little more direct than first running the Julia interpreter. For ease of use I created a shell alias.

{{< highlight julia >}}
$ alias ijulia='ipython notebook -profile julia'
$ ijulia
{{< /highlight >}}

**Update (2018/07/22):** Once you've installed the `IJulia` package you'll find that there is also a Julia kernel available in Jupyter.

## Editor Support

There is good support for Julia in various editors. Among the ones I use ([vim](https://github.com/JuliaLang/julia-vim), gedit, Notepad++, [emacs](https://github.com/emacs-ess/ESS/wiki/Julia) and Sublime Text) all have Julia capabilities.

## Hosting Code

[Julia Studio](https://github.com/forio/julia-studio) is a project which is no longer supported and has been incorporated into [Epicenter](http://forio.com/products/epicenter/), which is a platform for hosting server-side models. It facilitates the creation of interactive web and mobile applications. I haven't given it a go yet, but it looks interesting and it's certainly on the agenda.
