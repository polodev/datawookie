---
author: Andrew B. Collier
date: 2018-04-12T01:00:00Z
tags: ["talk: standard"]
title: "Wading into Stream Analytics"
draft: true
---

https://twitter.com/unspiced/status/1017417780864454657/photo/1

<!-- ========================================================================================== -->
<!-- OPTION 1: AZURE                                                                            -->
<!-- ========================================================================================== -->

{{< abstract title="Wading into Stream Analytics" >}}
	{{< abstract-short >}}
Setting up analytics on streaming data in real time.
	{{< /abstract-short >}}
	{{% abstract-long %}}
Large volumes of data originate at high velocity from various sources including IoT devices and sensors, web sites and social media feeds. A common approach is to simply store these data for offline processing.

Processing that in many instances never happens...

Wouldn't it be more efficient and effective to process the data stream as it arrives?

Azure Stream Analytics is an event-processing engine which enables processing of streaming data in real time. It can handle up to 1 Gb of data per second, which should suffice for most applications.

In this tutorial I'll take you through the processing of setting up a job on Azure Stream Analytics. I'll look specifically at the following:

- connecting to a data source
- extracting information (filter, sort, aggregate and join operations in a query language)
- identifying patterns and relationships
- using machine learning
- triggering actions
- feeding data to reporting tools and
- storing data for offline processing.

To illustrate these concepts we'll build a real time sentiment analysis system for streaming data from Twitter.

This talk can be based on either of the following technologies:

- [Azure Stream Analytics](https://azure.microsoft.com/en-us/services/stream-analytics/)
- [Azure Databricks](https://databricks.com/product/azure)
	{{% /abstract-long %}}
{{< /abstract >}}

<!-- ========================================================================================== -->
<!-- OPTION 2: AWS/SPARK/KAFKA                                                                  -->
<!-- ========================================================================================== -->

{{< abstract title="Wading into Stream Analytics" >}}
	{{< abstract-short >}}
	{{< /abstract-short >}}
	{{% abstract-long %}}
{{< /abstract >}}

<!-- ========================================================================================== -->
<!-- OUTLINE: AZURE                                                                             -->
<!-- ========================================================================================== -->

<!-- ========================================================================================== -->
<!-- OUTLINE: AWS/SPARK/KAFKA                                                                   -->
<!-- ========================================================================================== -->

These are some notes for a talk on getting started with streaming data. The talk takes the form of a demonstration using [Kafka](https://kafka.apache.org/) and [Spark](https://spark.apache.org/) on [Amazon Web Services](https://aws.amazon.com/) (AWS) with some [Docker](https://www.docker.com/), Python and [Jupyter](http://jupyter.org/) thrown in for good measure.

## AWS Overview

A quick, high level overview of AWS. How to launch a remote instance and connect via SSH.

## Spark Cluster

There are a couple of ways to launch a Spark cluster on AWS. I'll be using [Flintrock](https://github.com/nchammas/flintrock).

1. Look at configuration file.
2. Create a cluster.

	{{< highlight bash >}}
flintrock launch spark
{{< /highlight >}}

3. Use EC2 console to confirm that instances have been launched.
4. Take a look at the Security Groups.
5. Open the Spark UI (port 8080 on the master).
6. Install Python and missing JARs on cluster.
7. Install Docker.
8. Pull and run PySpark notebook. Pulling the image will take a little time, so we can set up Kafka in the meantime.

	{{< highlight bash >}}
docker pull datawookie/pyspark-notebook
docker run -d --name jupyter --net=host --user 500 -v $PWD:/home/jovyan/ datawookie/pyspark-notebook
docker logs jupyter
{{< /highlight >}}

9. Ensure that port 8888 is open. Browse to the Jupyter URL.

## Kafka

1. Launch an EC2 instance (a `t2.micro` with Ubuntu 16.04 will be fine).
2. Ensure that port 9092 is open.
3. Install the Java Developmen Kit (JDK).
4. Download Kafka distribution.
5. Unpack.
6. Change logging level and tweak configuration.
7. Start ZooKeeper and Kafka servers.
8. Create a topic.
9. Launch `tmux` and demonstrate producer and consumer in terminal.
10. Exit producer.

## Streaming Tweets

1. Script to stream tweets.
2. Script to push tweet contents to Kafka. Check consumer in terminal.
3. Notebooks for consuming tweet content. Sentiment analysis.
4. Script to push tweets as JSON to Kafka.
5. Notebook for consuming tweet JSON.
