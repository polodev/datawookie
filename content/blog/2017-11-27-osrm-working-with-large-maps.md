---
author: Andrew B. Collier
date: 2017-11-27T07:00:00Z
tags: ["OSRM"]
title: Using Large Maps with OSRM
---

How to deal with large data sets in OSRM? Some quick notes on processing monster PBF files and getting them ready to serve with OSRM.

<!--more-->

## Test Data

To illustrate, let's download two sets of data which might be considered "large". These data are both for Noth America and represent the same information but in different formats.

{{< highlight bash >}}
wget http://download.geofabrik.de/north-america-latest.osm.pbf
wget http://download.geofabrik.de/north-america-latest.osm.bz2
{{< /highlight >}}

The second of these files is a compressed XML file, which is what I have been routinely using before. However, as we will see shortly, the sheer size of this file makes it completely impractical!

When the above downloads complete you'll find that the PBF file is 8 Gb while the compressed XML file is 13 Gb. I tried decompressing the latter and rapidly ran out of space on my 80 Gb partition. Clearly the file was going to be too big to work with!

## Extract

So how to make use of the PDF file? Well, the PBF files (and the XML files too, actually!) contain a vast array of data, much of which is irrelevant to routing. The `osrm-extract` tool will extract only the salient data, which turns out to be a relatively small subset of the original.

This operation is going to consume memory like a beast! So unless you 're running on a machine with a hefty chunk of RAM you'll need to ensure that you have plenty of [swap space]({{ site.baseurl }}{% post_url 2015-06-19-amazon-ec2-adding-swap %}) available. For reference I did this on an EC2 instance with 30 Gb RAM and added another 45 Gb of swap. It's possible that the swap was overkill but I didn't want memory allocation to be a problem on a long job.

{{< highlight bash >}}
osrm-extract north-america-latest.osm.pbf
{{< /highlight >}}

And, yes, it's also going to take some time. So get busy doing something else. Waiting will be frustrating.

## Contract

When `osrm-extract` is done, the next step is to run `osrm-contract` on the results.

{{< highlight bash >}}
osrm-contract north-america-latest.osrm
{{< /highlight >}}

Again this is going chug away for a while. Go for a run. Make dinner. Knit.

On my 4 core EC2 instance that ran overnight. When it was done the processed files totalled 37 Gb. It's possible that not all of those files are necessary for routing calculations, but I'm going to hang onto all of them for now.

## Serve

At this stage you're ready to fire up the routing server.

{{< highlight bash >}}
osrm-routed north-america-latest.osrm
{{< /highlight >}}

Go head and start submitting requests on port 5000. Your lengthy labours will start paying off.