---
draft: true
title: "Ethereum: Initial Impressions"
date: 2017-12-13T03:00:00+00:00
author: Andrew B. Collier
excerpt_separator: <!-- more -->
layout: post
tags:
  - Blockchain
  - Ethereum
---

THIS IS AWESOME: http://www.ethviewer.live/

https://medium.freecodecamp.org/the-authoritative-guide-to-blockchain-development-855ab65b58bc

## Blockchain

Blockchains in general, and the Ethereum blockchain in particular, have a number of useful characteristics:

- decentralised;
- XXX
- XXX
- XXX

They achieve these characteristics as a result of a handful of technologies:

- asymmetric cryptography;
- cryptographic hashing;
- peer-to-peer networking.

<iframe width="560" height="315" src="https://www.youtube.com/embed/k53LUZxUF50" frameborder="0" gesture="media" allow="encrypted-media" allowfullscreen></iframe>

## Ethereum

The [Ethereum Guide](https://ethereum-homestead.readthedocs.io/en/latest/) is an excellent place to get a broad view over a various aspects of the Ethereum project.

Learning something new is massively invigorating. I've been dabbling with smart contracts and Ethereum. It's all very new to me right now and I'm still running around, wide eyed and knocking things over. But I'm also starting to figure out how things work. Taking lots of notes along the way. This is the first of those notes.

### Addresses

Addresses can be represented as a number in base 58:

- digits except 0 (1-9)
- upper case letters except O (A-N, P-Z) and
- lower case letters (a-z).

## Mining

The difficulty changes dynamically to ensure that a new block is only mined roughly every 13 seconds.

<a href="https://etherscan.io/chart/blocktime"><img src="/img/2017/12/ethereum-block-mining-time.png" /></a>

## Resources

A quick directory of useful sites for working with Ethereum:

- [ethereum.org](https://ethereum.org/)
- [MyEtherWallet](https://www.myetherwallet.com/) for creating a wallet.
- [Etherscan](https://etherscan.io/) allows you to see the current balance in an Ethereum account and a list of transactions associated with that account. From the home page you can see statistics about recently mined blocks and transactions. There's a version of Etherscan specifically for the [Ropsten test network](https://ropsten.etherscan.io/).
- [ethernodes.org](https://ethernodes.org/): explore nodes on the main and test network.
- [Ethplorer](https://ethplorer.io/)
- [ether.camp](https://live.ether.camp/)
- [https://infura.io/](Infura): public RPC access to all Ethereum networks.

### Web3

- [web3.js Documentation](http://web3js.readthedocs.io/en/1.0/) (under development)
- [web3.js Wiki](https://github.com/ethereum/wiki/wiki/JavaScript-API)
- [web3.js](https://gitter.im/ethereum/web3.js) gitter community.

### Solidity

- [Solidity Documentation](http://solidity.readthedocs.io/en/latest/index.html)
- [Solidity Online Compiler](https://ethereum.github.io/browser-solidity/)
- [Solidity](https://gitter.im/ethereum/solidity) gitter community.

### Mist

- [Mist](https://gitter.im/ethereum/mist) gitter community.