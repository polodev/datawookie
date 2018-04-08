---
author: Andrew B. Collier
date: 2014-07-22T17:11:49Z
tags: ["R", "Running"]
title: 'Comrades Marathon: A Race for Geriatrics?'
---

It has been suggested that the average Comrades Marathon runner is gradually getting older. As an "average runner" myself, I will not deny that I am personally getting older. But, what I really mean is that the average age of _all_ runners taking part in this great event is gradually increasing. This is not just an idle hypothesis: it is supported by the data. If you're interested in the technical details of the analysis, these are included [at the end](#analysis), otherwise read on for the results.

<!--more-->

## Results {#results}

The histograms below show graphically how the distribution of runners' ages at the Comrades Marathon has changed every decade starting in the 1980s and proceeding through to the 2010s. The data are encoded using blue for male and pink for female runners (apologies for the banality!). It is readily apparent how the distributions have shifted consistently towards older ages with the passing of the decades. The vertical lines in each panel indicate the average age for male (dashed line) and female (solid line) runners. Whereas in the 1980s the average age for both genders was around 34, in the 2010s it has shifted to over 40 for females and almost 42 for males.

<img src="/img/2014/07/age-decade-histogram.png">

Maybe clumping the data together into decades is hiding some of the details. The plot below shows the average age for each gender as a function of the race year. The plotted points are the observed average age, the solid line is a linear model fitted to these data and the dashed lines delineate a 95% confidence interval.

Prior to 1990 the average age for both genders was around 35 and varies somewhat erratically from year to year. Interestingly there is a pronounced decrease in the average age for both genders around 1990. Evidently something attracted more young runners that year... Since 1990 though there has been a consistent increase in average age. In 2013 the average age for men was fractionally less than 42, while for women it was over 40.

<img src="/img/2014/07/mean-age-year-regression.png">

## Conclusion

Of course, the title of this article is hyperbolic. The Comrades Marathon is a long way from being a race for geriatrics. However, there is very clear evidence that the average age of runners is getting higher every year. A linear model, which is a reasonably good fit to the data, indicates that the average age increases by 0.26 years annually and is generally 0.6 years higher for men than women. If this trend continues then, by the time of the 100th edition of the race, the average age will be almost 45.

Is the aging Comrades Marathon field a problem and, if so, what can be done about it?

## Analysis {#analysis}

