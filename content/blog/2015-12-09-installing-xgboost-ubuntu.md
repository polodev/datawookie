---
author: Andrew B. Collier
date: 2015-12-09T15:00:14Z
tags: ["R", "Python"]
title: Installing XGBoost on Ubuntu
---

<!--more-->

<img src="/img/2015/12/xgboost.png" >

[XGBoost](https://github.com/dmlc/xgboost) is the flavour of the moment for serious competitors on [kaggle](https://www.kaggle.com/). It was developed by [Tianqi Chen](https://www.kaggle.com/tqchen) and provides a particularly efficient implementation of the [Gradient Boosting](https://en.wikipedia.org/wiki/Gradient_boosting) algorithm. Although there is a [CLI](https://en.wikipedia.org/wiki/Command-line_interface) implementation of XGBoost you'll probably be more interested in using it from either R or Python. Below are instructions for getting it installed for each of these languages. It's pretty painless.

## Installing for R

Installation in R is extremely simple.

{{< highlight r >}}
> install.packages('xgboost')
> library(xgboost)
{{< /highlight >}}
  
It's also supported as a model in [caret](http://topepo.github.io/caret/index.html), which is especially handy for feature selection and model parameter tuning.

## Installing for Python

This might be as simple as

{{< highlight bash >}}
$ pip install xgboost
{{< /highlight >}}

If you run into trouble with that, try the alternative approach below.

Download the latest version from the [github repository](https://github.com/dmlc/xgboost). The simplest way to do this is to grab the [archive](https://github.com/dmlc/xgboost/archive/0.47.tar.gz) of a recent release. Unpack the archive, then become root and then execute the following:
  
{{< highlight text >}}
# cd xgboost-master
# make
# cd python-package/
# python setup.py install -user
{{< /highlight >}}
  
And you're ready to roll:
  
{{< highlight python >}}
import xgboost
{{< /highlight >}}

If you run into trouble during the process you might have to install a few other packages:
  
{{< highlight text >}}
# apt-get install g++ gfortran
# apt-get install python-dev python-numpy python-scipy python-matplotlib python-pandas
# apt-get install libatlas-base-dev
{{< /highlight >}}

## Conclusion

Enjoy building great models with the absurdly powerful tool. I've found that it effortlessly consumes vast data sets that grind other algorithms to a halt. Get started by looking at some [code examples](https://github.com/dmlc/xgboost/tree/master/demo). Also worth looking at are

* an [Introduction to Boosted Trees](https://xgboost.readthedocs.org/en/latest/model.html); 
* a [tutorial](https://www.kaggle.com/tqchen/otto-group-product-classification-challenge/understanding-xgboost-model-on-otto-data) showing how XGBoost was applied to the Otto Group Product Classification Challenge; 
* Understanding Gradient Boosting ([Part 1](http://rcarneva.github.io/understanding-gradient-boosting-part-1.html)); and 
* a [presentation](https://www.youtube.com/watch?v=sRktKszFmSk) by Alexander Ihler.

<iframe width="560" height="315" src="https://www.youtube.com/embed/zwKFyMkvNXE" frameborder="0" allowfullscreen></iframe>