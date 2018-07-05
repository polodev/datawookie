---
draft: true
title: "Ethereum: Mining on AWS"
date: 2017-12-18T03:00:00+00:00
author: Andrew B. Collier
excerpt_separator: <!-- more -->
layout: post
tags:
  - Blockchain
  - Ethereum
---

{{< comment >}}
https://hackernoon.com/how-to-mine-ethereum-in-5-min-3f3bc80d0c4b
{{< /comment >}}

A quick tutorial on setting up an Ether miner on AWS. It's not profitable, but it is an interesting exercise and lays a foundation for assembling a proper mining rig.

<!-- more -->

![](/img/logo-ethereum.png)

## Create a Wallet

You're going to need somewhere to store the proceeds of your mining. So before we even contemplate mining you'll need to [create a wallet]({{ site.baseurl }}{% post_url 2017-12-15-ethereum-creating-a-wallet %}).

## Spin Up an EC2 Instance

We'll use an AWS Spot Instance. Read [this post]({{ site.baseurl }}{% post_url 2017-09-13-aws-spot-instance %}) for detailed instructions on unleashing one of these beauties.

### Hardware

We'll start by selecting a `g2.2xlarge` EC2 instance. The spot price for a `g2.2xlarge` instance is currently 0.2347 USD per hour and this provides a good compromise between compute power and cost.

### Software

We'll need the kernel drivers for the NVIDIA card as well as `ethminer` to be installed. It's a simple matter to install both of these from scratch, but it's even easier to use an [AMI](https://en.wikipedia.org/wiki/Amazon_Machine_Image). For this tutorial I [built]({{ site.baseurl }}{% post_url 2017-12-04-creating-amazon-machine-image %}) an AMI which has everything I need.

Which version of `ethminer` do we get with `ami-d60f6bac`?

{% highlight text %}
$ ethminer --version
ethminer version 0.12.0
Build: Linux/g++/Release
{% endhighlight %}

That's the current stable release. You can visit the source repository [here](https://github.com/ethereum-mining/ethminer) to check for updates.

There's a selection of other AMIs which are also intended for mining Ethereum. A commonly referenced AMI is `ami-cb384fdd`, but it has an older version of `ethminer`.

## Listing Devices

Once the EC2 instance is up and running we can use `ethminer` to list the available GPU devices.

{% highlight text %}
$ ethminer --list-devices

Listing OpenCL devices.
FORMAT: [platformID] [deviceID] deviceName
[0] [0] GRID K520
	CL_DEVICE_TYPE: GPU
	CL_DEVICE_GLOBAL_MEM_SIZE: 4232577024
	CL_DEVICE_MAX_MEM_ALLOC_SIZE: 1058144256
	CL_DEVICE_MAX_WORK_GROUP_SIZE: 1024

Listing CUDA devices.
FORMAT: [deviceID] deviceName
[0] GRID K520
	Compute version: 3.0
	cudaDeviceProp::totalGlobalMem: 4232577024
{% endhighlight %}

