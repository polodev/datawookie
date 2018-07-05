---
draft: true
title: "Deploying Etherpad on DigitalOcean"
date: 2017-05-27T19:00:00+00:00
author: Andrew B. Collier
layout: post
excerpt_separator: <!-- more -->
categories:
  - Cloud
tags:
  - Digital Ocean
  - Etherpad
---

1. Connect as root to your DigitalOcean instance. Suppose that your instance is at 104.130.100.47.
{% highlight bash %}
$ ssh -l root 104.130.100.47
{% endhighlight %}
2. Install a bunch of packages.
{% highlight bash %}
# apt-get -y install gzip git curl python libssl-dev pkg-config build-essential python-software-properties
{% endhighlight %}
3. Next install [node.js](http://nodejs.org/).
{% highlight bash %}
# curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
# apt-get -y install nodejs
# node -v
v7.10.0
{% endhighlight %}
4. Create an `etherpad` user.
{% highlight bash %}
# adduser etherpad
{% endhighlight %}
5. Login as the `etherpad` user.
{% highlight bash %}
# # su - etherpad
{% endhighlight %}
6. Clone the repository.
{% highlight bash %}
$ git clone git://github.com/ether/etherpad-lite.git
{% endhighlight %}
7. Install a few dependencies. Depending on the size of your instance you might need to [add some swap](http://www.exegetic.biz/blog/2015/06/amazon-ec2-adding-swap/) to get this to work.
{% highlight bash %}
$ cd etherpad-lite
$ ./bin/installDeps.sh
{% endhighlight %}
8. If you already have something running on port 9001 then choose a new port in `settings.json`.
9. Start the server.
{% highlight bash %}
$ ./bin/run.sh
{% endhighlight %}

With the above setup Etherpad will use [DirtyDB](https://www.npmjs.com/package/dirtydb). For production purposes you'll probably want to use something like MySQL or Redis.

TODO: How to proxy this through NGINX?