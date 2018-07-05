---
title: "QGIS: Using OpenLayers to Create a Basemap Image"
date: 2017-05-26T09:00:00+00:00
author: Andrew B. Collier
layout: post
excerpt_separator: <!-- more -->
categories:
  - GIS
tags:
  - QGIS
draft: true
---

One of the first questions I had when starting firing up QGIS was: How do I create a [basemap](https://www.gislounge.com/basemaps-defined/) image? With the [OpenLayers](https://openlayers.org/) plugin this is actually very simple. <!-- more -->

## OpenLayers

First grab a suitable basemap by selecting <span class="menu">Web | OpenLayers plugin | Google Maps | Google Streets</span>. You can equally well choose one of the other options from Google Maps or even a different provider of maps. Just get your hands on whatever map suits your needs. Then zoom in on the area of interest.

<img src="/img/2017/05/qgis-openlayers-basemap.png">

Now save using <span class="menu">Project | Save as Image</span>. Select a suitable name and image format. There's a host of options for the latter. If you are going to be creating just a single image then PNG might be a good option. However, if you are going to be creating multiple images with the possibility of merging them later, then you'll definitely want to go with TIFF.

You'll find that two files are created. In this case I got `durban.tiff` and `durban.tiffw`, where the latter is the _world file_, a text file giving the location and resolution of the basemap image.

{% highlight bash %}
$ head durban.tiffw 
26.4583333603204629
0 
0 
-26.4583333603204629
3428878.64584410609677434
-3477093.40478078788146377
{% endhighlight %}

<iframe width="560" height="315" src="https://www.youtube.com/embed/NBCWkVtQksA" frameborder="0" allowfullscreen></iframe>

Next just load the basemap image using <span class="menu">Layer | Add Layer | Add Raster Layer</span>.

If you need to cover a larger spatial region then you'll need to repeat the process, creating multiple images.

## QuickMapServices

An alternative approach would be to use [QuickMapServices](http://nextgis.com/blog/quickmapservices/), although the resulting basemaps are relatively low resolution and not suitable for printing.

## Merging Basemap Images

If you create multiple basemap images in order to cover a particular region at a specific resolution then you might want to merge them into a single image. Provided that the images are TIFF then this is easily done with <span class="menu">Raster | Miscellaneous | Merge</span>.
