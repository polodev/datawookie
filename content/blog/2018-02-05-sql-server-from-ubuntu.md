---
author: Andrew B. Collier
date: 2018-02-05T08:00:00Z
excerpt_separator: <!-- more -->
tags:
- Ubuntu
- null
title: SQL Server from Ubuntu
url: /2018/02/05/sql-server-from-ubuntu/
---

Setting up the requisites to access a SQL Server database from Ubuntu.

<!--more-->

## Install

1. Add key.
    {{< highlight text >}}
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
{{< / highlight >}}
2. Add the location of the repository.
    {{< highlight text >}}
curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list | sudo tee /etc/apt/sources.list.d/mssql-tools.list
{{< / highlight >}}
3. Update the package list.
    {{< highlight text >}}
sudo apt-get update
{{< / highlight >}}
4. Install the `mssql-tools` and `unixodbc-dev` packages.
    {{< highlight text >}}
sudo ACCEPT_EULA=Y apt-get install -y mssql-tools
sudo apt-get install -y unixodbc-dev
{{< / highlight >}}
5. Add `PATH=$PATH:/opt/mssql-tools/bin` as the last line of `/etc/bash.bashrc`.

## Test

Connect to your server.

{{< highlight text >}}
sqlcmd -S {server_address} -U {user_id} -P {password}
1> SELECT @@VERSION
2> GO
{{< / highlight >}}

What driver was installed?

{{< highlight text >}}
cat /etc/odbcinst.ini
[ODBC Driver 17 for SQL Server]
Description=Microsoft ODBC Driver 17 for SQL Server
Driver=/opt/microsoft/msodbcsql17/lib64/libmsodbcsql-17.0.so.1.1
UsageCount=1
{{< / highlight >}}

You'll need the driver string (in this case `ODBC Driver 17 for SQL Server`) if you are connecting to the server from R.

{{< highlight r >}}
library(odbc)

db <- dbConnect(odbc(),
                Driver =   "ODBC Driver 17 for SQL Server",
                Server =   "{server_address}",
                Database = "{database_name}",
                UID =      "{user_id}",
                PWD =      "{password}")

odbcClose(db)
{{< / highlight >}}
