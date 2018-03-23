---
id: 1976
title: Searching Database for Column Names
date: 2015-09-01T11:49:28+00:00
author: Andrew B. Collier
layout: post
excerpt_separator: <!-- more -->
categories:
  - Data Science
tags:
  - SQL
  - SQL Server
---

<!-- more -->

How to find a table which has a column name matching a certain pattern? I am trying to find my way around a new SQL Server database and I wanted to find all columns with the word "Default" in their name.

{% highlight sql %}
SELECT tables.name AS TableName, columns.name AS ColumnName
FROM
				sys.columns AS columns
INNER JOIN
				sys.tables AS tables
ON
				tables.OBJECT_ID = columns.OBJECT_ID
WHERE
				columns.name like '%Default%';
{% endhighlight %}