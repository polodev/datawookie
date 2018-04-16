---
author: Andrew B. Collier
date: 2015-05-30T11:41:36Z
tags: ["R", "AWS"]
title: Hosting Shiny on Amazon EC2
---

<!--
NEW INFORMATION:

https://deanattali.com/2015/05/09/setup-rstudio-shiny-server-digital-ocean/
-->

I recently finished some work on a Shiny application which incorporated a Random Forest model. The model was stored in a RData file and loaded by server.R during initialisation. This worked fine when tested locally but when I tried to deploy the application on [shinyapps.io](https://www.shinyapps.io/) I ran into a problem: evidently you can only upload server.R and ui.R files. Nothing else.

<!--more-->

Bummer.

I looked around for alternatives and found that [Amazon Elastic Compute Cloud (EC2)](http://en.wikipedia.org/wiki/Amazon_Elastic_Compute_Cloud) was very viable indeed. I just needed to get it suitably configured. <!-- A [helpful article](http://www.numbrcrunch.com/blog/how-to-host-your-shiny-app-on-amazon-ec2-for-mac-osx) documented the process from an OSX perspective. This is the analogous Ubuntu view (which really only pertains to the last few steps of connecting via SSH and uploading your code). -->

Before embarking on this adventure it might be worthwhile reading some of the material about [Getting Started with AWS](http://aws.amazon.com/documentation/gettingstarted/).

## Create an Account

The first step is to create an account at [aws.amazon.com](http://aws.amazon.com). After you've logged into your account you should see a console like the one below. Select the **EC2** link under _Compute_.

<img src="/img/2015/05/AWS-Management-Console-002.bmp.png" width="100%">

Next, from the EC2 Dashboard select **Launch Instance**.

<img src="/img/2015/05/EC2-Management-Console-003.bmp.png" width="100%">

Step 1: There is an extensive range of machine images to choose from, but we will select the **Ubuntu Server**.

<img src="/img/2015/05/EC2-Management-Console-004.bmp.png" width="100%">

Step 2: Select the default option. Same applies for Step 3, Step 4 and Step 5.

<img src="/img/2015/05/EC2-Management-Console-005.bmp.png" width="100%">

Step 6: Choose the security settings shown below. SSH access should be restricted to your local machine alone. When you are done, select **Review & Launch**. Further information on access control can be found [here](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/authorizing-access-to-an-instance.html).

<img src="/img/2015/05/EC2-Management-Console-007.bmp.png" width="100%">

Step 7: Create a new key pair. Download the key and store it somewhere safe! Now press **Launch Instances**.

<img src="/img/2015/05/EC2-Management-Console-008.bmp.png" width="100%">

The launch status of your instance will then be confirmed.

<img src="/img/2015/05/EC2-Management-Console-009.bmp.png" width="100%">

At any later time the status of your running instance(s) can be inspected from the EC2 dashboard.

<img src="/img/2015/05/EC2-Management-Console-010.bmp.png" width="100%">

## SSH Connection

Now in order to install R and Shiny we need to login to our instance via SSH. In the command below you would need to substitute the name of your key file and also the Public DNS of your instance as the host name (the latter is available from the EC2 Dashboard).

{{< highlight bash >}}
$ ssh -i AWS-key.pem ubuntu@ec2-57-29-93-35.us-west-2.compute.amazonaws.com
{{< /highlight >}}

More detailed information on SSH access can be found [here](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstancesLinux.html).

## Installing R

Once you have the SSH connection up and running, execute the following on your remote instance:

{{< highlight bash >}}
$ sudo apt-get update  
$ sudo apt-get install r-base  
$ sudo apt-get install r-base-dev
{{< /highlight >}}

More in depth information on running R on AWS can be found [here](http://blogs.aws.amazon.com/bigdata/post/Tx3IJSB6BMHWZE5/Running-R-on-AWS).

## Installing Shiny

To install the Shiny R package, execute the following on your remote instance:

{{< highlight bash >}}
$ sudo su - -c "R -e \"install.packages('shiny', repos = 'http://cran.rstudio.com/')\""
{{< /highlight >}}

Next you need to install the Shiny server. Take a look at the [Shiny Server download page](https://www.rstudio.com/products/shiny/download-server/) to get the URL for the latest version of the package.

{{< highlight bash >}}
$ wget https://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-1.5.6.875-amd64.deb
$ sudo dpkg -i shiny-server-1.5.6.875-amd64.deb
{{< /highlight >}}
  
During the installation a directory `/srv/shiny-server/` will have been created, where your applications will be stored. Configuration options are given in `/etc/shiny-server/shiny-server.conf`.

Further information about configuring and running the Shiny server can be found in the [Shiny Server Administrator's Guide](http://docs.rstudio.com/shiny-server/).

## Installing and Testing your Applications

Transfer your applications across to the remote instance using sftp or scp. Then move them to a location under `/srv/shiny-server/`. You should now be ready to roll. You access the Shiny server on port 3838. So assuming for example, your application resides in a sub-folder called medal-predictions, then you would browse to http://ec2-52-24-93-52.us-west-2.compute.amazonaws.com:3838/medal-predictions/.

The structure of the `/srv/shiny-server/` should be something like this:

{{< highlight text >}}
$ tree /srv/shiny-server/
.
├── index.html -> /opt/shiny-server/samples/welcome.html
├── medal-predictions
│   └── app.R
└── sample-apps -> /opt/shiny-server/samples/sample-apps
{{< /highlight >}}

Every application folder should have a `app.R` file.

## Logs

If you are lucky then your app will work immediately after installing it on your Shiny server. If you are like me then you'll probably have to tweak a few things to get it working. The error messages that you'll get in your browser will probably not be very helpful. But there will be a log in `/var/log/shiny-server` for each time that the app is run.

## Azure

A similar procedure can be followed to install on an Azure instance. However you will also need to allow network access on port 3838. To do this simply add an inbound TCP rule to the networking options for the instance.
