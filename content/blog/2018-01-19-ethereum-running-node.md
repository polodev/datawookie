---
author: Andrew B. Collier
date: 2018-01-19T03:30:00Z
tags: ["Ethereum"]
title: 'Ethereum: Running a Node'
---

Once you've [installed Geth]({{< relref "2018-01-19-ethereum-diy-smart-contract.md" >}}) you're ready to run your own Ethereum node.

<!--more-->

## Synchronising

Your node will require a copy of the the Ethereum blockchain. It'll take a while to catch up with the most recently created blocks, but once you've downloaded the full history, further updates will be relatively quick. You'll also need a *good chunk* of storage space available!

### Getting in Sync

Start Geth in fast-sync mode.

{{< highlight text >}}
$ geth --fast --cache 4096
{{< /highlight >}}

Some notes on the command line options:

- `--fast` uses fast synchronisation; and
- `--cache 4096` increases the size of the internal cache (and will speed things up appreciably!).

It's important to note that you can only use the `--fast` option if you are downloading the chain from scratch. As is implied it will make the process more rapid and storage requirements will be smaller. However you will not have access to transaction information for blocks downloaded during synchronisation.

If you don't have enough RAM to cater for a 4 Gb cache then choose 2048 Mb or 1024 Mb. The default value of 128 Mb seems to produce relatively poor performance. It's worth noting that Geth can be a memory hungry beast (especially if you have allocated a decent sized cache), so to prevent the process from getting mysteriously killed by the operating system you should ensure that you have allocated a reasonable chunk of swap space for it to expand into if necessary.

{{< highlight text >}}
$ free -h
              total        used        free      shared  buff/cache   available
Mem:            14G        5.1G        171M        8.7M        9.6G        9.5G
Swap:            9G          0B          9G
{{< /highlight >}}

During synchronisation you'll see a deluge of log entries like this in rapid succession (log messages truncated for clarity):

{{< highlight text >}}
INFO [01-23|04:32:20] Imported new block headers
INFO [01-23|04:32:24] Imported new block receipts
INFO [01-23|04:32:33] Imported new state entries
{{< /highlight >}}

These indicate that for each block we are retrieving headers, receipts and state.

Let's take a quick look at some statistics about the size of the blockchain.

![](/img/2018/01/etherscan-transactions.svg)
![](/img/2018/01/etherscan-block-size.svg)
![](/img/2018/01/etherscan-data-size.svg)

The data requirements for hosting a node are rather intense and it's growing quickly.

### Check Current Status

In a separate terminal window you can attach a console to the running Geth process and check the current status of the network. This will show how many blocks still need to be downloaded.

{{< highlight text >}}
$ geth attach
Welcome to the Geth JavaScript console!

instance: Geth/v1.7.3-stable-4bb3c89d/linux-amd64/go1.9
 modules: admin:1.0 debug:1.0 eth:1.0 miner:1.0 net:1.0 personal:1.0 rpc:1.0 txpool:1.0 web3:1.0

> eth.syncing
{
  currentBlock: 4279201,
  highestBlock: 5009971,
  knownStates: 3167,
  pulledStates: 2651,
  startingBlock: 4276705
}
{{< /highlight >}}

That indicates that there are currently 5009971 blocks in the chain (that number will have changed by the time you read this!). Also, we've currently synchronised 4279201 of those blocks.

### Synchronised

Once your node is up to date you'll only see a block roughly every 10 to 20 seconds.

