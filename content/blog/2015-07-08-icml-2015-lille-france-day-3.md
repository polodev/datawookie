---
author: Andrew B. Collier
date: 2015-07-08T16:42:10Z
tags: ["Conference"]
title: 'ICML 2015 (Lille, France): Day 3'
---

Selected scribblings from the third day at the International Conference for Machine Learning (ICML 2015) in Lille, France. I'm going out on a limb with some of this, since the more talks I attend, the more acutely aware I become of my limited knowledge of the cutting edge of Machine Learning. Caveat emptor.

## Adaptive Belief Propagation (Georgios Papachristoudis, John Fisher)

Belief Propagation describes the passage of messages across a network. The focus of this talk was Belief Propagation within a tree. The authors consider an adaptive algorithm and found that their technique, AdaMP, was significantly better than the current state of the art algorithm, [RCTreeBP](http://www.jmlr.org/papers/v12/sumer11a.html).

## The Hedge Algorithm on a Continuum (Walid Krichene, Maximilian Balandat, Claire Tomlin, Alexandre Bayen)

The content of this talk went a little over my head. I did learn something about [regret](https://en.wikipedia.org/wiki/Regret_(decision_theory)) though, which in the context of decision theory quantifies the negative impact of finding out that a different action would have led to a preferable result. The importance of this concept is that a regret averse individual might anticipate the potential for future regret and factor this into their decision making process.

## Deep Edge-Aware Filters (Li Xu, Jimmy Ren, Qiong Yan, Renjie Liao, Jiaya Jia)

Applications: image enhancement, tone mapping (HDR). Much previous research has focused on accelerating various filters, for example, the [bilateral filter](https://en.wikipedia.org/wiki/Bilateral_filter). However, only after a decade of work has a real time implementation of the bilateral filter been developed.

New filtering techniques are being developed all the time. However, existing acceleration techniques do not necessarily generalise to these new techniques. The authors proposed a uniform framework for accelerating filters with the following benefits:

1. optimise for one but apply to all; 
2. implementation can be achieved in hardware.

They set out to generate a system which would learn how to achieve the effects of one or more (combined) filters. Learning in the colour domain does not work well because edges are not captured effectively. Optimising in the gradient domain works better though. Learning is done in the gradient domain using a Convolutional Neural Network (CNN), so that the original image needs to be reconstructed from the results of the model.

One of the major benefits of the technique is that it can learn composite filters. So, rather than applying filters A, B and C, the network will learn the results of the combined filters and then be able to generate the composite effect. Furthermore, it does this quickly, with up to 200 times acceleration.

More information on this work can be found at <http://www.lxu.me/projects/deepeaf>. As a photographer who has played around with filters quite extensively, this is very exciting research!

## DRAW: A Recurrent Neural Network For Image Generation (Karol Gregor, Ivo Danihelka, Alex Graves, Danilo Rezende, Daan Wierstra)

The DRAW system analyses an image progressively, breaking it down into parts and then analysing each part in sequence. But it does more than that. It "imagines" new images, effectively generating novel image content. The constructed image initially starts out as fairly blurred, but it becomes sharper as the system works on it.
                
<img src="/img/2015/07/DRAW-numbers.png" width="100%">

## Show, Attend and Tell: Neural Image Caption Generation with Visual Attention (Kelvin Xu, Jimmy Ba, Ryan Kiros, Kyunghyun Cho, Aaron Courville, Ruslan Salakhudinov, Rich Zemel, Yoshua Bengio)

Objective: image caption generation. Human vision is foveated (spatial focus) and sequential (temporal dynamics). The parsing of an image can also depend on the task at hand (what information the observer is trying to derive from the image).

The authors describe a technique in which the image is segmented and a neural network is used to model the way that an observer's attention would traverse the image. A CNN is then used to extract feature vectors from parts of the image and these are used to generate words which are aggregated to form a caption.

The system generally produces appropriate captions. When it fails to produce a reasonable caption it is readily obvious why it has failed. Some of the failures are pretty amusing.

The model can be "forced" by specifying words that should appear in the caption. The system then attempts to generate a reasonable caption incorporating these words.

Code for this project is available at <https://github.com/kelvinxu/arctic-captions>. Kelvin also mentioned the [Microsoft COCO](http://mscoco.org/) project.

## Online Tracking by Learning Discriminative Saliency Map with Convolutional Neural Network (Seunghoon Hong, Tackgeun You, Suha Kwak, Bohyung Han)

Visual tracking aims to target a subject across successive frames in a video. Authors used a CNN to extract features of the subject from the image. An Incremental SVM was used to identify these features in a new image.

## Learning Treatment Policies in Mobile Health (Susan Murphy)

Two objectives of mobile health programmes are monitoring of subjects and also giving them feedback. Two projects were discussed:

1. Smoking Cessation Health; and 
2. Heartsteps Activity Coach (for heart attack patients).

Subjects are asked to wear chest or wrist bands to monitor their activity. Their smartphones also act as monitoring devices and give push feedback to the subjects. Both of these are a little invasive, so one of the challenges is to ensure that the subjects continue with the programme.

Two types of decision times: regular intervals (where tempo might vary according to what is being observed) and at subject demand.

The system takes into account the availability of the subjects for interventions. For example, if the subject is driving or walking, then no push messages will be sent to the subject. When messages are sent, the logical question is: did the intervention have the required result? To answer this question the first step is to gather data. To get truly robust data it's necessary to make observations within the framework of a randomised clinical trial.

A Stochastic Treatment Policy can be used to retard the habituation rate of subjects.

## Finding Galaxies in the Shadows of Quasars with Gaussian Processes (Roman Garnett, Shirley Ho, Jeff Schneider)

The authors describe a project which used spectral data from a large catalog of Quasars to build a Gaussian Process model for Quasar emission spectra. This model was then used to detect evidence of galaxies lying between the Quasars and Earth. Such galaxies would result in absorption of the light emitted by the Quasars (the authors were specifically looking at absorption of light associated with the Lyman-α line of atomic Hydrogen). Data used in this project can be found at <http://www.sdss.org/>.

## Second Poster Session

The day ended with another well catered poster session. Apparently Microsoft is hosting a little shindig later this evening too.
