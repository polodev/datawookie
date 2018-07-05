---
draft: true
title: "Truffle Box React"
date: 2018-01-22T08:00:00+00:00
author: Andrew B. Collier
excerpt_separator: <!-- more -->
layout: post
tags:
  - Blockchain
  - Ethereum
  - Truffle
---

ALSO LOOK AT THE WEBPACK BOX

[Truffle]() allows you to access a selection of boilerplate code known as "Truffle Boxes".  Here we'll be looking at the React Box. Find out more about it at its [GitHub repository](https://github.com/truffle-box/react-box).

Create a new folder for the project and move into it.

{% highlight bash %}
mkdir react-box
cd react-box
{% endhighlight %}

Download the React Truffle Box.

{% highlight bash %}
truffle unbox react
{% endhighlight %}

This is what the top level structure of the resulting project looks like:

{% highlight text %}
.
├── config
├── contracts
├── migrations
├── node_modules
├── public
├── scripts
├── src
└── test
{% endhighlight %}

The `contracts` folder contains the Solidity code for the smart contracts. We're interested in the contents of `SimpleStorage.sol`.

{% highlight javascript %}
pragma solidity ^0.4.18;

contract SimpleStorage {
  uint storedData;

  function set(uint x) public {
    storedData = x;
  }

  function get() public view returns (uint) {
    return storedData;
  }
}
{% endhighlight %}

## Preparing the Smart Contract

Start the Truffle development environment.

{% highlight bash %}
truffle develop
{% endhighlight %}

Compile the smart contracts.

{% highlight text %}
truffle(develop)> compile
{% endhighlight %}

Apply the migrations.

{% highlight text %}
truffle(develop)> migrate
{% endhighlight %}

## Running Tests

Run the (single) test.

{% highlight text %}
truffle(develop)> test
{% endhighlight %}

## Running the Front End

In a separate console start the front end.

{% highlight bash %}
npm run start
{% endhighlight %}

That will pop up a browser window directed at <http://localhost:3000/>.

![](/img/2017/11/truffle-react-front-end.png)