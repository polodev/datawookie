---
draft: true
title: "Ethereum: Creating a Test Node"
date: 2018-01-10T08:00:00+00:00
author: Andrew B. Collier
excerpt_separator: <!-- more -->
layout: post
tags:
  - Blockchain
  - Ethereum
---

It would be completely impractical to test a new smart contract project against the live Ethereum blockchain. Rather we need some form of blockchain simulator, which behaves like the real thing but without any of the permanent consequences.

We need to have a way to test our smart contracts. There are a couple of ways to do this, both of which create a local instance of the Ethereum blockchain and allow you to simulate interactions.

We need to edit `truffle.js` and provide a network configuration. This specifies how we will be talking to the blockchain, which in this case will simply be hosted by a local test environment. There are two options for this test environment: testrpc and Truffle. The network configurations for these two options differ only in the port number used.

Find out more about configuration options [here](http://truffleframework.com/docs/advanced/configuration).

<!-- more -->

## testrpc

[testrpc](https://github.com/ethereumjs/testrpc) is a Ethereum client for testing and development.

Here's what you get with testrpc:

- a responsive fake node running on port 8545; and
- the ability to compile and run Solidity code.

Edit the `truffle.js` coniguration file as follows:

<script src="https://gist.github.com/DataWookie/bcdc574be984c0167c86e2fd3a6e816e.js"></script>

{% highlight bash %}
testrpc
{% endhighlight %}

{% highlight text %}
EthereumJS TestRPC v6.0.1 (ganache-core: 2.0.0)

Available Accounts
==================
(0) 0x10536e770238cdb28b49ea4759eed54fc179f35c
(1) 0xda3d5130faaa257fb993ccc33ab6a8716c2da221
(2) 0xad87112482882b689fd779b8160e36681fd977e5
(3) 0x747944608fb0e05c515c247398b92623559ce6ad
(4) 0xc17b49750b8c6238ff15af375401c08ab17c26a0
(5) 0x3b24089fb70d2cf069373fb61b5404c3ce854500
(6) 0x828a1cc251fcb3a16b20aace33dc04a24da6ba80
(7) 0xa30813ce65368ea2dbdb59b0b39d431fc909ae61
(8) 0x878e44a32fa83ca33935a15d24df92ca65c19b70
(9) 0xe0528a7caa86edccb445a761c512536b0a96e422

Private Keys
==================
(0) 3ee1507e6aba3baa09fb792e7bede0951ec1dcf46436f526b5c762a264648fd7
(1) 0056f413114029107829eeb58a3b0a2d3964ed5403da8fa0e443e5de508e51d0
(2) 31cf00225c716c8159c2a35472c92eb16a34bc203bf783668f22111d22916c9c
(3) 0ff571997e988ccd71864543e1fdcf0361c0425469d42d260ee51e0c6eccec40
(4) 01ae252a20155863838c9e6ca2de943aa5c2e328e1016fae0feaa8fbfaa43759
(5) 1e0931fbcedff379249771e1589c0f0f21140669bdd75c5bff03a5d52c9be050
(6) c20526c339e4a833aa5c9b2dcc0719e86cc43c72cf75c46c124eb91078dd2516
(7) 895925862c888234f3b86e0c2840c083ee7c4d7148df4227cfa5e7b2372aa541
(8) 23dde3d2b35e26f524376e8719e29c8f24adbb0504d418f119240b7f912e7329
(9) cd598b89fe5ca290edf49e8bb5e6e895ca67243f8aeba058241c838bfb237a2a

HD Wallet
==================
Mnemonic:      decline bag priority win view cousin heavy grocery velvet fatal heart exotic
Base HD Path:  m/44'/60'/0'/0/{account_index}

Listening on localhost:8545
{% endhighlight %}

Every time you restart testrpc it will, by default, generate a selection of 10 random accounts and their corresponding private keys. Each of these accounts is funded with 100 (bogus) Ether. If, however, you want to replicate the same environment you can kick off testrpc with the `-m` option and specify a particular menmonic. For example, to replicate the above environment, simple use:

{% highlight bash %}
testrpc -m "decline bag priority win view cousin heavy grocery velvet fatal heart exotic"
{% endhighlight %}

Alternatively you can get a deterministic (repeatable) environment by simply doing

{% highlight bash %}
testrpc -d
{% endhighlight %}

{% highlight text %}
EthereumJS TestRPC v6.0.1 (ganache-core: 2.0.0)

Available Accounts
==================
(0) 0x90f8bf6a479f320ead074411a4b0e7944ea8c9c1
(1) 0xffcf8fdee72ac11b5c542428b35eef5769c409f0
(2) 0x22d491bde2303f2f43325b2108d26f1eaba1e32b
(3) 0xe11ba2b4d45eaed5996cd0823791e0c93114882d
(4) 0xd03ea8624c8c5987235048901fb614fdca89b117
(5) 0x95ced938f7991cd0dfcb48f0a06a40fa1af46ebc
(6) 0x3e5e9111ae8eb78fe1cc3bb8915d5d461f3ef9a9
(7) 0x28a8746e75304c0780e011bed21c72cd78cd535e
(8) 0xaca94ef8bd5ffee41947b4585a84bda5a3d3da6e
(9) 0x1df62f291b2e969fb0849d99d9ce41e2f137006e

Private Keys
==================
(0) 4f3edf983ac636a65a842ce7c78d9aa706d3b113bce9c46f30d7d21715b23b1d
(1) 6cbed15c793ce57650b9877cf6fa156fbef513c4e6134f022a85b1ffdd59b2a1
(2) 6370fd033278c143179d81c5526140625662b8daa446c22ee2d73db3707e620c
(3) 646f1ce2fdad0e6deeeb5c7e8e5543bdde65e86029e2fd9fc169899c440a7913
(4) add53f9a7e588d003326d1cbf9e4a43c061aadd9bc938c843a79e7b4fd2ad743
(5) 395df67f0c2d2d9fe1ad08d1bc8b6627011959b79c53d7dd6a3536a33ab8a4fd
(6) e485d098507f54e7733a205420dfddbe58db035fa577fc294ebd14db90767a52
(7) a453611d9419d0e56f499079478fd72c37b251a94bfde4d19872c44cf65386e3
(8) 829e924fdf021ba3dbbc4225edfece9aca04b929d6e75613329ca6f1d31c0bb4
(9) b0057716d5917badaf911b193b12b910811c1497b5bada8d7711f758981c3773

HD Wallet
==================
Mnemonic:      myth like bonus scare over problem client lizard pioneer submit female collect
Base HD Path:  m/44'/60'/0'/0/{account_index}

Listening on localhost:8545
{% endhighlight %}


## Truffle Development Console

Edit the `truffle.js` coniguration file as follows:

<script src="https://gist.github.com/DataWookie/85f69833b4be8130c5b42f3ccdc63e02.js"></script>

In a separate terminal run `truffle develop`. This will listen on port 9545.

{% highlight text %}
Truffle Develop started at http://localhost:9545/

Accounts:
(0) 0x627306090abab3a6e1400e9345bc60c78a8bef57
(1) 0xf17f52151ebef6c7334fad080c5704d77216b732
(2) 0xc5fdf4076b8f3a5357c5e395ab970b5b54098fef
(3) 0x821aea9a577a9b44299b9c15c88cf3087f3b5544
(4) 0x0d1d4e623d10f9fba5db95830f7d3839406c6af2
(5) 0x2932b7a2355d6fecc4b5c0b6bd44cc31df247a2e
(6) 0x2191ef87e392377ec08e7c08eb105ef5448eced5
(7) 0x0f4f2ac550a1b4e2280d04c21cea7ebd822934b5
(8) 0x6330a553fc93768f612722bb8c2ec78ac90b3bbc
(9) 0x5aeda56215b167893e80b4fe645ba6d5bab767de

Mnemonic: candy maple cake sugar pudding cream honey rich smooth crumble sweet treat

truffle(develop)>
{% endhighlight %}