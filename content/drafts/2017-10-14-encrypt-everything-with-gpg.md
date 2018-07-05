---
draft: true
title: 'Encrypt Everything with GPG'
date: 2017-10-14T07:00:00+00:00
author: Andrew B. Collier
layout: post
excerpt_separator: <!-- more -->
tags:
  - Encryption
  - gpg
---

## Setup

Your `.gnupg` should be accessible by you alone.

{% highlight bash %}
$ chmod 0700 ~/.gnupg/
{% endhighlight %}

## Working with Keys

## Creating a Key

{% highlight bash %}
$ gpg --gen-key
{% endhighlight %}

### Exporting a Key

{% highlight bash %}
$ gpg --armor --export andrew@exegetic.biz
-----BEGIN PGP PUBLIC KEY BLOCK-----

mQENBFnyyfQBCACrbR/hQwJeFNU4Y0OcqWmerXDzSW013TXm+e5ESDCbUsWpJ2BJ
wrqeG3hQPDzOb32DW/ToKzF8Ghbt5qLRSz0pj4SPa2dnCLDfD1F/fjb4kyNL/yDD
tQZSM7zO03D/kgBL4u49ZuivD0Aa8gxi611ZXX2YCEiuhOOvgR4CHVx3Zc7rbv24
YoPc2LMg+5MjFMh9+HYse4ZoLusxSnSMCeXp/W0goPWmI04DUQ3wWA0IvgDRAgzn
BYT9yVwmSYkuiDvl9oywEAlbhtmsIxbHYJ9HFnVmspEzHXFlUflw/Nmf+6e58i2m
uWPU+I0KiMUzu560bVldxdo3jm89h3V4vxYfABEBAAG0JEFuZHJldyBDb2xsaWVy
IDxhbmRyZXdAZXhlZ2V0aWMuYml6PokBNwQTAQgAIQUCWfLJ9AIbAwULCQgHAgYV
CAkKCwIEFgIDAQIeAQIXgAAKCRA0GJwfAjuK25NiB/4zZN1edBKPXQMwIVW7lwzk
2QVAerOh003/MKAmO7/V5zFqio7txKcx8SdhuXEzo9TPpthqljdqPDjrcOgybtMr
hI19aPq1yk702NO/836EnNPbJyIiQajMaDDruuX/2h7Mhb+vyUi51jvVyKMEmkJW
bdarZSmHg3jCWfrvz/XNe3M8Ue+D6XtrXcCepGKtV5ZysWThmT4hhp4hR0M9i/c1
MJoo8zwSewUN9iozuQ4Iz2gTl7iLscrtOmRLny3WPZoYZS/a8TmOI+QjWpMPpwQZ
nseLTbSo62qRLcPtREo9UFWqFUA+XLy+MO/tUrbJ5GlhkZEpTstiwxjYN2o1GS13
uQENBFnyyfQBCAC9slJqaORyEiTO06cCdwxKFHRveXpyhA/r6Wv3jDbj4A2TvQLs
CIRQ1dh4OsWJv/7dEFEPEJFNEemOjc1ke3VLTqLMrYgrMQnUaPZxDrG6Ujy03nuQ
vMS0n1ffMaWfpwLj6bvzMTtakcoKl6w/drbZQes8NmSpWhBA+aHN/lpJOO4m5sRL
twz4i9MJonDaMj/+PW7CaGMHB0UGXvt+wA/QEosZOKjJoN9lCAirPiRfyCqR7J2C
va6WwWS5nUbFolvM6gdFrdt75/GBB0a22XjeCcNsB5zLGKetxlSKUHbw5D2jPDUy
J5UTyHF6Jfd2+PTtX3Z59SnMRliqdBcpa3VdABEBAAGJAR8EGAEIAAkFAlnyyfQC
GwwACgkQNBicHwI7ittwbAf+K6sqMq8q4nebIHTXmz+kfufFnkhEnH+WGdhmmqWB
J8bJk2DTSkkK10Z0/4fthZg1THSGXJ+iOULXKVGDRj01PxOWWQNPGQpjs+Jb03SG
zFAGKiiaD0C6FtDBsOXSNPp0KQwQtiQWFT2R4+xJ8ILr0zB3hfKRWDMWTiT4u+R/
8er+Qvqk8JVM3/Sh11NT0cN2POSBzpKAj0qEhAhb/XGOgTfEhTZibNRF7afIef9U
X1f7XPKupvsRFzQGT7NoEXYuVpBwBEUHV7llpza1Tisx0WNkqQt4PrUTSiAQ6ZkS
XQ+416lTpdwoX6d2vIABLQA6q7F5ZcDiSd+ZNtWE5S65zA==
=mWJk
-----END PGP PUBLIC KEY BLOCK-----
{% endhighlight %}

### Importing a Key

To import Alice's public key from `alice.asc`.

{% highlight bash %}
$ gpg --import alice.asc
gpg: key 632D3CF05C4858A5: public key "Alice <alice@example.com>" imported
gpg: Total number processed: 1
gpg:               imported: 1
{% endhighlight %}

### Listing Keys

{% highlight bash %}
$ gpg --list-keys
{% endhighlight %}

{% highlight bash %}
{% endhighlight %}

{% highlight bash %}
{% endhighlight %}

{% highlight bash %}
{% endhighlight %}

{% highlight bash %}
{% endhighlight %}

{% highlight bash %}
{% endhighlight %}

## Encrypting and Decrypting

### Encrypting a File

To create an encrypted copy of the file `document.txt` for Alice.

{% highlight bash %}
$ gpg --encrypt --recipient alice@example.com --output document.txt.gpg document.txt
{% endhighlight %}

### Decrypting a File

Alice would then decrypt the file like this:

{% highlight bash %}
$ gpg --output document.txt --decrypt document.txt.gpg
{% endhighlight %}

## Digital Signatures

## Other Options

veracrypt
