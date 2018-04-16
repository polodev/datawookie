---
author: Andrew B. Collier
date: 2015-10-07T12:30:09Z
tags: ["R", "Machine Learning", "Book Review"]
title: 'Review: Data Mining with Rattle and R'
---

<!--more-->

<img src="/img/2015/10/data-mining-with-rattle-and-R.jpg">

I read [Data Mining with Rattle and R](http://www.springer.com/us/book/9781441998897) by Graham Williams over a year ago. It's not a new book and I've just been tardy in writing up a review. That's not to say that I have not used the book in the interim: it's been on my desk at work ever since and I've dipped into it from time to time. As a reference for ongoing analyses it's an extremely helpful resource.

This book focuses on the use of [Rattle](http://rattle.togaware.com/), an interface to R, for Data Mining. Before I take a look at its contents, here are some specifics: it was published in 2011 by Springer-Verlag; it's part of the [Use R!](http://www.springer.com/series/6991) series; 374 pages in length; DOI 10.1007/978-1-4419-9890-3.

**Part I: Explorations**

1. _Introduction_   
Some general background information on Data Mining, outlining the typical path of a Data Mining project. Also discusses appropriate tools and why R+Rattle is a good combination. 
2. _Getting Started_   
Instructions on getting both R and Rattle up and running. Breeze through an introductory example, from loading data and exploratory analysis to building models and evaluating results. Finishes with a more in-depth review on some aspects of the R language, with a useful section on using environments for encapsulation. 
3. _Working with Data_   
Looking at various issues pertaining to data: where it comes from, quality and documentation. 
4. _Loading Data_   
Getting data into Rattle from various sources (including the clipboard, directly from the WWW, CSV or tab delimited files and ODBC). Then partitioning those data into training and testing sets as well as assigning roles to variables. 
5. _Exploring Data_   
A deeper look at exploratory data analysis on single variables using techniques ranging from numeric and textual summaries to visualisation with histograms, scatter, bar, dot, box and mosaic plots. Relationships between variables are considered using correlation matrices and hierarchical clustering. 
6. _Interactive Graphics_   
What extra information can be extracted from the data using interactive tools like [latticist](https://code.google.com/p/latticist/) and [GGobi](http://www.ggobi.org/)? 
7. _Transforming Data_   
 Data transformation is often the largest task in an analysis project. The issues of cleaning and dealing with missing data and outliers are dealt with. Scaling and non-linear transformation of the data are considered. Finally the chapter takes a look at variable recoding via binning of continuous variables or creating indicator variables.

**Part II: Building Models**

<ol>
	<li value="8"> <em>Descriptive and Predictive Analytics</em>
	<li> <em>Cluster Analysis</em>
	<li> <em>Association Analysis</em>
	<li> <em>Decision Trees</em>
	<li> <em>Random Forests</em>
	<li> <em>Boosting</em>
	<li> <em>Support Vector Machines</em>
</ol>

The first chapter in this part of the book describes the distinction between descriptive and predictive analytics, and acts as an introduction to building models in Rattle. Each of the following six chapters considers a different type of model. The chapter on association analysis uses data on DVD purchases while the remaining chapters all use the weather data set (from the rattle package) for illustration. Each chapter starts with a high level (mostly) qualitative description of how the model works and an overview of the algorithm. This is followed by a detailed tutorial showing how the model is applied in Rattle. The details of achieving the same analysis via the R console are then presented. Having both of these perspectives is extremely helpful. Details of various parameters used to fine tune the model round out each chapter.

### Part III: Delivering Performance

<ol>
<li value="15"> <em>Model Performance Evaluation</em><br>
There's a distinct part of the Rattle interface for dealing with the important topic of model evaluation. It provides access to a range of evaluation methods extending from simple metrics like precision and recall based on a confusion matrix through to risk charts and ROC curves.
<li> <em>Deployment</em><br>
Various options for deploying a Rattle model, ranging from a deployment in R to exporting <a href="https://en.wikipedia.org/wiki/Predictive_Model_Markup_Language">PMML</a> and converting to a stand alone model.
</ol>

### Part IV: Appendices

A. _Installing Rattle_   
How to install Rattle (predicated on an existing R installation).

B. _Sample Datasets_   
The datasets which come along with the Rattle package and a discussion of how these data were acquired and processed. This is a valuable portion of the book since it documents the entire data preparation pipeline.

There's an extensive set of references and a complete index.

Since I enjoy being close to the raw, bleeding edge I re-installed the beta version of Rattle today and gave it a spin.

{{< highlight r >}}
> library(devtools)
> devtools::install_bitbucket(&quot;kayontoga/rattle&quot;)
> library(rattle)
Rattle: A free graphical interface for data mining with R.
Version 4.0.0 Copyright (c) 2006-2015 Togaware Pty Ltd.
Type 'rattle()' to shake, rattle, and roll your data.
> rattle()
{{< /highlight >}}

The GUI looks pretty sleek. I did have hassles with some of the functionality in the beta version, so if you are going to give this a try I'd advise you to just install the version available at <a href="http://cran.mirror.ac.za/">CRAN</a>.

<img src="/img/2015/10/rattle-gui.jpg" width="100%">

Wrapping things up, <a href="http://www.springer.com/us/book/9781441998897">Data Mining with Rattle and R</a> is not just about how to use Rattle to solve Data Mining problems. It also digs quite deep into a number of Data Mining and Machine Learning algorithms. As such it's also a pretty handy reference. If you are looking at a way of transitioning from a point-and-click style analysis to R, then I think that installing Rattle and getting hold of a copy of this book would be a good place to start. I think that the key thing to consider with regards to this book is that it does not set out to be an encyclopaedia on Machine Learning. It's focus is on using Rattle (and in the process it provides the necessary background information).