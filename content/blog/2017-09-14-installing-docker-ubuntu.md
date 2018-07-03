---
author: Andrew B. Collier
date: 2017-09-14T05:00:00Z
tags: ["Docker", "Linux"]
title: Installing Docker on Ubuntu
---

This procedure works on both my laptop and a fresh EC2 instance.

<!--more-->

1. Add the GPG key for Docker.

	{{< highlight bash >}}
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo apt-key add -
{{< /highlight >}}

2. Add the details of the Docker repository.

	{{< highlight bash >}}
OSNAME=$(. /etc/os-release; echo "$ID")
OSVERS=$(lsb_release -cs)
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$OSNAME $OSVERS stable"
{{< /highlight >}}

3. Update the package index.

	{{< highlight bash >}}
sudo apt update
{{< /highlight >}}

4. Install the Community Edition package.

	{{< highlight bash >}}
sudo apt install docker-ce
{{< /highlight >}}

5. Test it.

	{{< highlight bash >}}
sudo docker run hello-world
{{< /highlight >}}

The output from the test should look something like this:

	{{< highlight text >}}
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
5b0f327be733: Pull complete 
Digest: sha256:1f1404e9ea1a6665e3664626c5d2cda76cf90a4df50cfee16aab1a78f58a3f95
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://cloud.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/engine/userguide/
{{< /highlight >}}

Note that the `docker` command currently requires superuser privileges. To allow `docker` for mere mortals, add their accounts to the `docker` group.

{{< highlight bash >}}
sudo gpasswd -a ubuntu docker
{{< /highlight >}}

On that user's next login the `docker` group will be added to their profile and they will be able to launch `docker` jobs.

I've wrapped the installation up in a very simple Gist. You can source the gist and install using

	{{< highlight text >}}
$ wget -q -O - https://bit.ly/2JGrYR2 | /bin/bash
{{< /highlight >}}

<script src="https://gist.github.com/DataWookie/9f29795059e6bccf9892bc85ed285337.js"></script>