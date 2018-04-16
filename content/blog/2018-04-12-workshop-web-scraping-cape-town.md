---
author: Andrew B. Collier
date: 2018-04-12T01:00:00Z
tags: ["Training"]
title: "Workshop: Web Scraping with R"
subtitle: "Cape Town (14-15 June 2018)"
---

Join Andrew Collier and Hanjo Odendaal for a workshop on using R for Web Scraping. Register <a href="https://www.quicket.co.za/events/44467-web-scraping-with-r/">here</a>.

## Who should attend?

This workshop is aimed at beginner and intermediate R users who want to learn more about using R for data acquisition and management, with a specific focus on web scraping.

## What will you learn?

You will learn:

- data manipulation with `dplyr`, `tidyr` and `purrr`;
- tools for accessing the DOM;
- scraping static sites with `rvest`;
- scraping dynamic sites with `RSelenium`; and
- setting up an automated scraper in the cloud.

See <a href="#programme">programme</a> below for further details.

<table>
	<tr>
		<th>Where</th>
		<td>-</td>
		<td><a href="https://thinkrise.com/cape-town">Rise</a>, Floor 5, Woodstock Exchange, 66 Albert Road, Woodstock, Cape Town</td>
	</tr>
	<tr>
		<th>When</th>
		<td>-</td>
		<td>14-15 June 2018</td>
	</tr>
	<tr>
		<th>Who</th>
		<td>-</td>
		<td>
			Andrew Collier<br>
			Hanjo Odendaal
		</td>
	</tr>
</table>

There are just 20 seats available. A discount is available for groups of 4 or more attendees from a single organisation. Register <a href="https://www.quicket.co.za/events/44467-web-scraping-with-r/">here</a>.

Email <a href="mailto:training@exegetic.biz?subject=Web Scraping Workshop (Cape Town) 14-15 June 2018">training@exegetic.biz</a> if you have any questions about the workshop.

## Programme

### Day 1

- Motivating Example
- R and the tidyverse
    - Vectors, Lists and Data Frames
    - Loading data from a file
    - Manipulating Data Frames with `dplyr`
    - Pivoting with `tidyr`
    - Functional programming with `purrr`
- Introduction to scraping
    - Ethics
    - DOM
    - Developer Tools
    - CSS and XPath
    - `robots.txt` and site map
- Scraping a static site with `rvest`
    - What happens under the hood
    - What the hell is `curl`?
    - Assisted Assignment: Movie information from IMDB 

### Day 2

- Case Study: Investigating drug tests using `rvest`
- Interacting with APIs
    - Using XHR to find an API
    - Building wrappers around APIs
- Scraping a dynamic site with `RSelenium`
    - Why `RSelenium` is needed
    - Navigation around web-pages
    - Combining `RSelenium` with `rvest`
    - Useful JavaScript tools
    - Case Study
- Deploying a Scraper in the Cloud
    - Launching and connecting to an EC2 instance
    - Headless browsers
    - Automation with cron