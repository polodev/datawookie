---
author: Andrew B. Collier
date: 2018-04-12T01:00:00Z
tags: ["talk: standard"]
title: "Getting Started with Stream Analytics"
draft: true
---

{{< abstract title="Getting Started with Stream Analytics" >}}
	{{< abstract-short >}}
Setting up analytics on streaming data in real time.
	{{< /abstract-short >}}
	{{% abstract-long %}}
Big Data is supposedly characterised by large volume and high velocity. The data can originate from a variety of sources including IoT devices and sensors, web sites and social media feeds. With so much data being generated, a common approach is to simply store it for offline processing. Processing that in many instances never happens...

Wouldn't it be more efficient and effective to process the data stream as it arrives?

Azure Stream Analytics is an event-processing engine which enables processing of streaming data in real time. It can handle up to 1 Gb of data per second, which should be sufficient for most applications.

In this tutorial I'll take you through the processing of setting up a job on Azure Stream Analytics. I'll look specifically at the following:

- connecting to a data source
- extracting information (filter, sort, aggregate and join operations in a query language)
- identifying patterns and relationships
- using machine learning
- triggering actions
- feeding data to reporting tools and
- storing data for offline processing.

To illustrate these concepts we'll build a real time sentiment analysis system for streaming data from Twitter.
	{{% /abstract-long %}}
{{< /abstract >}}