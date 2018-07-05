---
draft: true
title: "An Ethereum Package for R"
date: 2018-01-07T08:00:00+00:00
author: Andrew B. Collier
excerpt_separator: <!-- more -->
layout: post
tags:
  - Blockchain
  - Ethereum
  - R
---

Bitcoin has become synonymous with "cryptocurrency". [Ethereum](https://www.ethereum.org/) is another cryptocurrency which, although not as hyped at Bitcoin, presents some attractive characteristics. The foremost of these is the ability to create sophisticated [smart contracts](https://en.wikipedia.org/wiki/Smart_contract).

This post introduces the new [ether](https://github.com/DataWookie/ether) package for interacting with the Ethereum network from R. 

![](/img/2017/12/etherscan-transactions-addresses.png)

<!-- more -->

## Install and Load

The package has just been listed on CRAN. You can find it [here](https://cran.r-project.org/web/packages/ether/index.html).

{% highlight r %}
> install.packages("ether")
{% endhighlight %}

Alternatively, to access more recent code, install from GitHub using [devtools](https://cran.r-project.org/web/packages/devtools/index.html).

{% highlight r %}
> devtools::install_github("DataWookie/ether")
{% endhighlight %}

Now load the package.

{% highlight r %}
> library(ether)
{% endhighlight %}

## Connecting to the Ethereum Network

The package uses a [JSON-RPC](http://www.jsonrpc.org/specification) API to communicate with the Ethereum network. The API is documented [here](https://github.com/ethereum/wiki/wiki/JSON-RPC). You can use either a local or public node to connect to the network.

### Local Node

To run a local node you'll need to install [Geth](https://geth.ethereum.org/downloads/). With Geth on your machine, synchronise with the network.

{% highlight text %}
$ geth --fast
{% endhighlight %}

It'll take some time (and space!) to download all of those blocks. Once you are synchronised you can stop Geth and restart it with RPC enabled.

{% highlight text %}
$ geth --rpc
{% endhighlight %}

By default the ethereum package will connect to port 8545 on localhost.

{% highlight r %}
> get_rpc_address()
[1] "http://localhost:8545"
{% endhighlight %}

### Public Node

If you're impatient or just want to give this a quick try, then you might find the public RPC offered by [https://infura.io/](Infura) to be a good option. Register to create a key. You can then use this key to point the ethereum package to the Infura RPC interface.

{% highlight r %}
# Use your own key!
#
> set_rpc_address("https://mainnet.infura.io/", key = "9BvO3Cqze3p7EpinabXf")
> get_rpc_address()
[1] "https://mainnet.infura.io/9BvO3Cqze3p7EpinabXf"
{% endhighlight %}

## Interact with the Ethereum Blockchain

We can validate our connection by checking the protocol version.

{% highlight r %}
> eth_protocolVersion()
[1] 63
{% endhighlight %}

Ethereum operations have an associated execution fee which is expressed in units of gas. Gas, in turn, translates into Ether. What is the current gas price?

{% highlight r %}
> eth_gasPrice()
[1] 20000000000
# Or in more sensible units.
> as.gwei(eth_gasPrice())
[1] 20
{% endhighlight %}

![](/img/2017/12/etherscan-network-state.png)

What's the number of the most recent block?

{% highlight r %}
> eth_blockNumber()
[1] 4811795
{% endhighlight %}

Check against [Etherscan](https://etherscan.io/). Yup! That looks right.

Check if your node is mining.

{% highlight r %}
> eth_mining()
[1] TRUE
{% endhighlight %}

This will only be `TRUE` if you're running a local node and you've started mining. If you are mining then you'll also have set a coinbase address.

{% highlight r %}
> eth_coinbase()
[1] "0xda20137332ce9d8f6795c40682f5f77b8b32a5fa"
{% endhighlight %}

### Analysing Accounts

If you're running a local node and you've created an account then you should be able to see it from within R.

{% highlight r %}
> eth_accounts()
[1] "0xda20137332ce9d8f6795c40682f5f77b8b32a5fa"
{% endhighlight %}

If you are using Infura then you won't see any accounts.

However, due to the open nature of Ethereum, we are able to check the balance in any account on the network. These accounts are pseudo-anonymous, so although we're able to see the current balance, we're not sure who an account belongs to.

{% highlight r %}
> eth_getBalance("0xD34DA389374CAAD1A048FBDC4569AAE33fD5a375")
[1] 194274248530503149
# Or in more sensible units.
> as.ether(eth_getBalance("0xD34DA389374CAAD1A048FBDC4569AAE33fD5a375"))
[1] 0.19427424853050314908
{% endhighlight %}

How many transactions have been initiated from this address?

{% highlight r %}
> eth_getTransactionCount("0xD34DA389374CAAD1A048FBDC4569AAE33fD5a375")
[1] 1150417
{% endhighlight %}

### Burrowing into Blocks

How many transactions are there in a specific block? There are two ways of addressing a block: using the block address or the (sequential) block number.

{% highlight r %}
> eth_getBlockTransactionCountByHash("0xb6d656ead4c3d4b1aa24d6b4d3d4cde8c090794e597258993512d650f088fcba")
[1] 137
> eth_getBlockTransactionCountByNumber("0x4720FF")
[1] 137
{% endhighlight %}

We can delve into the details of a block.

{% highlight r %}
> block <- eth_getBlock("0xb6d656ead4c3d4b1aa24d6b4d3d4cde8c090794e597258993512d650f088fcba")
> block$number
[1] "0x4720ff"
> block$miner
[1] "0x52bc44d5378309ee2abf1539bf71de1b7d7be3b5"
> block$difficulty %>% hex_to_dec()
'mpfr1' 1574902798715204
> block$nonce
[1] "0x5484592003d8ca72"
> block$size %>% hex_to_dec()
[1] 21106
> block$timestamp
[1] "2017-12-02 09:38:00 UTC"
{% endhighlight %}

![](/img/2017/12/etherscan-block-details.png)

Look at the table of transactions.

{% highlight r %}
> dim(block$transactions)
[1] 137  14
> head(block$transactions)[, c("index", "from", "to", "value")]
  index                                       from                                         to               value
  <chr>                                      <chr>                                      <chr>               <chr>
1   0x0 0x5a6021e59be87de9b93623102d68fd4ab9c86cce 0xe0a5bf8757c631af64da60b4509740b6cc2475cc   0xbef55718ad60000
2   0x1 0x84ba23d0b49070578b9792291c6a3ad0ecf2f96f 0x75e7f640bf6968b6f32c47a3cd82c3c2c9dcae68  0x52d980072da1adc0
3   0x2 0x9b68f9eabf02c4b8458e4d2a6924000c0d8ceb44 0x75e7f640bf6968b6f32c47a3cd82c3c2c9dcae68   0xde0835c37f0adc0
4   0x3 0x353bd0ac47f6427b7835b38201f5250213fb97f9 0x75e7f640bf6968b6f32c47a3cd82c3c2c9dcae68   0x18699135dd7adc0
5   0x4 0x0f157ab6519263cba006db8b11b57ed18a530550 0x9d2faffdb77979c60f99906b01691f0e63be0e11 0x1927483ad6276cc80
6   0x5 0xa9683612ef7c5279b8942fbe4f4de33654f66636 0x75e7f640bf6968b6f32c47a3cd82c3c2c9dcae68   0x2ab03b628fd5400
{% endhighlight %}

### Tampering with Transactions

We can also access specific transactions directly using their unique hash. For example, the sixth transaction (index 0x5) from the block above.

{% highlight r %}
> eth_getTransactionByHash("0x8fd9e04958cc4fb602b9d9fa5a9b6da512779ccd22477ccc5ce73721296cf151")
$blockHash
[1] "0xb6d656ead4c3d4b1aa24d6b4d3d4cde8c090794e597258993512d650f088fcba"

$blockNumber
[1] "0x4720ff"

$from
[1] "0xa9683612ef7c5279b8942fbe4f4de33654f66636"

$gas
[1] "0x5208"

$gasPrice
[1] "0x89afcd80"

$hash
[1] "0x8fd9e04958cc4fb602b9d9fa5a9b6da512779ccd22477ccc5ce73721296cf151"

$input
[1] "0x"

$nonce
[1] "0x1"

$to
[1] "0x75e7f640bf6968b6f32c47a3cd82c3c2c9dcae68"

$transactionIndex
[1] "0x5"

$value
[1] "0x2ab03b628fd5400"

$v
[1] "0x26"

$r
[1] "0xdea14c6c5fc23aa15882781bac998527955a170ddfb4e4e8d5840b46b0af9e63"

$s
[1] "0x138a8f88c5790591b44a1a0c9fecdaab734b73e5ef899532df75de30788cd3a8"
{% endhighlight %}

## Breaking Down the Blockchain

<blockquote>
	And the earth was without form, and void; and darkness was upon the face of the deep.
	<cite>Genesis 1:2, King James Version</cite>
</blockquote>

Let's go all the way back to the beginning and take a look at the first block in the Ethereum blockchain, the "Genesis" block. To put that into some context, we'll also grab the following four blocks. You can retrieve multiple blocks using the `get_blocks()` helper function.

{% highlight r %}
> blocks <- get_blocks("0x0", count = 5)
{% endhighlight %}

Taking a look at selected fields for those blocks we see that each has a number, where the Genesis block is assigned the number 0x0 and subsequent blocks are numbered sequentially. Each block has a time stamp. The Genesis block has a `NA` time stamp because it was created synthetically rather than being mined. Importantly, each block has a unique `hash`.

{% highlight r %}
> blocks[, c("number", "timestamp", "hash")]
  number           timestamp                                                               hash
   <chr>              <dttm>                                                              <chr>
1    0x0                  NA 0xd4e56740f876aef8c010b86a40d5f56745a118d0906a34e69aec8c0db1cb8fa3
2    0x1 2015-07-30 15:26:28 0x88e96d4537bea4d9c05d12549907b32561d3bf31f45aae734cdc119f13406cb6
3    0x2 2015-07-30 15:26:57 0xb495a1d7e6663152ae92708da4843337b958146015a2802f4193a410044698c9
4    0x3 2015-07-30 15:27:28 0x3d6122660cc824376f11ee842f83addc3525e2dd6756b9bcf0affa6aa88cf741
5    0x4 2015-07-30 15:27:57 0x23adf5a3be0f5235b36941bcb29b62504278ec5b9cdfa277b992ba4a7a3cd3a2
{% endhighlight %}

Each block also has a `parentHash`. This is what links the blocks together. See, for example, that block number 0x1 has a `parentHash` which corresponds to the `hash` for block number 0x0. Similarly, block number 0x2 has a `parentHash` which corresponds to the `hash` for block number 0x1.

{% highlight r %}
> blocks[, c("number", "parentHash")]
  number                                                         parentHash
   <chr>                                                              <chr>
1    0x0 0x0000000000000000000000000000000000000000000000000000000000000000
2    0x1 0xd4e56740f876aef8c010b86a40d5f56745a118d0906a34e69aec8c0db1cb8fa3
3    0x2 0x88e96d4537bea4d9c05d12549907b32561d3bf31f45aae734cdc119f13406cb6
4    0x3 0xb495a1d7e6663152ae92708da4843337b958146015a2802f4193a410044698c9
5    0x4 0x3d6122660cc824376f11ee842f83addc3525e2dd6756b9bcf0affa6aa88cf741
{% endhighlight %}

## Future Plans

As mentioned earlier, one of the differentiating features of the Ethereum blockchain is its ability to accommodate smart contracts. The next featues I plan building into the ethereum package will (hopefully) be for interrogating and interacting with smart contracts.

I'd also like to clean up some of the function results, converting lists to data frames, for example. There are a few functions which each achieve the same output but with different input parameters. For example, the RPC functions `eth_getBlockByHash()` and `eth_getBlockByNumber()` have already been consolidated into the `eth_getBlock()` function.
