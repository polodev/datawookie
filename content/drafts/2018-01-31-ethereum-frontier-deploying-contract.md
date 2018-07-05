---
draft: true
title: "Ethereum: Deploying a Smart Contract on Frontier"
date: 2018-01-31T04:00:00+00:00
author: Andrew B. Collier
excerpt_separator: <!-- more -->
layout: post
tags:
  - Blockchain
  - Ethereum
---

{{< comment >}}
https://ethereumdev.io/deploy-truffle-smart-contracts-live-network/
{{< /comment >}}

In order to deploy a contract onto the live Ethereum blockchain you'll need to have

- a client which is synchronised with the blockchain;
- a client which is running a RPC server on a specific port (8546, for example, to differentiate it from a test RPC server);
- an account funded with sufficient Ether to pay for the deployment.

## Configure Truffle

You'll need to add a new network to your `truffle.js` configuration file.

## Deploying

{% highlight bash %}
truffle migrate --network live
{% endhighlight %}