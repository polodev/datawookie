---
author: Andrew B. Collier
date: 2016-09-01T15:00:46Z
tags: ["R", "Association Rules"]
title: 'PLOS Subject Keywords: Association Rules'
---

<!-- http://www.rdatamining.com/examples/association-rules -->

In a [previous post](http://www.exegetic.biz/blog/2016/08/plos-subjects-gathering-data/) I detailed the process of compiling data on subject keywords used in articles published in PLOS journals. In this instalment I'll be using those data to mine Association Rules with the [arules](http://lyle.smu.edu/IDA/arules/) package. Good references on the topic of Association Rules are

* Section 14.2 of [The Elements of Statistical Learning](https://web.stanford.edu/~hastie/ElemStatLearn/) (2009) by Hastie, Tibshirani and Friedman; and 
* [Introduction to arules](https://cran.r-project.org/web/packages/arules/vignettes/arules.pdf) by Hahsler, Grün, Hornik and Buchta.

<img src="/img/2016/08/association-rule-image.png">

## Terminology

Data suitable for mining Association Rules should consist of:

* a set of uniquely identified transactions, where 
* each transaction should have one or more items, where 
* items are binary attributes.

The derived rules take the form X &rarr; Y, where X and Y are disjoint itemsets, each consisting of one or more items. The itemsets X and Y are known as the antecedent (lhs or left hand side) and consequent (rhs or right hand side). The rules should be interpreted as "If X is present then so too is Y".

An Association Rules analysis aims to identify pairs (or groups) of items that are commonly found together. A shopping analogy would be that bread is often purchased with milk, while peanuts are often purchased with beer. This kind of analysis is not only confined to this sort of "consumption" scenario: it can be applied in any situation where a discrete set of items is associated with individual transactions.

In the context of the data we previously gathered from PLOS, where every article is tagged with one or more subjects, each of the articles is a "transaction" and the subjects are then the "items". We'll be deriving rules for which subjects commonly occur together. Or, more specifically, we'll be generating rules like "If an article is tagged with subject X then it is probably also tagged with subject Y".

## Transaction Matrix

The arules package derives Association Rules from a Transaction Matrix. The form in which we have the subjects data is particularly convenient for building a sparse matrix (class `ngCMatrix` from the Matrix package). 

{{< highlight r >}}
> head(subjects)
                           doi      journal              subject count
1 10.1371/journal.pbio.0000007 PLOS Biology               Borneo     1
2 10.1371/journal.pbio.0000007 PLOS Biology Conservation science     1
3 10.1371/journal.pbio.0000007 PLOS Biology            Elephants     1
4 10.1371/journal.pbio.0000007 PLOS Biology   Endangered species     2
5 10.1371/journal.pbio.0000007 PLOS Biology        Plant fossils     2
6 10.1371/journal.pbio.0000007 PLOS Biology    Pleistocene epoch     1
{{< /highlight >}}

For the purposes of the arules package the `ngCMatrix` needs to have items (in this case case subjects) as rows and transactions (in this case articles) as columns.

{{< highlight r >}}
> library(Matrix)
> 
> subjects.matrix <- with(subjects, sparseMatrix(i = as.integer(subject),
+                                                j = as.integer(doi),
+                                                dimnames = list(levels(subject),
+                                                                      levels(doi))))
> dim(subjects.matrix)
[1]   9357 185984
> class(subjects.matrix)
[1] "ngCMatrix"
attr(,"package")
[1] "Matrix"
{{< /highlight >}}

There are 185984 articles and 9357 subjects. Next we coerce this into a Transactions Matrix.

{{< highlight r >}}
> library(arules)
> 
> subjects.matrix <- as(subjects.matrix, "transactions")
> class(subjects.matrix)
[1] "transactions"
attr(,"package")
[1] "arules"
{{< /highlight >}}

Here's some summary information. We see that the vast majority of articles are associated with eight subjects.

{{< highlight r >}}
> summary(subjects.matrix)
transactions as itemMatrix in sparse format with
 185984 rows (elements/itemsets/transactions) and
 9357 columns (items) and a density of 0.000824 
 
most frequent items:
          Gene expression Polymerase chain reaction          Mouse models             Apoptosis                none 
                    17819                      9458                  8773                  7630                7593 
                  (Other) 
                  1382690 
 
element (itemset/transaction) length distribution:
sizes
     1      2      3      4      5      6      7      8 
  7625     16     22     34     26     30     54 178177 
 
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
   1.00    8.00    8.00    7.71    8.00    8.00 
 
includes extended item information - examples:
          labels
1     293T cells
2 3D bioprinting
3    3D printing
 
includes extended transaction information - examples:
                                                itemsetID
1 10.1371/annotation/008b05a8-229b-4aca-94ae-91e6dd5ca5ba
2 10.1371/annotation/00a3b22e-36a9-4d51-89e5-1e6561e7a1e9
3 10.1371/annotation/00d17a45-7b78-4fd5-9a9a-0f2e49b04eee
{{< /highlight >}}

## Generating Rules (Default Settings)

There are two major algorithms for generating Association Rules: [Apriori](https://en.wikipedia.org/wiki/Association_rule_learning#Apriori_algorithm) and [Eclat](https://en.wikipedia.org/wiki/Association_rule_learning#Eclat_algorithm). We'll be using the former here. We'll try to derive some rules using `apriori()` with default parameters.

{{< highlight r >}}
> rules <- apriori(subjects.matrix)
Apriori
 
Parameter specification:
 confidence minval smax arem  aval originalSupport support minlen maxlen target   ext
        0.8    0.1    1 none FALSE            TRUE     0.1      1     10  rules FALSE
 
Algorithmic control:
 filter tree heap memopt load sort verbose
    0.1 TRUE TRUE  FALSE TRUE    2    TRUE
 
Absolute minimum support count: 18598 
 
set item appearances ...[0 item(s)] done [0.00s].
set transactions ...[9357 item(s), 185984 transaction(s)] done [0.13s].
sorting and recoding items ... [0 item(s)] done [0.00s].
creating transaction tree ... done [0.01s].
checking subsets of size 1 done [0.00s].
writing ... [0 rule(s)] done [0.00s].
creating S4 object  ... done [0.01s].
{{< /highlight >}}

Zero rules! Well, that's a little disappointing. But not entirely surprising: the default minimum thresholds on support (0.1) and confidence (0.8) are rather conservative. (I'll explain what support and confidence mean shortly.) We'll relax them in order to at least generate a decent selection of rules.

## Generating Rules (Relaxed Settings)

Reducing the thresholds on support and confidence to 0.002 and 0.75 respectively results in 35 rules. Lower values for these thresholds are necessary because there is a relatively small degree of subject overlap between the articles in the collection. Not surprising since they are derived from a wide range of disciplines!

{{< highlight r >}}
> rules <- apriori(subjects.matrix, parameter = list(support = 0.002, confidence = 0.75))
Apriori
 
Parameter specification:
 confidence minval smax arem  aval originalSupport support minlen maxlen target   ext
       0.75    0.1    1 none FALSE            TRUE   0.002      1     10  rules FALSE
 
Algorithmic control:
 filter tree heap memopt load sort verbose
    0.1 TRUE TRUE  FALSE TRUE    2    TRUE
 
Absolute minimum support count: 371 
 
set item appearances ...[0 item(s)] done [0.00s].
set transactions ...[9357 item(s), 185984 transaction(s)] done [0.14s].
sorting and recoding items ... [838 item(s)] done [0.01s].
creating transaction tree ... done [0.10s].
checking subsets of size 1 2 3 4 done [0.04s].
writing ... [35 rule(s)] done [0.00s].
creating S4 object  ... done [0.04s].
{{< /highlight >}}

Below is some summary information on those rules. We see that the largest rule length (total number of items on lhs and rhs of rule) is only 3.

{{< highlight r >}}
> summary(rules)
set of 35 rules
 
rule length distribution (lhs + rhs):sizes
 2  3 
25 10 
 
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
   2.00    2.00    2.00    2.29    3.00    3.00 
 
summary of quality measures:
    support          confidence         lift       
 Min.   :0.00203   Min.   :0.756   Min.   :  9.34  
 1st Qu.:0.00233   1st Qu.:0.795   1st Qu.: 27.89  
 Median :0.00290   Median :0.858   Median : 39.60  
 Mean   :0.00337   Mean   :0.859   Mean   : 66.18  
 3rd Qu.:0.00365   3rd Qu.:0.923   3rd Qu.: 90.97  
 Max.   :0.01154   Max.   :1.000   Max.   :233.23  
 
mining info:
            data ntransactions support confidence
 subjects.matrix        185984   0.002       0.75
{{< /highlight >}}

This seems like a good time to peruse the rules themselves. To see the details we need to use `inspect()`.

{{< highlight r >}}
> inspect(rules)
   lhs                                        rhs                                        support   confidence lift    
1  {Memory T cells}                        => {T cells}                                  0.0021292 0.98020     28.1633
2  {Circadian oscillators}                 => {Circadian rhythms}                        0.0021292 0.85900    233.2272
3  {HbA1c}                                 => {Diabetes mellitus}                        0.0023550 0.90123     38.5500
4  {Secondary lung tumors}                 => {Lung and intrathoracic tumors}            0.0026346 1.00000    123.9067
5  {H1N1}                                  => {Influenza}                                0.0020432 0.76923     90.7770
6  {Corals}                                => {Coral reefs}                              0.0020271 0.75551    199.5923
7  {T helper cells}                        => {T cells}                                  0.0022314 0.82341     23.6585
8  {Face recognition}                      => {Face}                                     0.0021400 0.77282    191.3866
9  {T cell receptors}                      => {T cells}                                  0.0026669 0.91176     26.1971
10 {Breast tumors}                         => {Breast cancer}                            0.0024142 0.79610     57.2330
11 {Forest ecology}                        => {Forests}                                  0.0030271 0.94147     93.3362
12 {Antibody response}                     => {Antibodies}                               0.0028336 0.87542     39.0439
13 {Surgical oncology}                     => {Surgical and invasive medical procedures} 0.0024626 0.75702     50.3737
14 {Prostate gland}                        => {Prostate cancer}                          0.0030218 0.79603    130.7859
15 {HIV prevention}                        => {HIV}                                      0.0035003 0.90669     42.3372
16 {Tuberculosis diagnosis and management} => {Tuberculosis}                             0.0036885 0.93333     91.1686
17 {Geriatrics}                            => {Elderly}                                  0.0033229 0.80469    125.9756
18 {HIV diagnosis and management}          => {HIV}                                      0.0036186 0.81675     38.1376
19 {HIV epidemiology}                      => {HIV}                                      0.0038390 0.85817     40.0719
20 {Regulatory T cells}                    => {T cells}                                  0.0040971 0.87687     25.1945
21 {Chemotherapy}                          => {Cancer treatment}                         0.0040917 0.77259     22.3432
22 {Multiple alignment calculation}        => {Sequence alignment}                       0.0050811 0.85987     30.8255
23 {Malarial parasites}                    => {Malaria}                                  0.0051617 0.79668     74.8332
24 {HIV infections}                        => {HIV}                                      0.0076888 0.84816     39.6044
25 {Cytotoxic T cells}                     => {T cells}                                  0.0115386 0.95846     27.5388
26 {HIV epidemiology,HIV infections}       => {HIV}                                      0.0020432 0.95000     44.3597
27 {Gene expression,Regulator genes}       => {Gene regulation}                          0.0023174 0.77798     26.6075
28 {Malarial parasites,Parasitic diseases} => {Malaria}                                  0.0030863 0.78415     73.6565
29 {Malaria,Parasitic diseases}            => {Malarial parasites}                       0.0030863 0.82117    126.7428
30 {Phylogenetics,Sequence alignment}      => {Phylogenetic analysis}                    0.0022260 0.79310     33.2517
31 {Cytotoxic T cells,Flow cytometry}      => {T cells}                                  0.0023497 0.98202     28.2157
32 {Cytotoxic T cells,Immune response}     => {T cells}                                  0.0033121 0.96100     27.6117
33 {Cytokines,Cytotoxic T cells}           => {T cells}                                  0.0028981 0.96078     27.6055
34 {Enzyme-linked immunoassays,Vaccines}   => {Antibodies}                               0.0026293 0.77619     34.6185
35 {Gene regulation,Microarrays}           => {Gene expression}                          0.0041885 0.89437      9.3349
{{< /highlight >}}

Each of the rules consists of two itemsets, a lhs and a rhs, with the implication that if the lhs itemset is selected then so too is the rhs itemset.

## Rule Metrics

Naturally some rules are stronger than others. Their relative quality is measured by a set of metrics: support, confidence and lift.

### Support

The _support_ for an itemset is the proportion of transactions which contain that itemset. The _support_ for a rule is the proportion of transactions which contain both the antecedent and consequent itemsets.

The five rules below are those with the highest support. The rule {Cytotoxic T cells} &rarr; {T cells} has support of 0.0115386, which means that "Cytotoxic T cells" and "T cells" are present in 1.15% of transactions. Likewise, the rule {Gene regulation,Microarrays} &rarr; {Gene expression} has support of 0.0041885, indicating that "Gene regulation", "Microarrays" and "Gene expression" appear in 0.4% of transactions.

{{< highlight r >}}
> inspect(head(sort(rules, by = "support"), n = 5))
   lhs                                 rhs                  support   confidence lift   
25 {Cytotoxic T cells}              => {T cells}            0.0115386 0.95846    27.5388
24 {HIV infections}                 => {HIV}                0.0076888 0.84816    39.6044
23 {Malarial parasites}             => {Malaria}            0.0051617 0.79668    74.8332
22 {Multiple alignment calculation} => {Sequence alignment} 0.0050811 0.85987    30.8255
35 {Gene regulation,Microarrays}    => {Gene expression}    0.0041885 0.89437     9.3349
{{< /highlight >}}

Support does not directly indicate the strength of the rule, just how often the components of the rule are present in the data. However, having a decent level of support for a rule is important because it indicates what proportion of the data contributed to deriving that rule. Obviously if a rule is based on only a few transactions then it is not likely to be very robust.

### Confidence

The _confidence_ assigned to a rule is the proportion of transactions which contain both the antecedent and consequent relative to those which contain the antecedent. Equivalently, this is the ratio of the support for the rule to the support for the antecedent. Alternatively _confidence_ is the probability of the rhs being present in a transaction conditional on the lhs also being present.

The five rules below are those with the highest confidence. For example, we see that articles with subjects which include "Secondary lung tumors" will certainly also contain "Lung and intrathoracic tumors". Similarly, articles which have both "Cytokines" and "Cytotoxic T cells" as subjects will very likely also have "T cells".

{{< highlight r >}}
> inspect(head(sort(rules, by = "confidence"), n = 5))
   lhs                                    rhs                             support   confidence lift   
4  {Secondary lung tumors}             => {Lung and intrathoracic tumors} 0.0026346 1.00000    123.907
31 {Cytotoxic T cells,Flow cytometry}  => {T cells}                       0.0023497 0.98202     28.216
1  {Memory T cells}                    => {T cells}                       0.0021292 0.98020     28.163
32 {Cytotoxic T cells,Immune response} => {T cells}                       0.0033121 0.96100     27.612
33 {Cytokines,Cytotoxic T cells}       => {T cells}                       0.0028981 0.96078     27.606
{{< /highlight >}}

### Lift

The _lift_ of a rule indicates how much greater the support for the rule is relative to the support for the antecedent and consequent, treated as if they are independent. Equivalently, _lift_ is the ratio of confidence in a rule to the expected confidence were the antecedent and consequent independent. A useful interpretation of the lift is the increase in probability for the consequent if the antecedent is present. Alternatively, it's the ratio of the conditional probability of the consequent given the antecedent to the marginal probability of the consequent. Write out the expression and it'll make more sense.

A lift of 1 indicates that the antecedent and consequent are independent. In the rules below we see that the presence of "Circadian oscillators" results in a massive increase in the likelihood of the presence of "Circadian rhythms". Similarly, if both "Malaria" and "Parasitic diseases" are present then the probability of "Malarial parasites" being used increases by over one hundred fold.

{{< highlight r >}}
> inspect(head(sort(rules, by = "lift"), n = 5))
   lhs                             rhs                  support   confidence lift  
2  {Circadian oscillators}      => {Circadian rhythms}  0.0021292 0.85900    233.23
6  {Corals}                     => {Coral reefs}        0.0020271 0.75551    199.59
8  {Face recognition}           => {Face}               0.0021400 0.77282    191.39
14 {Prostate gland}             => {Prostate cancer}    0.0030218 0.79603    130.79
29 {Malaria,Parasitic diseases} => {Malarial parasites} 0.0030863 0.82117    126.74
{{< /highlight >}}

## Rule Selection

Before we look at rule selection we'll generate a more extensive assortment of rules by further lowering the thresholds for support and confidence.

{{< highlight r >}}
> rules <- apriori(subjects.matrix, parameter = list(support = 0.001, confidence = 0.25))
Apriori
 
Parameter specification:
 confidence minval smax arem  aval originalSupport support minlen maxlen target   ext
       0.25    0.1    1 none FALSE            TRUE   0.001      1     10  rules FALSE
 
Algorithmic control:
 filter tree heap memopt load sort verbose
    0.1 TRUE TRUE  FALSE TRUE    2    TRUE
 
Absolute minimum support count: 185 
 
set item appearances ...[0 item(s)] done [0.00s].
set transactions ...[9357 item(s), 185984 transaction(s)] done [0.15s].
sorting and recoding items ... [1600 item(s)] done [0.02s].
creating transaction tree ... done [0.13s].
checking subsets of size 1 2 3 4 done [0.07s].
writing ... [984 rule(s)] done [0.00s].
creating S4 object  ... done [0.04s].
{{< /highlight >}}

You can use the `subset()` function to focus on particular rules of interest. What other subjects are commonly associated with "HIV"?

{{< highlight r >}}
> subset(rules, subset = lhs %in% "HIV")
set of 19 rules 
{{< /highlight >}}

So there is quite a selection of them. We can narrow that down by focusing on those which have a relatively high level of confidence.

{{< highlight r >}}
> inspect(subset(rules, subset = lhs %in% "HIV" & confidence > 0.5))
    lhs                                            rhs              support   confidence lift  
677 {HIV,HIV prevention}                        => {HIV infections} 0.0018174 0.51920    57.274
685 {HIV,Tuberculosis diagnosis and management} => {Tuberculosis}   0.0010646 0.92958    90.802
694 {HIV,HIV epidemiology}                      => {HIV infections} 0.0020432 0.53221    58.709
844 {Cytotoxic T cells,HIV}                     => {T cells}        0.0010108 0.97917    28.134
{{< /highlight >}}

Selection criteria are applied in `subset()` using the operators `%in%` (does item appear in itemset?), `%pin%` (like `%in%` but with partial matching) and `%ain%` (match all items specified) to operate on lhs and rhs. Arithmetic comparisons are used on the rule metrics.

Here's another example which indicates that articles with subject "Dementia" will also have either "Alzheimer disease" or "Cognitive impairment" as a subject roughly 50% of the time.

{{< highlight r >}}
> inspect(subset(rules, subset = lhs %in% "Dementia"))
    lhs           rhs                    support   confidence lift  
101 {Dementia} => {Alzheimer disease}    0.0011022 0.53385    67.681
102 {Dementia} => {Cognitive impairment} 0.0011399 0.55208    55.502
{{< /highlight >}}

## Symmetry

It might have occurred to you that these rules should be symmetric: if X &rarr; Y then surely Y &rarr; X too? This is certainly the case. Consider the four rules below, which consist of two symmetric pairs.

{{< highlight r >}}
> inspect(subset(rules, subset = lhs %in% "Fungal genetics" | rhs %in% "Fungal genetics"))
    lhs                  rhs               support   confidence lift   
165 {Fungal genetics} => {Fungal genomics} 0.0010646 0.38900    135.482
166 {Fungal genomics} => {Fungal genetics} 0.0010646 0.37079    135.482
167 {Fungal genetics} => {Fungi}           0.0016453 0.60118     94.195
168 {Fungi}           => {Fungal genetics} 0.0016453 0.25779     94.195
{{< /highlight >}}

The rules {Fungal genetics} &rarr; {Fungi} and {Fungi} &rarr; {Fungal genetics} form one symmetric pair. Note that the support and lift are the same for both rules, but that the first rule has a higher confidence than the second. This is due to different supports for the antecedent in each case. Whereas "Fungal genetics" is a subject for 509 articles, "Fungi" appears as a subject for 1187 articles. The corresponding values of support are 0.0027368 and 0.0063823 respectively. Since "Fungi" is more than twice as common, the confidence in the second rule is diminished significantly. This emphasises the fact that rules with the highest confidence are those for which the support for the antecedent is almost as high as the support for the rule itself.

## Conclusion

Although the example presented here has been confined to binary (presence/absence) data, Association Rules can also be applied effectively to categorical data, as illustrated in Example 2 of the paper by Hahsler et al. cited above.

Association Rules are a powerful unsupervised learning technique which can be fruitfully applied in data mining. The resulting rules are often instrumental in identifying actionable insights from the data.
