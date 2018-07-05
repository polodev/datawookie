---
title: 'Installing Spark on AWS'
date: 2017-08-25T09:00:00+00:00
author: Andrew B. Collier
excerpt_separator: <!-- more -->
layout: post
categories:
  - AWS
tags:
  - Spark
  - S3
  - EC2
draft: true
---

A step-by-step tutorial on setting up a Spark cluster on AWS. This is stil a work in progress and I'll be adding in additional details as and when I get more time to play with this.

<!-- more -->

![](/img/logo/logo-spark.png)

<!-- http://holowczak.com/getting-started-with-apache-spark-on-aws/ -->

## Create a SSH Keypair

Create a AWS account at https://aws.amazon.com/ and login.

From the Service dropdown select EC2. In the Network & Security section choose Key Pairs. Press the Create Key Pair button. Give it a suitable name. A `.pem` file will automatically be downloaded. Ensure that only your user has access rights to this file and store it somewhere secure!

## Create a S3 Storage Bucket

From the Service dropdown select S3. Click the Create Bucket button.

1. Give the bucket a suitable name (this needs to be unique!). Keep the default region for the moment. Press the Create button.
2. Leave all properties in their default state for the moment.
3. Keep the default permissions for the moment.
4. On the Review tab press the Create bucket button.

![](/img/2017/07/aws-s3-bucket.png)

## Create Folders in the S3 Storage Bucket

Select the newly created bucket.

1. Press the Create folder button.
2. Name the new folder "data" and press Save.
3. Create folders named "output" and "logs".

![](/img/2017/07/aws-s3-folders.png)

## Upload data

1. Select the "data" folder.
2. Press the Upload button.
3. Select a CSV file for upload. Wait a moment while the data are shipped to your bucket.

These data are now stored on HDFS.

![](/img/2017/07/aws-s3-iris.png)

## Elastic MapReduce

### Default Setup

From the Service dropdown select EMR.

![](/img/2017/07/aws-emr-create-cluster-quick-options.png)

1. Click the <kbd class="bg-primary">Create cluster</kbd> button.
2. Give it an appropriate name.
3. Enable logging.
4. In the Software configuration section, choose the most recent release of EMR (selected by default) and then select the Spark application.
5. Choose the key pair that was created above.
6. Press the <kbd class="bg-primary">Create cluster</kbd> button.

You can monitor the status of your cluster. You need to wait for provisioning to take place, which can take a few minutes. While you are waiting for that you can update the Security Group of the master node.

### Updating Security Group

Click on the link for editing the security group for the master node. You might find that all of the rules are attached to specific addresses. This will make it hard for you to connect! You'll need to ensure that there's a SSH rule that allows inbound connections on port 22 from anywhere.

### Custom Setup

By default the EMR setup above will give you the following technologies:

- Zeppelin
- Ganglia and
- Spark.

If you want to mix in something else then you need to click the "Go to advanced options" link at the beginning of the setup process and manually select the components you need. You might consider adding the following:

- Hadoop
- Tex
- Pig
- Hive
- Mahout.

You might also want to customise your hardware configuration. By default you'll probably be getting `m4.large` or `m3.xlarge` nodes. This might be overkill (and expensive!) if you are just experimenting. You can change this to something more conservative.

## Connect using SSH

Wait for all of the nodes to be marked as <span style="color: green;">Running</span>.

![](/img/2017/07/aws-emr-status.png)

### Connecting

Find the Master public DNS entry (highlighted in the image above). Use the `.pem` file that you downloaded earlier to connect using SSH. You'll be logging in as the `hadoop` user.

{% highlight bash %}
$ ssh -i ~/SparkTest.pem hadoop@ec2-34-229-219-107.compute-1.amazonaws.com
{% endhighlight %}

Check that the data are accessible from S3.

{% highlight bash %}
$ aws s3 ls s3://exegetic-bucket/data/
{% endhighlight %}

## Adding More Data to S3.

1. You can download data using wget or curl.
2. These data can then be copied to S3.

{% highlight bash %}
$ aws s3 cp new-data.csv s3://exegetic-bucket/data/
{% endhighlight %}

## Spark SQL

Launch the Spark SQL client.

{% highlight bash %}
$ spark-sql
{% endhighlight %}

