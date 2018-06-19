---
author: Andrew B. Collier
date: 2018-06-01T07:00:00Z
tags: ["travel"]
title: "Data Science in the Cloud: Getting Started"
draft: false
---

## EC2 from the Dashboard (On Demand Instance)

1. Launch a `t2.micro` on demand instance.
2. Connect using SSH.


## EC2 from the Dashboard (Spot Instance)

1. Launch a `r3.8xlarge` on demand instance.
2. Connect using SSH.
3. Install Docker.

    {{< highlight text >}}
$ wget -q -O - https://bit.ly/2JGrYR2 | /bin/bash
{{< /highlight >}}
4. Logout and login again so that group settings take effect.
5. Pull and run a RStudio image.
    {{< highlight text >}}
$ docker pull datawookie/rstudio
$ docker run -d --name rstudio -p 8787:8787 -v ~/rstudio:/home/rstudio datawookie/rstudio
{{< /highlight >}}
6. Add some swap space.
    {{< highlight text >}}
$ sudo mkswap /dev/xvdb
$ sudo swapon /dev/xvdb
{{< /highlight >}}
7. Install some utilities.
    {{< highlight text >}}
$ sudo apt install htop
{{< /highlight >}}
8. Kick off a compute intensive task and watch `htop` light up light a Christmas tree.

## EC2 from Command Line

### Provisioning

- Docker
- RStudio Docker image

## RDS from Dashboard

## Kaggle on EC2

## Scraping on EC2

- Botcoin price script
- Store data in RDS
- Schedule on `crontab`
