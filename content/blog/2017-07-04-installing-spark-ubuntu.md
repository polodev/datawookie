---
author: Andrew B. Collier
date: 2017-07-04T09:30:00Z
tags: ["Linux", "Spark"]
title: Installing Spark on Ubuntu
---

I'm busy experimenting with Spark. This is what I did to set up a local cluster on my Ubuntu machine. Before you embark on this you should first [set up Hadoop]({{< relref "2017-07-04-installing-hadoop-ubuntu.md" >}}).


<!--more-->

<!-- http://spark.apache.org/docs/latest/spark-standalone.html -->

1. Download the latest release of Spark [here](https://spark.apache.org/downloads.html).
2. Unpack the archive.
  {{< highlight bash >}}
$ tar -xvf spark-2.1.1-bin-hadoop2.7.tgz
{{< /highlight >}}
3. Move the resulting folder and create a symbolic link so that you can have multiple versions of Spark installed.
  {{< highlight bash >}}
$ sudo mv spark-2.1.1-bin-hadoop2.7 /usr/local/
$ sudo ln -s /usr/local/spark-2.1.1-bin-hadoop2.7/ /usr/local/spark
$ cd /usr/local/spark
{{< /highlight >}}
Also add `SPARK_HOME` to your environment.
{{< highlight bash >}}
$ export SPARK_HOME=/usr/local/spark
{{< /highlight >}}
4. Start a standalone master server. At this point you can browse to <http://127.0.0.1:8080/> to view the status screen.
  {{< highlight bash >}}
$ $SPARK_HOME/sbin/start-master.sh
{{< /highlight >}}
![](/img/2017/07/ubuntu-spark-master-interface.png)
5. Start a worker process.
  {{< highlight bash >}}
$ $SPARK_HOME/sbin/start-slave.sh spark://ethane:7077
{{< /highlight >}}
To get this to work I had to make an entry for my machine in `/etc/hosts`:
{{< highlight text >}}
127.0.0.1 ethane
{{< /highlight >}}
6. Test out the Spark shell. You'll note that this exposes the native [Scala](https://www.scala-lang.org/) interface to Spark.
  {{< highlight bash >}}
$ $SPARK_HOME/bin/spark-shell
{{< /highlight >}}
{{< highlight text >}}
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /___/ .__/\_,_/_/ /_/\_\   version 2.1.1
      /_/
         
Using Scala version 2.11.8 (OpenJDK 64-Bit Server VM, Java 1.8.0_131)
Type in expressions to have them evaluated.
Type :help for more information.

scala> println("Spark shell is running")
Spark shell is running

scala> 
{{< /highlight >}}
<p>To get this to work properly it might be necessary to first set up the path to the Hadoop libraries.</p>
{{< highlight bash >}}
$ export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/hadoop/lib/native
{{< /highlight >}}
7. Maybe Scala is not your cup of tea and you'd prefer to use Python. No problem!
  {{< highlight bash >}}
$ $SPARK_HOME/bin/pyspark
{{< /highlight >}}
{{< highlight text >}}
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /__ / .__/\_,_/_/ /_/\_\   version 2.1.1
      /_/

Using Python version 2.7.13 (default, Jan 19 2017 14:48:08)
SparkSession available as 'spark'.
>>> 
{{< /highlight >}}
Of course you'll probably want to interact with Python via a Jupyter Notebook, in which case take a look at [this]({{< relref "2017-07-04-pyspark-in-jupyter-notebooks.md" >}}).
8. Finally, if you prefer to work with R, that's also catered for.
  {{< highlight bash >}}
$ $SPARK_HOME/bin/sparkR
{{< /highlight >}}
{{< highlight text >}}
 Welcome to
    ____              __ 
   / __/__  ___ _____/ /__ 
  _\ \/ _ \/ _ `/ __/  '_/ 
 /___/ .__/\_,_/_/ /_/\_\   version  2.1.1 
    /_/ 


 SparkSession available as 'spark'.
> spark
Java ref type org.apache.spark.sql.SparkSession id 1 
> 
{{< /highlight >}}
This is a light-weight interface to Spark from R. To find out more about sparkR, check out the documentation [here](http://spark.apache.org/docs/latest/sparkr.html). For a more user friendly experience you might want to look at [sparklyr](http://spark.rstudio.com/).
9. When you are done you can shut down the slave and master Spark processes.
{{< highlight bash >}}
$ $SPARK_HOME/sbin/stop-slave.sh
$ $SPARK_HOME/sbin/stop-master.sh
{{< /highlight >}}