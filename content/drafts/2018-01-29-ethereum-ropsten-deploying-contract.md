---
draft: true
title: "Ethereum: Deploying a Smart Contract on Ropsten"
date: 2018-01-29T04:00:00+00:00
author: Andrew B. Collier
excerpt_separator: <!-- more -->
layout: post
tags:
  - Blockchain
  - Ethereum
---

{{< comment >}}
This illustrates how to deploy a contract onto the Ropsten (test) blockchain:

  - https://medium.com/@mvmurthy/full-stack-hello-world-voting-ethereum-dapp-tutorial-part-2-30b3d335aa1f
  - https://medium.com/@mvmurthy/full-stack-hello-world-voting-ethereum-dapp-tutorial-part-3-331c2712c9df
{{< /comment >}}

This will set up a local node on the Ropsten test network.

{% highlight text %}
$ geth --testnet
{% endhighlight %}







Until now we have been testing our contract on a lightweight local node hosted by testrpc. It's time to get an idea of how it will perform on a real blockchain. But we probably don't want to commit to the real Ethereum blockchain just yet. Fortunately there is a middle ground: public test networks. We'll be using the Ropsten network. There are alternatives to Ropsten, like [Rinkeby](https://www.rinkeby.io/).

## Create an Account

Before you can deploy a contract, you'll need to first [create an account]({{ site.baseurl }}{% post_url 2018-01-26-ethereum-ropsten-create-account %}) on Ropsten. After you've created an account you'll be able to see it listed in the Truffle console.

{% highlight text %}
truffle(development)> web3.eth.accounts
[ '0x0304bdbda48208ef3cccb9dffecf4d14ab6481b0' ]
{% endhighlight %}

Check that the account is funded. It's going to cost Ether to deploy our contract.

{% highlight text %}
truffle(development)> web3.eth.getBalance('0x0304bdbda48208ef3cccb9dffecf4d14ab6481b0')
{ [String: '5000000000000000000'] s: 1, e: 18, c: [ 50000 ] }
{% endhighlight %}

## Unlock the Account

Unlock the account.

{% highlight text %}
truffle(development)> web3.personal.unlockAccount('0x0304bdbda48208ef3cccb9dffecf4d14ab6481b0', '(Frye}dbpfAc2', 15000)
true
{% endhighlight %}

## Migrating the Contract

{% highlight bash %}
$ truffle migrate
{% endhighlight %}

This will take a short while. Long enough to check your email; too quick to make a coffee.

{% highlight text %}
Using network 'development'.

Running migration: 1_initial_migration.js
  Deploying Migrations...
  ... 0x80237303c2266b7e3ad31bc42b3edce125ea0cd95b55bd1d66248338347ac316
  Migrations: 0x56ca1764afb7f2600118df1e8e06375f2611a80d
Saving successful migration to network...
  ... 0x6a6e0839c79929a352465b851ae0a0b96cd94f22f9ab78edf28d7e82e9c4c8db
Saving artifacts...
Running migration: 2_deploy_contracts.js
  Deploying Counter...
  ... 0x4a0beb243c2ae6461e5b1e51f708cf89a43eca8fede93479c1efb9218a5f5bde
  Counter: 0x0a7ebd3c67cec5fb398e2658ed1d462530f698fb
Saving successful migration to network...
  ... 0x4272526f9a552cb8f42e249763a81907ce37981b13736be64b1be57c29c1f553
Saving artifacts...
{% endhighlight %}

![](/img/2017/12/ropsten-account-contract-deployed.png)