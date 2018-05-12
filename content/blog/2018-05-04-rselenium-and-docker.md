---
author: Andrew B. Collier
date: 2018-05-04T07:00:00Z
tags: ["R", "web scraping"]
title: "RSelenium and Docker"
draft: true
---

# https://github.com/ropensci/RSelenium/blob/master/vignettes/RSelenium-docker.Rmd

# 1. Download image from https://hub.docker.com/u/selenium/.
#
# - For each image look at Tags to see what versions are available.
# - $ docker pull selenium/standalone-firefox:3.11
# - $ docker pull selenium/standalone-chrome:3.11
# - $ docker pull selenium/standalone-firefox-debug:3.11
# - $ docker pull selenium/standalone-chrome-debug:3.11
# - The debug images will allow you to connect to the container and view the browser window.
#
# 2. Start container and check that it is running.
#
# - docker run -d -p 4445:4444 selenium/standalone-firefox:3.11
# - docker ps

I am glad we are getting some responses in. I heard back from UCT and although they wont be able to help students fund entries, they are willing to post an ad for us on their Vula site. So lets hope that helps. I also mentioned that if they can get a group together, they must contact us for special academic pricing.

In terms of browsing, the easiest is to use the XXX-debug docker images + TightVNC and expose the correct ports on 0.0.0.0. You then 'SSH' into the container and voila, easy to then pickup why things aren't working. This is my go to:









library(RSelenium)
remDr <- remoteDriver(port = 4445L)
remDr$open()

library(RSelenium)

BROWSER_OPTIONS = list(
  chromeOptions = list(
    args = c(
      '--disable-gpu',
      '--window-size=800,1200'),
    prefs = list(
      "profile.default_content_settings.popups" = 0L,
      "download.prompt_for_download" = FALSE,
      "download.default_directory" = "/tmp",
      "marionette" = TRUE
    )
  )
)

TIMEOUT = 30000

# Fire up the server.
#
driver <- rsDriver(browser = "chrome", extraCapabilities = BROWSER_OPTIONS)
#
# Instantiate the browser.
#
web <- driver[["client"]]

# How long to wait for elements to appear.
#
# Have a relatively large value here. However, once the page is fully rendered you can (temporarily) shorten the
# timeout to make it more efficient.
#
web$setImplicitWaitTimeout(TIMEOUT)