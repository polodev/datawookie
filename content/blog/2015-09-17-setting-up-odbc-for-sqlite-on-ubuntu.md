---
author: Andrew B. Collier
date: 2015-09-17T05:39:01Z
tags: ["Linux", "SQLite"]
title: Setting up ODBC for SQLite on Ubuntu
---

First install the SQLiteODBC and unixODBC packages. Have a quick look at the documentation for [unixODBC](http://www.unixodbc.org/odbcinst.html) and [SQLiteODBC](http://ch-werner.de/sqliteodbc/html/index.html).

<!--more-->

{{< highlight bash >}}
$ sudo apt-get install libsqliteodbc unixodbc
{{< /highlight >}}

After the install you'll have a a `/etc/odbcinst.ini` file which will look something like this:

{{< highlight text >}}
[SQLite]
Description=SQLite ODBC Driver
Driver=libsqliteodbc.so
Setup=libsqliteodbc.so
UsageCount=1

[SQLite3]
Description=SQLite3 ODBC Driver
Driver=libsqlite3odbc.so
Setup=libsqlite3odbc.so
UsageCount=1
{{< /highlight >}}

Next you need to set up a [DSN](https://en.wikipedia.org/wiki/Data_source_name) entry for your SQLite database. You'll edit your `~/.odbc.ini` file to resemble this:

{{< highlight text >}}
[passwd]
Description = Password Database
Driver = SQLite3
Database = /home/colliera/passwd.sqlite
Timeout = 2000
{{< /highlight >}}

Obviously the name, description and path for your database file will differ.

Right, we're ready to use `isql` to open the database and execute queries.

{{< highlight sql >}}
$ isql -m20 passwd
+---------------------------------------+
| Connected!                            |
|                                       |
| sql-statement                         |
| help [tablename]                      |
| quit                                  |
|                                       |
+---------------------------------------+
SQL> select username, UID, GID from passwd limit 10;
+---------------------+---------------------+---------------------+
| username            | UID                 | GID                 |
+---------------------+---------------------+---------------------+
| root                | 0.0                 | 0.0                 |
| daemon              | 1.0                 | 1.0                 |
| bin                 | 2.0                 | 2.0                 |
| sys                 | 3.0                 | 3.0                 |
| sync                | 4.0                 | 65534.0             |
| games               | 5.0                 | 60.0                |
| man                 | 6.0                 | 12.0                |
| lp                  | 7.0                 | 7.0                 |
| mail                | 8.0                 | 8.0                 |
| news                | 9.0                 | 9.0                 |
+---------------------+---------------------+---------------------+
SQLRowCount returns 0
10 rows fetched
{{< /highlight >}}