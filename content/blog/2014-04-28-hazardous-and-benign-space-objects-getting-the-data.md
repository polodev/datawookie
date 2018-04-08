---
author: Andrew B. Collier
date: 2014-04-28T10:33:05Z
tags: ["R"]
title: 'Hazardous and Benign Space Objects: Getting the Data'
---

The recent story about a [skydiver nearly being hit by falling meteor](http://www.universetoday.com/110963/norwegian-skydiver-almost-gets-hit-by-falling-meteor-and-captures-it-on-film/ "Norwegian Skydiver Almost Gets Hit by Falling Meteor") got me thinking about all the pieces of rock floating around in near-Earth space. Despite the fact that the supposed meteor was [probably just a chunk of rock mistakenly packed in with a parachute](http://www.universetoday.com/111076/follow-up-on-skydiving-meteorite-crowdsourcing-concludes-it-was-just-a-rock/ "Follow-Up on Skydiving Meteorite: Crowdsourcing Concludes it Was Just a Rock"), the fact that something like that _could_ actually happen is quite intriguing. And not a little frightening.

<!--more-->

[Near Earth Objects](http://en.wikipedia.org/wiki/Near-Earth_object) (NEOs) all approach the Sun to within 1.3 AU. Information on NEOs can be found in a number of places. I grabbed the heliocentric ecliptic [orbital elements](http://en.wikipedia.org/wiki/Orbital_elements) for 10808 objects from NASA's [Near Earth Object Program](http://neo.jpl.nasa.gov/cgi-bin/neo_elem) as a rather massive HTML file.

## Loading the Data

The first step was to parse the HTML. As usual, I am going to do my analysis in R.

{{< highlight r >}}
> library(XML)
> library(stringr)
>
> orbits = readHTMLTable(file.path("data", "NEA Orbital Elements.html"), header = TRUE, trim = TRUE, stringsAsFactors = FALSE)
> #
> # Select required table
> #
> orbits = orbits[[12]]
{{< /highlight >}}

Somewhat surprisingly I could not get the "which" argument for readHTMLTable() to work, so I simply parsed all of the tables in the file and then selected the one that I wanted after the fact.

Next I had to clean up the column names, which were contaminated by an obscure character.

{{< highlight r >}}
> names(orbits) <- sub("Â", "", sub("\\(.*\\)", "", names(orbits)))
{{< /highlight >}}

The first and last columns turned out to be redundant, so they were removed.

{{< highlight r >}}
> orbits[,16] = NULL
> orbits[,14] = NULL
{{< /highlight >}}

The data in the first column was also contaminated with the same obscure character...

{{< highlight r >}}
> orbits[,1] = str_trim(gsub("Â", "", orbits[,1]))
{{< /highlight >}}

Then I converted some columns from strings to numbers and others from degrees to radians.

{{< highlight r >}}
> for (n in 3:13) orbits[,n] = as.numeric(orbits[,n])
> for (n in 5:8) orbits[,n] = orbits[,n] / 180 * pi
{{< /highlight >}}

And, lastly, split the class column to separate out the hazard data.

{{< highlight r >}}
> orbits$hazard = FALSE
> orbits$hazard[grep("\\*", orbits$class)] = TRUE
> #
> orbits$hazard = factor(orbits$hazard, levels = c(FALSE, TRUE))
> #
> orbits$class = sub("\\*", "", orbits$class)
{{< /highlight >}}

The resulting data looked like this:

{{< highlight r >}}
> head(orbits)
              Object Epoch       a       e        i       w    Node       M     q     Q    P    H     MOID class hazard
1         (2005 HC4) 53493 1.81640 0.96095 0.146327 5.39223 1.11392 5.95757 0.0709 3.56 2.45 20.7 0.061462   APO  FALSE
2         (2008 FF5) 54555 2.28305 0.96529 0.045831 0.34740 0.26706 0.20574 0.0792 4.49 3.45 23.1 0.007250   APO  FALSE
3        (2006 HY51) 56800 2.59951 0.96885 0.532597 5.94317 0.74014 5.53255 0.0810 5.12 4.19 17.2 0.089849   APO  FALSE
4 137924 (2000 BD19) 56800 0.87645 0.89507 0.448742 5.66019 5.82491 5.72942 0.0920 1.66 0.82 17.2 0.090637   ATE  FALSE
5   374158 (2004 UL) 56800 1.26636 0.92668 0.414790 2.60992 0.69126 3.68361 0.0928 2.44 1.43 18.8 0.018523   APO   TRUE
6        (2007 EP88) 56800 0.83731 0.88583 0.362511 0.82035 5.73542 4.42276 0.0956 1.58 0.77 18.5 0.142221   ATE  FALSE
{{< /highlight >}}

The salient columns are:

* `Object` - the object identifier; 
* `a` - length of the semi-major axis (AU); 
* `e` - eccentricity; 
* `i` - inclination; 
* `w` - argument of perihelion; 
* `Node` - longitude of the ascending node; 
* `M` - mean anomaly; 
* `q` - perihelion distance (AU); 
* `P` - orbital period (year); 
* `H` - absolute V-magnitude; 
* `MOID` - minimum orbital intersection distance (AU).

The class field specifies whether an object is a IEO (Interior Earth Object), AMO (Amor: orbit must be outside the orbit of Earth and not cross Earth's orbit; but coming within 0.30 AU of Earth's orbit), APO (Apollo: semi-major axes greater than 1 AU but perihelion distances less than Earth's aphelion distance; Earth-crossing orbits) or ATE (Aten: semi-major axes less than 1 AU and aphelion greater than 0.983 AU). Finally, the hazard field indicates whether or not an object is potentially hazardous to Earth. Many of these parameters are illustrated in the illustration below (courtesy of Wikipedia).

[<img src="/img/2014/04/500px-Orbit1.svg_.png">](http://en.wikipedia.org/wiki/File:Orbit1.svg)

## Summary Statistics

How are the 10808 objects distributed across the various classes?

{{< highlight r >}}
> table(orbits$class)

 AMO  APO  ATE  IEO 
4102 5857  835   14 
{{< /highlight >}}

Which class has the most hazardous objects?

{{< highlight r >}}
> with(orbits, table(class, hazard))
     hazard
class FALSE TRUE
  AMO  4017   85
  APO  4614 1243
  ATE   698  137
  IEO    10    4
{{< /highlight >}}

So, most of the things that we need to worry about are Apollo asteroids. The meteor which detonated over Chelyabinsk on 15 February 2013 was one of these.

The absolute magnitude data (which indicates the brightness of an object) can be used to get an idea of size.

<img src="/img/2014/04/histogram-v-magnitude.png">

Those objects with an absolute magnitude less than around 17 have a diameter of 1 km across or more. Those with a magnitude of 25 or more are about 50 m in diameter. You might have noticed that there is something a little odd about these magnitudes. Wouldn't you expect a larger object to reflect more light and thus have a _higher_ magnitude? Well, the magnitude scale is a curious beast: it seems to go in the "wrong" direction. A larger magnitude indicates a dimmer object and vice versa. Also, it is a logarithmic scale, so that, for example, an object with magnitude of 6 is around 2.5 times brighter than an object with a magnitude of 7, which in turn is about 2.5 times brighter than an magnitude 8 object.

## Kepler's Third Law

[Kepler's Third Law](http://en.wikipedia.org/wiki/Kepler's_laws_of_planetary_motion#Third_law) states that, for an elliptical orbit, the square of the period is proportional to the cube of the length of the semi-major axis. We can check whether our data are consistent with this law. Since it's a power law relationship, it makes sense to present the data on a log-log plot.

{{< highlight r >}}
> library(ggplot2)
> 
> ggplot(orbits, aes(x = a, y = P)) +
+   geom_point() +
+   scale_x_log10() + scale_y_log10() +
+   xlab("a [AU]") + ylab("Period [year]") +
+   theme_classic()
{{< /highlight >}}

<img src="/img/2014/04/kepler-third-law.png">

That looks pretty spot on... not too surprising though, because Kepler's Third Law was probably used to derive either the period of the semi-major axis! A linear fit confirms the ratio of exponents is 1.5.

{{< highlight r >}}
> lm(log10(P) ~ log10(a), data = orbits)

Call:
lm(formula = log10(P) ~ log10(a), data = orbits)

Coefficients:
(Intercept)     log10(a)  
   1.29e-05     1.50e+00 
{{< /highlight >}}

## Orbital Parameters and Hazard

[Orbital eccentricity](http://en.wikipedia.org/wiki/Orbital_eccentricity) describes to what degree an orbit deviates from circular. A circular orbit has an eccentricity of zero. Values between zero and one corresponds to progressively more "squashed" ellipses. An eccentricity of 1 or more is an open orbit (there are none of these in our data).

{{< highlight r >}}
> ggplot(orbits, aes(x = e)) +
+   geom_histogram(binwidth = 0.05, fill = "lightblue", colour = "black") +
+   xlab("Eccentricity") + ylab("") +
+   theme_classic()
{{< /highlight >}}

<img src="/img/2014/04/histogram-eccentricity.png">

The eccentricity histogram above shows that there are few objects on circular orbits. There are also few objects with extremely elliptical orbits. The majority have an eccentricity somewhere around 0.5.

We can make these data more illuminating by including the length of the semi-major axis. We will also indicate the class of the object (colour scale) and whether or not it is potentially hazardous (left and right panels).

{{< highlight r >}}
> ggplot(orbits[order(orbits$hazard),], aes(x = e, y = a)) +
+   geom_point(aes(colour = class), alpha = 0.5, size = 2) +
+   scale_y_log10() +
+   scale_colour_discrete("Class", h = c(240, 0), c = 150) +
+   facet_wrap(~ hazard, nrow = 1) +
+   xlab("Eccentricity") + ylab("Semi-Major Axis [AU]") +
+   theme_classic()
{{< /highlight >}}

<img src="/img/2014/04/points-eccentricity-sma-class-hazard.png">

Here we can see that the orbital parameters for the four different classes are well differentiated and that we should be able to easily classify a new object. There does not seem to be a clear distinction between objects which are or are not potentially hazardous. Why is that? Objects are considered hazardous if (i) they are likely to make a close approach to the Earth and (ii) are large enough to cause significant devastation. Effectively an object is defined as hazardous if it has a MOID of 0.05 AU (approximately 20 times the distance between the Earth and the Moon) or less and absolute magnitude less than 22 (approximately 150 m in diameter). This distinction is clarified in the plot below.

<img src="/img/2014/04/points-magnitude-moid-hazard.png">

## Conclusion

That was a quick overview of the data available. In the next few days I will post follow up articles in which I will solve Kepler's Equation to find the eccentric anomaly and then transform the coordinates into a Solar-ecliptic reference frame so that we can compare the objects' locations.
