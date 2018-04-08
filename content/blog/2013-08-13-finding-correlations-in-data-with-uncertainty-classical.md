---
author: Andrew B. Collier
date: 2013-08-13T13:40:27Z
tags: ["R"]
title: 'Finding Correlations in Data with Uncertainty: Classical Solution'
---

Following up on my [previous post](http://www.exegetic.biz/blog/2013/08/finding-correlations-in-data-with-uncertainty-bootstrap/) as a result of an excellent suggestion from Andrej Spiess. The data are indeed very [heteroscedastic](http://en.wikipedia.org/wiki/Heteroscedasticity)! Andrej suggested that an alternative way to attack this problem would be to use weighted correlation with weights being the inverse of the measurement variance.

<!--more-->

Let's look at the synthetic data first.

{{< highlight r >}}
> library(weights)
> 
> wtd.cor(synthetic$mu.x, synthetic$mu.y, weight = 1 / synthetic$sigma.y**2)
      correlation    std.err  t.value    p.value
V1.V1   0.1945633 0.09908485 1.963603 0.05240988
{{< /highlight >}}

This is in excellent agreement with the bootstrap results. Now the original experimental data.

{{< highlight r >}}
> wtd.cor(original$mu.x, original$mu.y, weight = 1 / original$sigma.y**2)
      correlation    std.err  t.value      p.value
V1.V1   0.2407686 0.04606181 5.227076 2.656016e-07
{{< /highlight >}}

Here the agreement with the bootstrap result is not as good. I'm not quite sure why, but suspect that it might have something to do with the fact that the original data are quite severely skewed so that assumptions about normality would probably be voilated.
