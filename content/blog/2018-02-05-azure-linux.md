---
title: "Linux VM on Azure"
date: 2018-02-05T07:00:00+00:00
author: Andrew B. Collier
excerpt_separator: <!-- more -->
layout: post
categories:
  - Cloud
tags:
  - Azure
  - Linux
---

A quick tutorial on how to create a Linux VM on Azure.

<!-- more -->

## Azure Portal

Login to the [Azure Portal](https://portal.azure.com/).

From the menu bar on the left of the Dashboard select New and then Compute.

Select the Ubuntu Server 16.04 LTS option (you might want to pop up the associated [Quickstart tutorial](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/) too).

![]({{ site.baseurl }}/static/img/2018/02/azure-new-service.png)

### Basics

From the Basics configuration

- fill in a suitable name for the server;
- fill in a user name (you can go for something generic like `ubuntu` or personalise);
- choose SSH public key authentication and copy the contents of your `~/.ssh/id_rsa.pub` file into the SSH public key field;
- choose a subscription mode (Pay-As-You-Go makes sense for starters);
- either create a new resource group or use an existing one;
- choose a location which makes sense (geographical proximity is good).

![]({{ site.baseurl }}/static/img/2018/02/azure-basics.png)

### Size

Choose View All to see all of the available machine sizes (the ones that are presented by default are somewhat expensive!).

Some of the low end options are

- `B1S` (cheap with 1 vCPU, 1 Gb RAM and 2 Gb storage)
- `B1MS` (cheap with 1 vCPU, 2 Gb RAM and 4 Gb storage)
- `B2S` (affordable with 2 vCPU, 4 Gb RAM and 8 Gb storage)
- `B2MS` (affordable with 2 vCPU, 8 Gb RAM and 16 Gb storage)
- `F1S` (affordable with 1 vCPU, 2 Gb RAM and 4 Gb storage)
- `DS1` (1 vCPU, 3.5 Gb RAM and 7 Gb storage)
- `DS1_V2` (2 vCPU, 14 Gb RAM and 28 Gb storage)

Select a machine that fits your budget and hardware requirements.

![]({{ site.baseurl }}/static/img/2018/02/azure-size.png)

### Settings

You can probably just go with the defaults here.

![]({{ site.baseurl }}/static/img/2018/02/azure-settings.png)

### Summary

Check that all of the details are correct and then press the <kbd class="bg-primary nobreak">Create</kbd> button.

You'll be taken back to the Dashboard where you'll see a status spinner indicating that your VM is being deployed.

When the deploy is complete you'll be taken to an overview page for your newly minted VM, where you'll find the public IP address (which you can use to make a SSH connection) along with a plethora of other details relating to the machine.

Enjoy your shiny new cloud compute!