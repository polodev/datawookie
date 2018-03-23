---
id: 4244
title: Deleting All Nodes and Relationships
date: 2016-09-15T15:00:55+00:00
author: Andrew B. Collier
layout: post
guid: http://www.exegetic.biz/blog/?p=4244
categories:
  - Neo4j
tags:
  - Cypher
  - Neo4j
---
Seems that I am doing this a lot: deleting my entire graph (all nodes and relationships) and rebuilding from scratch. I guess that this is part of the learning process.

<img src="{{ site.baseurl }}/static/img/2016/09/sample-graph.png" >

## Route 1: Delete Relationships then Nodes

A relationship is constrained to join a start node to an end node. Every relationship must be associated with at least one node (a relationship may begin and end on the same node). No such constraint exists for nodes. As a result relationships must be deleted before nodes are deleted.

Delete all relationships using either
  
{% highlight text %}
$ START r = RELATIONSHIP(*) DELETE r;
{% endhighlight %}
or
{% highlight text %}
$ MATCH ()-[r]-() DELETE r;
{% endhighlight %}
  
Then delete the nodes with
  
{% highlight text %}
$ MATCH (n) DELETE n;
{% endhighlight %}

## Route 2: Detach and Delete

Using `DETACH DELETE` it's possible to delete relationships and nodes at once.
  
{% highlight text %}
$ MATCH (n) DETACH DELETE n;
{% endhighlight %}

## Check

Confirm that all nodes and relationships have gone.
  
{% highlight text %}
$ MATCH (n) RETURN COUNT(n);
$ MATCH ()-[r]->() RETURN COUNT(r);
{% endhighlight %}
  
Or, alternatively:
  
{% highlight text %}
$ START n = NODE(*) return COUNT(n);  
$ START r = RELATIONSHIP(*) return COUNT(r);
{% endhighlight %}
