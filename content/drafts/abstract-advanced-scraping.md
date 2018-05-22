---
title: 'The Cloud, a God and a Transcendent Putty Knife'
date: 2017-09-13T09:30:00+00:00
author: Andrew B. Collier
excerpt_separator: <!-- more -->
layout: post
categories:
  - Conference
tags:
  - Talk
---

<div class="talk">
	<div class="title">
	Advanced Techniques for Web Scraping
	</div>
	<div class="abstract">
		<blockquote>
		"My scrapers run in the cloud using multiple shared proxies. That's how I get lightning fast results."
		<cite>Thor, God of Thunder and Lightning (loosely paraphrased).</cite>
		</blockquote>

		<p>Despite the fact that APIs are relatively pervasive, there are still many web sites that don't expose a programmatic interface to their data. Yet these sites may still contain vast volumes of useful information.</p>

		<p>Web scraping is an effective technique to access that information.</p>

		<p>Scraping a small web site is simple and fun: retrieving page contents, locating the relevant tags, then extracting and persisting the data. With the tools available in Python and R such a scraper can be assembled in under an hour. Achievable by a mere mortal with a basic putty knife.</p>

		<p>However, once the size of the target web site grows beyond a few dozen pages, the technical challenges are no longer locating the salient information on each page, but the infrastructure required to process the entire site in a reasonable timeframe. This is a job for a god equipped with thunder, lightning and a transcendent putty knife.</p>

		<p>In this talk I will demonstrate how to efficiently scrape a large web site consisting of tens of thousands of pages. Specifically I'll cover the following:</p>

		<ul>
		<li> Building a simple scraper for a single page</li>
		<li> Adding threads to enable simultaneous processing of multiple pages</li>
		<li> Persisting to a database</li>
		<li> Deploying the scraper in the Cloud</li>
		<li> Building and maintaining a shared URL queue</li>
		<li> Automating the process</li>
		</ul>

		<p>These feats will be enabled by various mythic technologies including Python, Beautiful Soup, Scrapy, MySQL, Redis, Docker and AWS.</p>

		<p>A couple of caveats:</p>

		<ul>
		<li> Thor is known to exaggerate, and so the title is mildly hyperbolic. The scraper, however, will indeed be swift.</li>
		<li> Thor is all about ethics. Web scraping techniques should generally be applied with moderation. Subjecting a defenceless web server to extreme levels of traffic is a mortal sin. However, if the target site is so big as to be insensitive to the activity, then unleash the fury of the gods!</li>
		</ul>
	</div>
</div>