---
draft: true
title: "Ethereum: DIY Tools for Decentralised Applications"
date: 2017-12-20T04:30:00+00:00
author: Andrew B. Collier
excerpt_separator: <!-- more -->
layout: post
tags:
  - Blockchain
  - Ethereum
---

### Web3

[web3.js](https://github.com/ethereum/web3.js/) is the Ethereum JavaScript API. This will allow you to interact with smart contracts from a browser.

{% highlight bash %}
sudo npm install -g web3@0.20.1
{% endhighlight %}

### MetaMask

[MetaMask](https://metamask.io/) is a Chrome browser extension which allows you to interact with Ethereum decentralised apps without running an Ethereum node or downloading the blockchain. You can install it directly from the [Chrome Web Store](https://chrome.google.com/webstore/search/metamask).

<blockquote>
  MetaMask injects a web3 object into your frontend which is preconfigured to use the public Ropsten network.
</blockquote>

### Mist

Download the most recent release of Mist from [here](https://github.com/ethereum/mist/releases). I selected the 64 bit Debian release. Grab the one that's appropriate for your system. While you're about it, you might as well also download the Ethereum Wallet, which is essentially a restricted version of Mist.

{% highlight text %}
$ sudo dpkg -i Ethereum-Wallet-linux64-0-9-3.deb
$ sudo dpkg -i Mist-linux64-0-9-3.deb
{% endhighlight %}

Before you run either Mist or the Ethereum Wallet you'll need to [start a local node](#go-implementation) and synchronise with the blockchain.

YOU SHOULD ACTUALLY BE ABLE TO RUN MIST OR WALLET WITHOUT RUNNING GETH... CHECK THE COMMAND LINE OPTIONS.

Start the browser.

{% highlight text %}
$ mist
{% endhighlight %}

Or start the wallet.

{% highlight text %}
$ ethereumwallet
{% endhighlight %}