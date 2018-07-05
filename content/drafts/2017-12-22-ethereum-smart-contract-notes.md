---
draft: true
title: "Ethereum: Notes on Smart Contracts"
date: 2017-12-22T08:00:00+00:00
author: Andrew B. Collier
excerpt_separator: <!-- more -->
layout: post
tags:
  - Blockchain
  - Ethereum
---

<!-- more -->

ULTIMATE REFERENCE: http://solidity.readthedocs.io/en/develop/contracts.html

<blockquote>
	When you call a smart-contract that does some state-changing work or computation (any action besides other than simply reading from storage), you will incur a gas “cost” for the work done by the smart contract, and this gas cost is related to the amount of computational work required to execute your function. It’s sort of a “micropayment for microcomputing” system, where you can expect to pay a set amount of gas for a set amount of computation, forever.

The price of gas itself is meant to stay generally constant, meaning that when Ether goes up on the global markets, the price of gas against Ether should go down. Thus, when you execute a function call to a smart-contract, you can get an estimation of the amount of gas you must pay beforehand, but you must also specify the price (in ether per gas) that you are willing to pay, and the mining nodes can decide if that’s a good enough rate for them to pick up your smart-contract function call in their next block.
</blockquote>

A smart contract has its own address on the blockchain, which means that it can send and receive ETH in much the same way as your personal account.

## Operations

There are two types of operations: calls and transactions.

### Calls

A call does not make any changes to the blockchain. It is a read operation. It does not consume Ether.

<blockquote>
	Calls, on the other hand, are very different. Calls can be used to execute code on the network, though no data will be permanently changed. Calls are free to run, and their defining characteristic is that they read data. When you execute a contract function via a call you will receive the return value immediately. In summary, calls:

Are free (do not cost gas)
Do not change the state of the network
Are processed immediately
Will expose a return value (hooray!)
Choosing between a transaction and a call is as simple as deciding whether you want to read data, or write it.
</blockquote>

### Transactions

<blockquote>
	Transactions fundamentally change the state of the network. A transaction can be as simple as sending Ether to another account, or as complicated as executing a contract function or adding a new contract to the network. The defining characteristic of a transaction is that it writes (or changes) data. Transactions cost Ether to run, known as "gas", and transactions take time to process. When you execute a contract's function via a transaction, you cannot receive that function's return value because the transaction isn't processed immediately. In general, functions meant to be executed via a transaction will not return a value; they will return a transaction id instead. So in summary, transactions:

Cost gas (Ether)
Change the state of the network
Aren't processed immediately
Won't expose a return value (only a transaction id).
</blockquote>

A transaction makes changes to the blockchain.

is broadcasted to the network, processed by miners, and if valid, is published on the blockchain.

It is a write-operation that will affect other accounts, update the state of the blockchain, and consume Ether (unless a miner accepts it with a gas price of zero).

It is asynchronous, because it is possible that no miners will include the transaction in a block (for example, the gas price for the transaction may be too low). Since it is asynchronous, the immediate return value of a transaction is always the transaction's hash. To get the "return value" of a transaction to a function, Events need to be used (unless it's Case4 discussed below).

Its web3.js API is web3.eth.sendTransaction and is used if a Solidity function is not marked constant.

Its underlying JSON-RPC is eth_sendTransaction

sendTransaction will be used when a verb is needed, since it is clearer than simply transaction.

## Oracle

Transactions on the blockchain need to be deterministic so that all nodes on the network can come to a consensus on the outcome of a transaction. This is one of the reasons why access to external resources, which might return non-deterministic results, is restricted. However, it's possible to access an *oracle*, which can be trusted to always return a consistent response.