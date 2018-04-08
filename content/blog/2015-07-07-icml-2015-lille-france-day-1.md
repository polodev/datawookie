---
author: Andrew B. Collier
date: 2015-07-07T19:08:02Z
tags: ["Conference"]
title: 'ICML 2015 (Lille, France): Day 1 (Tutorials)'
---

Started the day with a run through the early morning streets of Lille. This city seems to wake up late because it was still nice and quiet well after sunrise. Followed by a valiant attempt to sample everything on the buffet breakfast. I'll know where to focus my attention tomorrow.

## ICML2015

The first day of the International Conference on Machine Learning (ICML 2015) in Lille consisted of tutorials in two parallel streams. Evidently the organisers are not aware of my limited attention span because these tutorials each had nominal durations of longer than 2 hours, punctuated by a break in the middle.

Below are my notes from the tutorials. Most of the material discussed in these talks lies outside my field of expertise. So my understanding may well be flawed. Caveat emptor. I would appreciate feedback on anything that I have got horrendously wrong.

## Natural Language Understanding: Foundations and State-of-the-Art (Percy Liang)

[Natural Language Understanding](https://en.wikipedia.org/wiki/Natural_language_understanding) (NLU) is not the same as [Natural Language Processing](https://en.wikipedia.org/wiki/Natural_language_processing) (NLP). It's more specific, referring to the actual comprehension of and extraction of meaning from language. Understanding is a more difficult problem than simply processing since it has to deal with vagueness (incomplete information), uncertainty and ambiguity. Percy Liang made reference to the [Turing Test](https://en.wikipedia.org/wiki/Turing_test), implying that if a computer were to succeed in passing this test then it would need to be capable of understanding language (as opposed to simply processing it). [Siri](https://en.wikipedia.org/wiki/Siri) and [Google Now](https://en.wikipedia.org/wiki/Google_Now) were cited as examples of current systems which have implemented a form of NLU.

The first step towards NLU is choosing an internal representation for the language data. There are a number of options, including

* word vectors (just a "bag of words") or phrase vectors; and 
* [dependency parse trees](https://en.wikipedia.org/wiki/Parse_tree#Dependency-based_parse_trees).

Once you've wrestled the data into the machine, the fun can begin. Percy described an analytical hierarchy, with syntax at the lowest level and pragmatics at the highest level.

### Syntax

Syntax determines the structure of sentences. A large proportion of syntactic structure is extracted while constructing a dependency parse tree. However, as Percy pointed out, even then syntax can be fraught with ambiguity. He cited the following sentence as an example:

> I ate some dessert with a fork. 

This can have two interpretations depending on whether you regard "some dessert" or "some dessert with a fork" to be the subject of the sentence.

### Semantics

Semantics refers to the extraction of literal meaning from language. The interpretation of individual words or combinations of words. This too can be a tricky process. And there are fancy words to describe why it's tricky. First there is the problem of words with different meanings depending on context. This is known as [polysemy](https://en.wikipedia.org/wiki/Polysemy), and it can make the interpretation of words (and groups of words) unclear for humans, never mind machines. Then there is anaphora, which Percy illustrated using

> The dog chased the cat, which ran up a tree. It waited at the top. 

and

> The dog chased the cat, which ran up a tree. It waited at the bottom. 

Clearly for both examples the meaning of "it" in the second sentence depends on a deeper understanding of the situation being described and cannot be extracted from the text alone. The [Winograd Schema Challenge](https://en.wikipedia.org/wiki/Winograd_Schema_Challenge) is an alternative to the Turing Test which attempts to indentify machine intelligence based on the resolution of anaphora.
                
<img src="/img/2015/07/dog_chasing_cat_up_tree.png" width="100%">

Percy quoted John Rupert Firth:

<blockquote>
You shall know a word by the company it keeps.<cite>John Rupert Firth</cite>
</blockquote>

The implication is that an understanding of a word is facilitated by its context. The surrounding words at least partially determine its meaning.

One approach to semantic analysis is to construct a word content matrix. I assumed that this referred to a [Document-term_matrix](https://en.wikipedia.org/wiki/Document-term_matrix) or its transpose. I have encountered these before while using the [tm](http://cran.r-project.org/web/packages/tm/index.html) package, so for a moment I felt on firmer ground. Something that had not occurred to me (but in retrospect is rather obvious because these matrices can be massive) is to then apply dimensionality reduction. This would replace a sparse high-dimensional representation with a dense low-dimensional one. Percy suggested that SVD would be a suitable approach, but I imagine that PCA would work too.

### Pragmatics

I'll freely confess that by this stage both my attention and resolve were waning. I was beginning to entertain lewd thoughts about a cheese sandwich too. So what I managed to glean about pragmatics is fairly limited.

Pragmatics is the understanding of actual or intended meaning. And, as you might guess, this is an even harder problem than semantics. Percy mentioned two relevant projects:

* [FrameNet](https://framenet.icsi.berkeley.edu/fndrupal/), a lexical database of English, and 
* [PropBank](http://verbs.colorado.edu/~mpalmer/projects/ace.html), an annotated corpus.

For more detailed information on Percy's talk, check out the [slides](http://icml.cc/2015/tutorials/icml2015-nlu-tutorial.pdf).

## Bayesian Time Series Modeling: Structured Representations for Scalability (Emily Fox)

After lunch Emily Fox started out by describing the omnipresence of time series: they are literally everywhere! There are two major goals of time series analysis:

1. understanding evolution (changes with time); and 
2. revealing relational structure (dependencies within multivariate time series).

And there are a number of challenges encountered in reaching these goals:

* Data volume: time series data can be highly multidimensional and consist of a large number (or infinite stream) of observations; 
* The data might be irregularly sampled (different sampling times for each element of a multidimensional dataset); 
* Missing values; 
* Data of heterogeneous type and origin.

### Analysis Techniques

Some suitable analysis techniques:

#### Hidden Markov Models (HMMs)

Hidden Markov Models divide a time series into a sequence of states, with a transition matrix which describes the probability of changes between those states. Transition probabilities depend only on current state (this is the Markovian property). Observations within a given state are assumed to be independent, although this assumption is seldom realised in practice.

#### Vector Autoregressive (VAR) Models

These models are useful for modelling continuous value processes and are a multivariate extension of AR models.

#### State Space Models

Like HMMs but for continuous value processes. These are a super-set of VAR models.

#### Dynamic Latent Factor Models

A Dynamic Latent Factor Model is a state-space model with a low dimensional state but high dimensional observations. The observations are projected from a high dimensional space onto a lower dimensional subspace. This works because there is generally some redundancy between the original observations. Full complexity is captured in the subspace. The covariance matrix in the subspace changes with time and the relationship between the subspace and the space of the original observations also changes as the covariance matrix evolves.

This was the first time that I had given any serious thought to [latent variable models](https://en.wikipedia.org/wiki/Latent_variable_model) and I was intrigued. A little bit lost. But definitely intrigued.

### Clustering Time Series

In [Achieving a Hyperlocal Housing Price Index: Overcoming Data Sparsity by Bayesian Dynamical Modeling of Multiple Data Streams](http://arxiv.org/abs/1505.01164) authors Ren, Fox and Bruce describe an approach for analysing multiple time series where some series are dense and others are sparse. The covariance matrix is assumed to be block diagonal, with each block consisting of a cluster of time series with similar structure. The number of clusters is determined using Bayesian Non-parametric Clustering which allows the clusters to evolve as new data are added.

### Graphical Models for Time Series

Edges represent relationships between variables. If there is no edge then variables are conditionally independent. A Decomposable Graph can be broken down into Cliques and Separators.

For more information on Emily's talk, check out the [slides](http://icml.cc/2015/tutorials/BayesianTimeSeries.pdf).

## Computational Social Science (Hanna Wallach)

Hanna Wallach started off by juxtaposing the disciplines of Computer Science and Social Science. Whereas the latter is question driven, the former is method and/or data driven. With regards to research goals in the two disciplines she quoted:

> Policy makers or computer scientists may be interested in finding the needle in the haystack (such as a potential terrorist threat or the right web page to display from a search), but social scientists are more commonly interested in characterizing the haystack.<cite>Daniel J. Hopkins and Gary King</cite> 

More generally the two disciplines differ in a variety of aspects:

* **Object of Study:** pretty much anything for Computer Science and social processes for Social Science; 
* **Driving Force:** Computer Scientists are motivated by data and methods, while Social Scientists are concerned with questions; 
* **Data:** big and digital for Computer Science but relatively small and generally not digitised for Social Science; and 
* **Research Goal:** Computer Scientists aim at prediction while Social Scientists strive for explanation.

The distinct research goals are important. Explanation implies causality. The causal mechanisms should arise from the underlying theory. Data can then be used to test hypotheses based on the theory. Models derived from the data need to be interpreted within the framework of the theory and should thus only include variables which are in the theory. Prediction, on the other hand, doesn't care about causality and there is no need for interpretation. Consequently predictive models can include any relevant variables.

### Bayesian Latent Variable Models

Latent variable models again. Based on what I had learned from the previous tutorial I was feeling a little more confident about these. The values of the latent variables are inferred from the observables in an iterative fashion.

Hanna made reference to [Getting It Right: Joint Distribution Tests of Posterior Simulators](http://www.jstor.org/stable/27590449) which provides a robust approach to simulating points from a posterior distribution.

It's a pity that this talk was in the last session. Attendance was not what it should have been. It's also a pity that Hanna was so reliant on her notes. Otherwise her talk was great!

Unfortunately the slides for this talk do not seem to be available.

## Cocktail Party

Well organised Cocktail Party to end the first day. One beer. A dozen canapés. Zero social interactions (unless you count waiters). I suppose that I am more sociable in my mind than in real life.