{{< highlight text >}}
INFO [01-26|02:10:54] Imported new chain segment txs=197 mgas=7.999 number=4973375 hash=d074ad…f846a4
INFO [01-26|02:10:57] Imported new chain segment txs=216 mgas=7.996 number=4973376 hash=72239e…1719f7
INFO [01-26|02:11:19] Imported new chain segment txs=193 mgas=8.008 number=4973377 hash=674e81…a55243
INFO [01-26|02:11:50] Imported new chain segment txs=208 mgas=7.765 number=4973378 hash=64f366…ab5bad
INFO [01-26|02:12:00] Imported new chain segment txs=250 mgas=8.008 number=4973379 hash=a624f7…597848
INFO [01-26|02:12:12] Imported new chain segment txs=277 mgas=7.029 number=4973380 hash=0e0eb0…f833a4
INFO [01-26|02:12:17] Imported new chain segment txs=209 mgas=7.751 number=4973381 hash=3157e9…fbae52
INFO [01-26|02:12:33] Imported new chain segment txs=207 mgas=7.987 number=4973382 hash=0942fb…e8df1a
INFO [01-26|02:12:48] Imported new chain segment txs=229 mgas=8.000 number=4973383 hash=90dfc2…e458d0
INFO [01-26|02:12:52] Imported new chain segment txs=272 mgas=7.886 number=4973384 hash=e1d66f…efeb2d
{{< /highlight >}}

At this point you can restart Geth.

{{< highlight text >}}
$ geth --rpc
{{< /highlight >}}

Strictly you'd want to omit the `--rpc` because this makes your node somewhat less secure, but we'll expose RPC for the moment just so that we can try connecting.

There are now two modes of communication with the local node: a local pipe and RPC via HTTP on port 8545.

{{< highlight text >}}
INFO [01-26|03:14:00] HTTP endpoint opened: http://127.0.0.1:8545
INFO [01-26|03:14:00] IPC endpoint opened: /home/ubuntu/.ethereum/geth.ipc
{{< /highlight >}}

## Creating an Account

We can use Geth to create an account.

{{< highlight text >}}
$ geth account new
Passphrase: 
Repeat passphrase: 
Address: {446874e0587f65d9ea88cbce6cc54d972c235e9b}
{{< /highlight >}}

Choose a secure passphrase and store it somewhere safe!

{{< highlight text >}}
$ geth account list
Account #0: {446874e0587f65d9ea88cbce6cc54d972c235e9b}
{{< /highlight >}}

This is a list of the accounts controlled by the node. Just the single account for the moment. We can immediately check that the account has been created on the blockchain by vising [Etherscan](https://etherscan.io/address/0x446874e0587f65d9ea88cbce6cc54d972c235e9b).

![](/img/2018/01/etherscan-new-account.png)

## Interacting with the Blockchain: Remote Connection

You can interact with the blockchain using RPC via HTTP POST requests. You can find out more about the JSON-RPC API [here](https://github.com/ethereum/wiki/wiki/JSON-RPC). Although you can use RPC to communicate with a local node you can also use it to hook up with a remote node. To send requests to the local node we address them to `http://127.0.0.1:8545` (Geth exposes the RPC service on port 8545).

For example, to get the current block number, we specify the `eth_blockNumber` method.

{{< highlight text >}}
$ curl -X POST \
       -H "Content-Type: application/json" \
       --data '{"jsonrpc": "2.0",
                "method": "eth_blockNumber",
                "params": [],
                "id": 1}' \
       http://127.0.0.1:8545 | jq
{{< /highlight >}}

The details of the request are given in a JSON document and the response comes back as JSON too.

{{< highlight text >}}
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": "0x4be742"
}
{{< /highlight >}}

The result, 0x4be742, is encoded in hexadecimal, which translates to decimal 4974402.

We can check the balance on an account. This time we ask for the `eth_getBalance` method and supply the account code as a parameter.

{{< highlight text >}}
$ curl -X POST \
       -H "Content-Type: application/json" \
       --data '{"jsonrpc": "2.0",
                "method": "eth_getBalance",
                "params": ["0x6dd80e0bcc1ca62141b03e1b4978e569ce02d914", "latest"],
                "id": 1}' \
       http://127.0.0.1:8545 | jq
{{< /highlight >}}

The result again comes back as a JSON document.

{{< highlight text >}}
{
  "jsonrpc": "2.0",
  "id": 1, 
  "result": "0x216046c1fcd08000"
}
{{< /highlight >}}

