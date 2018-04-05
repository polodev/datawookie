---
author: Andrew B. Collier
categories:
- Julia
date: 2015-10-12T15:30:33Z
excerpt_separator: <!-- more -->
id: 2619
tags:
- '#julialang'
- Julia
- Juno
title: Installing LightTable and Juno on Ubuntu
url: /2015/10/12/installing-lighttable-and-juno-on-ubuntu/
---

The recipe below works for Light Table v. 0.7.2 and Julia v. 0.4.0. It might work for other versions too, but these are the ones I can vouch for.

<!--more-->

Grab the distribution from the [Light Table homepage](http://lighttable.com/). Unpack it and move the resulting folder somewhere suitable.

{{< highlight bash >}}
$ tar -zxvf LightTableLinux64.tar.gz
$ sudo mv LightTable /opt/
{{< /highlight >}}

Go ahead and fire it up.

{{< highlight bash >}}
$ /opt/LightTable/LightTable
{{< /highlight >}}

At this stage Light Table is just a generic editor: it doesn't know anything about Julia or Juno. We'll need to install a plugin to make that connection. In the Light Table IDE type <kbd>Ctrl</kbd>-<kbd>Space</kbd>, which will open the Commands dialog. Type `show plugin manager` into the search field and then click on the resulting entry.

<img src="/img/2015/10/light-table-plugin-manager.jpg">

Search for Juno among the list of available plugins and select Install.

<img src="/img/2015/10/light-table-plugin-search.jpg">

Open the Commands dialog again using <kbd>Ctrl</kbd>-<kbd>Space</kbd>. Type `settings` into the search field.

<img src="/img/2015/10/light-table-settings.jpg">

Click on the User behaviors entry.

<img src="/img/2015/10/light-table-user-behaviours.jpg">

Add the following line to the configuration file:

{{< highlight text >}}
[:app :lt.objs.langs.julia/julia-path "julia"]
{{< /highlight >}}

At this point you should start up Julia in a terminal and install the Jewel package.

{{< highlight julia >}}
Pkg.add("Jewel")
{{< /highlight >}}

I ran into some issues with the configuration file for the Julia plugin, so I replaced the contents of `~/.config/LightTable/plugins/Julia/jl/init.jl` with the following:

{{< highlight julia >}}
using Jewel
Jewel.server(map(parseint, ARGS)..., true)
{{< /highlight >}}

That strips out a lot of error checking, but as long as you have a recent installation of Julia and you have installed the Jewel package, you're all good.

Time to restart Light Table.

{{< highlight bash >}}
$ /opt/LightTable/LightTable
{{< /highlight >}}

You should find that it starts in Juno mode.

Finally, to make things easier we can define a shell macro for Juno.

{{< highlight bash >}}
$ alias juno='/opt/LightTable/LightTable'
$ juno
{{< /highlight >}}

Enjoy.
