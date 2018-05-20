---
author: Andrew B. Collier
date: 2018-01-19T03:30:00Z
tags: ["Ethereum"]
title: 'Ethereum: DIY Tools for Smart Contracts'
---

What tools do you need to start working with Ethereum smart contracts?

The [Solidity Online Compiler](https://ethereum.github.io/browser-solidity/) provides a quick way to experiment with smart contracts without installing any software on your machine. Another promising online alternative is [Cosmo](http://cosmo.to/).

However at some stage you'll probably want to put together a local Ethereum development environment. Here are some suggestions for how to do that on an Ubuntu machine.

Since I'm just feeling my way into this new domain, I'm not sure to what degree all of these are necessary. I do know for sure, that Truffle and `testrpc` are crucial.

<!--more-->

## Preliminaries

Accurate time is important. Probably not critical to have nanosecond or microsecond accuracy. But you want your computer's clock to be correct to within a few milliseconds.

An owner of a grandfather clock needs to regularly wind it and check its time. That's fine for an antique heirloom. But you don't want to have to do the same for your shiny computing machine, do you? Hell no! Nothing sexy about that. Rather ensure that you have [NTP running]({{< relref "2018-01-11-synchronise-time-ntp.md" >}}). NTP will take care of timekeeping tasks, adjusting your clock's time and offseting any inherent drift.

## Command Line Client

The Ethereum command line client allows to have direct access to the blockchain. By running the client you'll be able to mine blocks, send and receive ETH, deploy and interact with smart contracts.

There are multiple implementations of the client:

- [pyethapp](https://github.com/ethereum/pyethapp) (Python)
- [Eth](https://github.com/ethereum/cpp-ethereum/) (C++)
- [Geth](https://ethereum.github.io/go-ethereum/) (Go).

The third of these is the most popular and actively developed.

### Install from PPA

1. Add the Ethereum PPA.

{{< highlight text >}}
$ sudo apt-get install software-properties-common
$ sudo add-apt-repository -y ppa:ethereum/ethereum
$ sudo apt-get update
{{< /highlight >}}

{:start="2"}
2. Install Geth.

{{< highlight text >}}
$ sudo apt-get install -y ethereum
{{< /highlight >}}

{:start="3"}
3. Check the version.

{{< highlight text >}}
$ geth version
Geth
Version: 1.7.3-stable
Git Commit: 4bb3c89d44e372e6a9ab85a8be0c9345265c763a
Architecture: amd64
Protocol Versions: [63 62]
Network Id: 1
Go Version: go1.9
Operating System: linux
GOPATH=
GOROOT=/usr/lib/go-1.9
{{< /highlight >}}

New releases come out every few weeks, so it's not a bad idea to update from time to time.

This is a good time to [synchronise with the blockchain]({{< relref "2018-01-19-ethereum-running-node.md" >}}).

### Install the Docker Image

Alternatively, if you prefer to keep things in containers, there's also a Docker image.

{{< highlight bash >}}
$ docker run ethereum/client-go:stable version
Geth
Version: 1.7.3-stable
Git Commit: 4bb3c89d44e372e6a9ab85a8be0c9345265c763a
Architecture: amd64
Protocol Versions: [63 62]
Network Id: 1
Go Version: go1.9.2
Operating System: linux
GOPATH=
GOROOT=/usr/local/go
{{< /highlight >}}

## Solidity Compiler

There are currently three languages for developing smart contracts:

- Serpent
- LLL and
- Solidity.

Solidity appears to be winning the popularity competition, so we'll focus on that.

On a Ubuntu machine there are a few options for installing the Solidity compiler. Check out the [official install documentation](https://solidity.readthedocs.io/en/develop/installing-solidity.html).

### Install from PPA

1. Install from the PPA we added above.

{{< highlight bash >}}
$ sudo apt-get install solc
{{< /highlight >}}

{:start="2"}
2. Check the version.

{{< highlight text >}}
$ solc --version
solc, the solidity compiler commandline interface
Version: 0.4.19+commit.c4cbbb05.Linux.g++
{{< /highlight >}}

### Install the Docker Image

You can also take the Docker route.

{{< highlight bash >}}
$ docker run ethereum/solc:stable --version
Version: 0.4.19+commit.c4cbbb05.Linux.g++
{{< /highlight >}}

## Ganache Testing Client

A testing client simulates interactions with the Ethereum blockchain, making the development process quicker and more flexible.

The Ethereum ecosystem is evolving rapidly. The TestRPC testing client has become [Ganache](https://github.com/trufflesuite/ganache-cli).

### Update Node

If your version of Node is an antique then you'll need to update. First check which version you currently have.

{{< highlight text >}}
$ node --version
v6.12.2
{{< /highlight >}}

If that's less than 6.11.15 then run [the following](https://github.com/nodesource/distributions#installation-instructions) to update.

{{< highlight bash >}}
$ curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
$ sudo apt-get install -y nodejs
{{< /highlight >}}

### Install with NPM

{{< highlight text >}}
$ sudo npm install -g ganache-cli
{{< /highlight >}}

## Truffle

[Truffle](https://github.com/trufflesuite/truffle) is a development environment for Ethereum. It works well with Ganache.

### Install with NPM

{{< highlight bash >}}
$ sudo npm install -g truffle@4.0.1
{{< /highlight >}}

## Conclusion

That's pretty much everything you need to start writing smart contracts.