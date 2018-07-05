---
draft: true
title: "Ethereum: Notes on Solidity"
date: 2018-01-05T08:00:00+00:00
author: Andrew B. Collier
excerpt_separator: <!-- more -->
layout: post
tags:
  - Blockchain
  - Ethereum
---

Solidity has a syntax similar to JavaScript.

<!-- more -->

`msg.sender` is the address that is sending a transaction.

## Contracts and Instances

The relationship between contracts and instances is analogous to that between classes and objects.

## Data Types

- `address`
- `uint`

### Mappings and Arrays

use `call(3)`, for example, to get the the item at index 3. CHECK THIS!!!

A mapping is the same as an associative array or hash, and consists of key-value pairs.

{% highlight javascript %}
mapping (address => unit) balances;
{% endhighlight %}

### Doubly Linked List

### Access Modifiers

TALK ABOUT PUBLIC

An accessor function will automatically be created for every public state variable.

### Structures

`struct`

## Constructor

The constructor is executed once when the contract is deployed to the blockchain. Code that has been deployed on the blockchain is immutable. Deploying the same contract a second time will create a new instance on the blockchain but the original contract (and any data that it stores) will remain intact.

The address of an instance is automatically assigned to the `this` attribute.

In Truffle the arguments to the constructor a provided by a call to `deployer.deploy()` in the migration file.

## Self Destruct

Funds associated with a contract are stored in the contract itself. The `selfdestruct()` method will release those funds to the account which originally created the contract.

If your contract doesn't collect funds then this is not important. However, if it does handle funds it's vital that there should be a mechanism to destroy the contract and liberate those funds. Otherwise the funds could be captured by the contract for all eternity.

## Libraries

Libraries allow you to abstract out common code for future reuse.

## Modifiers

## Interacting with Smart Contracts

REFER TO "SMART CONTRACT NOTES" POST WHICH GIVES HIGH LEVEL VIEW OF WHAT HAPPENS WITH CALL/TRANSACTION.

<blockquote>
	Call
A call is a local invocation of a contract function that does not broadcast or publish anything on the blockchain.

It is a read-only operation and will not consume any Ether. It simulates what would happen in a transaction, but discards all the state changes when it is done.

It is synchronous and the return value of the contract function is returned immediately.

Its web3.js API is web3.eth.call and is what's used for Solidity constant functions.

Its underlying JSON-RPC is eth_call

Transaction
A transaction is broadcasted to the network, processed by miners, and if valid, is published on the blockchain.

It is a write-operation that will affect other accounts, update the state of the blockchain, and consume Ether (unless a miner accepts it with a gas price of zero).

It is asynchronous, because it is possible that no miners will include the transaction in a block (for example, the gas price for the transaction may be too low). Since it is asynchronous, the immediate return value of a transaction is always the transaction's hash. To get the "return value" of a transaction to a function, Events need to be used (unless it's Case4 discussed below).

Its web3.js API is web3.eth.sendTransaction and is used if a Solidity function is not marked constant.

Its underlying JSON-RPC is eth_sendTransaction

sendTransaction will be used when a verb is needed, since it is clearer than simply transaction.
</blockquote>

### Calls

A call is used to retrieve information from a contract. A call does not involve any mining (so it's completely free: no gas required) and is also not signed with a public key (so it's anonymous and actually doesn't leave any trace). Executing a call happens for free because it can be done locally and does not involve any modification to the blockchain.

### Transactions

When a transaction method is triggered, the function should return essentially immediately. However, this does not mean that the transaction has actually occurred. Far from it! This is just initiating the transaction. What happens next is that the transaction is submitted to the network of Ethereum miners. The transaction is actually only applied when it gets mined into a new block. With a test node this will appear to be essentially instantaneous. However, in practice on a real blockchain it might take some time.

The account which initiates a transaction and the value of that transaction can be accessed as `msg.sender` and `msg.value`.

Any transaction can be passed an object with one or more of the following fields:

- `from`
- `value`
- `gas`: the maximum amount of gas you're willing to expend on this transaction.

## Error Handling

https://medium.com/blockchannel/the-use-of-revert-assert-and-require-in-solidity-and-the-new-revert-opcode-in-the-evm-1a3a7990e06e

## Events

You can trigger events in Solidity code. These will be logged in the output from testRPC (SHOW THIS!).

The web3 API allows you to [listen](https://github.com/ethereum/wiki/wiki/JavaScript-API#contract-events) for events and execute code when they occur.

## Filters

NOTES ON FILTERS IN WEB3 https://github.com/ethereum/wiki/wiki/JavaScript-API#web3ethfilter
