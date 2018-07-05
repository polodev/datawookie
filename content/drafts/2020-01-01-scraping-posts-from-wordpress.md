---
draft: true
title: "Scraping Post Images from a Wordpress Blog"
author: Andrew B. Collier
layout: post
tags:
  - WordPress
  - Jekyll
  - R
  - RSelenium
  - rvest
  - webshot
---

I'm in the process of migrating my blog from WordPress to Jekyll. I've already exported the blog contents using the [WordPress to Jekyll Exporter](https://wordpress.org/plugins/jekyll-exporter/). The results are pretty good, but it seems that quite a bit of the formatting that I had on WordPress has been lost in the process.

I need to decommission the WordPress site quite soon because my hosting agreement is coming to an end. It'd be handy to have a visual record of what each of the pages looked like. So I set out to grab an image of each of those pages. I could have done that by hand using something like the [Full Page Screen Capture](http://mrcoles.com/full-page-screen-capture-chrome-extension/) extension for Chrome. But there are 265 posts... nobody has time for that kind of tedium.

This kind of routine task is an ideal candidate for automation. There are no doubt a bundle of ways to skin this particular cat, but I chose to do it in R using `RSelenium`, `rvest` and `webshot`.

First we'll fire up `RSelenium` and launch a browser window.

{% highlight r %}
> library(RSelenium)
> startServer()
> browser <- remoteDriver(browserName = "chrome")
> browser$open()
{% endhighlight %}

Then we'll cycle through each of the index pages on the blog and grab the links to the individual posts. The parsing and extraction from the index pages was done with `rvest`. I could have made this part more general, but since I was only planning on doing this once I was not too worried about hard coding the number of pages (which a quick inspection of the site told me was 27).

{% highlight r %}
> library(rvest)
> links <- lapply(1:27, function(page) {
+     browser$navigate(sprintf("http://www.exegetic.biz/blog/page/%d/", page))
+     read_html(browser$getPageSource()[[1]]) %>% html_nodes("h1 > a") %>% html_attr("href")
+ })
> links <- do.call(c, links)
{% endhighlight %}

At this stage `links` contained a vector of URLs for each of the posts. I then cycled through them usin the [webshot package](https://github.com/wch/webshot) to grab the screenshots.

{% highlight r %}
> devtools::install_github("wch/webshot")
> library(webshot)

> for (link in links) {
+   basename = gsub("/", "-", sub("/$", "", sub("http://www.exegetic.biz/blog/", "", link)))
+   webshot(link, paste0(basename, ".png"))
+ }
{% endhighlight %}

Here's an example of one of those screenshots.

<img src="{{ site.baseurl }}/static/img/2017/03/screenshot-clustering-the-words-of-william-shakespeare.png" >