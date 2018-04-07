---
author: Andrew B. Collier
date: 2017-07-01T05:30:00Z
tags: ["MySQL"]
title: Increasing MySQL Packet Maximum Size
---

In the process of uploading a massive CSV file to my Django application my session data are getting pretty big. As a the result I'm getting these errors:

- `(1153, "Got a packet bigger than 'max_allowed_packet' bytes")` and
- `(2006, 'MySQL server has gone away')`.

The second error is potentially unrelated.

After some research it became apparent that the source of the problem is my `max_allowed_packet` setting. <!--more--> A quick check to find the current value:

{{< highlight sql >}}
mysql> SELECT @@max_allowed_packet;
+----------------------+
| @@max_allowed_packet |
+----------------------+
|             16777216 |
+----------------------+
1 row in set (0.00 sec)
{{< /highlight >}}

That's 16 Mb, but evidently not enough! It's a simple matter to increase this limit. Just edit `/etc/mysql/my.cnf` (you'll have to be `root` to do that!) and add the following:

{{< highlight text >}}
[mysqld]
max_allowed_packet = 32M
{{< /highlight >}}

Then restart MySQL.

{{< highlight text >}}
# service mysql restart
{{< /highlight >}}

Check that the limit has increased.

{{< highlight sql >}}
mysql> SELECT @@max_allowed_packet;
+----------------------+
| @@max_allowed_packet |
+----------------------+
|             33554432 |
+----------------------+
1 row in set (0.00 sec)
{{< /highlight >}}

That solved the problem for me. If the problem persists then you might need to increase the limit further.
