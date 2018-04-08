---
author: Andrew B. Collier
date: 2013-07-29T07:29:17Z
title: Modelling the Age of the Oldest Person You Know
---

The blog post [How old is the oldest person you know?](http://freakonometrics.hypotheses.org/7079)&nbsp;by Arthur Charpentier was inspired by Prudential's&nbsp;[stickers campaign](http://www.youtube.com/watch?v=axofdNHh9DQ)&nbsp;which asks you to record the age of the oldest person you know by placing a blue sticker on a number line. The result is a histogram of ages. The original experiment was carried out using 400 real stickers in a park in Austin.

<!--more-->

<img src="/img/2013/07/OldestPerson.jpg">

Arthur Charpentier showed that the campaign data could be modelled by a transformed [Weibull Distribution](http://en.wikipedia.org/wiki/Weibull_distribution), which is commonly used in extreme value theory. However, applying such a model treats everyone in the population as exactly the same. This is generally the approach adopted in standard statistics. However, we can probably do a lot better. It stands to reason that personal circumstances should have a significant influence over the age distribution of your acquaintances. A teenager, for example, is likely to know many other teenagers but far fewer elderly people. The elderly people who he does know are probably family. In contrast, an octogenarian is likely to know more elderly people than teenagers. And the elderly people that he knows are probably not family.

What we are attempting to do here is to build a better model using data which treats every sample as an individual. By gathering a little more data from each person, we will build a model which will provide a more robust prediction of the age of the oldest person you know.

To contribute to the model, please fill in this short [questionnaire](https://docs.google.com/forms/d/1Puwu5xXilYOwG_v4Va_1GnseQkGsvQFb4wN-uac17Ks/viewform).
