---
draft: true
title: "Revisiting Riegel's Formula: I. Review of Some Previous Work"
author: Andrew B. Collier
layout: post
categories:
  - Running
  - Statistics
---

Riegel's formula is a simple expression for predicting a race time at a particular distance given a previously observed race time over another distance. The formula was originally published by [Peter Riegel](https://en.wikipedia.org/wiki/Peter_Riegel) in <a href="#riegel_1977">[1]</a>.

## The Formula

Riegel's formula can be expressed as

$$ \frac{t_2}{t_1} = \left( \frac{d_2}{d_1} \right)^\beta $$

where

- $$d_1$$ is a distance for which a time is known,
- $$t_1$$ is the time achieved for $$d_1$$,
- $$d_2$$ is the distance for which the time is to be predicted and
- $$t_2$$ is the predicted time for distance $$d_2$$.

Riegel's data supported a value of $$\beta = 1.06$$ for the [power law](https://en.wikipedia.org/wiki/Power_law) exponent. Since $$\beta > 1$$ the predicted average pace gradually slows down as the distance increases. For example, doubling the distance (say going from 21.1 km to 42.2 km) results in a factor 2.0849 projected increase in time, which is 4.2% longer than what would be expected if the same average pace was applied to both distances.

### Example

Suppose that you recently ran 10.0 km in 50 minutes. What would be your predicted time for a marathon?

$$ 50 \text{ min} \times \left( \frac{42.2}{10.0} \right)^{1.06} = 230 \text{ min}$$

If you also ran 01:55 for a half marathon a short time ago, then you could provide an independent prediction.

$$ 115 \text{ min} \times \left( \frac{42.2}{21.1} \right)^{1.06} \approx 240 \text{ min}$$

Based on these projections you could be fairly confident of finishing the marathon in 03:50 to 04:00, with the average prediction being 03:55.

## Dimensional Analysis

TALK ABOUT FACT THAT RAISING km TO NON-INTEGER POWER. AND x SHOULD BE NORMALISED TO 1 KM.

## The Endurance Equation

The formula above expresses performance over one distance in terms of performance over another distance. However the form of this relationship implies that you can write

$$ t = \alpha d^\beta $$

which Riegel called the <em>Endurance Equation</em> in <a href="#riegel_1981">[2]</a>. The choice of a power law to represent the data was "a good compromise between accuracy and simplicity". A more sophisticated model might have provided a better fit to the data, but it would probably not have been as easy to calculate.

Taking logarithms of both sides of the Endurance Equation gives

$$ \log t = \log \alpha + \beta \log d $$

which implies that there is a simple linear relationship between $$\log t$$ and $$\log d$$. Riegel noticed that a log-log plot of time versus distance for elite runners over distances from the mile to the marathon was approximated well by a straight line. He also found that this clear relationship broke down for race times of less than around 4 minutes or more than 230 minutes.

## Generalising Riegel's Formula

<img src="{{ site.baseurl }}/static/img/2017/03/riegel-figure-1.png" align="center">

From the Endurance Equation it's possible to calculate the average pace over a particular distance as

$$ v = \frac{d^{1 - \beta}}{\alpha}. $$

If $$\beta > 1$$ (which was the case for the value derived by Riegel) then the exponent of $$d$$ is negative and this relationship implies that average pace decreases with race distance, which is consistent with intuition. The exponent, $$\beta$$, is thus known as the *fatigue factor* since it describes the effect that increasing distance has on average pace.

The plot below (from [2]) shows how observed average pace decreases for greater distances across a variety of disciplines and that the relationship is well described by a power law.

<img src="{{ site.baseurl }}/static/img/2017/03/riegel-figure-2.png" align="center">

<img src="{{ site.baseurl }}/static/img/2017/03/riegel-figure-3.png">

Note that Riegel used $$b$$ to denote the exponent whereas we are using $$\beta$$.

<img src="{{ site.baseurl }}/static/img/2017/03/riegel-table-1.png">

The values of the parameters in the table above are derived from measurements of $$t$$ in minutes and $$d$$ in km. So, for example, the endurance formula makes the follow prediction for elite men over the marathon distance:

$$ t = 2.299\text{ min} \times 42.2^{1.07732} \approx 129.6\text{ min}. $$

<img src="{{ site.baseurl }}/static/img/2017/03/riegel-table-2.png">

## Potential Problems with Riegel's Formula

Riegel used race results from elite athletes to obtain values for the parameters in his model. Will the same relationship produce reasonable results for the average runner?

Riegel notes that the use of data for world class athletes implies that his results impose a "near-absolute standard for human performance".

## Other Work

["Prediction and Quantification of Individual Athletic Performance of Runners"](http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0157257)

["An empirical study of race times in recreational endurance runners"](https://bmcsportsscimedrehabil.biomedcentral.com/articles/10.1186/s13102-016-0052-y)

["Models for comparing athletic performances"](http://onlinelibrary.wiley.com/doi/10.1111/1467-9884.00151/abstract)

### References

<span id="riegel_1977">[1]</span> Riegel, Peter S. (1977). <em>Time Predicting</em>. Runner’s World.<br>
<span id="riegel_1981">[2]</span> Riegel, Peter S. (1981). <em>Athletic Records and Human Endurance</em>. American Scientist, 69(3), 285–290.