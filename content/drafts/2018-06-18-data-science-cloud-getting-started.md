---
draft: true
author: Andrew B. Collier
date: 2018-06-01T07:00:00Z
tags: ["travel"]
title: "Data Science in the Cloud: Getting Started"
draft: false
---

## Gap Fillers

Things to talk about while the machines are chugging away:

- SSH and key pairs
- Spot instances [https://aws.amazon.com/ec2/spot/pricing/]
- Docker

## EC2 from the Dashboard (On Demand Instance)

1. Launch a `t2.micro` on demand instance.
2. Connect using SSH.
3. Try running R.
4. Install some packages:

    {{< highlight text >}}
$ sudo apt install -y r-base-core mysql-client-core-5.7
{{< /highlight >}}

5. Run the script to download cryptocurrency data.
6. Check results in database.
7. Automate.

## RDS from Dashboard

1. Launch a MySQL instance.
2. Use the following details:

	- DB instance identifier: crypto
	- Master username: andrew
	- Master password: gAf1Q8Qcu3lL
	- Database name: crypto

3. Ensure that "Public accessibility" is set to "Yes".
4. Use or create a VPC security group that allows inbound connections on port 3306.

## EC2 from the Dashboard (Spot Instance)

1. Launch a `r4.16xlarge` on spot instance. Apply security groups which allow the following access:

	- SSH (port 22)
	- RStudio (port 8787)

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
6. Install some utilities.
    {{< highlight text >}}
$ sudo apt install htop
{{< /highlight >}}
7. Kick off a compute intensive task and watch `htop` light up <span  style="color: red;"><i class="fa fa-fire"></i><i class="fa fa-fire"></i><i class="fa fa-fire"></i></span> like a Christmas <span  style="color: green;"><i class="fa fa-tree"></i></span>.
