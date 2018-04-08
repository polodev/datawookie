---
author: Andrew B. Collier
date: 2013-05-12T07:48:29Z
tags: ["R"]
title: 'Loading Data'
---

I have just started preparing a series of talks aimed at introducing the use of R to a rather broad audience consisting of physicists, chemists, statisticians, biologists and computer scientists (plus a few other disciplines thrown in for good measure). I want to use a single consistent set of data throughout the talks. Finding something that would resonate with such a disparate set of people was quite a challenge. After playing around with a couple of options, I settled on using data for age, height and mass. These are things that we can all identify with. The next challenge was to actually find a suitable data set, which was surprisingly difficult. Eventually I stumbled upon the data from the National Health and Nutrition Examination Survey (NHANES), The data from the survey are available [here](http://www.icpsr.umich.edu/icpsrweb/DSDR/studies/25505). These data have been divided into a number of sets, each of which has been excellently curated and has a detailed codebook.

I started with the Body Measurements data (DS12), which I downloaded in tab-delimited format. The first task was to load this into [R](http://www.r-project.org/).

{{< highlight r >}}
> DS0012 <- read.delim("data/DS0012/25505-0012-Data.tsv")
> dim(DS0012)
[1] 9762 65
{{< /highlight >}}

So there are 9762 records, each of which has 65 fields. We will only retain a subset of those (sequence number, gender, age, mass and height). Although the field name for mass suggests that it might in fact be weight (BMXWT), it is actually mass in kilograms. Height is given in centimetres.

{{< highlight r >}}
> DS0012 = DS0012[,c("SEQN", "RIAGENDR", "RIDAGEYR", "BMXWT", "BMXHT")]
{{< /highlight >}}

There is some missing data (mass and height fields), which we remove.

{{< highlight r >}}
> summary(DS0012)
      SEQN          RIAGENDR        RIDAGEYR         BMXWT            BMXHT
 Min.   :41475   Min.   :1.000   Min.   : 0.00   Min.   : 3.10    Min.   : 81.5
 1st Qu.:44008   1st Qu.:1.000   1st Qu.:10.00   1st Qu.: 36.70   1st Qu.:150.3
 Median :46540   Median :1.000   Median :29.00   Median : 66.10   Median :162.4
 Mean   :46547   Mean   :1.497   Mean   :32.88   Mean   : 62.17   Mean   :156.1
 3rd Qu.:49094   3rd Qu.:2.000   3rd Qu.:54.00   3rd Qu.: 83.65   3rd Qu.:171.7
 Max.   :51623   Max.   :2.000   Max.   :80.00   Max.   :218.20   Max.   :203.8
                                                 NA's   :131      NA's   :889
> DS0012 = subset(DS0012, !(is.na(BMXWT) | is.na(BMXHT)))
> dim(DS0012)
[1] 8861 6
{{< /highlight >}}

So, we lost around 10% of the original data, but at least what we are left with is clean. Next we change the column labels to something a little less cryptic and convert the units for height to metres

{{< highlight r >}}
> names(DS0012) <- c("id", "gender", "age", "mass", "height")
> DS0012$height = DS0012$height / 100
{{< /highlight >}}

Lastly we add in a derived column for [Body Mass Index (BMI)](http://en.wikipedia.org/wiki/Body_mass_index). There was already BMI data in the original data set, however, it is illustrative to calculate it again here.

{{< highlight r >}}
> DS0012 = transform(DS0012, BMI = mass / height**2)
{{< /highlight >}}

This is what the final data look like:

{{< highlight r >}}
> head(DS0012)
     id gender age  mass height      BMI
1 41475      2  62 138.9  1.547 58.03923
2 41476      2   6  22.0  1.204 15.17643
3 41477      1  71  83.9  1.671 30.04755
5 41479      1  52  65.7  1.544 27.55946
6 41480      1   6  27.0  1.227 17.93390
7 41481      1  21  77.9  1.827 23.33782
{{< /highlight >}}

Next installment: defining some meaningful categories.
