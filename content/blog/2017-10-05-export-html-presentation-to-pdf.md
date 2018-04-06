---
author: Andrew B. Collier
date: 2017-10-05T07:00:00Z
tags: ["Speaking"]
title: Exporting HTML Presentations to PDF
---

Building a presentation with [reveal.js](http://lab.hakim.se/reveal-js/) is such a pleasure. And the results looks so good. Seriously doubt that I will ever use anything like PowerPoint again. Although it's possible to export a presentation directly to PDF using a [style sheet](https://github.com/hakimel/reveal.js#pdf-export), this doesn't always work perfectly (IMHO).

Fortunately there's another way: [decktape](https://github.com/astefanutti/decktape). It works with reveal.js and a bunch of other HTML5 presentation frameworks.

<!--more-->

You can install decktape using `npm`, but my preferred approach is to use a Docker container.

## Simple Conversion

### Presentation Hosted Online

If you have your presentation hosted online, say at `http://www.example.com/presentation` then convert to PDF as follows:

{{< highlight bash >}}
$ docker run --rm -v `pwd`:/slides astefanutti/decktape http://www.example.com/presentation slides.pdf
{{< /highlight >}}

### Presentation Hosted Locally

If you are hosting the presentation locally then you can also do this:

{{< highlight bash >}}
$ docker run --rm --net=host -v `pwd`:/slides astefanutti/decktape http://localhost:8000 slides.pdf
{{< /highlight >}}

But it will only work if *everything* is hosted locally (all of the CSS, Javascript etc.).

### Local File

It's also apparently possible to generate PDF from a local HTML file (without actually serving that file), but I haven't managed to figure that out yet. Would definitely make the process slightly easier. However, just spinning up a local web server with Python is almost effortless, so it's not a big deal.

## Options

### Screen Size

I initially found that some images would be misplaced in the resulting PDF. The solution to this was to specify a screen size. I chose the size of my laptop screen (since the HTML looked good at that size). Simply use the `-s` option.

{{< highlight bash >}}
$ docker run --rm -v `pwd`:/slides astefanutti/decktape -s 1920x1080 http://www.example.com/presentation slides.pdf
{{< /highlight >}}