---
author: Andrew B. Collier
date: 2018-05-20T11:00:00Z
tags: ["Linux"]
title: Movidius Neural Compute Stick
draft: true
---

I'm testing a Neural Compute Stick (NCS) from [Intel/Movidius](https://www.movidius.com/).

![](/img/2018/05/movidius-neural-compute-stick.jpg)

> The Intel® Movidius™ Neural Compute Stick (NCS) is a tiny fanless deep learning device that you can use to learn AI programming at the edge. NCS is powered by the same low power high performance Intel Movidius Vision Processing Unit (VPU) that can be found in millions of smart security cameras, gesture controlled drones, industrial machine vision equipment, and more.

> ColdFusion demonstrates the power of the Intel Movidius Neural Compute Stick, which enables rapid prototyping, validation and deployment of Deep Neural Network (DNN) inference applications at the edge. Its low-power VPU architecture enables an entirely new segment of AI applications that are not reliant on a connection to the cloud.

> The NCS combined with Intel Movidius Neural Compute SDK allows deep learning developers to profile, tune, and deploy Convolutional Neural Network (CNN) on low-power applications requiring real-time inferencing.

## Requirements

Nominal system requirements are:

- Operating system:
    - x86_64 computer running Ubuntu 16.04 or 
    - Raspberry Pi 3 Model B running Stretch desktop or 
    - Ubuntu 16.04 VirtualBox instance
- USB 2.0 Type-A port (Recommend USB 3.0)
- 1GB RAM
- 4GB free storage space

I am running Ubuntu 17.04 and that also works fine.

## Installation

I started by following the [Quick Start instructions](https://developer.movidius.com/start).

Create a new folder to work in and then clone the SDK.

{{< highlight bash >}}
git clone https://github.com/movidius/ncsdk.git
{{< /highlight >}}

Build and install the SDK. This will require you to provide your password to use `sudo` to escalate privileges.

{{< highlight bash >}}
cd ncsdk/
make install
{{< /highlight >}}

The install process took quite a while, partially because it did a brute force search for a file, but also because it downloaded and installed a bunch of other packages.

Plug the Intel Movidius NCS into a USB port.

## Examples

The `examples` folder contains a small suite of example code. You can execute all of the examples with

{{< highlight bash >}}
make examples
{{< /highlight >}}
