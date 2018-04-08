---
author: Andrew B. Collier
date: 2015-09-18T15:56:43Z
tags: ["Julia", "R"]
title: 'MonthOfJulia Day 17: Datasets from R'
---

<!--more-->

<img src="/img/2015/09/Julia-Logo-RDatasets.png" >

R has an extensive range of builtin datasets, which are useful for experimenting with the language. The `RDatasets` package makes many of these available within Julia. We'll see another way of accessing R's datasets in a couple of days' time too. In the meantime though, check out the [documentation](https://github.com/johnmyleswhite/RDatasets.jl) for `RDatasets` and then read on below.

As always, the first thing that we need to do is load the package.

{{< highlight julia >}}
julia> using RDatasets
{{< /highlight >}}

We can get a list of the R packages which are supported by `RDatasets`.

{{< highlight julia >}}
julia> RDatasets.packages()
33x2 DataFrame
| Row | Package        | Title                                                                     |
|-----|----------------|---------------------------------------------------------------------------|
| 1   | "COUNT"        | "Functions, data and code for count data."                                |
| 2   | "Ecdat"        | "Data sets for econometrics"                                              |
| 3   | "HSAUR"        | "A Handbook of Statistical Analyses Using R (1st Edition)"                |
| 4   | "HistData"     | "Data sets from the history of statistics and data visualization"         |
| 5   | "ISLR"         | "Data for An Introduction to Statistical Learning with Applications in R" |
| 6   | "KMsurv"       | "Data sets from Klein and Moeschberger (1997), Survival Analysis"         |
| 7   | "MASS"         | "Support Functions and Datasets for Venables and Ripley's MASS"           |
| 8   | "SASmixed"     | "Data sets from \"SAS System for Mixed Models\""                          |
| 9   | "Zelig"        | "Everyone's Statistical Software"                                         |
| 10  | "adehabitatLT" | "Analysis of Animal Movements"                                            |
| 11  | "boot"         | "Bootstrap Functions (Originally by Angelo Canty for S)"                  |
| 12  | "car"          | "Companion to Applied Regression"                                         |
| 13  | "cluster"      | "Cluster Analysis Extended Rousseeuw et al."                              |
| 14  | "datasets"     | "The R Datasets Package"                                                  |
| 15  | "gap"          | "Genetic analysis package"                                                |
| 16  | "ggplot2"      | "An Implementation of the Grammar of Graphics"                            |
| 17  | "lattice"      | "Lattice Graphics"                                                        |
| 18  | "lme4"         | "Linear mixed-effects models using Eigen and S4"                          |
| 19  | "mgcv"         | "Mixed GAM Computation Vehicle with GCV/AIC/REML smoothness estimation"   |
| 20  | "mlmRev"       | "Examples from Multilevel Modelling Software Review"                      |
| 21  | "nlreg"        | "Higher Order Inference for Nonlinear Heteroscedastic Models"             |
| 22  | "plm"          | "Linear Models for Panel Data"                                            |
| 23  | "plyr"         | "Tools for splitting, applying and combining data"                        |
| 24  | "pscl"         | "Political Science Computational Laboratory, Stanford University"         |
| 25  | "psych"        | "Procedures for Psychological, Psychometric, and Personality Research"    |
| 26  | "quantreg"     | "Quantile Regression"                                                     |
| 27  | "reshape2"     | "Flexibly Reshape Data: A Reboot of the Reshape Package."                 |
| 28  | "robustbase"   | "Basic Robust Statistics"                                                 |
| 29  | "rpart"        | "Recursive Partitioning and Regression Trees"                             |
| 30  | "sandwich"     | "Robust Covariance Matrix Estimators"                                     |
| 31  | "sem"          | "Structural Equation Models"                                              |
| 32  | "survival"     | "Survival Analysis"                                                       |
| 33  | "vcd"          | "Visualizing Categorical Data"                                            |
{{< /highlight >}}

Next we'll get a list of all datasets supported across all of those R packages. There are a lot of them! Also we see some specific statistics about the number of records and fields in each of them.

{{< highlight julia >}}
julia> sets = RDatasets.datasets();
julia> size(sets)
(733,5)
julia> head(sets)
6x5 DataFrame
| Row | Package | Dataset     | Title       | Rows | Columns |
|-----|---------|-------------|-------------|------|---------|
| 1   | "COUNT" | "affairs"   | "affairs"   | 601  | 18      |
| 2   | "COUNT" | "azdrg112"  | "azdrg112"  | 1798 | 4       |
| 3   | "COUNT" | "azpro"     | "azpro"     | 3589 | 6       |
| 4   | "COUNT" | "badhealth" | "badhealth" | 1127 | 3       |
| 5   | "COUNT" | "fasttrakg" | "fasttrakg" | 15   | 9       |
| 6   | "COUNT" | "lbw"       | "lbw"       | 189  | 10      |
{{< /highlight >}}

Or we can find out what datasets are available from a particular R package.

