---
title: 'Setting up Jupyter with Python 3 on Ubuntu'
date: 2017-06-23T05:00:00+00:00
author: Andrew B. Collier
excerpt_separator: <!-- more -->
layout: post
category: Python
tags:
  - Jupyter
  - Linux
  - Ubuntu
  - 'Xenial Xerus'
---

![]({{ site.baseurl }}/static/img/2017/06/jupyter-test-notebook.png)

A short note on how to set up Jupyter Notebooks with Python 3 on Ubuntu. The instructions are specific to Xenial Xerus (16.04) but are likely to be helpful elsewhere too.

<!-- more -->

## Python Prerequisites

Make sure that you have `python3` and `pip3` installed.

{% highlight bash %}
$ sudo apt install python3
$ sudo apt install python3-pip
{% endhighlight %}

Also install the IPython shell.

{% highlight bash %}
$ sudo apt install ipython3
{% endhighlight %}

## Install Jupyter

It's then a simple matter to install Jupyter.

{% highlight bash %}
$ pip3 install jupyter
{% endhighlight %}

That installed the executables into `~/.local/bin/`, which then needs to be added to the execution path.

{% highlight bash %}
$ export PATH=$PATH:~/.local/bin/
{% endhighlight %}

It's a good idea to add that to one of your startup scripts, probably `.bashrc`.

## Execution Time

At this stage you should be ready to roll.

{% highlight bash %}
$ jupyter notebook
{% endhighlight %}

That will open up a new Jupyter browser tab. From there you'll be able to browse to find existing notebooks or create a new notebook by pressing the `New` dropdown and selecting the notebook type.

