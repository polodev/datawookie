---
author: Andrew B. Collier
categories:
- Python
date: 2017-07-04T10:30:00Z
excerpt_separator: <!-- more -->
tags:
- Jupyter
- Spark
title: Accessing PySpark from a Jupyter Notebook
url: /2017/07/04/pyspark-in-jupyter-notebooks/
---

It'd be great to interact with PySpark from a Jupyter Notebook. This post describes how to get that set up. <!--more--> It assumes that you've installed Spark like [this]({{ site.baseurl }}{% post_url 2017-07-04-installing-spark-ubuntu %}).

<!-- https://spark.apache.org/docs/0.9.0/python-programming-guide.html -->
<!-- https://blog.sicara.com/get-started-pyspark-jupyter-guide-tutorial-ae2fe84f594f -->

1. Install the `findspark` package.
{{< highlight bash >}}
$ pip3 install findspark
{{< / highlight >}}
{:start="2"}
2. Make sure that the `SPARK_HOME` environment variable is defined
3. Launch a Jupyter Notebook.
{{< highlight bash >}}
$ jupyter notebook
{{< / highlight >}}
{:start="4"}
4. Import the `findspark` package and then use `findspark.init()` to locate the Spark process and then load the `pyspark` module. See below for a simple example.

![]({{ site.baseurl }}/static/img/2017/07/ubuntu-pyspark-test.png)
