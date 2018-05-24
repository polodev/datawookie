---
title: 'Remote Access to Selenium on EC2'
date: 2018-08-01T09:30:00+00:00
author: Andrew B. Collier
tags: ["aws", "web scraping", "Docker"]
draft: true
---

Create an EC2 instance. Apply security groups whigh allow access on SSH (port 22) and VNC (port 5900).

Install Docker on the instance following [these instructions]({{< relref "2017-09-14-installing-docker-ubuntu.md" >}}).

On the instance:

{{< highlight text >}}
docker run -d -p 4444:4444 -p 5900:5900 selenium/standalone-chrome-debug:3.11
{{< /highlight >}}

## Viewing the Browser

You should now be able to connect to the instance using VNC. The password for logging in is `secret`. At this stage you will just see a blank screen with the Ubuntu logo.

Install R on the instance. Start R and then install the RSelenium package.

{{< highlight R >}}
install.packages("RSelenium")
{{< /highlight >}}

Load the library.

{{< highlight R >}}
library(RSelenium)
{{< /highlight >}}

Open a browser window.

{{< highlight R >}}
browser <- remoteDriver(remoteServerAddr = "localhost", port = 4445L, browserName = "chrome")
browser$open()
{{< /highlight >}}

An empty browser window should now be visible over the VNC connection.

Browse to a specific URL.

{{< highlight R >}}
browser$navigate("http://www.google.com")
{{< /highlight >}}

Bam!

## Remote Access to Selenium

What about actually driving Selenium remotely? Well, you can run Selenium on the EC2 instance by drive it from your local machine. To do this you will also have to apply a security group to your EC2 instance which allows connections on port 4444.

Now on your local machine do:

{{< highlight R >}}
library(RSelenium)

EC2INSTANCE = "ec2-54-167-202-131.compute-1.amazonaws.com"

browser <- remoteDriver(remoteServerAddr = EC2INSTANCE, port = 4444, browserName = "chrome")
browser$open()

browser$navigate("http://www.google.com")
{{< /highlight >}}

Obviously you'll need to substitute the DNS name for your EC2 instance.

How cool is that?