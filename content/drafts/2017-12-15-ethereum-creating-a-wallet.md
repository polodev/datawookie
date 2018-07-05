---
draft: true
title: "Ethereum: Creating a Wallet"
date: 2017-12-15T03:00:00+00:00
author: Andrew B. Collier
excerpt_separator: <!-- more -->
layout: post
tags:
  - Blockchain
  - Ethereum
---

Head over to [MyEtherWallet](https://www.myetherwallet.com/) and just follow the simple steps. Take careful note of all the information provided. This is serious stuff and if you don't take care then you will be place yourself at considerable risk!

<!-- more -->

You should definitely encrypt your wallet with a secure passphrase.

## Be Super Sceptical

Be extremely cautious with any sites that request information regarding your Ethereum details.

## Address

Your address is synonymous with your "account number" and "public key". This is the piece of information required when sending Ether to your account. You can safely share this information.

![](/img/2017/12/myetherwallet-details.png)

## Private Key and Passphrase

Your private key and passphrase, on the other hand, need to be kept secret and secure.

Make (at least!) one or more backup copies of your private key and passphrase. Good options are

- printing a hard copy (old school, but reliable)
- copy onto USB drive.

These backup copies should be stored in physically separate, secure locations.

![](/img/2017/12/xkcd-password-strength.png)

## Ethereum Wallet

Download the most recent release from [here](https://github.com/ethereum/mist/releases). I selected the 64 bit Debian release. Grab the one that's appropriate for your system.

{% highlight text %}
{% endhighlight %}

Start the wallet.

{% highlight text %}
$ ethereumwallet
{% endhighlight %}