The balance, 0x216046c1fcd08000, converted to decimal is 2405 000 000 000 000 000. Don't get excited though, that's 2405 000 000 000 000 000 Wei, but only 2.405 Ether.

## Interacting with the Blockchain: Local Connection

We can also communicate with the blockchain more directly (and certainly more conveniently) using IPC via the Geth console. We do this by attaching the Geth console to a local node (see above). This console gives you access to a [JavaScript runtime environment](https://github.com/ethereum/go-ethereum/wiki/JavaScript-Console) which communicates with the blockchain using the [Web3 library](https://github.com/ethereum/wiki/wiki/JavaScript-API).

If you're not running a full local node then you can still use the Geth console using a RPC connection to a public node.
<!-- http://help.b9lab.com/eth-developer-course-technical-help/our-public-geth-nodes -->
{{< highlight text >}}
$ geth attach http://52.208.46.161:8550
{{< /highlight >}}

Let's kick this off with some simple interactions. We can query the version of the Web3 api as well as the client that our node is running.

{{< highlight text >}}
> web3.version.api
"0.20.1"
> web3.version.node
"Geth/v1.7.3-stable-4bb3c89d/linux-amd64/go1.9"
{{< /highlight >}}

### Utilities

The library also has a range of utility functions. We can convert from Wei to a range of other currency units using `fromWei`.

{{< highlight text >}}
> web3.fromWei('750000000000000', 'finney')
"0.75"
> web3.fromWei('750000000000000', 'ether')
"0.00075"
{{< /highlight >}}

There are functions for coverting numbers between decimal and hexidecimal.

{{< highlight text >}}
> web3.toDecimal("0x4be742")
4974402
> web3.toHex(4974402)
"0x4be742"
{{< /highlight >}}

And a host of other somewhat more obscure utilities which you will find use for from time to time.

### Accessing Accounts

We can check on the account we just created.

{{< highlight text >}}
> eth.accounts
["0x446874e0587f65d9ea88cbce6cc54d972c235e9b"]
> eth.getBalance("0x446874e0587f65d9ea88cbce6cc54d972c235e9b")
0
{{< /highlight >}}

What about other accounts? We can check the balance on any account, provided that we know the address. Let's take a look at [another account](https://etherscan.io/address/0x6dd80e0bcc1ca62141b03e1b4978e569ce02d914).

{{< highlight text >}}
> eth.getBalance("0x6dd80e0bcc1ca62141b03e1b4978e569ce02d914")
2405000000000000000
{{< /highlight >}}

Out of interest you might like to take a look at [0x75e7f640bf6968b6f32c47a3cd82c3c2c9dcae68](https://etherscan.io/address/0x75e7f640bf6968b6f32c47a3cd82c3c2c9dcae68), which is an account belonging to [CEX](https://cex.io/).

### Investigating Blocks

Blocks can be access by specifying either the block number, block hash or "latest" (to get the most recent block). We'll look at block 4974402.

{{< highlight text >}}
> var block = web3.eth.getBlock(4974402)
{{< /highlight >}}

The resulting object has a variety of fields which characterise the block. Here's a selection.

{{< highlight text >}}
> block.number
4974402
> block.timestamp
1516947782
> block.parentHash
"0xdfc2dd3e9c58261f377752c4f0dc01144b26b401a72b555d32e6be1db022822e"
> block.hash
"0x07d450fca27b3b978d7225a23e7478e9e4629556ff47263397275489614e2b59"
> block.miner
"0xea674fdde714fd979de3edf0f56aa9716b898ec8"
> block.nonce
"0x897a7af40ec30fe5"
{{< /highlight >}}

There's also a `transactions` component which is a list of transactions hashes. We'll look at that in a moment.

While we're looking at blocks though, it's easy to see how they are linked together. Staring with the Genesis block, let's look at its hash and parent hash.

{{< highlight text >}}
> web3.eth.getBlock(0).hash
"0xf6c2f1e5d1d90b8430a1df7fa7e413158cbbfec3d8bfb7379952920f2ce87e8d"
> web3.eth.getBlock(0).parentHash
"0x0000000000000000000000000000000000000000000000000000000000000000"
{{< /highlight >}}

Not surprisingly the parent hash is null. This is the Genesis block so it doesn't have a parent! What about the next block in the chain?

{{< highlight text >}}
> web3.eth.getBlock(1).hash
"0xda98b51aab84db3c664dc16bc0f88b674d8ed2ed0c17ab65fc34eea5d11d3ee6"
> web3.eth.getBlock(1).parentHash
"0xf6c2f1e5d1d90b8430a1df7fa7e413158cbbfec3d8bfb7379952920f2ce87e8d"
{{< /highlight >}}

We see that the parent hash for this block is precisely the same as the hash of the previous (Genesis) block. This is the link that holds the chain together. Similarly for the next block in the chain.

{{< highlight text >}}
> web3.eth.getBlock(2).parentHash
"0xda98b51aab84db3c664dc16bc0f88b674d8ed2ed0c17ab65fc34eea5d11d3ee6"
{{< /highlight >}}

### Exploring Transactions

Finally let's dig all the way down to individual transactions.

{{< highlight text >}}
> block.transactions.length
196
> block.transactions.slice(0, 5)
["0xe8cd9324be1d671f24ba640281a4cde9615a7f08e50405127c728adfeceea63d",
 "0x698970e491ad68c91053a041fefbc3da5cec6d593bee8b3d805862f57a3e062c",
 "0xab0d7f18f20b9beada68e5dfd791571db4748d2b7b1a3ec8a57b3deb19ccfe13",
 "0xc0eead2e855bbe1e87d958550a0bc83964ca1bd73c1db28f9c4945edca6835ca",
 "0xb561f8f44c2c5850b9aeca9d7a533d26d74a589e20aea02ae9bcd7ada36f70c2"]
{{< /highlight >}}

Taking a look at block 4974402 we see that it encapsulates 196 transactions and we can see the hashes for the first five transactions above. Let's pick out a particular transaction and record its hash.

{{< highlight text >}}
> txhash = block.transactions[142]
"0x3d42bfe6e200329e26949038a6adf521294c9c7bf2e8a9e063e69f58004e1f73"
{{< /highlight >}}

Now we can go and get the details of that transaction.

{{< highlight text >}}
> tx = web3.eth.getTransaction(txhash)
{
  blockHash: "0x07d450fca27b3b978d7225a23e7478e9e4629556ff47263397275489614e2b59",
  blockNumber: 4974402,
  from: "0x75e7f640bf6968b6f32c47a3cd82c3c2c9dcae68",
  gas: 21000,
  gasPrice: 30000000000,
  hash: "0x3d42bfe6e200329e26949038a6adf521294c9c7bf2e8a9e063e69f58004e1f73",
  input: "0x",
  nonce: 189776,
  r: "0x738a1d623047707c2cf45e6fa3e4bd083a4ca8426f03b442bef7cc00cc1e2870",
  s: "0x6e228a45b947f63ce1834777ced62c2dc973d72faea9d85e0db398968ec576fa",
  to: "0x6dd80e0bcc1ca62141b03e1b4978e569ce02d914",
  transactionIndex: 142,
  v: "0x26",
  value: 715000000000000000
}
{{< /highlight >}}

We see that we have access to a wealth of information about the transaction. Perhaps the most pertinent pieces of information are the account from which the transaction originates (`from`) and the destination account (`to`), as well as the amount (`value`).

Incidentally, we could also have accessed this transaction directly using the block hash and transaction number.

{{< highlight text >}}
> web3.eth.getTransactionFromBlock(block.hash, 142)
{{< /highlight >}}

## Exeunt

We've taken a look at what's required to run an Ethereum node using Geth. We've also seen that connecting to a node allow's you to rummage around in the guts of the blockchain. I've found that this has given me a much better feeling for how it all works. The level of detail available is quite astonishing and with such a wealth of data available there's lots of scope for doing interesting things!