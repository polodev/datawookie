---
draft: true
title: "Ethereum: Minimal JavaScript for Smart Contracts"
date: 2018-01-08T08:00:00+00:00
author: Andrew B. Collier
excerpt_separator: <!-- more -->
layout: post
tags:
  - Blockchain
  - Ethereum
  - JavaScript
---

I needed to brush up on my JavaScript to make sense of some of the stuff that was happening in Truffle. These are my notes.

<!-- more -->

## Promises

A [promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Using_promises) is an alternative to providing a callback function for dealing with asynchronous results. It represents the *eventual* result of an asynchronous operation and can be in one of three states:

- **pending**
- **fulfilled** (operation completed successfully) or
- **rejected** (operation failed).

Promises are useful for working with smart contracts because interactions with the blockchain can take time (while a block is being mined). So being able to run these interactions asynchronously will ensure that your code doesn't block while waiting for results.

### Using await

This only appears to be available by default with newer versions of `node`.

https://davidburela.wordpress.com/2017/09/21/writing-truffle-tests-with-asyncawait/
https://medium.com/hello-sugoi/testing-solidity-with-truffle-and-async-await-396e81c54f93
https://github.com/aaren/truffle-await