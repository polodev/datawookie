---
author: Andrew B. Collier
date: 2015-07-10T09:38:57Z
tags: ["Conference"]
title: 'ICML 2015 (Lille, France): Day 4'
---

Sundry notes from the fourth day of the International Conference for Machine Learning (ICML 2015) in Lille, France. Some of this might not be entirely accurate. Caveat emptor.

## Celeste: Variational inference for a generative model of astronomical images (Jeffrey Regier, Andrew Miller, Jon McAuliffe, Ryan Adams, Matt Hoffman, Dustin Lang, David Schlegel, Prabhat)

Colour modelled as a 4 dimensional vector. The Physics (Planck's Law) places some constraints on the components of these vectors. Light density model accounts for rotation as well as asymmetry of galactic axes.

Discounting effects of pixellation and atmosphere the authors consider an idealised sky view where stars are seen as delta functions. Diffraction and atmospheric effects, however, mean that stars are not actually observed as points of light. This is accounted for by a Point Spread Function (PSF). A Gaussian PSF was used and it was assumed that a given star could only contribute light to a limited range of nearby pixels, so that the Gaussian could be truncated.

Variational inference applied to deal with fact that evidence component in Bayes' Theorem intractable.

## From Word Embeddings To Document Distances (Matt Kusner, Yu Sun, Nicholas Kolkin, Kilian Weinberger)

Talk was based on high quality word embedding using [word2vec](https://code.google.com/p/word2vec/). Question addressed: can one construct document distances from word embeddings. Proposed algorithm is called the "Word Mover's Distance" (WMD), and is related to the [Earth Mover's Distance](https://en.wikipedia.org/wiki/Earth_mover%27s_distance).

Results assessed using k-Nearest Neighbours and look promising. However, the computational complexity is \\(O(n^3 \log n)\\) where \\(n\\) is the number of unique words. However, an approximate "Word Mover's Distance" is only \\(O(n^2)\\), which is much better.

## Latent Topic Networks: A Versatile Probabilistic Programming Framework for Topic Models (James Foulds, Shachi Kumar, Lise Getoor)

Topic Models are useful for Data Mining and Computational Social Science. However, when generating custom Topic Models, more time is spent actually formulating the model than running it. So the analyst becomes the bottleneck. The authors describe a general purpose modelling framework. This system has reduced the time required to generate a custom Topic Model from around six months to a couple of days. The framework was built in [Probabilistic Soft Logic](https://en.wikipedia.org/wiki/Probabilistic_soft_logic) (PSL), which is a first-order logic based SRL language.

The authors refer to [Modeling Scientific Impact with Topical Influence Regression](http://www.ics.uci.edu/~jfoulds/TIR_EMNLP.pdf) by Foulds and Smyth (2013).

## Scalable Deep Poisson Factor Analysis for Topic Modeling (Zhe Gan, Changyou Chen, Ricardo Henao, David Carlson, Lawrence Carin)

Authors based their work on [Beta-Negative Binomial Process and Poisson Factor Analysis](http://arxiv.org/pdf/1112.3605.pdf) by Zhou et al. (2012).

## Ordinal Mixed Membership Models (Seppo Virtanen, Mark Girolami)

Mixed Membership Models: observations are grouped and a mixture model is applied to each group, where mixture components common across groups but mixture proportions are specific to individual groups. These models have previously provided sensible topics. More specifically, Ordinal Mixed Membership Models are based on ordinal variables which have values in a number of ordered categories.

Applied to consumer-generated reviews of mobile software applications.

## Efficient Training of LDA on a GPU by Mean-for-Mode Estimation (Jean-Baptiste Tristan, Joseph Tassarotti, Guy Steele)

Once a statistical model has been decided on, the next question is the computational model. Will the hardware be massively parallel? Will the data be distributed? Will communication be necessary? The answers to these questions might then feed back to the selection of a statistical model.

The authors described an implementation of [Latent Dirichlet Allocation](https://en.wikipedia.org/wiki/Latent_Dirichlet_allocation) (LDA) on a GPU using a Data-Parallel Algorithm. The collapsed Gibbs sampling algorithm, which takes advantage of the sparsity of the data, does not work well in a GPU context. However an "uncollapsed" version of Gibbs sampling can be implemented in a data-parallel fashion although it does have some drawbacks. The authors looked at a slight modification of this algorithm which overcomes these problems. One aspect of their algorithm is to represent the counts in a dense matrix and using "approximate counts" which reduce the memory footprint and bandwidth requirements.

## Social Phenomena in Global Networks (Jon Klenberg)

The "library" metaphor for the WWW has evolved into a "crowd" metaphor. Social interactions and graph theory have become important in describing the WWW.

Referred to [A search for life on Earth from the Galileo spacecraft](http://www.nature.com/nature/journal/v365/n6448/abs/365715a0.html) by Carl Sagan et al. (1993). A related thing has been done using pictures taken by Flickr users: the locations of pictures they take trace out where humans are living. Or does it simply indicate where people are living _and_ taking pictures? The empty spaces: do they exist because people _can't_ live there or because they _don't want_ to live there?

Principles that affect social networks:

* Homophily (people like you); 
* Triadic Closure (if A knows B and B knows C, then A probably knows C too); and 
* Small World Phenomenon.

These ideas go back well into the twentieth century.

Themes:

1. Relationship between global structure and neighbourhoods of individual nodes; 
2. Socially shared information at neighbourhood level.

Neighbourhoods of individual nodes all look quite similar, with a node at the centre surrounded by a few tightly clustered groups of other nodes. You can break the global network down into one of these neighbourhood graphs for each individual. Erdös-Rényi graphs are an appropriate model for these neighbourhoods. Modelling Facebook as a collection of node neighbourhoods can give an understanding of global network structure arising from local structure.

Within a neighbourhood there are generally a relatively small number of strong ties (with frequent communication) and a comparably vast number of weak ties (with rare communication). Triangles in a network play an important role in the theory of strong and weak ties (have a look at [The Strength of Weak Ties](https://sociology.stanford.edu/sites/default/files/publications/the_strength_of_weak_ties_and_exch_w-gans.pdf) and [Economic Action and Social Structure: The Problem of Embeddedness](https://www.jstor.org/stable/2780199)). The "embeddedness" of an edge is the number of common neighbours shared by the endpoint nodes of that edge. This is effectively the number of mutual friends. It's also the metric commonly used in Sociology.

Question: for a Facebook user in a relationship, find their partner just based on network structure. Consider 1.3 million Facebook users who are in a relationship, have 50-2000 friends and are at least 20 years old. For each of these users, rank their friends by a variety of metrics. For what fraction of users is their partner ranked at the top? Interestingly this algorithm gives better results for men than women, suggesting that for men there are fewer friends in their immediate neighbourhood who could be confused with their partner.

> It's doubly awkward because it makes public what should be private. MySpace doesn't just create social networks, it anatomizes them. It spreads them out like a digestive tract on the autopsy table. You can see what's connected to what, who's connected to whom. You can even trace the little puffs of intellectual flatus as they pass through the system. <cite>The Globe and Mail</cite> 

## Learning to Rank using Gradient Descent: Test of Time Award (Chris Burges, Tal Shaked, Erin Renshaw, Ari Lazier, Matt Deeds, Nicole Hamilton, Greg Hullender)

The award was for the paper [Learning to Rank using Gradient Descent](http://icml.cc/2015/wp-content/uploads/2015/06/icml_ranking.pdf) which appeared in the Proceedings of the 22nd International Conference on Machine Learning (Germany, 2005).

Lessons learned:

* Speed is more important than accuracy. 
* If you think that you're onyo something, press on! 
* Goal-oriented research has pros and cons.

## High Confidence Policy Improvement (Philip Thomas, Georgios Theocharous, Mohammad Ghavamzadeh)

In a [Reinforcement Learning](https://en.wikipedia.org/wiki/Reinforcement_learning) (RL) context a policy is a mapping that assigns a probability distribution to possible actions. The system learns by being rewarded for taking the "right" actions towards achieving a goal. The authors presented a system which uses data to evolve the reinforcement learning policy. The system is labelled _High Confidence_ because it will (seldom) return an evolved policy which is worse than the existing policy.

## Functional Subspace Clustering with Application to Time Series (Mohammad Taha Bahadori, David Kale, Yingying Fan, Yan Liu)

Multivariate time series data gathered from patients in hospital. Data have high dimensionality with a complicated latent structure. One challenge is that the data may have been subjected to deformations or transformations. For example, in the time domain the signal might have been shifted or warped. How does the model discriminate between a signal that has been time warped and one that simply has different frequency content?

## Banquet

The day ends with a Banquet which is included with the conference package. Apparently the food is going to be _tres magnifique_. Twitter is hosting a bash at my hotel after that, so I think I might swing by and grab a drink on the way to bed.
