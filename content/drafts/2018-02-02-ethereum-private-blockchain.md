---
draft: true
title: "Ethereum: Creating a Private Blockchain"
date: 2018-02-02T04:00:00+00:00
author: Andrew B. Collier
excerpt_separator: <!-- more -->
layout: post
tags:
  - Blockchain
  - Ethereum
---

{{< comment >}}
https://www.ethereum.org/cli
{{< /comment >}}

<!-- more -->

Create a folder for the new private blockchain.

{% highlight text %}
$ mkdir ~/.ethereum_private/
{% endhighlight %}

## Creating an Account

Then create an account which we will fund when we initiate our blockchain. This is an optional step.

{% highlight text %}
$ geth --datadir ~/.ethereum_private account new
WARN [12-08|05:48:25] No etherbase set and no accounts found as default 
Your new account is locked with a password. Please give a password. Do not forget this password.
Passphrase: 
Repeat passphrase: 
Address: {a70a1b6b5f9604b1cb934d571b5497720dd80b3e}
{% endhighlight %}

## Configuring the Genesis Block

We need to create a `genesis.json` file which will be used to construct the first block on the chain.

{% highlight text %}
{
	"config": {
		"chainId": 17,
    "homesteadBlock": 0
	},
	"alloc" : {
		"0xa70a1b6b5f9604b1cb934d571b5497720dd80b3e": {"balance": "100000000"}
	},
	"coinbase" : "0x0000000000000000000000000000000000000000",
	"difficulty" : "0x20000",
	"extraData" : "",
	"gasLimit" : "0x2fefd8",
	"nonce" : "0xDEADBEEFDEFEC8ED",
	"mixhash" : "0x0000000000000000000000000000000000000000000000000000000000000000",
	"parentHash" : "0x0000000000000000000000000000000000000000000000000000000000000000",
	"timestamp" : "0x00"
}
{% endhighlight %}

A few things that you will probably want to do to personalise your `genesis.json`:

- Choose a unique value for `chainId`.
- Change `nonce` to a random hexadecimal number.
- If you have created an account then use its address in the `alloc` section.
- Choose a relatively low value for `difficulty` because this will influence the block generation time.

Next initialise the network.

{% highlight text %}
$ geth --datadir ~/.ethereum_private init genesis.json
INFO [12-08|04:52:56] Allocated cache and file handles
INFO [12-08|04:52:56] Writing custom genesis block
INFO [12-08|04:52:56] Successfully wrote genesis state
INFO [12-08|04:52:56] Allocated cache and file handles
INFO [12-08|04:52:56] Writing custom genesis block
INFO [12-08|04:52:56] Successfully wrote genesis state
{% endhighlight %}

Note: An alternative to providing `genesis.json` is to start `geth` with the `--dev` flag, which will use a preconfigured set of parameters.

## Start the Network

Now it's just a simple matter of starting the network. This will drop you into the Geth console.

{% highlight text %}
$ geth --networkid 58769 --datadir ~/.ethereum_private console
Welcome to the Geth JavaScript console!

instance: Geth/v1.7.2-stable-1db4ecdc/linux-amd64/go1.9
coinbase: 0xa70a1b6b5f9604b1cb934d571b5497720dd80b3e
at block: 0 (Thu, 01 Jan 1970 02:00:00 SAST)
 datadir: /home/colliera/.ethereum_private
 modules: admin:1.0 debug:1.0 eth:1.0 miner:1.0 net:1.0 personal:1.0 rpc:1.0 txpool:1.0 web3:1.0

> 
{% endhighlight %}

