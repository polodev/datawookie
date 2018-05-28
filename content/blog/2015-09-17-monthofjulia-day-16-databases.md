---
author: Andrew B. Collier
date: 2015-09-17T16:00:55Z
tags: ["Julia"]
title: 'MonthOfJulia Day 16: Databases'
---

<!--more-->

<img src="/img/2015/09/Julia-Logo-Database.png">

[Yesterday](http://www.exegetic.biz/blog/2015/09/monthofjulia-day-15-time-series/) we looked at how time series data can be sucked into Julia from [Quandl](https://www.quandl.com/). What happens if your data are sitting in a database? No problem, Julia can handle that too. There are a number of database packages available. I'll be focusing on [`SQLite`](https://github.com/quinnj/SQLite.jl) and [`ODBC`](https://github.com/quinnj/ODBC.jl), but it might be worthwhile checking out [`JDBC`](https://github.com/aviks/JDBC.jl), [`LevelDB`](https://github.com/jerryzhenleicai/LevelDB.jl) and [`LMDB`](https://github.com/wildart/LMDB.jl) too.

## SQLite

[SQLite](https://www.sqlite.org/) is a lightweight transactional SQL database engine that does not require a server or any major configuration. [Installation](https://www.sqlite.org/download.html) is straightforward on most platforms.

The first step towards using SQLite from Julia is to load the package.

{{< highlight julia >}}
julia> using SQLite
{{< /highlight >}}

Next, for illustrative purposes, we'll create a database (which exists as a single file in the working directory) and add a table which we'll populate directly from a delimited file.

{{< highlight julia >}}
julia> db = SQLiteDB("passwd.sqlite")
SQLiteDB{UTF8String}("passwd.sqlite",Ptr{Void} @0x00000000059cde38,0)
julia> create(db, "passwd", readdlm("/etc/passwd", ':'), ["username", "password", "UID", "GID",
                                                          "comment", "homedir", "shell"])
1x1 ResultSet
| Row | "Rows Affected" |
|-----|-----------------|
| 1   | 0               |
{{< /highlight >}}

Then the interesting bit: we execute a simple query.

{{< highlight julia >}}
julia> query(db, "SELECT username, homedir FROM passwd LIMIT 10;")
10x2 ResultSet
| Row | "username" | "homedir"         |
|-----|------------|-------------------|
| 1   | "root"     | "/root"           |
| 2   | "daemon"   | "/usr/sbin"       |
| 3   | "bin"      | "/bin"            |
| 4   | "sys"      | "/dev"            |
| 5   | "sync"     | "/bin"            |
| 6   | "games"    | "/usr/games"      |
| 7   | "man"      | "/var/cache/man"  |
| 8   | "lp"       | "/var/spool/lpd"  |
| 9   | "mail"     | "/var/mail"       |
| 10  | "news"     | "/var/spool/news" |
{{< /highlight >}}

Most of the expected SQL operations are supported by SQLite (check the [documentation](https://www.sqlite.org/docs.html)) and hence also by the Julia interface. When we're done we close the database connection.

{{< highlight julia >}}
julia> close(db)
{{< /highlight >}}

Of course, the database we created in Julia is now available through the shell too.

{{< highlight bash >}}
colliera@propane:~/proj/Z-212-language-julia/src$ ls -l passwd.sqlite
-rw-r-r- 1 colliera colliera 6144 Sep 18 07:21 passwd.sqlite
colliera@propane:~/proj/Z-212-language-julia/src$ sqlite3 passwd.sqlite
SQLite version 3.8.7.4 2014-12-09 01:34:36
Enter ".help" for usage hints.
sqlite> pragma table_info(passwd);
0|username|TEXT|0||0
1|password|TEXT|0||0
2|UID|REAL|0||0
3|GID|REAL|0||0
4|comment|TEXT|0||0
5|homedir|TEXT|0||0
6|shell|TEXT|0||0
sqlite>
{{< /highlight >}}

## ODBC

If you need to access an enterprise DB (for example, Oracle, PostgreSQL, MySQL, Microsoft SQL Server or DB2) then the [ODBC](https://en.wikipedia.org/wiki/Open_Database_Connectivity) interface will be the way to go. To avoid the overhead of using one of these fancy DBs, I will demonstrate Julia's ODBC functionality using the SQLite database we created above. Before we do that though, you'll need to [setup ODBC for SQLite](http://wp.me/p3pzmk-Ag). It's not an onerous procedure at all. Then we fire up the `ODBC` package and we're ready to roll.

{{< highlight julia >}}
julia> using ODBC
{{< /highlight >}}

First we'll check which drivers are available for ODBC (just SQLite in my case) and what [data source names](https://en.wikipedia.org/wiki/Data_source_name) (DSNs) are registered.

{{< highlight julia >}}
julia> listdrivers()
(String["SQLite","SQLite3"],String["Description=SQLite ODBC Driver\0Driver=libsqliteodbc.so\0Setup=libsqliteodbc.so\0UsageCount=1\0","Description=SQLite3 ODBC Driver\0Driver=libsqlite3odbc.so\0Setup=libsqlite3odbc.so\0UsageCount=1\0"])
julia> listdsns()
(String["passwd"],String["SQLite3"])
{{< /highlight >}}

We see that there is a DSN available for the `passwd` database. So we create a connection:

{{< highlight julia >}}
julia> db = ODBC.connect("passwd")
ODBC Connection Object
----------------------
Connection Data Source: passwd
passwd Connection Number: 1
Contains resultset(s)? No
{{< /highlight >}}

At this point I'd like to execute a query. However, somewhat disappointingly, this doesn't work. No error message but also no results. I've logged an [issue](https://github.com/quinnj/ODBC.jl/issues/96) with the package maintainer, so hopefully this will be resolved soon.

{{< highlight julia >}}
julia> query("SELECT * FROM passwd LIMIT 5;", db)
0x0 DataFrame
{{< /highlight >}}

What's promising though is that I can still retrieve the metadata for that query.

{{< highlight julia >}}
julia> querymeta("SELECT * FROM passwd LIMIT 5;", db)
Resultset metadata for executed query
-------------------------------------
Query: SELECT * FROM passwd LIMIT 5
Columns: 7
Rows: 0
7x5 DataFrame
| Row | Names      | Types                  | Sizes | Digits | Nullable |
|-----|------------|------------------------|-------|--------|----------|
| 1   | "username" | ("SQL_LONGVARCHAR",-1) | 65536 | 0      | 1        |
| 2   | "password" | ("SQL_LONGVARCHAR",-1) | 65536 | 0      | 1        |
| 3   | "UID"      | ("SQL_DOUBLE",8)       | 54    | 0      | 1        |
| 4   | "GID"      | ("SQL_DOUBLE",8)       | 54    | 0      | 1        |
| 5   | "comment"  | ("SQL_LONGVARCHAR",-1) | 65536 | 0      | 1        |
| 6   | "homedir"  | ("SQL_LONGVARCHAR",-1) | 65536 | 0      | 1        |
| 7   | "shell"    | ("SQL_LONGVARCHAR",-1) | 65536 | 0      | 1        |
{{< /highlight >}}

Again, when we're done, we close the database connection.

{{< highlight julia >}}
julia> disconnect(db)
{{< /highlight >}}

We're now covered a number of means for getting data into Julia. Over the next few days we'll be looking at Julia's capabilities for analysing data. Stay tuned. In the meantime you can check out the code for today (and previous days) on [github](https://github.com/DataWookie/MonthOfJulia). Take a look at the talk below. Also, there's a great [tutorial on working with SQLite](https://www.guru99.com/sqlite-tutorial.html), which is well worth looking at.

<iframe width="560" height="315" src="https://www.youtube.com/embed/IvOFVQgLDgg" frameborder="0" allowfullscreen></iframe>
