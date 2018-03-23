---
title: 'Running OSRM with Docker'
date: 2017-10-07T07:00:00+00:00
author: Andrew B. Collier
layout: post
excerpt_separator: <!-- more -->
tags:
  - Docker
  - OSRM
---

{% comment %}
https://github.com/Project-OSRM/osrm-backend/issues/3161
{% endcomment %}

I've now been through the process of [setting up OSRM]({{ site.baseurl }}{% post_url 2017-08-31-using-aws-cli %}) a few times. While it's not exactly taxing, it seemed like a prime candidate for automation.

<!-- more -->

Although there are existing Docker images for OSRM, I elected to roll my own to have a little more control. You can find the `Dockerfile` and a startup script [here](https://github.com/DataWookie/docker-exegetic/tree/master/osrm).

To use, do as follows:

1. Build the image.

{% highlight bash %}
$ docker build -t osrm:latest .
{% endhighlight %}

{:start="2"}
2. Download map data. For the sake of illustration, we'll assume that the resulting file is called `map.xml`.
3. Launch a container.

{% highlight bash %}
$ docker run -p 5000:5000 -v `pwd`:/data osrm:latest map.xml
{% endhighlight %}

The image exposes the service on port 5000, which is mapped to port 5000 on the host. Now go ahead an submit requests!