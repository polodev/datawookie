---
author: Andrew B. Collier
date: 2013-05-18T09:53:02Z
tags: ["R"]
title: 'Descriptive Statistics'
---

<!--more-->

In the [previous installment](http://www.exegetic.biz/blog/2013/05/introducing-r-categorical-variables/) we derived two new categorical variables for the National Health and Nutrition Examination Survey data. This time we will get some simple descriptive statistics from the data.

Firstly, let's start by looking at a summary of the entire data set. We can exclude the identifier field, since this has no real significance.

{{< highlight r >}}
> summary(DS0012[, c(-1, -7)])
 gender        age             mass            height           BMI             BMI.category
 M:4448   Min.   : 2.00   Min.   : 10.40   Min.   :0.815   Min.   :12.50   underweight:1759
 F:4413   1st Qu.:12.00   1st Qu.: 49.00   1st Qu.:1.503   1st Qu.:19.97   normal     :2589
          Median :33.00   Median : 68.70   Median :1.624   Median :25.16   overweight :2260
          Mean   :35.45   Mean   : 66.68   Mean   :1.561   Mean   :25.71   obese      :2253
          3rd Qu.:56.00   3rd Qu.: 85.20   3rd Qu.:1.717   3rd Qu.:30.08 
          Max.   :80.00   Max.   :218.20   Max.   :2.038   Max.   :73.43
{{< /highlight >}}

This gives the quantiles and mean for each of the numerical variables, and the counts for each of the categorical variables. The average age of the subjects is 35. The subjects have masses between 10.4 and 218.2 kg.

We could have extracted these statistics for each of the numerical variables individually.

{{< highlight r >}}
> mean(DS0012$BMI)
[1] 25.7057
> median(DS0012$BMI)
[1] 25.15504
> quantile(DS0012$BMI)
      0%      25%      50%      75%     100%
12.50312 19.97228 25.15504 30.08150 73.42526
{{< /highlight >}}

It gets a little painful to type out the variable name every time, but we can attach the DS0012 variable to R's search path, which makes things much more compact.

{{< highlight r >}}
> attach(DS0012)
> mean(BMI)
[1] 25.7057
{{< /highlight >}}

That's better. We can also get a table of counts for an individual categorical variable.

{{< highlight r >}}
> table(age.category)
age.category
   child teenager    adult   mature   senior
    2220      757     2105     1793     1986
{{< /highlight >}}

This is precisely the information that we got in the summary above: children make up the largest portion of the sample, followed by adults and then seniors. Teenagers are in the minority. What about generating a [contingency table](http://en.wikipedia.org/wiki/Contingency_table) which cross-tabulates two categorical variables?

{{< highlight r >}}
> table(age.category, BMI.category)
            BMI.category
age.category underweight normal overweight obese
    child           1537    519        117    47
    teenager         111    390        143   113
    adult             50    765        630   660
    mature            31    421        638   703
    senior            30 4   94        732   730
{{< /highlight >}}

Now that is interesting: it seems that the majority of children in the data are underweight. Should we be concerned? No, the interpretation of [BMI for children](http://en.wikipedia.org/wiki/Body_mass_index#BMI-for-age) is different: the nominal thresholds between each of the categories no longer apply and BMI is compared to typical values for children of similar age. Among teenagers and adults the majority of the sample have normal BMIs. However, even the overweight and obese categories for adults are already well populated. In the mature and senior portion of the sample, BMIs more often indicate overweight or obese.

Finally, let's generate a three way contingency table of BMI, age and gender.

{{< highlight r >}}
> (bmi.age.gender = table(BMI = BMI.category, age = age.category, gender))
, , gender = M

             age
BMI           child teenager adult mature senior
  underweight   818       67    14     10     15
  normal        259      199   393    184    227
  overweight     52       75   354    374    390
  obese          23       53   291    313    337

, , gender = F

             age
BMI           child teenager adult mature senior
  underweight   719       44    36     21     15
  normal        260      191   372    237    267
  overweight     65       68   276    264    342
  obese          24       60   369    390    393
{{< /highlight >}}

It's a little difficult to make sense of all that, but as we will see later on, there are great tools for understanding the contents of multiway contingency tables.

Right, that has given us a general feel for what the data looks like. The next step is to generate some plots.

The last thing that we need to do is detach the DS0012 variable

{{< highlight r >}}
> detach(DS0012)
{{< /highlight >}}
