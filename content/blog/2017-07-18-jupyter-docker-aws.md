---
author: Andrew B. Collier
date: 2017-07-18T04:00:00Z
tags: ["Jupyter", "Docker", "AWS"]
title: Deploying Jupyer on AWS using Docker
---

<!--
http://zero-to-jupyterhub.readthedocs.io/en/latest/
https://github.com/jupyterhub/jupyterhub-deploy-teaching
-->

Amazon's EC2 Container Services (ECS) is an orchestrated system for deploying Docker containers on AWS. This post is about *not* using ECS.

![](/img/logo/aws-ec2-container-service.png)

<!-- <iframe width="853" height="480" src="https://www.youtube.com/embed/zBqjh61QcB4" frameborder="0" allowfullscreen></iframe> -->

<!--more-->

I gave it a try and decided that I'd rather set it up from scratch in a simple EC2 instance. This is a record of my process.

## Create an EC2 Instance

Login to AWS and select EC2 in the Management Console. Create an instance. These are the specifications of the instance I created:

- Ubuntu Server 16.04 LTS image
- t2.xlarge instance (4 virtual CPUs and 16 GB of RAM).

You might go for a different setup, but maybe choosing the same operating system image would be a good place to start.

During the launch process I also

- edited the Security Group and added access for HTTP (port 80) and HTTPS (port 443).

## Connect via SSH

Once the launch process is complete you can connect to the instance using SSH and the PEM file that was created during the launch process.

{{< highlight bash >}}
ssh -i ~/docker.pem ubuntu@ec2-34-201-235-59.compute-1.amazonaws.com
{{< /highlight >}}

You'll connect as the `ubuntu` user.

## Install Docker

The next step is to install Docker on the EC2 host. Start by adding the public key for the Docker repository.

{{< highlight bash >}}
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
{{< /highlight >}}

Then add the repository and update.

{{< highlight bash >}}
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
{{< /highlight >}}

Retrieve some information about the `docker-ce` package (this step is optional).

{{< highlight bash >}}
apt-cache policy docker-ce
{{< /highlight >}}

{{< highlight text >}}
docker-ce:
  Installed: (none)
  Candidate: 17.06.0~ce-0~ubuntu
  Version table:
     17.06.0~ce-0~ubuntu 500
        500 https://download.docker.com/linux/ubuntu xenial/stable amd64 Packages
     17.03.2~ce-0~ubuntu-xenial 500
        500 https://download.docker.com/linux/ubuntu xenial/stable amd64 Packages
     17.03.1~ce-0~ubuntu-xenial 500
        500 https://download.docker.com/linux/ubuntu xenial/stable amd64 Packages
     17.03.0~ce-0~ubuntu-xenial 500
        500 https://download.docker.com/linux/ubuntu xenial/stable amd64 Packages
{{< /highlight >}}

Install the `docker-ce` package.

{{< highlight bash >}}
sudo apt-get install -y docker-ce
{{< /highlight >}}

Check that the `docker` service started successfully.

{{< highlight bash >}}
sudo systemctl status docker
{{< /highlight >}}

If everything went well then you should see that the service is loaded, active and running.

## Adding User to the Docker Group

If you try running any Docker commands as the `ubuntu` user you will be denied! You need to add this user to the `docker` group.

{{< highlight bash >}}
sudo gpasswd -a ubuntu docker
{{< /highlight >}}

You should logout and reconnect for the changes to take effect. Check that you are now able to run Docker commands.

{{< highlight bash >}}
docker version
{{< /highlight >}}
{{< highlight text >}}
Client:
 Version:      17.06.0-ce
 API version:  1.30
 Go version:   go1.8.3
 Git commit:   02c1d87
 Built:        Fri Jun 23 21:23:31 2017
 OS/Arch:      linux/amd64

Server:
 Version:      17.06.0-ce
 API version:  1.30 (minimum version 1.12)
 Go version:   go1.8.3
 Git commit:   02c1d87
 Built:        Fri Jun 23 21:19:04 2017
 OS/Arch:      linux/amd64
 Experimental: false
{{< /highlight >}}

## Running the Jupyter Docker Image

You are now able to run the [JupyterHub](https://github.com/jupyterhub/jupyterhub) Docker image.

{{< highlight bash >}}
docker run -d --name jupyterhub jupyterhub/jupyterhub jupyterhub
{{< /highlight >}}

Check that a `jupyterhub` container has been launched.

{{< highlight bash >}}
docker ps
{{< /highlight >}}

{{< highlight text >}}
CONTAINER ID        IMAGE                   COMMAND             CREATED              STATUS              PORTS               NAMES
240099f5bc8f        jupyterhub/jupyterhub   "jupyterhub"        About a minute ago   Up About a minute   8000/tcp            jupyterhub
{{< /highlight >}}

However, this is not quite right yet. JupyterHub is listening on port 8000 and our Security Group only allows access on port 80. So we need to stop that container and make some tweaks.

{{< highlight bash >}}
docker stop 240099f5bc8f
{{< /highlight >}}

We'll restart it with the container port 8000 mapped to the host port 80.

{{< highlight bash >}}
docker run -d -p 80:8000 jupyterhub/jupyterhub
{{< /highlight >}}

The port mapping is confirmed in the output from `docker ps`.

{{< highlight text >}}
CONTAINER ID        IMAGE                   COMMAND             CREATED             STATUS              PORTS                  NAMES
03ca8788b0c8        jupyterhub/jupyterhub   "jupyterhub"        5 seconds ago       Up 5 seconds        0.0.0.0:80->8000/tcp   fervent_ramanujan
{{< /highlight >}}

You should now be able to visit http://ec2-34-201-235-59.compute-1.amazonaws.com/ in your browser and find a Jupyter login dialog.

If you get a `500 : Internal Server Error` then check the Docker logs. It's very likely that you'll find `PAM Authentication failed` which indicates that there is a problem with the user account that you are trying to use to login.

## Persisting User Data

You'll probably want to use a mechanism for persisting user data. There are a couple of options for doing this. A simple technique which I have found helpful is documented [here]({{< relref "2017-07-20-docker-persisting-user-data.md" >}}).
