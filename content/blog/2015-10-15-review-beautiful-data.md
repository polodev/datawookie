---
author: Andrew B. Collier
date: 2015-10-15T16:00:39Z
tags: ["R", "Python", "Book Review"]
title: 'Review: Beautiful Data'
---

<!--more-->

I've just finished reading [Beautiful Data](http://shop.oreilly.com/product/9780596157128.do) (published by O'Reilly in 2009), a collection of essays edited by Toby Segaran and Jeff Hammerbacher. The 20 essays from 39 contributors address a diverse array of topics relating to data and how it's collected, analysed and interpreted.

<img src="/img/2015/09/beautiful-data-cover.png">

Since this is a collection of essays, the writing style and level of technical detail varies considerably between chapters. To be honest, I didn't find every chapter absolutely riveting, but I generally came away from each of them having learned a thing or two. Below is a list of chapter titles with occasional comments.

1. _Seeing Your Life in Data_   
Nathan Yau writes about personal data collection, highlighting [your.flowingdata](https://flowingdata.com/) which is a Twitter app for gathering personal data. Although I am keenly interested in the data logged by my Garmin 910XT, I don't think that I have the discipline to tweet every time I go out for a run. Regardless though, it's a cool idea.
2. _The Beautiful People: Keeping Users in Mind When Designing Data Collection Methods_ 
3. _Embedded Image Data Processing on Mars_   
Instruments on planetary probes operate under significant technological constraints. So it's fascinating to learn the details behind the imaging system on the Phoenix Mars lander.
4. _Cloud Storage Design in a PNUTShell_ 
5. _Information Platforms and the Rise of the Data Scientist_   
Jeff Hammerbacher along with DJ Patil coined the term "Data Scientist". The chapter starts with a story of how 17 year old Hammerbacher was fired from his job as a cashier in a grocery store and ends with the creation of the role "Data Scientist" at Facebook, reflecting the various and disparate tasks currently undertaken by people working intensively with data.
<blockquote>
By decoupling the requirements of specifying structure from the ability to store data and innovating on APIs for data retrieval, the storage systems of large web properties are starting to look less like databases and more like dataspaces.
<cite><a href="http://shop.oreilly.com/product/9780596157128.do">Beautiful Data</a>, p. 83</cite> 
</blockquote>

<ol>
	<li value="6"><em>The Geographic Beauty of a Photographic Archive</em>
	<li> <em>Data Finds Data_ </em>
	<li> <em>Portable Data in Real Time</em>
Jud Valeski describes the evolution of APIs for public access to data. Having spent a lot of time recently messing around with the APIs for Twitter and [Quandl](https://www.quandl.com/tools/api), this was interesting stuff.
	<li> <em>Surfacing the Deep Web</em>
	<li> <em>_Building Radiohead's House of Cards</em>
I've watched the video for Radiohead's [House of Cards](https://en.wikipedia.org/wiki/House_of_Cards_(Radiohead_song)) a few times before and thought that it was a cool concept. Now that I know what went into making the video (courtesy of this chapter), my appreciation has gone up a number of notches. The authors explain in appreciable detail how they gathered data using LIDAR systems and used [processing](https://processing.org/) to generate the aetherial animations in the video.
</ol>

<iframe width="560" height="315" src="https://www.youtube.com/embed/8nTFjVm9sTQ" frameborder="0" allowfullscreen></iframe>

Although at the time of publishing some of the data for the video were released as open source, it appears to have subsequently been withdrawn. That's a pity. I think I would have enjoyed hacking on that. And it would have been good motivation to learn more about [processing](https://processing.org/).

<ol>
	<li value="11"><em>Visualizing Urban Data</em>
	<li> <em>The Design of Sense.us</em>
	<li> <em>What Data Doesn't Do</em>  
Coco Krumme provides a somewhat dissenting view, writing about the limitations of data. She reminds us that a naive interpretation of statistics can be very misleading; that more data is not always better data; that data alone do not provide explanations; and that even good models have limitations.
	<li> <em>Natural Language Corpus Data</em> 
This is probably the most technical chapter in the book. Peter Norvig gives a tutorial on Natural Language Processing (NLP) with sample code in Python. He certainly provides enough information to get you up and running with NLP. He also points out a number of potential gotchas and ways to get around them. 
	<li> <em>Life in Data: The Story of DNA</em>
{{< highlight c >}}
char(3*10^9) human_genome;
{{< /highlight >}}
I'm not sure why, but that snippet of code really amused me. Great way of capturing an obscure biological fact in a form which resonates with my inner geek.
</ol>

<ol>
	<li value="16"><em>Beautifying Data in the Real World</em>
	<li> <em>Superficial Data Analysis: Exploring Millions of Social Stereotypes</em>  
The authors write about processing the data gathered at FaceStat.com, providing numerous handy snippets of R code. Although the FaceStat web site has been discontinued, the principles of their analysis will find applications elsewhere.
	<li> <em>Bay Area Blues: The Effect of the Housing Crisis</em>
	<li> <em>Beautiful Political Data</em>
	<li> <em>Connecting Data</em>
This chapter addresses the issue of connecting data from disparate sources. Here I found something that is going to be of immediate use to me: [Collective Entity Resolution](http://drum.lib.umd.edu/handle/1903/4241). It appears that this algorithm will solve a problem I have grappled with for a few months. This bit of information alone made the book a worthwhile read.
</ol>

You're not going to learn the details of any new technical skills from this book. But you will definitely uncover many inspiring thoughts and ideas. And you'll probably find a gem or too, just like I did.
