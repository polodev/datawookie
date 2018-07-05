---
draft: true
title: "Ethereum: Building a Decentralised Application"
date: 2018-01-19T08:00:00+00:00
author: Andrew B. Collier
excerpt_separator: <!-- more -->
layout: post
tags:
  - Blockchain
  - Ethereum
---

{{< comment >}}
https://blockgeeks.com/guides/solidity/
{{< /comment >}}

https://cdn-images-1.medium.com/max/800/1*y7Cdz1uGBGLxZ3ekIE13RA.png

https://medium.com/@mvmurthy/full-stack-hello-world-voting-ethereum-dapp-tutorial-part-1-40d2d0d807c2
https://medium.com/@mvmurthy/full-stack-hello-world-voting-ethereum-dapp-tutorial-part-2-30b3d335aa1f
https://medium.com/@mvmurthy/full-stack-hello-world-voting-ethereum-dapp-tutorial-part-3-331c2712c9df

https://medium.com/@ConsenSys/a-101-noob-intro-to-programming-smart-contracts-on-ethereum-695d15c1dab4 READ MOST OF IT ALREADY EXCEPT THE DAPP STUFF AT THE END

A Decentralised Application (or "DApp"; or, if you're one of the cool kids, "ÐApp") is a ...

Each client connects to its own instance of the Dapp. No central server involved. This is diametrically opposite to the "conventional" web application where all clients communicate with one (or a few) central servers.

A disadvantage of Dapps is that everybody needs to have a local copy of the whole blockchain. This is a necessary evil though: to get around the problem of all data being stored on one central server, you need to create many copies of the data so that it's distributed across numerous locations.

https://github.com/ethereum/wiki/wiki/Useful-%C3%90app-Patterns

## web3

[web3.js](https://github.com/ethereum/web3.js/) is a JavaScript library which facilitates interactions with Ethereum nodes and smart contracts.

https://github.com/Tectract/ethereum-demo-tools/tree/master/GeektReactApp

### Installing web3.js

Install the web3.js module by running the following inside your project folder:

{% highlight bash %}
npm install -S web3
{% endhighlight %}

That will install the latest version of web3.js. However it's probably better to install a specific (stable) version.

{% highlight bash %}
npm install -S web3@0.20.1
{% endhighlight %}

## Installing web3.py

https://github.com/pipermerriam/web3.py




{{< comment >}}
https://blockgeeks.com/guides/how-to-learn-solidity/
{{< /comment >}}


{{< comment >}}
https://www.stateofthedapps.com/

https://medium.com/@mvmurthy/full-stack-hello-world-voting-ethereum-dapp-tutorial-part-2-30b3d335aa1f.
{{< /comment >}}

A decentralised application will most likely provide the capability to either

- deploy a contract and then
- interact with that contract

or

- interact with an existing contract.


## MetaMask

<iframe width="560" height="315" src="https://www.youtube.com/embed/6Gf_kRE4MJU" frameborder="0" allowfullscreen></iframe>

When you activate MetaMask you'll be asked to accept a Privacy Notice and a Terms of Use.

Creating a New Den

Provide a password. Then you'll see something like this:

![](/img/2017/11/metamask-words.png)

Keep a copy of those words somewhere safe.

## Mist