---
author: Andrew B. Collier
date: 2013-04-16T14:16:14Z
tags: ["R"]
title: Locations of Geosynchronous Satellites
---

A year or so ago I went to a talk which included the diagram below. It shows the locations of the Earth&#8217;s fleet of [geosynchronous satellites](http://en.wikipedia.org/wiki/Geosynchronous_satellite). According to the speaker, the information in this diagram was already quite dated: the satellites and their locations had changed.

<img src="/img/2013/04/geosynch-old.jpg" width="100%">

I decided to update the diagram using the locations of satellites from the [list of geosynchronous satellites published](http://en.wikipedia.org/wiki/List_of_satellites_in_geosynchronous_orbit) on Wikipedia. Probably not the most definitive source of data on this subject, but it was a good starting point.

First, grab the Wikipedia page and extract the two tables (one for satellites over each of the eastern and western hemispheres. Then concantenate those tables.

{{< highlight r >}}
download.file("http://en.wikipedia.org/wiki/List\_of\_satellites\_in\_geosynchronous_orbit",
              "wiki-geosynchronous-satellites.html")
#
W = readHTMLTable("wiki-geosynchronous-satellites.html", which = 3, trim = TRUE,
stringsAsFactors = FALSE)
E = readHTMLTable("wiki-geosynchronous-satellites.html", which = 4, trim = TRUE,
stringsAsFactors = FALSE)
#
geosat = rbind(W, E)
{{< /highlight >}}

The longitude column indicates whether the satellites are east (E) or west (W) of the prime meridian. It is going to be more convenient to convert these to numerical values and make the ones that are to the west negative.

{{< highlight r >}}
index = grep("°W", geosat[,1])
geosat[index, 1] = paste0("-", geosat[index, 1]) 
#
geosat[,1] = sub("°[WE]$", "", geosat[,1])
{{< /highlight >}}

After some housekeeping, converting the range of longitudes from [-180&deg;,180&deg;) to [0&deg;,360&deg;), and retaining only the necessary columns, we end up with data that looks like this:

{{< highlight r >}}
> head(geosat)
  Location   Satellite      Type
1      212  EchoStar-1 Broadcast
2      221  Americom-8 Broadcast
3      223  Americom-7 Broadcast
4      225 Americom-10 Broadcast
5      227   Galaxy-12 Broadcast
6      229 Americom-11 Broadcast
{{< /highlight >}}

Well, that is really the tricky stuff. Generating the plots was quite straight forward. First I grouped the longitudes into bins. Then, for each bin

1. assigned radial distance vector for satellites (not realistic, but allowed bins with multiple satellites to be plotted neatly); 
2. converted longitude and radial distance into Cartesian coordinates; 
3. plotted points at these locations; and 
4. inserted labels.

This is the result:
                
<img src="/img/2013/04/geosynchronous-orbit.png" width="100%">

Have a look at a higher resolution [pdf version](/img/2013/04/geosynchronous-orbit.pdf).
