---
author: Andrew B. Collier
date: 2016-01-13T13:10:41Z
tags: ["MongoDB"]
title: 'MongoDB: Installing on Windows 7'
---

It's not my personal choice, but I have to spend a lot of my time working under Windows. Installing MongoDB under Ubuntu is a snap. Getting it going under Windows seems to require jumping through a few more hoops. Here are my notes. I hope that somebody will find them useful.

<!--more-->

1. [Download](https://www.mongodb.org/downloads) the installation. This will be an MSI installer package with a name like `mongodb-win32-x86_64-2008plus-ssl-3.2.0-signed.msi`. 
2. Run the installer with a deft double-click.

<img src="/img/2016/01/MongoDB-install-dialog.png" >

3. Accept the License Agreement. 
4. Select the Complete installation type and click Install. 
5. Briefly browse YouTube (you won't have time to make a cup of coffee). 
6. When the installation is complete press Finish. 
7. Reboot your machine. This might not be entirely necessary, but my Windows experience tells me that it is never a bad idea. 
8. Create a folder for the data files. By default this will be `C:\data\db`. 
9. Create a folder for the log files. By default this will be `C:\data\log`. 
10. Open a command prompt, change the working directory to `C:\Program Files\MongoDB\Server\3.2\bin` and start the database server, `mongod.exe`.

<img src="/img/2016/01/MongoDB-starting-server.png" >

At this stage you should be ready to roll. Open another command prompt and start the database client, `mongo.exe` which you'll find in the same folder as `mongod.exe`.

To make your installation a little more robust, you can also do the following:

1. Create a configuration file at `C:\Program Files\MongoDB\Server\3.2\mongod.cfg`. For starters you could enter the following configuration directives:

{{< highlight text >}}
systemLog:
    destination: file
    path: c:\data\log\mongod.log
storage:
    dbPath: c:\data\db
{{< /highlight >}}
2. Install MongoDB as a service by running
{{< highlight text >}}
mongod.exe -config "C:\Program Files\MongoDB\Server\3.2\mongod.cfg" -install
{{< /highlight >}}
3. The service can then be launched with
{{< highlight text >}}
net start MongoDB
{{< /highlight >}}
And stopping the service is as simple as
{{< highlight text >}}
net stop MongoDB
{{< /highlight >}}