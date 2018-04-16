---
author: Andrew B. Collier
date: 2016-09-06T15:00:34Z
tags: ["Neo4j", "Linux"]
title: Installing Neo4j on Ubuntu 16.04
---

Some instructions for installing Neo4j on Ubuntu 16.04. More for my own benefit than anything else.

<img src="/img/2016/09/neo4j-logo.png" >

## Installing Java

Neo4j is implemented in Java, so you'll need to have the Java Runtime Environment (JRE) installed. If you already have this up and running, go ahead and skip this step.

{{< highlight text >}}
sudo apt install default-jre default-jre-headless
{{< /highlight >}}

Check whether you can now run the `java` executable.

{{< highlight text >}}
java
{{< /highlight >}}
  
If that works for you, great! It didn't immediately work on one of my machines. Strangely there were some dangling links in the alternatives system (which, to be honest, I was not even aware of until then!). It took a bit of Googling to figure this out, but the issue was resolved with the following:

{{< highlight text >}}
sudo update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/bin/java
sudo update-alternatives --set javac /usr/lib/jvm/java-8-openjdk-amd64/bin/javac
{{< /highlight >}}

## Installing Neo4j

First we'll add the repository key to our keychain.

{{< highlight text >}}
wget --no-check-certificate -O - https://debian.neo4j.org/neotechnology.gpg.key | sudo apt-key add -
{{< /highlight >}}

Then add the repository to the list of `apt` sources.

{{< highlight text >}}
echo 'deb http://debian.neo4j.org/repo stable/' | sudo tee /etc/apt/sources.list.d/neo4j.list
{{< /highlight >}}

Finally update the repository information and install Neo4j.

{{< highlight text >}}
sudo apt update
sudo apt install neo4j
{{< /highlight >}}

The server should have started automatically and should also be restarted at boot. If necessary the server can be stopped with

{{< highlight text >}}
sudo service neo4j stop
{{< /highlight >}}
  
and restarted with

{{< highlight text >}}
sudo service neo4j start
{{< /highlight >}}

## Accessing Neo4j

You should now be able to access the database server via http://localhost:7474/browser/.

I had some problems logging in with the default username and password (`neo4j` and `neo4j`), but this was easily resolved by deleting the file `/var/lib/neo4j/data/dbms/auth` and restarting the server.
