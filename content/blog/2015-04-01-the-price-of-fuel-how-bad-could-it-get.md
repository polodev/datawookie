---
author: Andrew B. Collier
date: 2015-04-01T09:00:03Z
tags: ["R"]
title: 'The Price of Fuel: How Bad Could It Get?'
---

The cost of fuel in South Africa (and I imagine pretty much everywhere else) is a contentious topic. It varies from month to month and, although it is clearly related to the price of crude oil and the exchange rate, various other forces play an influential role.

<!--more-->

According to the [Department of Energy](http://www.energy.gov.za/files/petroleum_frame.html) the majority of South Africa's fuel is refined from imported crude oil. The rest is synthetic fuel produced locally from coal and natural gas. The largest expense for a fuel refinery is for raw materials. So little wonder that the cost of fuel should be intimately linked to the price of crude oil. The price of crude oil on the international market is quoted in US Dollars (USD) per barrel, so that the exchange rate between the South African Rand and the US Dollar (ZAR/USD) also exerts a strong influence on the South African fuel price.

I am going to adopt a simplistic model in which I'll assume that the price of South African fuel depends on only those two factors: crude oil price and the ZAR/USD exchange rate. We'll look at each of them individually before building the model.

## Exchange Rate

The Rand reached a weak point against the USD in January 2002 when $1 cost around R11.70. After that it recovered and was relatively strong in 2005. However, since then it has been systematically weakening (with the exception of some brief intervals of recovery). At present (end of March 2015) you will pay around R12 for $1.

I guess this is part of the reason why new running shoes are so damn expensive.

<img src="/img/2015/03/date-delta-ZARUSD.png">

## Crude Oil Price

Crude oil has been getting progressively more expensive. The price of around $25 per barrel in 2000 escalated to a peak of roughly $135 per barrel in August 2008. This was followed by a massive decrease in price, bringing it down to only approximately $40 per barrel at the beginning of 2009. We have recently seen a similar dramatic decrease in the crude oil price (unfortunately, not as dramatic as the one in 2008).

<img src="/img/2015/03/date-delta-crude-oil.png">

## Fuel Price

Back in 2000 you could get a litre of fuel in South Africa for around R3. Those were halcyon days. Since then the cost of fuel has been steadily increasing, with the exception of a sharp spike in 2008 and the recent decline starting towards the end of 2014.

<img src="/img/2015/03/diesel-petrol-time.png">

## Building Simple Models

If you're not interested in the technical details of the model building process, feel free to [skip forward to the results](#results).

There is a clear linear relationship between the fuel price and the price of crude oil (plot on the left below, with Diesel in blue and Petrol in red). A power law relationship actually gives a tighter fit (see log-log plot on the right below). However, in the interests of simplicity we'll stick to linear relationships.

<img src="/img/2015/03/diesel-petrol-crude-oil.png">

We'll put together three simple (and probably naive) linear models for the fuel price:

* an additive linear model depending on exchange rate and crude oil price; 
* the same model but including the [interaction](http://en.wikipedia.org/wiki/Interaction_(statistics)) between exchange rate and crude oil price; and 
* a model depending only on the above interaction.

The first model assumes that the influences of exchange rate and crude oil price are independent. A moment's thought reveals that this cannot be a particularly good model, since the effects of these two quantities must be inextricably linked. However, as we will see, the model provides a relatively good fit to the data, but probably will not extrapolate effectively.

{{< highlight r >}}
> fit.1 <- lm(ULP_Inland_95 ~ DollarPerBarrel + ZARUSD, data = fuel.data)
> summary(fit.1)

Call:
lm(formula = ULP_Inland_95 ~ DollarPerBarrel + ZARUSD, data = fuel.data)

Residuals:
    Min      1Q  Median      3Q     Max 
-2.1686 -0.2130  0.1724  0.4877  1.1874 

Coefficients:
                 Estimate Std. Error t value Pr(>|t|)    
(Intercept)     -6.210351   0.446422  -13.91   <2e-16 ***
DollarPerBarrel  0.075478   0.003091   24.42   <2e-16 ***
ZARUSD           1.093711   0.051210   21.36   <2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.7103 on 105 degrees of freedom
  (72 observations deleted due to missingness)
Multiple R-squared:  0.9305,    Adjusted R-squared:  0.9292 
F-statistic: 702.9 on 2 and 105 DF,  p-value: < 2.2e-16

> AIC(fit.1)
[1] 237.5634
{{< /highlight >}}

The second model considers both the independent (additive) effects of exchange rate and crude oil price as well as their joint (multiplicative) effect. The p-values in the summary output below indicate that only the multiplicative term is statistically significant. This provides a motivation for the third model.

{{< highlight r >}}
> fit.2 <- lm(ULP_Inland_95 ~ DollarPerBarrel * ZARUSD, data = fuel.data)
> summary(fit.2)

Call:
lm(formula = ULP_Inland_95 ~ DollarPerBarrel * ZARUSD, data = fuel.data)

Residuals:
    Min      1Q  Median      3Q     Max 
-2.2018 -0.3598  0.1219  0.4863  1.0814 

Coefficients:
                        Estimate Std. Error t value Pr(>|t|)    
(Intercept)             2.285115   1.599475   1.429    0.156    
DollarPerBarrel        -0.019958   0.017625  -1.132    0.260    
ZARUSD                  0.050663   0.195616   0.259    0.796    
DollarPerBarrel:ZARUSD  0.011591   0.002115   5.481 2.97e-07 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.6287 on 104 degrees of freedom
  (72 observations deleted due to missingness)
Multiple R-squared:  0.9461,    Adjusted R-squared:  0.9445 
F-statistic: 608.3 on 3 and 104 DF,  p-value: < 2.2e-16

> AIC(fit.2)
[1] 212.1551
{{< /highlight >}}

The third and final model uses only the interaction between exchange rate and crude oil price. The summary output below indicates that for this model the coefficients associated with both the intercept and interaction terms are significant.

{{< highlight r >}}
> fit.3 <- lm(ULP_Inland_95 ~ DollarPerBarrel:ZARUSD, data = fuel.data)
> summary(fit.3)

Call:
lm(formula = ULP_Inland_95 ~ DollarPerBarrel:ZARUSD, data = fuel.data)

Residuals:
     Min       1Q   Median       3Q      Max 
-2.06270 -0.27476  0.08142  0.44747  1.35974 

Coefficients:
                        Estimate Std. Error t value Pr(>|t|)    
(Intercept)            1.9443004  0.2043706   9.514 6.98e-16 ***
DollarPerBarrel:ZARUSD 0.0102018  0.0002601  39.224  < 2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.6808 on 106 degrees of freedom
  (72 observations deleted due to missingness)
Multiple R-squared:  0.9355,    Adjusted R-squared:  0.9349 
F-statistic:  1539 on 1 and 106 DF,  p-value: < 2.2e-16

> AIC(fit.3)
[1] 227.4323
{{< /highlight >}}

Based on standard metrics all three of these models are reasonable approximations to the data. The principle of parsimony suggests that of Models 2 and 3 the latter should be preferred (especially in light of the fact that the coefficients for the extra terms in Model 2 are not significant).

The [quantile-quantile plots](http://en.wikipedia.org/wiki/Q%E2%80%93Q_plot) for the standardised residuals of the three models are given below. Both Model 1 and Model 2 have residuals which are skewed to the left. The distribution of residuals for Model 3 is close to normal but with heavy tails (large kurtosis).

<img src="/img/2015/03/model-residuals-quantile.png" width="100%">

The next set of plots show the relative errors for Models 2 and 3. For Model 3 there is a gradient from negative errors in the top left corner of the plot to positive errors in the bottom right corner. This indicates that Model 3 is systematically failing to capture some of the underlying variation in the data. The relative error for Model 2 does not display a similar pattern.

<img src="/img/2015/03/model-relative-error-scatter.png" width="100%">

So, despite the simplicity of Model 3, Model 2 provides a better description of the data. The pattern of relative errors for Model 1 is similar to that for Model 2.

## Model Projections {#results}

So what do these models tell us?

The plots below show the predictions based on Models 1 and 2. The points indicate the data used to derive the models. The dashed lines denote contours of constant fuel price. The linear and hyperbolic shapes of the contours reflect the form of the underlying models.

It's dangerous to extrapolate too far beyond the domain covered by your data. However, the general trend of both models is obvious: increases in either the crude oil price or the ZAR/USD exchange rate will result in higher fuel costs. Let's consider some individual test cases. Suppose the price of crude oil remained around 60 USD per barrel but the ZAR/USD exchange rate went up to R15 per $1. In this case Model 1 predicts that the fuel price would reach R14.70 per litre, while Model 2 predicts R13.45 per litre. We've been in this regime before and it wasn't pleasant! Another scenario to consider would be the ZAR/USD exchange rate staying at around R12 per $1 but the price of crude oil going up to 160 USD per barrel. In this case Model 1 predicts that the fuel price would reach R19.00 per litre, while Model 2 predicts R21.10 per litre. Either of those is rather daunting. Finally, what would happen if the price of crude oil went up to 160 USD per barrel and the ZAR/USD exchange rate hit 15? Under these conditions Model 1 predicts R22.30 per litre, while Model 2 gives R26.20 per litre. Those are both pretty appalling!

<img src="/img/2015/03/model-predictions.png" width="100%">

## Conclusions

These models only consider the effects of the international price of crude oil and exchange rates. Effects like the fuel price increases in March and April 2015, which were based on [budgetary decisions](http://www.timeslive.co.za/thetimes/2015/02/25/sharp-increase-in-fuel-taxes-budget2015), are of course not accounted for. Predictions should thus be treated with a healthy dose of skepticism. But as a general guide to the possible fuel prices we could expect in the future, it's quite illuminating. And not a little bit scary.