By default this will create a `geth.ipc` file in the data directory. This is a [domain socket](https://en.wikipedia.org/wiki/Unix_domain_socket) for [inter-process communication](https://en.wikipedia.org/wiki/Inter-process_communication) and is used to interact with other applications running on your machine.

A few things that you might want to tweak:

- Choose a unique value for `--networkid`.
- Modify the behaviour of `geth` by using
* `--fast`: enable fast syncing
* `--cache 512`: specify size of cache (in Mb)
* `--nodiscover`: disable discovery of network peers
* `--maxpeers 0`: disable network by setting number of peers to zero.

With all of those applied you'd invoke `geth` like this:

{% highlight text %}
$ geth --fast --cache 512 --nodiscover --maxpeers 0 --ipcpath ~/.ethereum_private/geth.ipc \
  --networkid 58769 --datadir ~/.ethereum_private console
{% endhighlight %}

## Check Accounts

Check what accounts are registered.

{% highlight text %}
> eth.accounts
["0xa70a1b6b5f9604b1cb934d571b5497720dd80b3e"]
{% endhighlight %}

As expected, just the account which we created earlier. What about the initial balance on that account?

{% highlight text %}
> eth.getBalance(eth.accounts[0])
100000000
{% endhighlight %}

Precisely as specified in the genesis block.

## Network Initial State

Check the number of peers on the network.

{% highlight text %}
> net.peerCount
0
{% endhighlight %}

This should be zero. If not then you might want to restart with a different value for `--networkid`.

Find some information relating to our node.

{% highlight text %}
> admin.nodeInfo
{
  enode: "enode://8a5258f3c0f0cd694141787805f28610a9fe4f32babe7354c6feff3e877211d0da1cbf622576cde597d9adb4988e70940d052a2035030c5d32eccf55023fbb54@105.225.211.128:30303",
  id: "8a5258f3c0f0cd694141787805f28610a9fe4f32babe7354c6feff3e877211d0da1cbf622576cde597d9adb4988e70940d052a2035030c5d32eccf55023fbb54",
  ip: "105.225.201.108",
  listenAddr: "[::]:30303",
  name: "Geth/v1.7.2-stable-1db4ecdc/linux-amd64/go1.9",
  ports: {
    discovery: 30303,
    listener: 30303
  },
  protocols: {
    eth: {
      difficulty: 131072,
      genesis: "0x2122a629dd2bd99e5897f3889f2099588875ac600fa2c959a35ec9c049f9b23d",
      head: "0x2122a629dd2bd99e5897f3889f2099588875ac600fa2c959a35ec9c049f9b23d",
      network: 58769
    }
  }
}
{% endhighlight %}

How many blocks do we have?

{% highlight text %}
> eth.blockNumber
0
{% endhighlight %}

None. Well, that makes sense. We need to start mining!

## Start Mining

Set account which will receive earnings for mined blocks.

{% highlight text %}
> miner.setEtherbase(eth.accounts[0])
true
{% endhighlight %}

Start mining. This will immediately kick up your CPU utilisation.

{% highlight text %}
> miner.start(1)
null
{% endhighlight %}

We specified mining on just a single thread. If you don't provide any arguments to `miner.start()` then, depending on your machine, mining may commence on multiple threads in parallel.

 After a short while...

{% highlight text %}
INFO [12-09|15:15:25] Successfully sealed new block            number=1 hash=4f5e5d…307f33
INFO [12-09|15:15:25] 🔨 mined potential block                  number=1 hash=4f5e5d…307f33
INFO [12-09|15:15:25] Commit new mining work                   number=2 txs=0 uncles=0 elapsed=137.568µs
INFO [12-09|15:15:25] Successfully sealed new block            number=2 hash=1d0333…771631
INFO [12-09|15:15:25] 🔨 mined potential block                  number=2 hash=1d0333…771631
INFO [12-09|15:15:25] Commit new mining work                   number=3 txs=0 uncles=0 elapsed=128.642µs
INFO [12-09|15:15:26] Successfully sealed new block            number=3 hash=eb411d…9eca54
INFO [12-09|15:15:26] 🔨 mined potential block                  number=3 hash=eb411d…9eca54
INFO [12-09|15:15:26] Commit new mining work                   number=4 txs=0 uncles=0 elapsed=129.339µs
INFO [12-09|15:15:26] Successfully sealed new block            number=4 hash=f556e7…610f65
INFO [12-09|15:15:26] 🔨 mined potential block                  number=4 hash=f556e7…610f65
INFO [12-09|15:15:26] Mining too far in the future             wait=2s
INFO [12-09|15:15:28] Commit new mining work                   number=5 txs=0 uncles=0 elapsed=2.001s
INFO [12-09|15:15:29] Successfully sealed new block            number=5 hash=b2bb40…957b08
INFO [12-09|15:15:29] 🔨 mined potential block                  number=5 hash=b2bb40…957b08
INFO [12-09|15:15:29] Commit new mining work                   number=6 txs=0 uncles=0 elapsed=116.991µs
INFO [12-09|15:15:30] Successfully sealed new block            number=6 hash=5d39f4…a163c3
INFO [12-09|15:15:30] 🔗 block reached canonical chain          number=1 hash=4f5e5d…307f33
INFO [12-09|15:15:30] 🔨 mined potential block                  number=6 hash=5d39f4…a163c3
INFO [12-09|15:15:30] Commit new mining work                   number=7 txs=0 uncles=0 elapsed=110.898µs
INFO [12-09|15:15:31] Successfully sealed new block            number=7 hash=40080a…1e7aa5
INFO [12-09|15:15:31] 🔗 block reached canonical chain          number=2 hash=1d0333…771631
INFO [12-09|15:15:31] 🔨 mined potential block                  number=7 hash=40080a…1e7aa5
INFO [12-09|15:15:31] Commit new mining work                   number=8 txs=0 uncles=0 elapsed=112.846µs
INFO [12-09|15:15:31] Successfully sealed new block            number=8 hash=f80dad…6104fb
INFO [12-09|15:15:31] 🔗 block reached canonical chain          number=3 hash=eb411d…9eca54
INFO [12-09|15:15:31] 🔨 mined potential block                  number=8 hash=f80dad…6104fb
INFO [12-09|15:15:31] Commit new mining work                   number=9 txs=0 uncles=0 elapsed=105.987µs
INFO [12-09|15:15:32] Successfully sealed new block            number=9 hash=06ac2f…466377
INFO [12-09|15:15:32] 🔗 block reached canonical chain          number=4 hash=f556e7…610f65
INFO [12-09|15:15:32] 🔨 mined potential block                  number=9 hash=06ac2f…466377
INFO [12-09|15:15:32] Commit new mining work                   number=10 txs=0 uncles=0 elapsed=97.569µs
INFO [12-09|15:15:33] Successfully sealed new block            number=10 hash=4ccbad…abf231
INFO [12-09|15:15:33] 🔗 block reached canonical chain          number=5  hash=b2bb40…957b08
INFO [12-09|15:15:33] 🔨 mined potential block                  number=10 hash=4ccbad…abf231
INFO [12-09|15:15:33] Commit new mining work                   number=11 txs=0 uncles=0 elapsed=81.564µs
INFO [12-09|15:15:33] Successfully sealed new block            number=11 hash=f650a6…c466ee
INFO [12-09|15:15:33] 🔗 block reached canonical chain          number=6  hash=5d39f4…a163c3
INFO [12-09|15:15:33] 🔨 mined potential block                  number=11 hash=f650a6…c466ee
INFO [12-09|15:15:33] Mining too far in the future             wait=2s
{% endhighlight %}

You'll notice that the tempo at which new blocks is being added is rather high. This is due to the initial difficulty assigned in the genesis block. If you want to make this more "realistic" you can choose a higher initial difficulty like 0x200000.

You can keep track of the number of mined blocks.

{% highlight text %}
> eth.blockNumber
47
{% endhighlight %}

So that's chugging along well. You can stop mining with

{% highlight text %}
> miner.stop()
{% endhighlight %}

## Examining Blocks

Let's take a look at the genesis block. I've left the `logsBloom` field out of the object because it's bulky and uninformative.

{% highlight text %}
> eth.getBlock(0, true)
{
  difficulty: 131072,
  extraData: "0x",
  gasLimit: 3141592,
  gasUsed: 0,
  hash: "0x2122a629dd2bd99e5897f3889f2099588875ac600fa2c959a35ec9c049f9b23d",
  miner: "0x0000000000000000000000000000000000000000",
  mixHash: "0x0000000000000000000000000000000000000000000000000000000000000000",
  nonce: "0xdeadbeefdefec8ed",
  number: 0,
  parentHash: "0x0000000000000000000000000000000000000000000000000000000000000000",
  receiptsRoot: "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421",
  sha3Uncles: "0x1dcc4de8dec75d7aab85b567b6ccd41ad312451b948a7413f0a142fd40d49347",
  size: 507,
  stateRoot: "0x5fb27b61749dac13eb2c9ca0bfa66d2265caf47a1909ed21e286b66edcd6537e",
  timestamp: 0,
  totalDifficulty: 131072,
  transactions: [],
  transactionsRoot: "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421",
  uncles: []
}
{% endhighlight %}

What about the next block in the chain?

{% highlight text %}
> eth.getBlock(1, true)
{
  difficulty: 131072,
  extraData: "0xd583010702846765746885676f312e39856c696e7578",
  gasLimit: 3144658,
  gasUsed: 0,
  hash: "0xf9a7cbeea490550e2ff592e2124944fd873ce8bc516b56cc707fb2da9fd6a746",
  miner: "0xa70a1b6b5f9604b1cb934d571b5497720dd80b3e",
  mixHash: "0x767551a92a565128f2d620e6d3c12b97e99ba411b45b406cea705db3bed5fa45",
  nonce: "0x3077867534fd99a0",
  number: 1,
  parentHash: "0x2122a629dd2bd99e5897f3889f2099588875ac600fa2c959a35ec9c049f9b23d",
  receiptsRoot: "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421",
  sha3Uncles: "0x1dcc4de8dec75d7aab85b567b6ccd41ad312451b948a7413f0a142fd40d49347",
  size: 533,
  stateRoot: "0x7dfaf4efd6e6ba16c947b3e14713e8c67169d74245c21f25126372850a8473f4",
  timestamp: 1512705502,
  totalDifficulty: 262144,
  transactions: [],
  transactionsRoot: "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421",
  uncles: []
}
{% endhighlight %}

The value of `parentHash` for block 1 corresponds to the `hash` from block 0. This is how the blocks in the chain are linked together.

We can also interrogate the block currently being mined.

{% highlight text %}
> eth.getBlock('pending', true)
{
  difficulty: 142743,
  extraData: "0xd583010702846765746885676f312e39856c696e7578",
  gasLimit: 3733773,
  gasUsed: 0,
  hash: null,
  miner: null,
  mixHash: "0x0000000000000000000000000000000000000000000000000000000000000000",
  nonce: null,
  number: 177,
  parentHash: "0x599650760ffe17f28eaaa60eed5e847d059d5ffb7ce1f9359025bbc34a3e5ce2",
  receiptsRoot: "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421",
  sha3Uncles: "0x1dcc4de8dec75d7aab85b567b6ccd41ad312451b948a7413f0a142fd40d49347",
  size: 534,
  stateRoot: "0xa5430cf9ba3895c31f9f2d16bee9bd9b8d8b3597b98f1924172f3f99656183ff",
  timestamp: 1512705729,
  totalDifficulty: 0,
  transactions: [],
  transactionsRoot: "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421",
  uncles: []
}
{% endhighlight %}

The value of `hash` is `null` because this block is still being mined. We see that the block number is 177, so if we wait a short while we can take a look at this block after it has been mined. The value of `hash` has not been filled in.

{% highlight text %}
> eth.getBlock(177, false)
{
  difficulty: 142743,
  extraData: "0xd583010702846765746885676f312e39856c696e7578",
  gasLimit: 3733773,
  gasUsed: 0,
  hash: "0x27f0ccd125625575b76aa85eecac6d71ceb5fa8fad612359239b34e6c9cd7a78",
  miner: "0xa70a1b6b5f9604b1cb934d571b5497720dd80b3e",
  mixHash: "0x8f90d379a1439a5aa62706faf3b58152b2b56fb8229b00cc5d83bcc3e65b3bb5",
  nonce: "0x3b764789297f535b",
  number: 177,
  parentHash: "0x599650760ffe17f28eaaa60eed5e847d059d5ffb7ce1f9359025bbc34a3e5ce2",
  receiptsRoot: "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421",
  sha3Uncles: "0x1dcc4de8dec75d7aab85b567b6ccd41ad312451b948a7413f0a142fd40d49347",
  size: 534,
  stateRoot: "0xa5430cf9ba3895c31f9f2d16bee9bd9b8d8b3597b98f1924172f3f99656183ff",
  timestamp: 1512705729,
  totalDifficulty: 24349254,
  transactions: [],
  transactionsRoot: "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421",
  uncles: []
}
{% endhighlight %}

## Proceeds of Mining

Let's check the balance on our account again.

{% highlight text %}
> eth.getBalance(eth.accounts[0])
1.5050000000001e+21
{% endhighlight %}

That's a stupidly big number because it's given in unit of Wei. Divide by 1000000000000000000 to get ETH. Or just use `web3.fromWei()` to do the conversion for you.

{% highlight text %}
> web3.fromWei(eth.getBalance(eth.coinbase), "ether")
1505.0000000001
{% endhighlight %}

A thoroughly more meaningful number. How many ETH did we receive per block mined?

{% highlight text %}
> eth.blockNumber
301
> 1505 / 301
5
{% endhighlight %}

As expected!

Take note that these are not real ETH because they have been created on our private network.

## Difficulty

If you track the newly created blocks then you'll note that the value of `difficulty` will be getting inexorably bigger.

The `difficulty` specified in the genesis block will determine how rapidly the first few blocks are mined. However it will be adjusted dynamically so that the network settles down to create a new block roughly every 13 seconds.

## GPU Mining

You can use `ethminer` to leverage your GPU for mining on a private network (although, to be honest, a CPU should be quite enough!). First you'll need to start `geth` with the `--rpc` option, which will enable it to distribute work packages. Then start `ethminer` like this:

{% highlight text %}
$ ethminer -G
{% endhighlight %}

That's going to chew a lot of your resources, so it might make working on your machine difficult.
