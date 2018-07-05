---
draft: true
title: 'Django: Dumping Data'
author: andrew
type: post
date: 2016-09-24T15:00:13+00:00
categories:
  - Django
  - Uncategorized
tags:
  - backup
  - Database
  - Django
  - JSON

---
Keeping a backup of the valuable data you have acquired with your Django application is vital. There are a couple of ways to do this. Most of the supported databases come with tools for dumping the contents of tables. However we can also use `manage.py` to generate a copy of the data which is independent of the database being used.

[code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
$ python3 manage.py dumpdata &#8211;exclude auth.permission &#8211;exclude contenttypes &#8211;exclude admin.LogEntry &#8211;indent 2 >db.json

The data are dumped in JSON format. The `--indent 2` option just makes the contents of the file easier on the eye, but if you&#8217;re not planning on reading the contents then this can be dispensed with. The `--exclude` option can be used to select one or more components of the data which should not be included in the dump.
