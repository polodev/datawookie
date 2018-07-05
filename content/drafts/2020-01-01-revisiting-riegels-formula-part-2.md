---
draft: true
title: "Revisiting Riegel's Formula: II. Using Data from Racently"
author: Andrew B. Collier
layout: post
categories:
  - Running
  - Statistics
---

The values of $$a$$ span an unreasonable range and we have $$k < 0$$ too!

<img src="{{ site.baseurl }}/static/img/2017/03/riegel-k-a-naive.png">

<img src="{{ site.baseurl }}/static/img/2017/03/riegel-fit-poor.png">

The fit for these data is not particularly good:

{% highlight r %}
Call:
lm(formula = log(mins) ~ log(km), data = df)

Residuals:
   7470    7471    7472    7473    7474    7475 
 0.1396  0.0280 -0.1142 -0.1406  0.0452  0.0421 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)   
(Intercept)    4.526      0.629    7.19    0.002 **
log(km)        0.206      0.171    1.20    0.295   
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.119 on 4 degrees of freedom
Multiple R-squared:  0.266, Adjusted R-squared:  0.0829 
F-statistic: 1.45 on 1 and 4 DF,  p-value: 0.295
{% endhighlight %}

If we demand that both intercept and coefficient in each model are significant at the 1% then things look much more reasonable.

<img src="{{ site.baseurl }}/static/img/2017/03/riegel-k-a-significant.png">