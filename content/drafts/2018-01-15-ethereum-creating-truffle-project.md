---
draft: true
title: "Ethereum: A Simple Truffle Project"
date: 2018-01-15T08:00:00+00:00
author: Andrew B. Collier
excerpt_separator: <!-- more -->
layout: post
tags:
  - Blockchain
  - Ethereum
---

{{< comment >}}
General introductions:

  - https://medium.com/@ConsenSys/a-101-noob-intro-to-programming-smart-contracts-on-ethereum-695d15c1dab4

This illustrates how to hook up a small web site to the contract:

  - https://medium.com/@mvmurthy/full-stack-hello-world-voting-ethereum-dapp-tutorial-part-1-40d2d0d807c2.
{{< /comment >}}

Truffle provides an environment in which you can compile and test smart contracts. Instructions for installing Truffle and other handy tools can be found in the [Ethereum Starter Kit]({{ site.baseurl }}{% post_url 2018-01-19-ethereum-diy-smart-contract %}) post. A good place to start is by taking a quick look at the [Truffle documentation](http://truffleframework.com/docs/). But after that you'll probably want to dive right in. That was certainly my experience.

<!-- more -->

CHECK THESE OUT:

https://ethereum.org/greeter
https://dappsforbeginners.wordpress.com/

Before starting on this tutorial it's worthwhile opening the [Truffle Documentation](http://truffleframework.com/docs/) and poking around to see what reference material is available there. It's pretty extensive and kept up to date.

We'll be building a simple smart contract that implements a counter. Although we'll be doing this from scratch, the full code for this project is available from [this repository](https://github.com/DataWookie/ethereum-counter).

For reference I'm working with the following software versions:

- Truffle 4.0.1
- testrpc 6.0.1

## Workflow

This is the typical workflow for developing a smart contract:

1. Initiate an Ethereum test node.
2. Write or revise a contract.
3. Compile.
4. Deploy.
5. Interact with deployed contract.
6. Iterate back to step 2 if necessary.

## Truffle Operations

Simply running `truffle` in a terminal without any further arguments will generate a summary of usage options.

{% highlight text %}
Truffle v4.0.1 - a development framework for Ethereum

Usage: truffle <command> [options]

Commands:
  init      Initialize new Ethereum project with example contracts and tests
  compile   Compile contract source files
  migrate   Run migrations to deploy contracts
  deploy    (alias for migrate)
  build     Execute build pipeline (if configuration present)
  test      Run Mocha and Solidity tests
  debug     Interactively debug any transaction on the blockchain (experimental)
  opcode    Print the compiled opcodes for a given contract
  console   Run a console with contract abstractions and commands available
  develop   Open a console with a local TestRPC
  create    Helper to create new contracts, migrations and tests
  install   Install a package from the Ethereum Package Registry
  publish   Publish a package to the Ethereum Package Registry
  networks  Show addresses for deployed contracts on each network
  watch     Watch filesystem for changes and rebuild the project automatically
  serve     Serve the build directory on localhost and watch for changes
  exec      Execute a JS module within this Truffle environment
  unbox     Unbox Truffle project
  version   Show version number and exit

See more at http://truffleframework.com/docs
{% endhighlight %}

We'll only be using a subset of these right now. Other operations will have to wait for later.

## Creating a Truffle Project

Create a new folder for the project. We'll use something nice and generic.

{% highlight bash %}
mkdir truffle-project
cd truffle-project
{% endhighlight %}

Initialise the project.

{% highlight bash %}
truffle init
{% endhighlight %}

{% highlight text %}
Downloading...
Unpacking...
Setting up...
Unbox successful. Sweet!

Commands:

  Compile:        truffle compile
  Migrate:        truffle migrate
  Test contracts: truffle test
{% endhighlight %}

This creates a simple folder hierachy and populates it with a few boilerplate files.

{% highlight text %}
.
├── contracts
│   └── Migrations.sol
├── migrations
│   └── 1_initial_migration.js
├── test
├── truffle-config.js
└── truffle.js
{% endhighlight %}

There's already a `Migrations.sol` file in the `contracts/` folder. This creates a smart contract which actually keeps track of the state of your project. Just leave that alone because it's going to make your life easier.

## Create a Smart Contract

{% highlight bash %}
truffle create contract Counter
{% endhighlight %}

That will create a new file `Counter.sol` file in the `contracts/` folder.

We'll build a smart contract based on some code from the [solidity-baby-steps repository](https://github.com/fivedogit/solidity-baby-steps), which has a bunch of examples. The smart contract implements a simple counter and is written in [Solidity](https://solidity.readthedocs.io/en/develop/index.html).

{% highlight javascript %}
pragma solidity ^0.4.4;

contract Counter {
    address public creator;
    uint counter;

    function Counter() public
    {
        creator = msg.sender; 
        counter = 0;
    }

    function increment() public
    {
        counter = counter + 1;
    }

    modifier onlyCreator() {
        require(msg.sender == creator);
        _;
    } 

    function set(uint value) onlyCreator public
    {
        counter = value;
    }

    function get() public constant returns (uint)
    {
        return counter;
    }

    function kill() public
    { 
        if (msg.sender == creator) selfdestruct(creator);  
    }
}
{% endhighlight %}


The `pragma` in the first line of the contract file specifies the required Solidity compiler version. I made a few minor changes to the original code to make it conformant with this version of Solidity.

This contract stores a couple of state variables on the blockchain. Storing data is relatively more costly than simply performing computations.

## Compile

Next we'll compile the contract.

{% highlight bash %}
truffle compile
{% endhighlight %}

That will create a `build/contracts` folder and beneath it a JSON file for each contract in the `contracts/` folder. These JSON files (or "artefacts") contain the bytecode for the contracts.

{% highlight text %}
.
├── build
│   └── contracts
│       ├── Counter.json
│       └── Migrations.json
├── contracts
│   ├── Counter.sol
│   └── Migrations.sol
├── migrations
│   └── 1_initial_migration.js
├── test
├── truffle-config.js
└── truffle.js
{% endhighlight %}

Find out more about compiling contracts [here](http://truffleframework.com/docs/getting_started/compile).

## Network Configuration and Local Test Node Server

Next we need to edit `truffle.js` and provide a network configuration. This specifies how we will be talking to the blockchain, which in this case will simply be hosted by a local test environment. There are two options for this test environment: testrpc and Truffle. Have a look at [Creating an Ethereum Test Node]({{ site.baseurl }}{% post_url 2018-01-10-ethereum-test-node %}) FIX THIS LINK!!! to find out more about these. The network configurations for these two options differ only in the port number used.

We'll launch a repeatable testrpc node as follows

{% highlight bash %}
testrpc -d
{% endhighlight %}

## Migrate

Once you've configured your network and started a test node, you're ready to migrate.

In the `migrations` folder you'll find `1_initial_migration.js`, which references `Migrations.sol` in the `contracts` folder. That defines a `Migrations` contract which essentially manages the migration of further contracts. It keeps track of which contracts have been migrated via the `last_completed_migration` field.

You can read the documentation around migrations [here](http://truffleframework.com/docs/getting_started/migrations).

### How Much Gas?

We can get an estimate of the gas costs of deploying this contract.

{% highlight bash %}
solc --gas contracts/Counter.sol
{% endhighlight %}

{% highlight text %}
   ======= contracts/Counter.sol:Counter =======
Gas estimation:
construction:
   25452 + 133400 = 158852
external:
   creator(): 434
   get(): 460
   increment(): 20436
   kill():  30658
   set(uint256):  20498
{% endhighlight %}

### Adding to the Blockchain

Create `migrations/2_deploy_contracts.js`.

{% highlight javascript %}
var Counter = artifacts.require("./Counter.sol");

module.exports = function(deployer) {
	deployer.deploy(Counter);
};
{% endhighlight %}

If you need to pass arguments to the constructor then these would be provided as additional arguments to `deployer.deploy()`.

Now we're ready to migrate our smart contract, which will add (or "deploy") it to our test node.

{% highlight bash %}
truffle migrate
{% endhighlight %}

{% highlight text %}
Using network 'development'.

Running migration: 1_initial_migration.js
  Replacing Migrations...
  ... 0x104a53892ecf8aba5b7993a3eae4746dd35b0f4d4d1e18a11a44c65da375dbd6
  Migrations: 0x05b02f6d3d0a602f12212e04dc9a13336e2e6d39
Saving successful migration to network...
  ... 0xff62e4e04673d9df6673fb532f8a62b4767c8221d16c0e938dd7f684703eda3e
Saving artifacts...
Running migration: 2_deploy_contracts.js
  Replacing Counter...
  ... 0x04c8261ae7883c995164b7ed1b13d0506ee5774231931b4aef2fba90690061cf
  Counter: 0x60003b9ad41c1cb8bcb9ceff16bdd03cf06f4c5f
Saving successful migration to network...
  ... 0x98731089fad71d2210c8735af364b9dfef8cddd92180b144f42d85aacce6b70e
Saving artifacts...
{% endhighlight %}

The address of a smart contract is where people will send transactions. Addresses also allows smart contracts to interact with each other. From the output above we can see that the address for the `Counter` contract is 0x60003b9ad41c1cb8bcb9ceff16bdd03cf06f4c5f.

Unless you make changes to the smart contract then the operation above is idempotent: if you try to migrate again then nothing will happen.

{% highlight bash %}
truffle migrate
{% endhighlight %}

{% highlight text %}
Using network 'development'.

Network up to date.
{% endhighlight %}

If you want to force migration again then you'll need to use `truffle migrate --reset`.

It can be handy to lump the compile and migrate steps together.

{% highlight bash %}
truffle compile && truffle migrate --reset
{% endhighlight %}

At this stage your new contract has been added to the test blockchain on testrpc. Be aware that if you restart testrpc then any deployed contracts will be lost. It'll start again from scratch (blank, nothing, *tabula rasa*!).

Find out more about migrating contracts [here](http://truffleframework.com/docs/getting_started/migrations).

## Working with the Console

You can use the Truffle console to interact with the smart contract.

{% highlight bash %}
truffle console
{% endhighlight %}

### Accounts

Let's have a look at the accounts available on the test node.

{% highlight text %}
truffle(development)> web3.eth.accounts
[ '0x90f8bf6a479f320ead074411a4b0e7944ea8c9c1',
  '0xffcf8fdee72ac11b5c542428b35eef5769c409f0',
  '0x22d491bde2303f2f43325b2108d26f1eaba1e32b',
  '0xe11ba2b4d45eaed5996cd0823791e0c93114882d',
  '0xd03ea8624c8c5987235048901fb614fdca89b117',
  '0x95ced938f7991cd0dfcb48f0a06a40fa1af46ebc',
  '0x3e5e9111ae8eb78fe1cc3bb8915d5d461f3ef9a9',
  '0x28a8746e75304c0780e011bed21c72cd78cd535e',
  '0xaca94ef8bd5ffee41947b4585a84bda5a3d3da6e',
  '0x1df62f291b2e969fb0849d99d9ce41e2f137006e' ]
{% endhighlight %}

The first of these is the default account for the session.

{% highlight text %}
truffle(development)> web3.eth.coinbase
'0x90f8bf6a479f320ead074411a4b0e7944ea8c9c1'
{% endhighlight %}

We can check the available balance on an account.

{% highlight text %}
truffle(development)> web3.eth.getBalance(web3.eth.accounts[0])
{ [String: '99947841300000000000'] s: 1, e: 19, c: [ 999478, 41300000000000 ] }
truffle(development)> web3.eth.getBalance(web3.eth.accounts[1])
{ [String: '100000000000000000000'] s: 1, e: 20, c: [ 1000000 ] }
{% endhighlight %}

We see that the first account has used up some gas in the process of deploying the first contract.

The information about accounts is retrieved from the `web3` object, which is exposed by the [web3.js library (Ethereum JavaScript API)](https://github.com/ethereum/web3.js). Further examples of interacting with this library are given below.

### Contract Characteristics

{% highlight text %}
truffle(development)> Counter.address
'0x60003b9ad41c1cb8bcb9ceff16bdd03cf06f4c5f'
{% endhighlight %}

{% highlight text %}
truffle(development)> Counter.abi
[ { constant: true,
    inputs: [],
    name: 'creator',
    outputs: [ [Object] ],
    payable: false,
    stateMutability: 'view',
    type: 'function' },
  { constant: false,
    inputs: [],
    name: 'kill',
    outputs: [],
    payable: false,
    stateMutability: 'nonpayable',
    type: 'function' },
  { constant: false,
    inputs: [ [Object] ],
    name: 'set',
    outputs: [ [Object] ],
    payable: false,
    stateMutability: 'nonpayable',
    type: 'function' },
  { constant: true,
    inputs: [],
    name: 'get',
    outputs: [ [Object] ],
    payable: false,
    stateMutability: 'view',
    type: 'function' },
  { constant: false,
    inputs: [],
    name: 'increment',
    outputs: [],
    payable: false,
    stateMutability: 'nonpayable',
    type: 'function' },
  { inputs: [],
    payable: false,
    stateMutability: 'nonpayable',
    type: 'constructor' } ]
{% endhighlight %}

### Interacting with the Smart Contract

{% highlight text %}
truffle(development)> var counter = Counter.deployed()
undefined
{% endhighlight %}

Since operations on the blockchain do not occur instantaneously, our interactions with the smart contract are mediated via [promises](https://developers.google.com/web/fundamentals/primers/promises).

{% highlight text %}
truffle(development)> counter.then(instance => instance.get.call())
{ [String: '0'] s: 1, e: 0, c: [ 0 ] }
{% endhighlight %}

{% highlight text %}
truffle(development)> counter.then(instance => instance.increment())
'0xd08c6051ff3d0c223d744924532e728f23fbc7b8fdb45e2a047db209ffa72c50'
truffle(development)> counter.then(instance => instance.get.call())
{ [String: '1'] s: 1, e: 0, c: [ 1 ] }
{% endhighlight %}

The long hexadecimal string is the unique transaction identifier.

{% highlight text %}
truffle(development)> counter.then(instance => instance.increment())
'0x27c7209451c8fa0d820f7b9056e6d4ae0eb78226a6a552a7914ccb26a96fa973'
truffle(development)> counter.then(instance => instance.get.call())
{ [String: '2'] s: 1, e: 0, c: [ 2 ] }
{% endhighlight %}

Now those transactions have been executed by the same (default) account. And they would have consumed some gas. We can check on that.

{% highlight text %}
truffle(development)> web3.eth.getBalance(web3.eth.accounts[0])
{ [String: '99829853900000000000'] s: 1, e: 19, c: [ 998298, 53900000000000 ] }
{% endhighlight %}

What about sending a transaction from a different account?

{% highlight text %}
truffle(development)> counter.then(instance => instance.increment({ from:web3.eth.accounts[1] }))
'0x13cc1feff2b35995908fc3ed16af5620737eab92d17c44046f5c03946b7fbdab'
truffle(development)> web3.eth.getBalance(web3.eth.accounts[1])
{ [String: '99997331400000000000'] s: 1, e: 19, c: [ 999973, 31400000000000 ] }
{% endhighlight %}

Find out more about interacting with contracts [here](http://truffleframework.com/docs/getting_started/contracts).

### Creating Contract from a Specific Account

THIS NEEDS TO BE EDITED AND DISCUSSED.

{% highlight text %}
truffle(development)> var counter = Counter.deployed()
undefined
truffle(development)> counter.then(instance => instance.creator.call())
'0x90f8bf6a479f320ead074411a4b0e7944ea8c9c1'
truffle(development)> var counter = Counter.new({ from: web3.eth.accounts[1] })
undefined
truffle(development)> counter.then(instance => instance.creator.call())
'0xffcf8fdee72ac11b5c542428b35eef5769c409f0'
{% endhighlight %}

### Transactions from a Specific Account

The contract applies a modifier to the `set()` method. The modifier, in turn, uses the `require()` guard function to ensure that `set()` is only executable by the contract creator. Let's test that out.

{% highlight text %}
truffle(development)> counter.then(instance => instance.set(1))
'0x7e4fe2ab7abc377e8c71efb09d4e18cbb9a90bd68f98176a89780ff615dc700e'
truffle(development)> counter.then(instance => instance.get.call())
{ [String: '1'] s: 1, e: 0, c: [ 1 ] }
{% endhighlight %}

That just used the default account. We can explicitly specify that account too.

{% highlight text %}
truffle(development)> counter.then(instance => instance.set(0, { from:web3.eth.accounts[0] }))
'0x9a73353da8acbbab6bf14301004ec6333418e2b1e36671646433d2fc3a8b3bb6'
{% endhighlight %}

Works fine! But what happens if we use a different account?

{% highlight text %}
truffle(development)> counter.then(instance => instance.set(0, { from:web3.eth.accounts[1] }))
Error: VM Exception while processing transaction: revert
{% endhighlight %}

As expected, it generates an error (and a stack trace which has been omitted for brevity). Another, less dramatic, approach would have been to use a simple conditional like in `kill()`, which would fail silently. This is probably a better solution though.

### The Web3 API

We can retrieve a receipt for any transaction by specifying the transaction identifier.

{% highlight text %}
truffle(development)> web3.eth.getTransactionReceipt('0x13cc1feff2b35995908fc3ed16af5620737eab92d17c44046f5c03946b7fbdab')
{ transactionHash: '0x13cc1feff2b35995908fc3ed16af5620737eab92d17c44046f5c03946b7fbdab',
  transactionIndex: 0,
  blockHash: '0x6e6bfaa65392077be6b9abf3ea802165bf67c84b11581a04777d46689e7b7fdb',
  blockNumber: 18,
  gasUsed: 26686,
  cumulativeGasUsed: 26686,
  contractAddress: null,
  logs: [],
  status: 1 }
{% endhighlight %}

We can find the number of transactions sent from a particular account.

{% highlight text %}
truffle(development)> web3.eth.getTransactionCount('0xffcf8fdee72ac11b5c542428b35eef5769c409f0')
1
{% endhighlight %}

Account balances are returned in [units of Wei](https://etherconverter.online/). We can convert to other units.

{% highlight text %}
truffle(development)> web3.fromWei(web3.eth.getBalance(web3.eth.coinbase), 'ether');
{ [String: '99.8245167'] s: 1, e: 1, c: [ 99, 82451670000000 ] }
{% endhighlight %}

Read the [wiki](https://github.com/ethereum/wiki/wiki/JavaScript-API) to find out more about the web3 API.

{% highlight text %}
{% endhighlight %}

{% highlight text %}
{% endhighlight %}

{% highlight text %}
{% endhighlight %}


## Tests

You can write test for your contracts using either [JavaScript](http://truffleframework.com/docs/getting_started/javascript-tests) or [Solidity](http://truffleframework.com/docs/getting_started/solidity-tests). Since we have been interacting thus far in JavaScript it makes sense to make it our testing language too.

Create the framework for some tests.

{% highlight text %}
truffle create test Counter
{% endhighlight %}

This will generate a JavaScript file with a single test. You'll need to add in the first line below to include the declaration of the `Counter` contract.

{% highlight javascript %}
var Counter = artifacts.require("Counter.sol");

contract('Counter', function(accounts) {
  it("should assert true", function(done) {
    var counter = Counter.deployed();
    assert.isTrue(true);
    done();
  });
});
{% endhighlight %}

Now run the test.

{% highlight text %}
truffle test
{% endhighlight %}

This simple test will pass (unless something has gone horribly wrong!).

Check out the [repository](https://github.com/DataWookie/ethereum-counter) for some slightly more interesting tests. An important aspect of writing these tests (and interacting with smart contracts in general) is to acknowledge the asynchronous nature of the process. Don't just assume that an operation has completed.

## Tutorials and Stuff

https://monax.io/docs/

Check out this excellent tutorial video ([part 1](https://www.youtube.com/watch?v=8jI1TuEaTro) and [part 2](https://www.youtube.com/watch?v=3-XPBtAfcqo)) which will run you through building a simple smart contract using Truffle.








EXAMPLES HERE https://blockgeeks.com/guides/how-to-learn-solidity/

{% highlight text %}
$ truffle test
truffle(development)> var counter = Counter.deployed()
undefined
{% endhighlight %}

We can take a look at the Application Binary Interface (ABI) which defines the interface for interacting with the smart contract.

{% highlight text %}
truffle(development)> counter.then(function(instance){console.log(JSON.stringify(instance.abi, null, 2));})
[
  {
    "constant": true,
    "inputs": [],
    "name": "creator",
    "outputs": [
      {
        "name": "",
        "type": "address"
      }
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [],
    "name": "kill",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {
        "name": "value",
        "type": "uint256"
      }
    ],
    "name": "set",
    "outputs": [
      {
        "name": "",
        "type": "uint256"
      }
    ],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "get",
    "outputs": [
      {
        "name": "",
        "type": "uint256"
      }
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [],
    "name": "increment",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "constructor"
  }
]
undefined
{% endhighlight %}

