---
id: 4234
title: Running Cypher Queries from File on Windows
date: 2016-09-14T15:00:07+00:00
author: Andrew B. Collier
layout: post
guid: http://www.exegetic.biz/blog/?p=4234
excerpt_separator: <!-- more -->
categories:
  - Neo4j
tags:
  - Cypher
  - Neo4j
---
Recent packages of Neo4j for Windows do not include `neo4j-shell`. The Neo4j browser will only accept one statement at a time, making scripts consisting of multiple Cypher commands a problem.

<!-- more -->

<img src="{{ site.baseurl }}/static/img/2016/09/lazywebcypher.png" >

Have a look at [LazyWebCypher](http://www.lyonwj.com/) which will allow you to execute an arbitrary volume on Cypher code on your local Neo4j server.

There are multiple avenues to upload your script: provide a URL, select a file or simply paste the code. Then move to the other tab and hit the Import button.

Voila!