So there's just a single GPU and it's a [NVIDIA GRID K520](http://www.nvidia.com/object/cloud-gaming-gpu-boards.html) card (Kepler architecture), which has 3072 CUDA cores running at 800 MHz and consumes at most 225&nbsp;W. We can get more information using `lspci`.

{% highlight text %}
$ sudo lspci -v -s $(lspci | grep NVIDIA | cut -d" " -f 1)
00:03.0 VGA compatible controller: NVIDIA Corporation GK104GL [GRID K520] (rev a1) (prog-if 00 [VGA controller])
	Subsystem: NVIDIA Corporation Device 1014
	Physical Slot: 3
	Flags: bus master, fast devsel, latency 0, IRQ 116
	Memory at ec000000 (32-bit, non-prefetchable) [size=16M]
	Memory at e0000000 (64-bit, prefetchable) [size=128M]
	Memory at ea000000 (64-bit, prefetchable) [size=32M]
	I/O ports at c100 [size=128]
	Expansion ROM at ee000000 [disabled] [size=512K]
	Capabilities: [60] Power Management version 3
	Capabilities: [68] MSI: Enable+ Count=1/1 Maskable- 64bit+
	Capabilities: [78] Express Endpoint, MSI 00
	Capabilities: [b4] Vendor Specific Information: Len=14 <?>
	Kernel driver in use: nvidia
{% endhighlight %}

You can perform a quick benchmark on your GPU to make sure that everything is set up correctly.

{% highlight text %}
$ ethminer -M -G
{% endhighlight %}

## Start Mining

Since working in isolation is not very fruitful we'll be using a [mining pool](https://en.wikipedia.org/wiki/Mining_pool). There are a number of active pools, but we'll use [Dwarfpool](https://dwarfpool.com/) for the moment and consider some other options later. We just need to point `ethminer` at the pool and provide it with the address of our wallet.

{% highlight text %}
$ ethminer -G -F http://eth-eu.dwarfpool.com/6Dd80e0BCC1cA62141b03e1B4978e569CE02d914/k520
{% endhighlight %}

That will start the mining process, dumping copious amounts of logging information to the terminal.

Let's take a moment to unpack some of those parameters:

- `-G`: use the GPU;
- `-F`: go into mining farm mode with server specified by a URL with the form `http://{pool}/{account}/{label}`. If you are running multiple workers then the label can be used to differentiate the statistics from each of them.

### Persistence

Obviously you'll want the mining process to continue even when you are disconnected from the EC2 instance. To set this up, start `ethminer` in either a `screen` or `tmux` session.

## Checking GPU Utilisation

Is the GPU being fully utilised?

{% highlight text %}
$ nvidia-smi
Sun Dec  3 05:48:23 2017       
+------------------------------------------------------+                       
| NVIDIA-SMI 340.29     Driver Version: 340.29         |                       
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  GRID K520           Off  | 0000:00:03.0     Off |                  N/A |
| N/A   71C    P0    91W / 125W |   2320MiB /  4095MiB |    100%      Default |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Compute processes:                                               GPU Memory |
|  GPU       PID  Process name                                     Usage      |
|=============================================================================|
|    0      1516  ethminer                                            2303MiB |
+-----------------------------------------------------------------------------+
{% endhighlight %}

Yes, it looks like it is. You'll find that one of the CPU cores is maxed out too. According to the `ethminer` logs all of this computing power delivers a hash rate of around 5.5 Mh/s.

## Trying a Different EC2 Instance

The cost of a `p2.xlarge` instance is essentially the same as a `g2.2xlarge`, 0.2129 USD per hour (it's actually fractionally cheaper). How does the hardware differ?

{% highlight text %}
$ ethminer --list-devices

Listing OpenCL devices.
FORMAT: [platformID] [deviceID] deviceName
[0] [0] Tesla K80
	CL_DEVICE_TYPE: GPU
	CL_DEVICE_GLOBAL_MEM_SIZE: 11995578368
	CL_DEVICE_MAX_MEM_ALLOC_SIZE: 2998894592
	CL_DEVICE_MAX_WORK_GROUP_SIZE: 1024

Listing CUDA devices.
FORMAT: [deviceID] deviceName
[0] Tesla K80
	Compute version: 3.7
	cudaDeviceProp::totalGlobalMem: 11995578368
{% endhighlight %}

{% highlight text %}
$ sudo lspci -v -s $(lspci | grep NVIDIA | cut -d" " -f 1)
00:1e.0 3D controller: NVIDIA Corporation Device 102d (rev a1)
	Subsystem: NVIDIA Corporation Device 106c
	Physical Slot: 30
	Flags: bus master, fast devsel, latency 0, IRQ 93
	Memory at 84000000 (32-bit, non-prefetchable) [size=16M]
	Memory at 1000000000 (64-bit, prefetchable) [size=16G]
	Memory at 82000000 (64-bit, prefetchable) [size=32M]
	Capabilities: [60] Power Management version 3
	Capabilities: [68] MSI: Enable+ Count=1/1 Maskable- 64bit+
	Capabilities: [78] Express Endpoint, MSI 00
	Kernel driver in use: nvidia
{% endhighlight %}

The `p2.xlarge` has a [NVIDIA Tesla K80](http://www.nvidia.com/object/tesla-k80.html), which has 4992 CUDA cores.

If we run the same miner on this hardware then again we see 100% GPU utilisation.

{% highlight text %}
$ nvidia-smi
Sun Dec  3 11:30:06 2017       
+------------------------------------------------------+                       
| NVIDIA-SMI 340.29     Driver Version: 340.29         |                       
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  Tesla K80           Off  | 0000:00:1E.0     Off |                    0 |
| N/A   73C    P0   130W / 149W |   2391MiB / 11519MiB |    100%      Default |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Compute processes:                                               GPU Memory |
|  GPU       PID  Process name                                     Usage      |
|=============================================================================|
|    0      1426  ethminer                                            2330MiB |
+-----------------------------------------------------------------------------+
{% endhighlight %}

What about hash rate? On the `p2.xlarge` I get a hash rate of around 8.5 Mh/s, which is appreciably better than the `g2.2xlarge`.

## Other Mining Pools

Some mining pools are better than others. And the hierarchy is fairly dynamic. So do some research to find out which one is currently the most attractive. Having said that, below are some good alternatives to Dwarfpool.

### Ethpool/Ethermine

[Ethpool](http://ethpool.org/) and [Ethermine](https://ethermine.org/) are distinct sites which appear to reference the same pool. Both charge a fee of 1% and have a minimum payout threshold of 0.05 ETH (you need to mine at least this amount before withdrawing).

Start mining on Ethermine:

{% highlight text %}
$ ethminer --farm-recheck 200 -G -S eu1.ethermine.org:4444 -FS us1.ethermine.org:4444 \
  -O 6Dd80e0BCC1cA62141b03e1B4978e569CE02d914.k80
{% endhighlight %}

There are a few new parameters here:

- `--farm-recheck`: interval at which to check for changed work;
- `-S`: stratum mode with specified stratum server;
- `-FS`: failover stratum server;
- `-O`: stratum login credentials.

### Nanopool

[Nanopool](https://nanopool.org/) has a similar cost structure to the other pools. It offers mining of a number of other cryptocurrencies too.

Start mining on Nanopool:

{% highlight text %}
$ ethminer --farm-recheck 200 -G -S eth-eu1.nanopool.org:9999 -FS eth-eu2.nanopool.org:9999 \
  -O 6Dd80e0BCC1cA62141b03e1B4978e569CE02d914.k80
{% endhighlight %}

## Profitability

Can you make money mining ETH on AWS?

Well, let's take a look at the numbers. I ran `ethminer` on a `p2.xlarge` instance for 24 hours. The cost was 5.11 USD. During that time my share of the Dwarfpool proceeds was 0.00119237 ETH, far below the payout threshold! At the current market price of 480 USD/ETH this is equivalent to 0.57 USD. That gives a profit margin of roughly -800%.

Short answer: no, you can't make money mining ETH on AWS!

## Conclusion

Setting up an Ethereum mining environment on AWS is pretty simple. The `p2.xlarge` is cheaper than the `g2.2xlarge` and also gives a better hash rate. But despite the fact that these AWS Spot Instances are very cost effective, they are still far too expensive for mining.