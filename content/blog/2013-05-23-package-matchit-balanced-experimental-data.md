---
author: Andrew B. Collier
date: 2013-05-23T15:08:47Z
tags: ["R"]
title: 'Package MatchIt: Balancing experimental data'
---

A balanced [experimental design](http://en.wikipedia.org/wiki/Design_of_experiments) is one in which the distribution of the covariates is the same in both the control and treatment groups. However, although achievable in an experimental scenario, for observational data this ideal is seldom attained. The MatchIt package provides a means of pre-processing data so that the treated and control groups are as similar as possible, minimising the dependence between the treatment variable and the other covariates.

<!--more-->

I will illustrate this with a simple (and somewhat contrived) example. Consider the following situation: a group of school children is being taught history. There are 150 children in the grade and they are split between two teachers, Claire and Jane. Jane has some revolutionary ideas about teaching and she claims that she is able to achieve better results than Claire. They set out to test this claim using a set of standardised questions. The results of the questions along with the gender and age of each of the children are recorded. Claire's husband loads the data into R and it looks like this:

{{< highlight r >}}
> summary(pupils)
 gender      age           teacher       grades
 F:69   Min.   : 9.006   Claire:90   Min.   :28.00
 M:81   1st Qu.: 9.451   Jane  :60   1st Qu.:49.00
        Median : 9.630               Median :59.50
        Mean   : 9.725               Mean   :59.29
        3rd Qu.: 9.942               3rd Qu.:70.00
        Max.   :11.878               Max.   :94.00
> with(pupils, table(teacher, gender))
        gender
teacher   F  M
  Claire 32 58
  Jane   37 23
> tapply(pupils$age, list(pupils$teacher, pupils$gender), median)
              F        M
Claire 9.539227  9.55096
Jane   9.961180 10.05199
{{< /highlight >}}

Claire is teaching 90 children, almost two thirds of which are boys. Jane is only teaching 60 children with almost the opposite gender ratio. The distribution of ages is reflected in the plot below. There is clearly a wider range of ages in the children taught by Jane and their median ages are higher than those taught by Claire.

<img src="/img/2013/05/age-gender.png">

The distribution of the aggregate result of the questions (expressed as a %) are given below. It appears that for both teachers the girls fare better than the boys.

<img src="/img/2013/05/grade-gender.png">

If we make a simple comparison of the average grade for children taught by Claire and Jane, then it seems like Jane might be onto something: her average is about 5% higher than Claire's.

{{< highlight r >}}
> tapply(pupils$grades, pupils$teacher, mean)
  Claire     Jane
57.17778 62.45000
{{< /highlight >}}

But that is not the full story: if we break down the averages by gender and teacher then the results are less convincing: boys do slightly better under Jane's regime, while girls do slightly worse.

{{< highlight r >}}
> tapply(pupils$grades, list(pupils$gender, pupils$teacher), mean)
    Claire     Jane
F 70.81250 69.27027
M 49.65517 51.47826
{{< /highlight >}}

Let's apply the tried and tested t-test to see if there is a significant difference between the average grades.

{{< highlight r >}}
> t.test(pupils$grades[pupils$teacher == "Claire"], pupils$grades[pupils$teacher == "Jane"])

	Welch Two Sample t-test

data:  pupils$grades[pupils$teacher == "Claire"] and pupils$grades[pupils$teacher == "Jane"]
t = -2.2626, df = 126.725, p-value = 0.02537
alternative hypothesis: true difference in means is not equal to 0
95 percent confidence interval:
 -9.8833660 -0.6610785
sample estimates:
mean of x mean of y
 57.17778  62.45000
{{< /highlight >}}

This indicates that the difference in the mean grade for children taught by Claire and Jane is significant at the 5% level (p-value = 0.02537). So perhaps Jane is right. However, contradictory performance of the two genders taken separately should cause us to think carefully about this result. Perhaps the fact that Jane is teaching a larger proportion of girls is having an effect? Or maybe the older children in Jane's class are skewing the statistics?

This is where MatchIt comes into play. First we add a dichotomous treatment variable, which is 1 for every child taught by Jane and 0 otherwise.

{{< highlight r >}}
pupils$treatment = ifelse(pupils$teacher == "Jane", 1, 0)
{{< /highlight >}}

The resulting data is then fed into the matching routine.

{{< highlight r >}}
> m = matchit(treatment ~ gender + age, data = pupils, method = "nearest")
> m

Call:
matchit(formula = treatment ~ gender + age, data = pupils, method = "nearest")

Sample sizes:
          Control Treated
All            90      60
Matched        60      60
Unmatched      30       0
Discarded       0       0
{{< /highlight >}}

We see that in the original (unmatched) data there were 90 records in the control (Claire) group and only 60 in the treated (Jane) group. After matching there are 60 records in each group. The remaining 30 records are unmatched. We then extract the matched records.

{{< highlight r >}}
> matched <- match.data(m)
>
> with(matched, table(teacher, gender))
        gender
teacher   F  M
  Claire 29 31
  Jane   37 23
> tapply(matched$age, list(matched$teacher, matched$gender), median)
              F         M
Claire 9.584322  9.672314
Jane   9.961180 10.051985
{{< /highlight >}}

The gender and age disparities between the control and treated group have not been removed but they are now much improved. What influence does this have on a comparison of the grades?

{{< highlight r >}}
> t.test(matched$grades[matched$teacher == "Claire"], matched$grades[matched$teacher == "Jane"])

	Welch Two Sample t-test

data:  matched$grades[matched$teacher == "Claire"] and matched$grades[matched$teacher == "Jane"]
t = -0.9127, df = 117.593, p-value = 0.3633
alternative hypothesis: true difference in means is not equal to 0
95 percent confidence interval:
 -7.607438  2.807438
sample estimates:
mean of x mean of y
    60.05     62.45
{{< /highlight >}}

The difference in average grade is no longer significant. So perhaps Jane has not really discovered anything revolutionary after all. The initial difference in results was probably due to the imbalance between the gender ratios in the control and treatment groups. Certainly the data indicate that there is a marked difference in performance between the girls and boys!

Finally, it seems to me that MatchIt is most effective when the control group is larger than the treatment group. This was the situation for the example above. If the converse applies then MatchIt does not appear to have much of an effect.

## Things That Might Go Wrong

There are some situations where things might not run quite so smoothly.

1. If you get an error message like this then it normally means that the output variable from your model is not dichotomous. You need to make it either a boolean or 0/1 variable.

{{< highlight r >}}
Error in weights.matrix(match.matrix, treat, discarded) : 
  No units were matched
In addition: Warning messages:
1: glm.fit: algorithm did not converge 
2: glm.fit: fitted probabilities numerically 0 or 1 occurred 
3: In max(pscore[treat == 0]) :
  no non-missing arguments to max; returning -Inf
4: In max(pscore[treat == 1]) :
  no non-missing arguments to max; returning -Inf
5: In min(pscore[treat == 0]) :
  no non-missing arguments to min; returning Inf
6: In min(pscore[treat == 1]) :
  no non-missing arguments to min; returning Inf
{{< /highlight >}}
  

