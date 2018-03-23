---
id: 4228
title: Remote Access to Neo4j on Windows
date: 2016-09-13T15:00:13+00:00
author: Andrew B. Collier
layout: post
guid: http://www.exegetic.biz/blog/?p=4228
excerpt_separator: <!-- more -->
categories:
  - Neo4j
tags:
  - Neo4j
  - Windows
---

<!-- more -->

Accessing the Neo4j server running on your local machine is simple: just point your browser to http://localhost:7474/. But with the default configuration the server is not accessible from other machines. This means that other folk can share in the wonder of your nodes edges.

Enabling remote access is simple.

1. Shut down your running Neo4j server. 
2. Press the Options button, which will bring up a dialog like this:

<img src="{{ site.baseurl }}/static/img/2016/09/neo4j-options.png" >

3. Press the top Edit button, which will open the `neo4j.conf` file in an editor. 
4. Browse to the HTTP Connector section and add a `dbms.connector.http.address` entry.

{% highlight text %}
# HTTP Connector
#
dbms.connector.http.type=HTTP
dbms.connector.http.enabled=true
#
# dbms.connector.http.address=0.0.0.0:#{default.http.port}
dbms.connector.http.address=0.0.0.0:7474
{% endhighlight %}

Your server will now be available to other machines via port 7474. From the local machine it'll still be at `http://localhost:7474/`.

The above solution works (at least) for Neo4j 3.0.4.
