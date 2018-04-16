---
author: Andrew B. Collier
date: 2016-02-23T15:00:50Z
tags: ["R"]
title: R, HDF5 Data and Lightning
---

I used to spend an inordinate amount of time digging through lightning data. These data came from a number of sources, the [World Wide Lightning Location Network](http://wwlln.net/) (WWLLN) and LIS/OTD being the most common. I recently needed to work with some [Hierarchical Data Format (HDF)](https://en.wikipedia.org/wiki/Hierarchical_Data_Format) data. HDF is something of a niche format and, since that was the format used for the LIS/OTD data, I went to review those old scripts. It was very pleasant rediscovering work I did some time ago.

<!--more-->

## LIS and OTD

The [Optical Transient Detector](https://lightning.nsstc.nasa.gov/otd/) (OTD) and [Lightning Imaging Sensor](https://lightning.nsstc.nasa.gov/lis/overview_lis_instrument.html) (LIS) were instruments for detecting lightning discharges from Low Earth Orbit. OTD was launched in 1995 on the MicroLab-1 satellite into a near polar orbit with inclination 70&deg;. OTD achieved global (spatial) coverage for the period May 1995 to April 2000 with roughly 60% uptime. LIS was an instrument on the [TRMM](https://en.wikipedia.org/wiki/Tropical_Rainfall_Measuring_Mission) satellite, launched into a 35&deg; inclination orbit during 1997. Data from LIS were thus confined to more tropical latitudes. The TRMM mission only ended in April 2015.

The seminal work using data from OTD, [Global frequency and distribution of lightning as observed from space by the Optical Transient Detector](http://onlinelibrary.wiley.com/doi/10.1029/2002JD002347/abstract), was published by Hugh Christian and his collaborators in 2003. It's open access and well worth a read if you are interested in where and when lightning happens across the Earth's surface.

## Preprocessing HDF4 to HDF5

The LIS/OTD data are available as HDF4 files from <https://lightning.nsstc.nasa.gov/data/>. To load them into R I first converted to HDF5 using a tool from the h5utils suite:

{{< highlight bash >}}
$ h5fromh4 -d lrfc LISOTD\_LRFC\_V2.3.2014.hdf
{{< /highlight >}}

## Loading HDF5 in R

Support for HDF5 in R appears to have evolved appreciably in recent years. I originally used the hdf5 package. Then some time later transitioned to the h5r package. Neither of these appear on CRAN at present. Current support for HDF5 is via the [h5](http://cran.mirror.ac.za/web/packages/h5/index.html) package. This package depends on the h5c++ library, which I needed to grab.

{{< highlight bash >}}
$ sudo apt-get install libhdf5-dev
{{< /highlight >}}

Then, back in R I installed and loaded the h5 package.

{{< highlight r >}}
> install.packages("h5")
> library(h5)
{{< /highlight >}}

Ready to roll!

## Low Resolution Full Climatology

The next step was to interrogate the contents of one of the HDF files. A given file may contain multiple data sets (this is part of the "hierarchical" nature of HDF), so we'll check on what data sets are packed into one of those files. Let's look at the Low Resolution Full Climatology (LRFC) data.

{{< highlight r >}}
> file = h5file(name = "data/LISOTD\_LRFC\_V2.3.2014.h5", mode = "r")
> dataset = list.datasets(file)
> cat("datasets:", dataset, "\n")
datasets: /lrfc
{{< /highlight >}}

Just a single data set, but that's by design: we only extracted one using h5fromh4 above. What are the characteristics of that data set?

{{< highlight r >}}
> print(file[dataset])
DataSet 'lrfc' (72 x 144)
type: numeric
chunksize: NA
maxdim: 72 x 144
{{< /highlight >}}

It contains numerical data and has dimensions 72 by 144, which means that it has been projected onto a latitude/longitude grid with 2.5&deg; resolution. We'll just go ahead and read in those data.

{{< highlight r >}}
> lrfc = readDataSet(file[dataset])
> class(lrfc)
[1] "matrix"
> dim(lrfc)
[1] 72 144
{{< /highlight >}}

That wasn't too hard. And it's not much more complicated if there are multiple data sets per file.

Below is a ggplot showing the annualised distribution of lightning across the Earth's surface. It's apparent that most lightning occurs over land in the tropics, with the highest concentration in Central Africa. The units of the colour scale are flashes per square km per year. Higher resolution data can be found the HRFC file (High Resolution Full Climatology), but the LRFC is quite sufficient to get a flavour of the data.

<img src="/img/2016/02/lis-otd-flash-density.png" >

## Low Resolution Annual Climatology

The Low Resolution Annual Climatology (LRAC) data have the same spatial resolution as LRFC but the data are broken down by day of year. This allows us to see how lightning activity varies at a particular location during the course of a year.

{{< highlight r >}}
> file = h5file(name = "data/LISOTD\_LRFC\_V2.3.2014.h5", mode = "r")
> dataset = list.datasets(file)
> lrac = readDataSet(file[dataset])
> dim(lrac)
[1] 72 144 365
{{< /highlight >}}

The data are now packed into a three dimensions array, where the first two dimensions are spatial (as for LRFC) and the third dimension corresponds to day of year.

We'll look at two specific grid cells, one centred at 28.75&deg; S 28.75&deg; E (near the northern border of Lesotho, which according to the plot above is a region of relatively intense lightning activity) and the other at 31.25&deg; S 31.25&deg; E (in the Indian Ocean, just off the coast of Margate, South Africa). The annualised time series are plotted below. Lesotho has a clear annual cycle, with peak lightning activity during the Summer months but extending well into Spring and Autumn. There is very little lightning activity in Lesotho during Winter due to extremely dry and cold conditions. The cell over the Indian Ocean has a relatively high level of sustained lightning activity throughout the year. This is due to the presence of the warm Agulhas Current flowing down the east coast of South Africa. We wrote a paper about this, [Processes driving thunderstorms over the Agulhas Current](http://onlinelibrary.wiley.com/doi/10.1002/jgrd.50238/abstract). It's also open access, so go ahead and check it out.

<img src="/img/2016/02/lis-otd-time-series.png" >

Although the data in the plot above are rather jagged, with some aggregation and mild filtering they become pleasingly smooth and regular. We observed that you could actually fit the resulting curves rather well with just a pair of sinusoids. That work was documented in [A harmonic model for the temporal variation of lightning activity over Africa](http://onlinelibrary.wiley.com/doi/10.1029/2010JD014455/abstract). Like the other two papers, it's open access. Enjoy (if that sort of thing is your cup of tea).

## Conclusion

My original intention with this post was to show how to handle HDF data in R. But in retrospect it has achieved a second objective, showing that it's possible to do some meaningful Science with data that's in the public domain.
