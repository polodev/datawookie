---
draft: true
title: "Ethereum: Creating an Account on Ropsten"
date: 2018-01-26T04:00:00+00:00
author: Andrew B. Collier
excerpt_separator: <!-- more -->
layout: post
tags:
  - Blockchain
  - Ethereum
---

{{< comment >}}
This illustrates how to deploy a contract onto the Ropsten (test) blockchain:

  - https://medium.com/@mvmurthy/full-stack-hello-world-voting-ethereum-dapp-tutorial-part-2-30b3d335aa1f.
{{< /comment >}}

How to create accounts on the Ropsten (test) blockchain.

<!-- more -->

{% include snippet-work-in-progress.html %}

## Synchronise

{{< comment >}}
This will only be necessary if you had sycnchronised previously and now it won't work. Do this first to clear up any lurking data.

{% highlight bash %}
geth --testnet removedb
{% endhighlight %}
{{< /comment >}}

Before we can create an account we'll need to launch a local Ethereum node and synchronise with the Ethereum Blockchain.

{% highlight bash %}
geth --testnet --fast --bootnodes "enode://20c9ad97c081d63397d7b685a412227a40e23c8bdc6688c6f37e97cfbc22d2b4d1db1510d8f61e6a8866ad7f0e17c02b14182d37ea7c3c8b9c2683aeb6b733a1@52.169.14.227:30303,enode://6ce05930c72abc632c58e2e4324f7c7ea478cec0ed4fa2528982cf34483094e9cbc9216e7aa349691242576d552a2a56aaeae426c5303ded677ce455ba1acd9d@13.84.180.240:30303"
{% endhighlight %}

That will connect to peers and begin to download blocks. It'll take a while to retrieve the entire blockchain, so be patient. Status will be logged to the terminal. Below are some abridged log data.

{% highlight text %}
INFO [11-28|06:32:19] blocks=1 txs=6 mgas=2.926 elapsed=28.982ms mgasps=100.951 number=2156491 hash=e1088c…66a782
INFO [11-28|06:32:22] blocks=1 txs=1 mgas=2.738 elapsed=21.609ms mgasps=126.692 number=2156492 hash=ae88c3…c5e95c
INFO [11-28|06:32:23] blocks=1 txs=1 mgas=2.310 elapsed=25.376ms mgasps=91.024  number=2156493 hash=f4deab…f5e66c
INFO [11-28|06:32:26] blocks=1 txs=4 mgas=0.281 elapsed=37.741ms mgasps=7.448   number=2156494 hash=93d414…b9eb3a
INFO [11-28|06:33:57] blocks=1 txs=4 mgas=0.232 elapsed=32.003ms mgasps=7.246   number=2156495 hash=3a4f6c…77c500
{% endhighlight %}

Every record reflects some statistics for a new segment in the blockchain. Specifically,

- `blocks`: the number of blocks in this segment (seems to always be 1);
- `txs`: the number of transcations;
- `number`: the (sequence) number of the block; and
- `hash`: the unique hash identifying the block.

You can tell that your node is synchronised when the block number, `blocks`, is the same as the block height listed on the [Ropsten Testnet Pool](http://pool.ropsten.ethereum.org/).

![](/img/2017/11/ropsten-network-status.png)

## Enable RPC

In order to allow communication with the local Ethereum node we'll need to enable [RPC](https://en.wikipedia.org/wiki/Remote_procedure_call). Restart `geth` with the `--rpc --rpcapi db,eth,net,web3,personal,web3` options added. It will continue to download blocks as before.

The node will now also be listening on port 8545 for RPC connections. This is the same port that was previously being used by testrpc. However, now, rather than communicating with a "test" node we will be communicating with a real Ethereum blockchain, albeit the Ropsten test blockchain.

## Create an Account via geth

{{< comment >}}
https://ethereum.gitbooks.io/frontier-guide/content/managing_accounts.html
{{< /comment >}}

Open another terminal and create a new account.

{% highlight bash %}
$ geth account new
{% endhighlight %}

When prompted, type in a secure passphrase. **Do not lose this passphrase and keep it secure!**

{% highlight text %}
WARN [12-02|17:27:51] No etherbase set and no accounts found as default 
Your new account is locked with a password. Please give a password. Do not forget this password.
Passphrase: 
Repeat passphrase: 
Address: {8cc0b0a7372ab95a22774b1f30e3254c3af00db1}
{% endhighlight %}

The details of the new account are stored in the `~/.ethereum/keystore/` folder.

{% highlight bash %}
$ ls -l ~/.ethereum/keystore/
total 4
-rw------- 1 colliera colliera 491 Dec  2 17:28 UTC--2017-12-02T15-28-46.998647286Z--8cc0b0a7372ab95a22774b1f30e3254c3af00db1
{% endhighlight %}

You can create multiple accounts using the above procedure. List the available accounts as follows:

{% highlight bash %}
$ geth account list
{% endhighlight %}

The accounts are listed according to time of creation. In principle you'll only need a single account, but I've created a few for illustrative purposes. The output below has been abridged for clarity.

{% highlight bash %}
Account #0: {6f1ade412335931b17113315bff6cbc0de454d57}
Account #1: {b30e9f15ff346961ed5db2653d69462b08fae19e}
Account #2: {673c8d0a01537154b1f771189266c4e8e59aeadd}
{% endhighlight %}

## Create an Account via web3

Next we need to create and fund an account. We do this from the Truffle console.

Create a new account, providing a strong password.

{% highlight text %}
truffle(development)> web3.personal.newAccount('(Frye}dbpfAc2')
'0x0304bdbda48208ef3cccb9dffecf4d14ab6481b0'
{% endhighlight %}

The details of the new account are stored in the `~/.ethereum/testnet/keystore/` folder.

List available accounts.

{% highlight text %}
truffle(development)> web3.eth.accounts
[ '0x0304bdbda48208ef3cccb9dffecf4d14ab6481b0' ]
{% endhighlight %}

Note that the other accounts created above are not visible. We'll talk about this more below.

To verify that this account has been created on Ropsten, head over to <https://ropsten.etherscan.io/> and search for the account hash.

![](/img/2017/11/ropsten-account-empty.png)

The account exists but there are no transactions on it.

Check the account balance.

{% highlight text %}
truffle(development)> web3.eth.getBalance('0x0304bdbda48208ef3cccb9dffecf4d14ab6481b0')
{ [String: '0'] s: 1, e: 0, c: [ 0 ] }
{% endhighlight %}

Not surprisingly, it's empty. To get your hands on some Ropsten Ether take a look at [this](https://www.reddit.com/r/ethdev/comments/72ltwj/the_new_if_you_need_some_ropsten_testnet_ethers/) Reddit thread. If you're impatient then you can add the `--mine --minerthreads 1` options for `geth` and mine some yourself.

After getting some funds.

{% highlight text %}
truffle(development)> web3.eth.getBalance('0x0304bdbda48208ef3cccb9dffecf4d14ab6481b0')
{ [String: '5000000000000000000'] s: 1, e: 18, c: [ 50000 ] }
{% endhighlight %}

## web3 and geth Accounts

As noted above

- `/home/colliera/.ethereum/keystore/` - keyfiles for accounts created with geth and
- `/home/colliera/.ethereum/testnet/keystore/` - keyfiles for accounts created with web3.

Because the keyfiles are located in different folders this means that AFAIK accounts created with geth are not readily accessible from web3 and vice versa. Now there certainly should be a way to do this, but to date I have not figured out how.