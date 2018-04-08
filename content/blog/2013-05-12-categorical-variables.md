---
author: Andrew B. Collier
date: 2013-05-12T08:14:34Z
tags: ["R"]
title: 'Categorical Variables'
---

In the [previous installment](http://www.exegetic.biz/blog/2013/05/introducing-r-loading-data/) we sucked some data from the National Health and Nutrition Examination Survey into R and did some preliminary work: selecting only the fields of interest, renaming columns and removing missing data. Now we are going to play with some categorical data.

There is already one categorical field in the data representing gender. However, the labels are not ideal:

{{< highlight r >}}
> head(DS0012)
     id gender age  mass height      BMI
1 41475      2  62 138.9  1.547 58.03923
2 41476      2   6  22.0  1.204 15.17643
3 41477      1  71  83.9  1.671 30.04755
5 41479      1  52  65.7  1.544 27.55946
6 41480      1   6  27.0  1.227 17.93390
7 41481      1  21  77.9  1.827 23.33782
> unique(DS0012$gender)
[1] 2 1
{{< /highlight >}}

Reference to the excellent codebook accompanying the data reveals that one should interpret 1 as male and 2 as female. We can make things a little more transparent by converting this field to a factor and introducing appropriate labels.

{{< highlight r >}}
> DS0012$gender <- factor(DS0012$gender, labels = c("M", "F"))
> head(DS0012)
     id gender age  mass height      BMI
1 41475      F  62 138.9  1.547 58.03923
2 41476      F   6  22.0  1.204 15.17643
3 41477      M  71  83.9  1.671 30.04755
5 41479      M  52  65.7  1.544 27.55946
6 41480      M   6  27.0  1.227 17.93390
7 41481      M  21  77.9  1.827 23.33782
{{< /highlight >}}

That's better! Next we introduce a new categorical field which indicates age group. The boundaries between these fields are somewhat arbitrary (and might be rather politically incorrect), but they more or less make sense. Note that respondents above the age of 80 had their ages simply coded as 80.

{{< highlight r >}}
# [ 0, 13) - child
# [13, 18) - teenager
# [18, 40) - adult
# [40, 60) - mature
# > 60 - senior
#
> DS0012$age.category <- cut(DS0012$age, breaks = c(0, 13, 18, 40, 60, 81), right = FALSE,
                             labels = c("child", "teenager", "adult", "mature", "senior"))
> head(DS0012)
     id gender age  mass height      BMI age.category
1 41475      F  62 138.9  1.547 58.03923       senior
2 41476      F   6  22.0  1.204 15.17643        child
3 41477      M  71  83.9  1.671 30.04755       senior
5 41479      M  52  65.7  1.544 27.55946       mature
6 41480      M   6  27.0  1.227 17.93390        child
7 41481      M  21  77.9  1.827 23.33782        adult
{{< /highlight >}}

Finally we introduce [BMI](http://en.wikipedia.org/wiki/Body_mass_index) categories. These are rather broad categories, but will suffice for our analysis.

{{< highlight r >}}
# < 18.5 - underweight
# 18.5 to 25.0 - normal
# 25.0 to 30.0 - overweight
# > 30 - obese
#
DS0012$BMI.category <- cut(DS0012$BMI, breaks = c(0, 18.5, 25, 30, 100),
labels = c("underweight", "normal", "overweight", "obese"))
{{< /highlight >}}

This is what the final data look like

{{< highlight r >}}
> head(DS0012)
     id gender age  mass height      BMI age.category BMI.category
1 41475      F  62 138.9  1.547 58.03923       senior        obese
2 41476      F   6  22.0  1.204 15.17643        child  underweight
3 41477      M  71  83.9  1.671 30.04755       senior        obese
5 41479      M  52  65.7  1.544 27.55946       mature   overweight
6 41480      M   6  27.0  1.227 17.93390        child  underweight
7 41481      M  21  77.9  1.827 23.33782        adult       normal
{{< /highlight >}}

Next installment: some descriptive statistics.