The `spark-sql` client can be a little noisy, spewing out a ream of log messages. We'd like to reduce the noise. First exit back to the shell with <kbd>Ctrl</kbd>-<kbd>d</kbd>. Then create a `.log4j.properties` file and add the following:

{% highlight text %}
# Set everything to be logged to the console
log4j.rootCategory=WARN, console
log4j.appender.console=org.apache.log4j.ConsoleAppender
log4j.appender.console.target=System.err
log4j.appender.console.layout=org.apache.log4j.PatternLayout
log4j.appender.console.layout.ConversionPattern=%d{yy/MM/dd HH:mm:ss} %p %c{1}: %m%n

# Settings to quiet third party logs that are too verbose
log4j.logger.org.eclipse.jetty=WARN
log4j.logger.org.eclipse.jetty.util.component.AbstractLifeCycle=ERROR
log4j.logger.org.apache.spark.repl.SparkIMain$exprTyper=WARN
log4j.logger.org.apache.spark.repl.SparkILoop$SparkILoopInterpreter=WARN
{% endhighlight %}

Now restart using this configuration. There will still be some messages, but they will have been decimated.

{% highlight bash %}
$ spark-sql --driver-java-options "-Dlog4j.configuration=file:///home/hadoop/.log4j.properties"
{% endhighlight %}

That's a bit of a handful, so you might want to create a shell alias.

Now we are going to create a table and populate it with the data from `iris.csv` by running the following SQL:

{% highlight sql %}
CREATE EXTERNAL TABLE iris
(
    sepal_length    FLOAT,
    sepal_width     FLOAT,
    petal_length    FLOAT,
    petal_width     FLOAT,
    species         CHAR(10)
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
LOCATION 's3://exegetic-bucket/data/';
{% endhighlight %}

Note that the `LOCATION` clause must point to the appropriate location on S3.

We can check on the structure and contents of the table we've created.

{% highlight sql %}
spark-sql> DESCRIBE iris;
sepal_length    float   NULL
sepal_width     float   NULL
petal_length    float   NULL
petal_width     float   NULL
species         string  NULL
Time taken: 0.165 seconds, Fetched 5 row(s)
spark-sql> SELECT COUNT(*) FROM iris;
151
Time taken: 0.708 seconds, Fetched 1 row(s)
{% endhighlight %}

Find out more about [Spark SQL](http://spark.apache.org/sql/) and check out the [Spark SQL, DataFrames and Datasets Guide](http://spark.apache.org/docs/latest/sql-programming-guide.html).

## Spark SQL

If you press on the <kbd>AWS CLI export</kbd> button you'll get a shell script which can be used to spin up a similar cluster from the command line.

## Installing JupyterHub

THIS DOESN'T WORK YET.

Edit `/etc/profile` to ensure that `/usr/local/bin/` is in the `root` user's `PATH`.

{% highlight bash %}
sudo yum install nodejs npm --enablerepo=epel
sudo npm install -g configurable-http-proxy
{% endhighlight %}

{% highlight bash %}
sudo pip-3.4 install jupyterhub
{% endhighlight %}

Make links for the JupyterHub executables.

{% highlight bash %}
sudo /bin/bash
cd /usr/bin/
ln -s /usr/local/bin/jupyterhub
ln -s /usr/local/bin/jupyterhub-singleuser
{% endhighlight %}

{% highlight bash %}
sudo jupyterhub --port 8000
{% endhighlight %}

You'll need to make sure that port 8000 is open to inbound connections by editing the Security Group for the master node.

## Connecting with Port Forwarding

On local machine create a SSH tunnel. The machine name below is the public DNS for the master node.

ssh -i ~/Downloads/datawookie-sydney.pem -N \
    -L 8157:ec2-54-153-204-122.ap-southeast-2.compute.amazonaws.com:8088 \
    hadoop@ec2-54-153-204-122.ap-southeast-2.compute.amazonaws.com

Then browse to http://localhost:8157/

## Cleaning Up

It's important that you terminate your EMR cluster once you are finished with it, otherwise Amazon will keep on billing you. Note that any data stored on the cluster will be lost when it's terminated, so you need to move anything that you want to keep across onto S3.

Of course you're also going to be charged for storage on S3, so if you no longer need a bucket, go ahead and delete it.