As before I have used the Comrades Marathon results from 1980 through to 2013. Since my [last post on this topic](http://www.exegetic.biz/blog/2014/06/twins-tripods-and-phantoms-at-the-comrades-marathon/) I have refactored these data, which now look like this:

{{< highlight r >}}
> head(results)
       key year age gender category   status  medal direction medal_count decade
1  6a18da7 1980  39   Male   Senior Finished Bronze         D          20   1980
2   6570be 1980  39   Male   Senior Finished Bronze         D          16   1980
3 4371bd17 1980  29   Male   Senior Finished Bronze         D           9   1980
4 58792c25 1980  24   Male   Senior Finished Silver         D          25   1980
5 16fe5d63 1980  58   Male   Master Finished Bronze         D           9   1980
6 541c273e 1980  43   Male  Veteran Finished Silver         D          18   1980
{{< /highlight >}}

The first step in the analysis was to compile decadal and annual summary statistics using plyr.

{{< highlight r >}}
> decade.statistics = ddply(results, .(decade, gender), summarize,
+                           median.age = median(age, na.rm = TRUE),
+                           mean.age = mean(age, na.rm = TRUE))
> #
> year.statistics = ddply(results, .(year, gender), summarize,
+                           median.age = median(age, na.rm = TRUE),
+                           mean.age = mean(age, na.rm = TRUE))
> head(decade.statistics)
  decade gender median.age mean.age
1   1980 Female         34   34.352
2   1980   Male         34   34.937
3   1990 Female         36   36.188
4   1990   Male         36   36.440
5   2000 Female         39   39.364
6   2000   Male         39   39.799
> head(year.statistics)
  year gender median.age mean.age
1 1980 Female       35.0   35.061
2 1980   Male       33.0   34.091
3 1981 Female       33.5   34.096
4 1981   Male       34.0   34.528
5 1982 Female       34.5   35.032
6 1982   Male       34.0   34.729
{{< /highlight >}}

The decadal data were used to generate the histograms. I then considered a selection of linear models applied to the annual data.

{{< highlight r >}}
> fit.1 <- lm(mean.age ~ year, data = year.statistics)
> fit.2 <- lm(mean.age ~ year + year:gender, data = year.statistics)
> fit.3 <- lm(mean.age ~ year + gender, data = year.statistics)
> fit.4 <- lm(mean.age ~ year + year * gender, data = year.statistics)
{{< /highlight >}}

The first model applies a simple linear relationship between average age and year. There is no discrimination between genders. The model summary (below) indicates that the average age increases by about 0.26 years annually. Both the intercept and slope coefficients are highly significant.

{{< highlight r >}}
> summary(fit.1)

Call:
lm(formula = mean.age ~ year, data = year.statistics)

Residuals:
    Min      1Q  Median      3Q     Max 
-1.3181 -0.5322 -0.0118  0.4971  1.9897 

Coefficients:
             Estimate Std. Error t value Pr(>|t|)    
(Intercept) -4.80e+02   1.83e+01   -26.2   <2e-16 ***
year         2.59e-01   9.15e-03    28.3   <2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.74 on 66 degrees of freedom
Multiple R-squared:  0.924,	Adjusted R-squared:  0.923 
F-statistic:  801 on 1 and 66 DF,  p-value: <2e-16
{{< /highlight >}}

The second model considers the effect on the slope of an interaction between year and gender. Here we see that the slope is slightly large for males than females. Although this interaction coefficient is statistically significant, it is extremely small relative to the slope coefficient itself. However, given that the value of the abscissa is around 2000, it still contributes roughly 0.6 extra years to the average age for men.

{{< highlight r >}}
> summary(fit.2)

Call:
lm(formula = mean.age ~ year + year:gender, data = year.statistics)

Residuals:
   Min     1Q Median     3Q    Max 
-1.103 -0.522  0.024  0.388  2.287 

Coefficients:
                 Estimate Std. Error t value Pr(>|t|)    
(Intercept)     -4.80e+02   1.68e+01  -28.57  < 2e-16 ***
year             2.59e-01   8.41e-03   30.78  < 2e-16 ***
year:genderMale  3.00e-04   8.26e-05    3.63  0.00056 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.68 on 65 degrees of freedom
Multiple R-squared:  0.937,	Adjusted R-squared:  0.935 
F-statistic:  481 on 2 and 65 DF,  p-value: <2e-16
{{< /highlight >}}

The third model considers an offset on the intercept based on gender. Here, again, we see that the effect of gender is small, with the fit for males being shifted slightly upwards. Again, although this effect is statistically significant, it has only a small effect on the model. Note that the value of this coefficient (5.98e-01 years) is consistent with the effect of the interaction term (0.6 years for typical values of the abscissa) in the second model above.

{{< highlight r >}}
> summary(fit.3)

Call:
lm(formula = mean.age ~ year + gender, data = year.statistics)

Residuals:
    Min      1Q  Median      3Q     Max 
-1.1038 -0.5225  0.0259  0.3866  2.2885 

Coefficients:
             Estimate Std. Error t value Pr(>|t|)    
(Intercept) -4.80e+02   1.68e+01  -28.58  < 2e-16 ***
year         2.59e-01   8.41e-03   30.79  < 2e-16 ***
genderMale   5.98e-01   1.65e-01    3.62  0.00057 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.68 on 65 degrees of freedom
Multiple R-squared:  0.937,	Adjusted R-squared:  0.935 
F-statistic:  480 on 2 and 65 DF,  p-value: <2e-16
{{< /highlight >}}

The fourth and final model considers both an interaction between year and gender as well as an offset of the intercept based on gender. Here we see that the data does not differ sufficiently on the basis of gender to support both of these effects, and neither of the resulting coefficients is statistically significant.

{{< highlight r >}}
> summary(fit.4)

Call:
lm(formula = mean.age ~ year + year * gender, data = year.statistics)

Residuals:
    Min      1Q  Median      3Q     Max 
-1.0730 -0.5127 -0.0492  0.4225  2.1273 

Coefficients:
                 Estimate Std. Error t value Pr(>|t|)    
(Intercept)     -460.3631    23.6813  -19.44   <2e-16 ***
year               0.2491     0.0119   21.00   <2e-16 ***
genderMale       -38.4188    33.4904   -1.15     0.26    
year:genderMale    0.0195     0.0168    1.17     0.25    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.679 on 64 degrees of freedom
Multiple R-squared:  0.938,	Adjusted R-squared:  0.935 
F-statistic:  322 on 3 and 64 DF,  p-value: <2e-16
{{< /highlight >}}

On the basis of the above discussion, the fourth model can be immediately abandoned. But how do we choose between the three remaining models? An ANOVA indicates that the second model is a significant improvement over the first model. There is little to choose, however, between the second and third models. I find the second model more intuitive, since I would expect there to be a slight gender difference in the rate of aging, rather than a simple offset. We will thus adopt the second model, which indicates that the average age of runners increases by about 0.259 years annually, with the men aging slightly faster than the women.

{{< highlight r >}}
> anova(fit.1, fit.2, fit.3, fit.4)
Analysis of Variance Table

Model 1: mean.age ~ year
Model 2: mean.age ~ year + year:gender
Model 3: mean.age ~ year + gender
Model 4: mean.age ~ year + year * gender
  Res.Df  RSS Df Sum of Sq     F  Pr(>F)    
1     66 36.2                               
2     65 30.1  1      6.09 13.23 0.00055 ***
3     65 30.1  0     -0.02                  
4     64 29.5  1      0.62  1.36 0.24833    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
{{< /highlight >}}

Lastly, I constructed a data frame based on the second model which gives both the model prediction and a 95% uncertainty interval. This was used to generate the second set of plots.

{{< highlight r >}}
fit.data <- data.frame(year = rep(1980:2020, each = 2), gender = c("Female", "Male"))
fit.data <- cbind(fit.data, predict(fit.2, fit.data, level = 0.95, interval = "prediction"))
{{< /highlight >}}
