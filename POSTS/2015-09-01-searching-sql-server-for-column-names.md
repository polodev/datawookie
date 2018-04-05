---
author: Andrew B. Collier
categories:
- Data Science
date: 2015-09-01T11:49:28Z
excerpt_separator: <!-- more -->
id: 1976
tags:
- SQL
- SQL Server
title: Searching Database for Column Names
url: /2015/09/01/searching-sql-server-for-column-names/
---

<!--more-->

How to find a table which has a column name matching a certain pattern? I am trying to find my way around a new SQL Server database and I wanted to find all columns with the word "Default" in their name.

{{< highlight sql >}}
SELECT tables.name AS TableName, columns.name AS ColumnName
FROM
				sys.columns AS columns
INNER JOIN
				sys.tables AS tables
ON
				tables.OBJECT_ID = columns.OBJECT_ID
WHERE
				columns.name like '%Default%';
{{< /highlight >}}