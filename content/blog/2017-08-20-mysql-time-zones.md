---
author: Andrew B. Collier
date: 2017-08-20T05:00:00Z
tags: ["MySQL", "Django"]
title: Setting Up Time Zones in MySQL
---

I'm in the process of setting up a [Zinnia](https://github.com/Fantomas42/django-blog-zinnia) blog on one of my Django sites. After putting all of the necessary plumbing in place I got the following message on first visiting the blog URL:

{{< highlight text >}}
Database returned an invalid value in QuerySet.datetimes(). Are time zone definitions for your database and pytz installed?
{{< /highlight >}}

The solution to this is to copy your system's time zone information across to the database.

<!--more-->

## Creating the Time Zone Tables

There's a MySQL tool to do precisely this: `mysql_tzinfo_to_sql`. You just need to pass it the path to your system's zoneinfo database. On my Ubuntu system the appropriate path is `/usr/share/zoneinfo/`.

The following command will read the contents of your system's zoneinfo database, transform it into SQL statements and execute them in MySQL. You'll need to provide the password for the `root` MySQL user.

{{< highlight bash >}}
mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u root -p mysql
{{< /highlight >}}

You can just specify a single time zone, but it makes sense to me to simply load up the entire gamut.

The result is a set of tables in the `mysql` database.

{{< highlight sql >}}
mysql> SELECT * FROM time_zone LIMIT 10;
+--------------+------------------+
| Time_zone_id | Use_leap_seconds |
+--------------+------------------+
|            1 | N                |
|            2 | N                |
|            3 | N                |
|            4 | N                |
|            5 | N                |
|            6 | N                |
|            7 | N                |
|            8 | N                |
|            9 | N                |
|           10 | N                |
+--------------+------------------+
10 rows in set (0.00 sec)
{{< /highlight >}}

{{< highlight sql >}}
mysql> SELECT * FROM time_zone_name LIMIT 10;
+--------------------+--------------+
| Name               | Time_zone_id |
+--------------------+--------------+
| Africa/Abidjan     |            1 |
| Africa/Accra       |            2 |
| Africa/Addis_Ababa |            3 |
| Africa/Algiers     |            4 |
| Africa/Asmara      |            5 |
| Africa/Asmera      |            6 |
| Africa/Bamako      |            7 |
| Africa/Bangui      |            8 |
| Africa/Banjul      |            9 |
| Africa/Bissau      |           10 |
+--------------------+--------------+
10 rows in set (0.00 sec)
{{< /highlight >}}

{{< highlight sql >}}
mysql> SELECT * FROM time_zone_transition LIMIT 10;
+--------------+-----------------+--------------------+
| Time_zone_id | Transition_time | Transition_type_id |
+--------------+-----------------+--------------------+
|            1 |     -2147483648 |                  0 |
|            1 |     -1830383032 |                  1 |
|            2 |     -2147483648 |                  0 |
|            2 |     -1640995148 |                  2 |
|            2 |     -1556841600 |                  1 |
|            2 |     -1546388400 |                  2 |
|            2 |     -1525305600 |                  1 |
|            2 |     -1514852400 |                  2 |
|            2 |     -1493769600 |                  1 |
|            2 |     -1483316400 |                  2 |
+--------------+-----------------+--------------------+
10 rows in set (0.00 sec)
{{< /highlight >}}

{{< highlight sql >}}
mysql> SELECT * FROM time_zone_transition_type LIMIT 10;
+--------------+--------------------+--------+--------+--------------+
| Time_zone_id | Transition_type_id | Offset | Is_DST | Abbreviation |
+--------------+--------------------+--------+--------+--------------+
|            1 |                  0 |   -968 |      0 | LMT          |
|            1 |                  1 |      0 |      0 | GMT          |
|            2 |                  0 |    -52 |      0 | LMT          |
|            2 |                  1 |   1200 |      1 | +0020        |
|            2 |                  2 |      0 |      0 | GMT          |
|            3 |                  0 |   8836 |      0 | LMT          |
|            3 |                  1 |  10800 |      0 | EAT          |
|            3 |                  2 |   9000 |      0 | +0230        |
|            3 |                  3 |   9900 |      0 | +0245        |
|            3 |                  4 |  10800 |      0 | EAT          |
+--------------+--------------------+--------+--------+--------------+
10 rows in set (0.00 sec)
{{< /highlight >}}

## MySQL Server Time Zone

You can check the time zone that's configured for your MySQL server as follows:

{{< highlight sql >}}
mysql> SELECT @@time_zone;
+-------------+
| @@time_zone |
+-------------+
| SYSTEM      |
+-------------+
1 row in set (0.00 sec)
{{< /highlight >}}

So my MySQL server is using the same time zone as the system. We can lock that down by configuring a specific time zone for MySQL. Add the following to the end of `/etc/mysql/my.cnf`.

{{< highlight text >}}
[mysqld]
default-time-zone = 'UTC'
{{< /highlight >}}

Now restart MySQL.

{{< highlight bash >}}
sudo service mysql restart
{{< /highlight >}}

And check for the server time zone.

{{< highlight sql >}}
mysql> SELECT @@time_zone;
+-------------+
| @@time_zone |
+-------------+
| UTC         |
+-------------+
1 row in set (0.00 sec)
{{< /highlight >}}

Sorted.