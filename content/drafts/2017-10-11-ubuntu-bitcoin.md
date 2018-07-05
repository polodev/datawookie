---
draft: true
title: "Bitcoin: A Beginner's Journey"
date: 2017-10-07T07:00:00+00:00
author: Andrew B. Collier
layout: post
excerpt_separator: <!-- more -->
tags:
  - Ubuntu
  - Bitcoin
---

{{< comment >}}
https://www.linuxbabe.com/ubuntu/install-bitcoin-core-wallet-ubuntu-16-04-16-10
{{< /comment >}}

## Resources

- [Bitcoin Wiki](http://en.bitcoinwiki.org/Main_Page)
- [bitcoin.org](https://bitcoin.org/en/)
- [bitcoin.com](https://www.bitcoin.com/)
- [fiatleak.com](http://fiatleak.com/)
- []()
- []()
- []()

## Installing on Ubuntu

{% highlight bash %}
sudo add-apt-repository ppa:bitcoin/bitcoin
sudo apt update
sudo apt install -y bitcoin-qt bitcoind
{% endhighlight %}

### Synchronising Data

The first thing you'll need to do will be to get a local copy of the bitcoin data. To initiate this, just launch the Bitcoin Core client.

{% highlight bash %}
bitcoin-qt
{% endhighlight %}

![](/img/2017/10/bitcoin-welcome.png)
