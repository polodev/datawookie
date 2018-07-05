---
title: 'Installing Spark on EC2'
date: 2017-08-23T13:00:00+00:00
author: Andrew B. Collier
excerpt_separator: <!-- more -->
layout: post
categories:
  - AWS
tags:
  - Spark
  - EC2
draft: true
---

A step-by-step tutorial on setting up a Spark cluster on an AWS EC2 instance. This is stil a work in progress and I'll be adding in additional details as and when I get more time to play with this.

<!-- more -->

<!-- http://blog.insightdatalabs.com/jupyter-on-apache-spark-step-by-step/ -->
<!-- http://blog.insightdatalabs.com/spark-cluster-step-by-step/ -->

## Spin Up an EC2 Instance

Press the <kbd class="bg-primary">Launch Instance</kbd> button in the EC2 Dashboard.

### Choose an Amazon Machine Image

Select the Ubuntu AMI.

### Choose an Instance Type

Select a `t2.large` instance type.

### Configure Instance Details

Set the number of instances to 4.

### Add Storage

Add 64 GiB storage to each of the instances.

### Add Tags

Skip.

### Configure Security Group

We'll make this very permissive for the moment by choosing "All traffic". Once the system is up and running you can clamp down on access.

Press the <kbd class="bg-primary">Review and Launch</kbd> button. Verify that everything is correct and then press <kbd class="bg-primary">Launch</kbd>.

Name the first instance `master` and the remaining instances `slave-1`, `slave-2` and `slave-3`.

## Setup SSH

Connect to the `master` node using SSH. Configure passwordless SSH login from `master` to each of `slave-1`, `slave-2` and `slave-3`.

## Install Java

On each of the nodes:

1. Install JDK.
{% highlight bash %}
sudo apt-get update
sudo apt-get install -y openjdk-8-jdk
{% endhighlight %}
{:start="2"}
2. Check JDK installation.
{% highlight bash %}
java -version
{% endhighlight %}
<!--
{:start="3"}
3. Install Hadoop.
{% highlight bash %}
wget http://apache.mirrors.tds.net/hadoop/common/hadoop-2.8.1/hadoop-2.8.1.tar.gz
sudo tar -zxvf hadoop-2.8.1.tar.gz -C /usr/local/
sudo mv /usr/local/hadoop-2.8.1/ /usr/local/hadoop/
{% endhighlight %}
-->

## Install Spark

On each of the nodes:

1. Install Scala.
{% highlight bash %}
sudo apt-get install -y scala
{% endhighlight %}
{:start="2"}
2. Check Scala installation.
{% highlight bash %}
scala -version
{% endhighlight %}
{:start="3"}
3. Install Spark.
{% highlight bash %}
wget http://apache.mirrors.tds.net/spark/spark-2.2.0/spark-2.2.0-bin-hadoop2.7.tgz
sudo tar -zxvf spark-2.2.0-bin-hadoop2.7.tgz -C /usr/local/
sudo mv /usr/local/spark-2.2.0-bin-hadoop2.7/ /usr/local/spark/
{% endhighlight %}

## Environment

On each of the nodes:

1. Add the following content to `.profile`.
{% highlight text %}
export SPARK_HOME=/usr/local/spark
export PATH=$PATH:$SPARK_HOME/bin
{% endhighlight %}
{:start="2"}
2. Source into current shell.
{% highlight bash %}
. .profile
{% endhighlight %}
{:start="3"}
3. Change the owner of the `$SPARK_HOME` folder.
{% highlight bash %}
sudo chown -R ubuntu $SPARK_HOME
{% endhighlight %}

## Configure Spark

On each of the nodes create `$SPARK_HOME/conf/spark-env.sh` with the following content:

{% highlight text %}
#!/usr/bin/env bash

export JAVA_HOME=/usr
export SPARK_PUBLIC_DNS="current_node_public_dns"
#
# Assuming 2 CPUs on each of the slaves.
#
export SPARK_WORKER_CORES=6
{% endhighlight %}

### Master Node

On the master node create `$SPARK_HOME/conf/slaves` and list the IPs of the three slave nodes.

{% highlight text %}
35.177.42.230
35.176.120.23
52.56.201.51
{% endhighlight %}

## Start Spark

On the master node start the Spark cluster.

{% highlight bash %}
$SPARK_HOME/sbin/start-all.sh
{% endhighlight %}

You should then be able to view the Spark dashboard on port 8080 using your browser.

![](/img/2017/08/aws-spark-dashboard.png)

## Stop Spark

When you are done experimenting with your Spark cluster, shut it down as follows:

{% highlight bash %}
$SPARK_HOME/sbin/stop-all.sh
{% endhighlight %}

## Installing Jupyter

On the master node:

1. Install some packages.
{% highlight bash %}
sudo apt-get install -y python-dev python-pip python-numpy python-scipy python-pandas gfortran
sudo apt-get install -y ipython-notebook
{% endhighlight %}
{:start="2"}
2. Source into current shell.
{% highlight bash %}
. .profile
{% endhighlight %}

## Spot Instances

To make this more cost effective, instead of launching an on-demand instance, consider using a spot instance instead: select Spot Requests from the EC2 Dashboard. There are a few considerations which can make spot instances a more viable option (by dimishing the chance that the instances will be terminated), but I won't be talking about those today.
