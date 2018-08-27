---
author: Andrew B. Collier
date: 2018-02-05T08:00:00Z
excerpt_separator: <!-- more -->
title: SQL Server from Ubuntu
draft: false
tags: ["SQL", "Linux"]
---

Setting up the requisites to access a SQL Server database from Ubuntu.

<!--more-->

## Install

1. Add key.
    {{< highlight text >}}
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
{{< /highlight >}}
2. Add the location of the repository.
    {{< highlight text >}}
# For Ubuntu 16.04.
#
curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list | sudo tee /etc/apt/sources.list.d/mssql-tools.list
#
# For Ubuntu 17.10.
#
curl https://packages.microsoft.com/config/ubuntu/17.10/prod.list | sudo tee /etc/apt/sources.list.d/mssql-release.list
#
# For Ubuntu 18.04.
#
curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list | sudo tee /etc/apt/sources.list.d/mssql-release.list
{{< /highlight >}}
3. Update the package list.
    {{< highlight text >}}
sudo apt-get update
{{< /highlight >}}
4. Install packages.
    {{< highlight text >}}
sudo apt-get install -y unixodbc-dev
#
# For Ubuntu 16.04.
#
sudo ACCEPT_EULA=Y apt-get install -y mssql-tools
#
# For Ubuntu 17.10 & 18.04.
#
sudo ACCEPT_EULA=Y apt-get install -y msodbcsql17
{{< /highlight >}}
5. Add `PATH=$PATH:/opt/mssql-tools/bin` as the last line of `/etc/bash.bashrc`.

## Test

Connect to your server.

{{< highlight text >}}
sqlcmd -S {server_address} -U {user_id} -P {password}
1> SELECT @@VERSION
2> GO
{{< /highlight >}}

What driver was installed?

{{< highlight text >}}
cat /etc/odbcinst.ini
[ODBC Driver 17 for SQL Server]
Description=Microsoft ODBC Driver 17 for SQL Server
Driver=/opt/microsoft/msodbcsql17/lib64/libmsodbcsql-17.0.so.1.1
UsageCount=1
{{< /highlight >}}

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
{{< /highlight >}}