{{< highlight julia >}}
julia> RDatasets.datasets("vcd")
31x5 DataFrame
| Row | Package | Dataset           | Title                                      | Rows  | Columns |
|-----|---------|-------------------|--------------------------------------------|-------|---------|
| 1   | "vcd"   | "Arthritis"       | "Arthritis Treatment Data"                 | 84    | 5       |
| 2   | "vcd"   | "Baseball"        | "Baseball Data"                            | 322   | 25      |
| 3   | "vcd"   | "BrokenMarriage"  | "Broken Marriage Data"                     | 20    | 4       |
| 4   | "vcd"   | "Bundesliga"      | "Ergebnisse der Fussball-Bundesliga"       | 14018 | 7       |
| 5   | "vcd"   | "Bundestag2005"   | "Votes in German Bundestag Election 2005"  | 16    | 6       |
| 6   | "vcd"   | "Butterfly"       | "Butterfly Species in Malaya"              | 24    | 2       |
| 7   | "vcd"   | "CoalMiners"      | "Breathlessness and Wheeze in Coal Miners" | 32    | 4       |
| 8   | "vcd"   | "DanishWelfare"   | "Danish Welfare Study Data"                | 180   | 5       |
| 9   | "vcd"   | "Employment"      | "Employment Status"                        | 24    | 4       |
| 10  | "vcd"   | "Federalist"      | "'May' in Federalist Papers"               | 7     | 2       |
| 11  | "vcd"   | "Hitters"         | "Hitters Data"                             | 154   | 4       |
| 12  | "vcd"   | "HorseKicks"      | "Death by Horse Kicks"                     | 5     | 2       |
| 13  | "vcd"   | "Hospital"        | "Hospital data"                            | 3     | 4       |
| 14  | "vcd"   | "JobSatisfaction" | "Job Satisfaction Data"                    | 8     | 4       |
| 15  | "vcd"   | "JointSports"     | "Opinions About Joint Sports"              | 40    | 5       |
| 16  | "vcd"   | "Lifeboats"       | "Lifeboats on the Titanic"                 | 18    | 8       |
| 17  | "vcd"   | "NonResponse"     | "Non-Response Survey Data"                 | 12    | 4       |
| 18  | "vcd"   | "OvaryCancer"     | "Ovary Cancer Data"                        | 16    | 5       |
| 19  | "vcd"   | "PreSex"          | "Pre-marital Sex and Divorce"              | 16    | 5       |
| 20  | "vcd"   | "Punishment"      | "Corporal Punishment Data"                 | 36    | 5       |
| 21  | "vcd"   | "RepVict"         | "Repeat Victimization Data"                | 8     | 9       |
| 22  | "vcd"   | "Saxony"          | "Families in Saxony"                       | 13    | 2       |
| 23  | "vcd"   | "SexualFun"       | "Sex is Fun"                               | 4     | 5       |
| 24  | "vcd"   | "SpaceShuttle"    | "Space Shuttle O-ring Failures"            | 24    | 6       |
| 25  | "vcd"   | "Suicide"         | "Suicide Rates in Germany"                 | 306   | 6       |
| 26  | "vcd"   | "Trucks"          | "Truck Accidents Data"                     | 24    | 5       |
| 27  | "vcd"   | "UKSoccer"        | "UK Soccer Scores"                         | 5     | 6       |
| 28  | "vcd"   | "VisualAcuity"    | "Visual Acuity in Left and Right Eyes"     | 32    | 4       |
| 29  | "vcd"   | "VonBort"         | "Von Bortkiewicz Horse Kicks Data"         | 280   | 4       |
| 30  | "vcd"   | "WeldonDice"      | "Weldon's Dice Data"                       | 11    | 2       |
| 31  | "vcd"   | "WomenQueue"      | "Women in Queues"                          | 11    | 2       |
{{< /highlight >}}

Finally, the most interesting bit: accessing data from a particular dataset. Below we load up the `women` dataset from the `vcd` package.

{{< highlight julia >}}
julia> women = dataset("datasets", "women")
15x2 DataFrame
| Row | Height | Weight |
|-----|--------|--------|
| 1   | 58     | 115    |
| 2   | 59     | 117    |
| 3   | 60     | 120    |
| 4   | 61     | 123    |
| 5   | 62     | 126    |
| 6   | 63     | 129    |
| 7   | 64     | 132    |
| 8   | 65     | 135    |
| 9   | 66     | 139    |
| 10  | 67     | 142    |
| 11  | 68     | 146    |
| 12  | 69     | 150    |
| 13  | 70     | 154    |
| 14  | 71     | 159    |
| 15  | 72     | 164    |
{{< /highlight >}}

From these data we learn that the average mass of American women of height 66 inches is around 139 pounds. If you are from a country which uses the Metric system (like me!) then these numbers might seem a little mysterious. Come back in a couple of days and we'll see how Julia can convert pounds and inches in metres and kilograms.

That's all for now. Code for today is available on [github](https://github.com/DataWookie/MonthOfJulia).
