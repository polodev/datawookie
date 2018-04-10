---
author: Andrew B. Collier
date: 2017-11-27T07:00:00Z
tags: ["OSRM"]
title: Using Large Maps with OSRM
---

How to deal with large data sets in OSRM? Some quick notes on processing monster PBF files and getting them ready to serve with OSRM.

Something to consider up front: if you are RAM limited then this process is going to take a very long time due to swapping. It might make sense to spin up a big clound instance (like a `r4.8xlarge`) for a couple of hours. You'll get the job done much more quickly and it'll definitely be worth it.

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

So how to make use of the PBF file? These files (and the XML files too, actually!) contain a vast array of data, much of which is irrelevant to routing. The `osrm-extract` tool will extract only the salient data, which turns out to be a relatively small subset of the original.

{{< highlight bash >}}
osrm-extract north-america-latest.osm.pbf
{{< /highlight >}}

And, yes, it's also going to take some time (especially if the job is too big to fit into RAM and it starts swapping). So get busy doing something else. Waiting will be frustrating.

This operation is going to consume memory like a beast! So unless you're running on a machine with a hefty chunk of RAM you'll need to ensure that you have plenty of [swap space]({{< relref "2015-06-19-amazon-ec2-adding-swap.md" >}}) available. If you can, spin up a big machine. It'll save you a lot of time (and probably work out more economical too).

<figure>
  <img src="/img/2018/04/osrm-r4.8xlarge.png">
  <figcaption>Running across 32 cores on a <code>r4.8xlarge</code> instance.</figcaption>
</figure>

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

{{< highlight text >}}
$ lsof -i :5000
COMMAND     PID   USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
osrm-rout 25517 ubuntu   14u  IPv4 421436      0t0  TCP *:5000 (LISTEN)
{{< /highlight >}}

Go head and start submitting requests on port 5000. Your lengthy labours will start paying off.

{{< highlight bash >}}
$ curl -s "http://localhost:5000/nearest/v1/driving/-106.619414,35.084085" | jq
{
  "waypoints": [
    {
      "nodes": [
        2540747742,
        2540747745
      ],
      "location": [
        -106.618295,
        35.083693
      ],
      "hint": "DpAthK_QToQAAAAABwAAAAwAAADCAAAAAAAAAAcAAAAMAAAAwgAAAB5CAABJIqX5rVUXAuodpfk1VxcCAQCPAQABEL4=",
      "name": "",
      "distance": 110.789041
    }
  ],
  "code": "Ok"
}
{{< /highlight >}}