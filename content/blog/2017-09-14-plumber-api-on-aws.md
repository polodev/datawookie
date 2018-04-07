---
author: Andrew B. Collier
date: 2017-09-14T04:00:00Z
tags: ["AWS", "R", "Plumber"]
title: Hosting a Plumber API on AWS
---

<!-- Other notes on hosting at https://www.rplumber.io/docs/hosting.html. -->

<img src="/img/logo/logo-plumber.png" style="float: right; margin-left: 10px;" />

I've been putting together a small proof-of-concept API using R and [plumber](https://github.com/trestletech/plumber). It works flawlessly on my local machine and I was planning on deploying it on an EC2 instance to demo it for a client. However, I ran into a snag: despite opening the required port in my Security Group I was not able to access the API. This is what I needed to do to get it working.

<!--more-->

<!-- <div style="clear: both;"></div> -->

## This Didn't Work

I spun up an EC2 instance and applied a very liberal Security Group: access allowed on all ports from any location. Disaster from a security perspective, but flexible enough to just to get things working.

I installed R and all of the required dependencies and the started the API.

{{< highlight r >}}
> library(plumber)
> r <- plumb("api.R")
> r$run(port = 8000)
{{< /highlight >}}

Everything looking good so far.

I tested the API locally on the EC2 instance using `curl` and it worked as expected. Awesome! I felt like I was on the finishing straight.

Next I tried to access it using the browser from my local machine.

![](/img/2017/09/aws-api-connection-refused.png)

Not good. I checked to see if I could access it using `telnet`.

{{< highlight bash >}}
$ telnet ec2-54-172-17-150.compute-1.amazonaws.com 8000
Trying 54.172.17.150...
telnet: Unable to connect to remote host: Connection refused
{{< /highlight >}}

Same story. Time to do some research.

## Investigation

A combination of Google and StackOverflow (as usual) came to the rescue.

First I checked for any firewall rules that might be blocking the port.

{{< highlight bash >}}
$ sudo iptables -L
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         

Chain FORWARD (policy DROP)
target     prot opt source               destination         

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination   
{{< /highlight >}}

Nothing untoward there. Next I checked what ports were being listened on.

{{< highlight bash >}}
$ netstat -an | grep 8000
tcp        0      0 127.0.0.1:8000          0.0.0.0:*               LISTEN     
{{< /highlight >}}

Aha! So something is listening on port 8000 but only on the loopback interface. That's probably the problem.

## Fixing It

I had to rummage through the `plumber` source on GitHub to find this, but it turns out that you can specify a `host` parameter as well.

{{< highlight r >}}
> library(plumber)
> r <- plumb("api.R")
> r$run(host = "0.0.0.0", port = 8000)
{{< /highlight >}}

Let's check those ports again.

{{< highlight bash >}}
ubuntu@ip-172-31-59-224:~$ netstat -an | grep 8000
tcp        0      0 0.0.0.0:8000            0.0.0.0:*               LISTEN      
{{< /highlight >}}

The API should now be visible outside of `localhost`.

## Success

This small change made all the difference. The API now works perfectly from the EC2 instance.

Note to self (again!): what works locally might very well not work when deployed.