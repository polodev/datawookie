---
author: Andrew B. Collier
date: 2017-07-11T04:00:00Z
tags: ["R", "Docker"]
title: RStudio Environment on DigitalOcean with Docker
---

{{< comment >}}
Alternative deployment options:

- AWS: http://www.win-vector.com/blog/2018/01/setting-up-rstudio-server-quickly-on-amazon-ec2/
- Azure: http://blog.jumpingrivers.com/posts/2017/rstudio_azure_cloud_1/
{{< /comment >}}

I'll be running a training course in a few weeks which will use RStudio as the main computational tool. Since it's a short course I don't want to spend a lot of time sorting out technical issues. And with multiple operating systems (and *versions*) these issues can be numerous and pervasive. Setting up a RStudio server which everyone can access (and that requires no individual configuration!) makes a lot of sense.

![](/img/logo/docker-logo.png)

These are some notes about how I got this all set up using a Docker container on DigitalOcean. <!--more--> This idea was inspired by [this article](https://itsalocke.com/r-training-environment/). I provide some additional details about the process.

<!-- https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-getting-started -->
<!-- https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04 -->

<!-- https://github.com/rocker-org/rocker-versioned -->
<!-- https://github.com/rocker-org/rocker -->

## Local Setup

I began by trying things out on my local machine. The first step was to install [Docker](https://www.docker.com/). On my Linux machine this was a simple procedure. I added my user to the `docker` group and I was ready to roll.

### Validate Docker

Being my first serious foray into the world of Docker I spent some time getting familiar with the tools. First it makes sense to validate that Docker is correctly configured and operational. Check the version.

{{< highlight bash >}}
$ docker -v
Docker version 17.06.0-ce, build 02c1d87
{{< /highlight >}}

Check the current status of the Docker service. This should indicate that Docker is loaded, running and active.

{{< highlight text >}}
$ systemctl status docker
{{< /highlight >}}

To see further system information about Docker:

{{< highlight text >}}
$ docker info
{{< /highlight >}}

Finally run a quick test to ensure that Docker is able to download and launch images.

{{< highlight text >}}
$ docker run hello-world

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

## RStudio Container

A selection of RStudio Docker containers are hosted by the [Rocker project](https://github.com/rocker-org/rocker). We'll install the [verse container](https://hub.docker.com/r/rocker/verse/) which contains base R, RStudio, tidyverse, devtools and some packages related to publishing.

{{< highlight text >}}
$ docker pull rocker/verse
{{< /highlight >}}

That will download a load of content. Depending on the speed of your connection it might take a couple of minutes. Once the downloads are complete we can spin it up.

{{< highlight text >}}
$ docker run -d -p 80:8787 rocker/verse
{{< /highlight >}}

Now point your browser at <http://localhost:80/>. You should see a login dialog. Login with username `rstudio` and password `rstudio`.

Once you've satisfied yourself that the RStudio server is working properly, we'll shut it down. Check on the running Docker containers.

{{< highlight text >}}
$ docker ps
{{< /highlight >}}

The ID in the output from the previous command is used to stop the container.

{{< highlight text >}}
$ docker stop 487487fc346d
{{< /highlight >}}

## Creating a New Container Image

We're now going to create a custom Docker image based on the `rocker/verse` image we used above. We do this by creating a `Dockerfile`. You can take a look at the one that I am using in this [GitHub repository](https://github.com/DataWookie/docker-exegetic). It adds a few minor features to the `rocker/verse` image:

- a small shell script for generating new user profiles;
- the `whois` package for the `apg` command (although I am currently using `openssl` for password generation); and
- a few extra R packages.

Check out the [best practices](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/) for creating a Dockerfile.

### Building

We need to build the image before we can launch it. Navigate to the folder which contains the `Dockerfile` and then do the following:

{{< highlight text >}}
$ docker build -t rstudio:latest .
{{< /highlight >}}

That will step through the instructions in the `Dockerfile`, building up the new image as a series of layers. We can get an idea of which components contributed the most to the resulting image.

{{< highlight text >}}
$ docker history rstudio:latest
IMAGE               CREATED              CREATED BY                                      SIZE                COMMENT
1206300d01f8        About a minute ago   /bin/sh -c R -e 'install.packages("RSeleni...   11.6MB              
4f0daf5ee744        4 hours ago          /bin/sh -c R -e 'install.packages(c("binma...   3.4MB               
60e254d31a5a        4 hours ago          /bin/sh -c apt-get install whois                2.31MB              
5107e33b5c77        4 hours ago          /bin/sh -c apt-get update                       15.5MB              
a720b73666a2        4 hours ago          /bin/sh -c #(nop)  MAINTAINER Andrew Colli...   0B                  
8232739f906d        7 hours ago          /bin/sh -c apt-get update   && apt-get ins...   763MB               
<missing>           7 hours ago          /bin/sh -c apt-get update -qq && apt-get -...   720MB               
<missing>           10 hours ago         /bin/sh -c #(nop)  CMD ["/init"]                0B                  
<missing>           10 hours ago         /bin/sh -c #(nop)  VOLUME [/home/rstudio/k...   0B                  
<missing>           10 hours ago         /bin/sh -c #(nop)  EXPOSE 8787/tcp              0B                  
<missing>           10 hours ago         /bin/sh -c #(nop) COPY file:b221a73265993c...   1.17kB              
<missing>           10 hours ago         /bin/sh -c #(nop) COPY file:3012c80f63f800...   2.36kB              
<missing>           10 hours ago         /bin/sh -c apt-get update   && apt-get ins...   486MB               
<missing>           10 hours ago         /bin/sh -c #(nop)  ENV PANDOC_TEMPLATES_VE...   0B                  
<missing>           10 hours ago         /bin/sh -c #(nop)  ARG PANDOC_TEMPLATES_VE...   0B                  
<missing>           10 hours ago         /bin/sh -c #(nop)  ARG RSTUDIO_VERSION          0B                  
<missing>           10 hours ago         /bin/sh -c #(nop)  CMD ["R"]                    0B                  
<missing>           10 hours ago         /bin/sh -c sed -i "s/deb.debian.org/cloudf...   477MB               
<missing>           10 hours ago         /bin/sh -c #(nop)  ENV R_VERSION=3.4.1 LC_...   0B                  
<missing>           10 hours ago         /bin/sh -c #(nop)  ARG BUILD_DATE               0B                  
<missing>           10 hours ago         /bin/sh -c #(nop)  ARG R_VERSION                0B                  
<missing>           10 hours ago         /bin/sh -c #(nop)  LABEL org.label-schema....   0B                  
<missing>           2 weeks ago          /bin/sh -c #(nop)  CMD ["bash"]                 0B                  
<missing>           2 weeks ago          /bin/sh -c #(nop) ADD file:93a0dbb6973bc13...   100MB               
{{< /highlight >}}

We can now test the new container.

{{< highlight text >}}
$ docker run -d -p 80:8787 --name rstudio rstudio:latest
{{< /highlight >}}

Once you are satisfied that it works, stop the container.

## Deploy on DigitalOcean

We're now in a position to deploy the image on [DigitalOcean](http://digitalocean.com/). If you don't already have an account, go ahead and create one now,

### Create a Droplet

Once you've logged in to your DigitalOcean account, create a new Droplet and choose the Docker one-click app (I chose Docker 17.06.0-ce on 16.04). Make sure that you provide your SSH public key.

![](/img/2017/07/digital-ocean-one-click-apps.png)

### Connect as root

Once the Droplet is live (give it a moment or two, even after it claims to be "Good to go!"), use the IP address from the DigitalOcean dashboard to make a SSH connection. You'll connect initially as the `root` user.

{{< highlight bash >}}
$ ssh -l root 104.236.93.95
{{< /highlight >}}

### Swap Space

Docker containers use the kernel, memory and swap from the host. So if you've created a relatively small Droplet then you might want to [add swap space]({{< relref "2015-06-19-amazon-ec2-adding-swap.md" >}}).

### Create a `docker` User

Create a `docker` user and add it to the `docker` group.

{{< highlight text >}}
# useradd -g users -G docker -m -s /bin/bash docker
{{< /highlight >}}

Add your SSH public key to `.ssh/authorized_keys` for the `docker` user. Terminate your `root` connection and reconnect as the `docker` user.

{{< highlight text >}}
$ ssh docker@104.236.73.164
$ groups
users docker
{{< /highlight >}}

### Build the Container

Clone the [GitHub repository](https://github.com/DataWookie/docker-exegetic). Navigate to the folder which contains the RStudio `Dockerfile`. Now build the image on the Droplet.

{{< highlight text >}}
$ docker build -t rstudio:latest .
{{< /highlight >}}

And then launch a container.

{{< highlight text >}}
$ docker run -d -p 80:8787 --name rstudio rstudio:latest
{{< /highlight >}}

Connect to the Droplet using the IP address from the DigitalOcean dashboard.

![](/img/2017/07/docker-rstudio-login.png)

Sign in using the same credentials as before. Sweet: you're connected to an instance of RStudio running somewhere out in the cloud.

![](/img/2017/07/docker-rstudio-interface.png)

### Accessing Usernames and Passwords

Obviously the default credentials we've been using are a security hole. We'll need to fix that. We'll also need to create a brace of new accounts which we can give to the course delegates. These new accounts need to be created on the container not the host!

To accomplish all of this we'll need to connect to the running Docker container. Again use `docker ps` to find the ID of the running container. Then connect a `bash` shell using `docker exec`, providing the container ID as the `-i` argument.

{{< highlight text >}}
$ docker exec -t -i df3a7a5af57e /bin/bash
{{< /highlight >}}

Delete the `rstudio` user.

{{< highlight text >}}
root@df3a7a5af57e:/# userdel rstudio
{{< /highlight >}}

Now create some new users using the `generate-users.sh` scripts packaged with the image. For example, to generate five new users:

{{< highlight text >}}
root@df3a7a5af57e:/# /usr/sbin/generate-users.sh 5
U001,/kK160rx
U002,hhNk7FJl
U003,RaH4EJYP
U004,YBpMcl6n
U005,9Rcl8gye
{{< /highlight >}}

This will create the user profiles and home folders. The usernames and passwords are dumped to the terminal in CSV format. Record these and then assign a pair to each of the course delegates.

## Persisting User Data

You'll probably want to use a mechanism for persisting user data. There are a couple of options for doing this. A simple technique which I have found helpful is documented [here]({{< relref "2017-07-20-docker-persisting-user-data.md" >}}).

## Finish and Klaar

Feel free to fork the [repository](https://github.com/DataWookie/docker-exegetic) and customise the `Dockerfile` to suit your requirements. Let me know how this works out for you. I'm rather excited to run a course which will not be plagued by technical issues!
