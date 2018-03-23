---
title: "Restoring a Django Backup"
date: 2018-02-23T10:00:00+00:00
author: Andrew B. Collier
excerpt_separator: <!-- more -->
layout: post
tags:
  - Django
---

It took me a little while to figure out the correct sequence for restoring a Django backup. If you have borked your database, this is how to put it back together.

<!-- more -->

1. Drop the old database.
2. Create a new database.
3. `python manage.py migrate`. Build all of the tables. Nothing in them yet though!
4. `python manage.py dbrestore`. Retrieve the data and insert it into appropriate tables.

And you're back! It seems pretty trivial, but I hit my head against this a number of times and got very frustrated when things just wouldn't work. Follow this recipes and you're good.