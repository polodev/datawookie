---
author: Andrew B. Collier
date: 2013-10-19T09:01:49Z
tags: ["R"]
title: Plotting Times of Discrete Events
---

I recently enjoyed reading O’Hara, R. B., & Kotze, D. J. (2010). _Do not log-transform count data_. Methods in Ecology and Evolution, 1(2), 118–122. doi:10.1111/j.2041-210X.2010.00021.x.

<!--more-->

The article prompted me to think about processes involving discrete events and how these might be presented graphically. I am not talking about counts (which are well represented by a histogram) but the individual events themselves. The problems here being that

  1. the data are essentially one dimensional (just a sequence of times at which events occurred) and
  2. there may be a great number of events and they can be distributed over a considerable period of time.

Plotting the events as a series of points along a linear axis would therefore make a rather boring plot, possibly with a rather extreme aspect ratio. There had to be a better way! What about wrapping that axis up into an [Archimedes' spiral](http://mathworld.wolfram.com/ArchimedesSpiral.html)? Sounds reasonable. Let's take a look.

# First Iteration

<img src="/img/2013/10/spiral-non-uniform.png">

Here time runs along the spiral and points indicate the times at which events occurred. In this case I have 21 events occurring at uniform intervals. Although it looks okay, there is one major flaw: the angular separation of the points is uniform but this is not consistent with the idea of a spiral axis. The points should be distributed uniformly in terms of arc length along the spiral!

# Revision: Spiral Arc Length

I needed to calculate the arc length along the spiral. Since I was not concerned with the absolute length, I neglected the spiral's pitch, giving a function which depended only on angle.

{{< highlight r >}}
spiral.length <- function(phi) {
    phi * sqrt(1 + phi**2) + log(phi + sqrt(1 + phi**2))
}
{{< /highlight >}}

Then I could interpolate to find the correct location of the events.

<img src="/img/2013/10/spiral-uniform.png">

Now the events, which are distributed uniformly in time, appear at uniform intervals along the spiral axis. Mission accomplished.

Here is the code to generate the spiral plot:

{{< highlight r >}}
spiral.plot <- function(t, nturn = 5, colour = "black") {
    npoint = nturn * 720
    #
    curve = data.frame(phi = (0:npoint) / npoint * 2 * pi * nturn, r = (0:npoint) / npoint)
    curve = transform(curve,
                      arclen = spiral.length(phi),
                      x = r* cos(phi),
                      y = r * sin(phi))
    #
    points = data.frame(arclen = t * max(curve$arclen) / max(t))
    points = within(points, {
        phi = approx(curve$arclen, curve$phi, arclen, rule = 2)$y
        r = approx(curve$arclen, curve$r, arclen, rule = 2)$y
        x = r* cos(phi)
        y = r * sin(phi)
    })
    #
    ggplot(curve, aes(x = x, y = y)) + 
        geom_path(colour = "grey") +
        geom_point(data = points, aes(x = x, y = y), size = 3, colour = colour) +
        coord_fixed(ratio = 1) +
        theme(axis.text = element_blank(),
              axis.ticks = element_blank(),
              axis.title = element_blank(),
              panel.background = element_blank(),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank())
}
{{< /highlight >}}

It is unfortunate that I had to transform the data to Cartesian Coordinates in order to plot it. Although ggplot2 does has the capability to generate polar plots, it does not allow polar angles exceeding a single revolution. If anybody has other ideas on how to deal with this more elegantly, I would be very happy to hear from them.

The first enhancement I would apply to this plot would be to find a way of putting tick marks along the spiral. Again, any input would be appreciated.

# Practical Application

What about applying it to a more realistic scenario? If we simulate a radioactive decay process using the exponential distribution to yield a series of decay intervals, then these intervals can be accumulated to find the decay times.

{{< highlight r >}}
> Bq = 5
>
> delay = rexp(2000, Bq)
> 
> decay = data.frame(delay, time = cumsum(delay))
> spiral.plot(decay$time, 20)
{{< /highlight >}}

<img src="/img/2013/10/spiral-plot-large.png">

As discussed by O’Hara and Kotze, the distribution of events in clumps of varying sizes separated by intervals without events is readily apparent.
