---
author: Andrew B. Collier
date: 2015-07-08T07:30:10Z
tags: ["Conference"]
title: 'ICML 2015 (Lille, France): Day 2'
---

Some notes from the second day at the International Conference for Machine Learning (ICML 2015) in Lille, France. Don't quote me on any of this because it's just stuff that I jotted down during the course of the day. Also much of the material discussed in these talks lies outside my field of expertise. Caveat emptor.

## Two Big Challenges in Machine Learning (Léon Bottou)

Machine Learning is an Exact Science. It's also an Experimental Science. It's also Engineering.

The experimental paradigm in Machine Learning consists of splitting a large data set into training and testing sets. Train. Test. Iterate. Done! But this paradigm is reaching its limits. Other experimental disciplines (for example, Physics, Biology) have to work a lot harder on designing, executing and interpreting experiments.

Léon referred us to the [Learning and Transferring Mid-Level Image Representations using Convolutional Neural Networks](http://www.di.ens.fr/willow/research/cnn/) project.

Machine Learning practitioners cannot rely exclusively on train/test experiments. We need to adopt best practices from other experimental sciences. Proposition: Machine Learning papers should specify the limitations in their approach. For example, for data with a Zipf distribution the majority of examples have only a single occurrence. In such a case we should aim to achieve maximum coverage across the data rather than looking at average accuracy.

## A Nearly-Linear Time Framework for Graph-Structured Sparsity (Ludwig Schmidt)

Data often exhibits structured sparsity. For example, Astronomical images are mostly empty, but where there is something interesting in the image, it is well structured.

Sparsity is often accompanied by rich structure. This motivates the application of Sparse Linear Regression. From this point the talk very quickly became highly theoretical. Unfortunately, my graduate course in graph theory was too long ago for me to make too much sense of it. From what I could gather, the approach was to represent the vector of regression coefficients as a graph. Considerations for this approach are generality, statistical efficiency and computational efficiency.

## Learning from Corrupted Binary Labels via Class-Probability Estimation (Aditya Menon, Brendan Van Rooyen, Cheng Soon Ong, Bob Williamson)

Consider a data set consisting of instances with binary labels. Some of these labels are either corrupted (True to False or vice versa) or censored. Corruption occurs at random. A simple approach would be to treat data as if it were not corrupted. But it's possible to do much better than that.

We can model the situation using a pair of parameters, alpha and beta, which describe the relative frequency of corruption of each type of label. There is also an underlying clean class probability, which we aim to access via a corrupted class probability. The latter can be estimated directly from the corrupted data.

## Manifold-valued Dirichlet Processes (Hyunwoo Kim, Jia Xu, Baba Vemuri, Vikas Singh)

<div class="sidenote">
  I didn't know anything about Dirichlet Processes, so I did a bit of reading. It seems that an application we would be interested in would be to use them for k-means clustering with an unknown number of clusters.
</div>

## Multi-instance multi-label learning in the presence of novel class instances (Anh Pham, Raviv Raich, Xiaoli Fern, Jesús Pérez Arriaga)

Multiple instances with multiple labels. For example, a selection of images, each of which has labels indicating some selected contents. More specifically, "Tree", "Cloud" and "Water" in image 1; "Duck" and "Water" in image 2; etc. The novel instances are things that appear in an image but are not reflected in the label. For example, "Grass" in image 1. How do we deal with instances that are not included in the bag of known labels?

Their approach is a discriminative graphical model with exact inference based on multiclass logistic regression which caters for unknown labels.

## Entropy evaluation based on confidence intervals of frequency estimates: Application to the learning of decision trees (Mathieu Serrurier, Henri Prade)

The use of entropy as a splitting criterion becomes progressively less effective as you get further down the decision tree due to the sparsity of cases. Simple decision trees are thus prone to overfitting. Possible remedies are early-stopping or pruning.

## Support Matrix Machines (Luo Luo, Yubo Xie, Zhihua Zhang, Wu-Jun Li)

Consider a classification problem where the features are matrices (e.g., EEG or image data). There is redundancy or correlation between adjacent elements which would be lost if the data were represented as a vector, since it would ignore structure. One solution is a matrix analogue of SVM. Details were buried in a mountain of maths.

## Attribute Efficient Linear Regression with Distribution-Dependent Sampling (Doron Kukliansky, Ohad Shamir)

Two approaches to budgeted learning:

1. few subjects and many tests; 
2. many subjects with fewer tests.

The latter is obviously preferable from the perspective of the subjects. If the same number of tests are conducted overall, it may not have a significant effect on costs, but perhaps it is possible to get away with fewer tests in total?

Concrete example: 4 subjects with 4 tests each versus 8 subjects with 2 (randomly sampled) tests each. Effectively leads to a data matrix with missing elements. But it's not really a "missing data" problem. One approach is the AERR algorithm ([Linear regression with limited observation](http://icml.cc/2012/papers/433.pdf)) described by Hazan, Elad and Koren, Tomer.

## Optimal Regret Analysis of Thompson Sampling in Stochastic Multi-armed Bandit Problem with Multiple Plays (Junpei Komiyama, Junya Honda, Hiroshi Nakagawa)

I'll freely admit that, despite having worked in the online gaming industry, I had to check what a [Multi-arm Bandit](https://en.wikipedia.org/wiki/Multi-armed_bandit) (MAB) referred to in the context of Machine Learning. It turns out that they are not too different from what you would expect! The player has access to an array of machines, each of which produces a random reward which is sampled from a particular distribution associated with that machine. He has to decide which of these machines to play, the number of times that he plays each machine and the sequence in which he plays them. The player attempts to optimise the cumulative reward across a series of games. He has to balance exploitation of machines that he already knows to provide higher rewards with exploration of other machines (which might, in principle, yield even higher rewards).

Somewhat surprisingly, this model has been applied to diverse scenarios like resource allocation in the presence of uncertainty, but where the level of uncertainty declines with time.

## Compressing Neural Networks with the Hashing Trick (Wenlin Chen, James Wilson, Stephen Tyree, Kilian Weinberger, Yixin Chen)

Deep Learning is easier if you have access to significant computing resources. But what if you want to do it on a small device (like a phone) with a relatively low-end CPU and limited RAM? In a neural network model the weight matrices are the biggest consumers of memory. Compressing these matrices will make neural networks possible on smaller devices. A variety of techniques exist for reducing the size of these matrices, all of which introduce only a marginal amount of additional error for moderate compression (so there is definitely room for this approach without compromising efficiency). The hashing trick appears to achieve the most effective compression without severe impacts on performance.

## Deep Learning with Limited Numerical Precision (Suyog Gupta, Ankur Agrawal, Kailash Gopalakrishnan, Pritish Narayanan)

Consider algorithms running on numerically noisy hardware. From a computational perspective the noisy hardware is likely to be more efficient. Using low precision (16 bit versus 32 bit) fixed point (as opposed to floating point) arithmetic results in improvements in memory footprint as well as data transfer bandwidth. But what is the impact on Machine Learning algorithms?

The proportion of the bits in the fixed point number which are allocated to representing the fractional part has a strong influence on the results. This occurs when "conventional" round-to-nearest rounding schemes are used. However, when [stochastic rounding](https://en.wikipedia.org/wiki/Rounding#Stochastic_rounding) (where numbers are rounded up or down randomly with weights depending on the distance to the ceiling or floor) is applied, the results are much better.

## Scalable Model Selection for Large-Scale Factorial Relational Models (Chunchen Liu, Lu Feng, Ryohei Fujimaki, Yusuke Muraoka)

Relational models attempt to reveal the latent group structure in a network and also to predict unseen links that have not yet been captured by the network.

## Consistent estimation of dynamic and multi-layer block models (Qiuyi Han, Kevin Xu, Edoardo Airoldi)

A simple network can be insufficient to describe some phenomenon of interest. Instead one might consider a dynamic network, which changes over time, or a multi-layer network, including information relating to different relationships (for example, connections across Facebook and LinkedIn). A single network can be modelled using an adjacency matrix. A Stochastic Block Model (SBM) incorporates a number of classes, where edges are formed with a class-dependent probability. In this model the adjacency matrix is block diagonal.

The authors worked with a SBM for multi-graphs (sequence of graph snapshots), where the edge probability matrix changed between snapshots but the classes remain static. One of the examples presented was based on the [Reality Commons](http://realitycommons.media.mit.edu/realitymining3.html) data set, which was analysed using a multi-graph SBM approach.

## Community Detection Using Time-Dependent Personalized PageRank (Haim Avron, Lior Horesh)

Community detection is the process of finding a collection of nodes which are internally cohesive and well separated. One technique for identifying communities is based on graph diffusion. The fundamental quantity involved in this process is a diffusion vector. The classical form of the diffusion vector is the PageRank vector [as described by Brin and Page](http://www.sciencedirect.com/science/article/pii/S016975529800110X).

## Poster Session

A well catered poster session with an extensive range of interesting contributions. Delcious salami. It might be my downfall.
