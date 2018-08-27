---
author: Andrew B. Collier
date: 2017-10-07T07:00:00Z
excerpt_separator: <!-- more -->
tags:
- Docker
- OSRM
title: Running OSRM with Docker
---

{{< comment >}}
https://github.com/Project-OSRM/osrm-backend/issues/3161
{{< /comment >}}

I've now been through the process of [setting up OSRM]({{< relref "2017-08-31-using-aws-cli.md" >}}) a few times. While it's not exactly taxing, it seemed like a prime candidate for automation.

<!--more-->

Although there are existing Docker images for OSRM, I elected to roll my own to have a little more control. You can find the `Dockerfile` and a startup script [here](https://github.com/DataWookie/docker-osrm).

To use, do as follows:

1. Build the image.

	{{< highlight bash >}}
$ docker build -t osrm:latest .
{{< /highlight >}}

2. Download map data. For the sake of illustration, we'll assume that the resulting file is called `map.xml`.
3. Launch a container.

	{{< highlight bash >}}
$ docker run -p 5000:5000 -v `pwd`:/data osrm:latest map.xml
{{< /highlight >}}

The image exposes the service on port 5000, which is mapped to port 5000 on the host. Now go ahead and submit requests!