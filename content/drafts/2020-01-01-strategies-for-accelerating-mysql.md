---
draft: true
title: "Strategies for Accelerating MySQL"
author: Andrew B. Collier
layout: post
categories:
  - SQL
tags:
  - MySQL
  - SQL
---

These are my notes on some strategies that I have explored for speeding up MySQL databases. The notes are based on my experience but the original ideas have been cobbled together from elsewhere.

The MySQL Documentation has an [entire chapter](https://dev.mysql.com/doc/refman/5.7/en/optimization.html) on optimisation. This is a good place to start.

For approaches specific to Django, look [here](https://docs.djangoproject.com/en/1.8/topics/db/optimization/).

## Multi-Column Indexes
