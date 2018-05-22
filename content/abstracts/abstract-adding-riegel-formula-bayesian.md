---
title: "Revising Riegel's Formula: A Bayesian Approach"
date: 2017-09-13T09:30:00+00:00
author: Andrew B. Collier
---

<!--
	https://www.theguardian.com/lifeandstyle/the-running-blog/2017/mar/28/the-formula-for-marathon-success

	Bayesian model: See "Statistical Rethinking" for how pooling would work. But basically the idea would be to use all of the athletes to generate pooled estimate of a reference pace (say over 10 km) and then look at how this would vary with distance and age.
-->
<div class="talk">
	<div class="title">
	Revising Riegel's Formula: A Bayesian Approach
	</div>
	<div class="abstract">
Riegel's Formula, published in 1977, is a simple method for predicting running times over different distances. Despite the limited data used to derive this formula, it has proved remarkably accurate and is still commonly used today. However, with carefully curated data describing thousands of runners over hundreds of races, it's possible to create a much more robust model. With such an abundance of data, it's also possible to exploit more elaborate statistical machinery.

The following approaches are investigated:

- a single linear model with interactions;
- a horde of independent linear models; and
- a Bayesian model pooling information among runners.

These analyses show that, in addition to the effect of varying distances, it's also possible to infer the influence of aging on race times.

Packages used: [dplyr](http://dplyr.tidyverse.org/), [tidyr](http://tidyr.tidyverse.org/), [rstan](http://mc-stan.org/users/interfaces/rstan).
	</div>
</div>
