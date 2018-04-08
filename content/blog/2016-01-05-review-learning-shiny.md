---
author: Andrew B. Collier
date: 2016-01-05T15:00:32Z
tags: ["R"]
title: 'Review: Learning Shiny'
---

I was asked to review [_Learning Shiny_](https://www.packtpub.com/application-development/learning-shiny) (Hernán G. Resnizky, Packt Publishing, 2015). I found the book to be useful, motivating and generally easy to read. I'd already spent some time dabbling with Shiny, but the book helped me graduate from paddling in the shallows to wading out into the Shiny sea.

<!--more-->

<img src="/img/2015/12/learning-shiny-cover.png">

The book states its objective as:

<blockquote>
... this book intends to be a guide for the reader to understand the scope and possibilities of creating web applications in R, and from here, make their own path through a universe full of different possibilities.
<cite>"Learning Shiny" by Hernán G. Resnizky</cite>
</blockquote>

And it does achieve this goal. If anything it's helpful in giving an idea of just what's achievable using Shiny. The book has been criticised for providing little more than what's to be found in the online Shiny tutorials, and there's certainly a reasonable basis for this criticism.

I'm not going to dig into the contents in any great detail, but here's the structure of the book with a few comments on each of the chapters.

1. Introducing R, RStudio, and Shiny   
A very high level overview of R, RStudio and Shiny, what they do and how to get them installed. If you've already installed them and you have some prior experience with R then you could safely skip this chapter. I did, however, learn something new and useful about collapsing code blocks in RStudio, so perhaps don't be too hasty.
2. First Steps towards Programming in R   
Somewhat disturbingly the first section in this chapter is entitled <em>Object-oriented programming concepts</em> but doesn't touch on any of the real Object Oriented support in R (S3, S4 and Reference classes). In fact, with regards to Object Oriented concepts it seemed to have rather the wrong end of the stick. The chapter does redeem itself though, giving a solid introduction to programming concepts in R, covering fundamental data types, variables, function definitions, control structures, indexing modes for each of the compound data types and reading data from a variety of sources.
3. An Introduction to Data Processing in R   
This chapter looks at the functionality provided by the plyr, data.table and reshape2 packages, as well as some fundamental operations like sorting, searching and summarising. These are all central to getting data into a form suitable for application development. It might have made more sense to look at dplyr rather than plyr, but otherwise this chapter includes a lot of useful information.
4. Shiny Structure - Reactivity Concepts   
Reactivity is at the core of any Shiny application: if it's not reactive then it's really just a static report. Having a solid understanding of reactivity is fundamental to your success with Shiny. Using a series of four concise example applications this chapter introduces the bipartite form of a Shiny application, the server and UI, and how they interact.
5. Shiny in Depth - A Deep Dive into Shiny's World   
The various building blocks available for constructing a UI are listed and reviewed, starting with those used to structure the overall layout and descending to lower level widgets like radio buttons, check boxes, sliders and date selectors.
6. Using R's Visualization Alternatives in Shiny   
Any self-respecting Shiny application will incorporate visualisation of some sort. This chapter looks at ways of generating suitable visualisations using the R's builtin graphics capabilities as well as those provided by the googleVis and ggplot2 packages. Although not covered in the book, <a href="https://plot.ly/r/">plotly</a> is another excellent alternative.
7. Advanced Functions in Shiny   
Although the concept of reactivity was introduced in Chapter 4, wiring up any non-trivial application will depend on the advanced concepts addressed in this chapter. Specifically, validation of inputs; <code>isolate()</code>, which prevents portions of server code from activating when inputs are changed; <code>observe()</code>, which provides reactivity without generating any output; and ways to programmatically update the values of input elements.
8. Shiny and HTML/JavaScript   
This chapter looks at specifying the Shiny UI with lower level code using either HTML tags, CSS rules or JavaScript. If you want to differentiate your application from all of the others, the techniques discussed here will get you going in the right direction. It does, however, assume some background in these other technologies.
9. Interactive Graphics in Shiny   
It's also possible to drive a Shiny application by interacting with graphical elements, as illustrated here using JavaScript integration.
10. Sharing Applications   
Means for sharing a Shiny application are discussed. The options addressed are: just sharing the code directly or via GitHub (not great options because they significantly limit the range of potential users); or hosting the application at <a href="http://www.shinyapps.io/">http://www.shinyapps.io/</a> or your own server.
11. From White Paper to a Full Application   
This chapter explores the full application development path from problem presentation and conceptual design, through coding UI.R and server.R, and then finally using CSS to perfect the appearance of the UI.

I did find a few minor errors which I submitted as errata via the publisher's web site. There are also a couple of things that I might have done differently:

1. I'm generally not a big fan of screenshots presented in a book, but in this case it would have been helpful to have a few more screenshots illustrating the effects of the code snippets.
2. Styling Shiny applications using CSS was only touched on: I think that there's a lot to be said on this subject and I would have liked to read more.
