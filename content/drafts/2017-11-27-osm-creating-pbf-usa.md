---
draft: true
title: 'Creating OpenStreetMap Data for the USA'
date: 2017-10-07T07:00:00+00:00
author: Andrew B. Collier
layout: post
excerpt_separator: <!-- more -->
tags:
  - OSRM
---

Create a new folder for the PBF files.

{% highlight bash %}
mkdir states-pbf
cd states-pbf
{% endhighlight %}

Now download the files for each state. There's a delay in the loop so that the server doesn't feel like it's being violated. It does slow things down but it'll ensure that you don't get greylisted. And this entire process is going to take some time, so no sense in rushing.

{% highlight bash %}
for state in alabama alaska arizona arkansas california colorado connecticut delaware district-of-columbia florida georgia hawaii idaho illinois indiana iowa kansas kentucky louisiana maine maryland massachusetts mexico michigan minnesota mississippi missouri montana nebraska nevada new-hampshire new-jersey new-mexico new-york north-carolina north-dakota ohio oklahoma oregon pennsylvania puerto-rico rhode-island south-carolina south-dakota tennessee texas utah vermont virginia washington west-virginia wisconsin wyoming
do
	wget -c http://download.geofabrik.de/north-america/us/${state}-latest.osm.pbf
	sleep 180
done
{% endhighlight %}

Now merge those files using `osmium`. Read more about the [Osmium Tool](). NEED TO INSERT LINK HERE!!!

{% highlight bash %}
osmium merge *.osm.pbf -o merged.osm.pbf
{% endhighlight %}

At this stage you are ready to do the `osrm-extract` and `osrm-contract` dance before starting up the router. Check [this]() LINK TO POST ABOUT WORKING WITH BIG MAPS out for details.