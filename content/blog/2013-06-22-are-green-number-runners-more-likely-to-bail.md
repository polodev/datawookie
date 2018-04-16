---
author: Andrew B. Collier
date: 2013-06-22T15:07:44Z
tags: ["R", "running"]
title: Are Green Number Runners More Likely to Bail?
---

Comrades Marathon runners are awarded a permanent green race number once they have completed 10 journeys between Durban and Pietermaritzburg. For many runners, once they have completed the race a few times, achieving a green number becomes a possibility. And once the idea takes hold, it can become something of a compulsion. I can testify to this: I am thoroughly compelled! For runners with this goal in mind, every finish is one step closer to a green number. They are slowly chipping away, year after year and the idea of bailing is anathema. However, once the green number is in the bag, does the imperative to complete the race fade?

I am going to explore the hypothesis that runners with green numbers are more likely to bail.

Let's start by looking at the proportions of runners who finish the race as opposed to those who do not finish (DNF) and those who enter but do not start (DNS). As can be seen from the plot below, the proportion of runners who finish the race seems to increase with the number of medals that the runners in question have. So, for example, of the runners with one medal, 68.6% finished while only 21.7% were DNF. For runners with ten medals, 87.1% finished and only 9.5% were DNF.

On the face of it, this seems to make sense: there is a natural selection effect. Runners who have more medals are probably a little more hard core and thus less likely to bail. Less experienced runners might be more likely to jump on the bus when the going gets really tough.

But, unfortunately, it is not quite that simple.

<img src="/img/2013/06/status-proportion-medal-count.png">

The analysis above has a serious problem: consider those runners with one medal. We are comparing the number of finishers (those that have just received that medal) to non-finishers (who already have a medal!). So we are not really comparing apples with apples! What we really should be working with are the number of finishers who had _i-1_ medals before the race and the number of non-finishers who had _i_ medals.

Compiling these data takes a little work, but nothing too taxing. Let's consider an anonymous (but real) runner whose Comrades Marathon history looks like this:

{{< highlight r >}}
year   status medal.count
1985 Finished           1
1986 Finished           2
1987 Finished           3
1988 Finished           4
1989 Finished           5
1990 Finished           6
1991 Finished           7
1992      DNF           7
1993      DNF           7
1998      DNF           7
1999 Finished           8
2000 Finished           9
2001      DNF           9
2002      DNF           9
2003      DNF           9
2009      DNS           9
2010      DNS           9
2011      DNS           9
2012      DNS           9
2013      DNS           9
{{< /highlight >}}

What we want is a table that shows how many times he ran with a given number of medals. So, for our anonymous hero, this would be:

{{< highlight r >}}
           0 1 2 3 4 5 6 7 8 9
  Finished 1 1 1 1 1 1 1 1 1 0
  DNF      0 0 0 0 0 0 0 3 0 3
  DNS      0 0 0 0 0 0 0 0 0 5
{{< /highlight >}}

Things went well for the first seven years. On the first year he had no medal (column 0) but he finished (so there is a 1 in the first row). The same applies for columns 1 to 6. Then on year 7 he finished, gaining his seventh medal (hence the 1 in the first row of column 6: he already had 6 medals when he ran this time!). However, for the next three years (when he already had 7 medals) he got a DNF (hence the 3 in the second row of column 7). On his fourth attempt he got medal number 8 (giving the 1 in the first row of column 7: he already had 7 medals when he ran this time!). And the following year he got medal number 9. Then he suffered a string of 3 DNFs (the 3 in the second row of column 9), followed by a series of 5 DNSs (the 5 in the third row of column 9). To illustrate the proportions, when he had 7 medals he got DNS 0% (0/4) of the time, DNF 75% (3/4) of the time and finished 25% (1/4) of the time.

Those are the data for a single athlete. To make a compelling case it is necessary to compile the same statistics for many, many runners. So I generated the analogous table for all athletes who ran the race between 1984 and 2013. A melted and abridged version of the resulting data look like this:

{{< highlight r >}}
     status medal.count number proportion
1  Finished           0  78051 0.83386039
2       DNF           0  11102 0.11860858
3       DNS           0   4449 0.04753104
4  Finished           1  52186 0.83512298
5       DNF           1   7336 0.11739666
6       DNS           1   2967 0.04748036
7  Finished           2  37478 0.83605863
8       DNF           2   5332 0.11894617
9       DNS           2   2017 0.04499520
10 Finished           3  28506 0.83472914
11      DNF           3   4072 0.11923865
12      DNS           3   1572 0.04603221
13 Finished           4  22814 0.83326637
14      DNF           4   3256 0.11892326
15      DNS           4   1309 0.04781037
16 Finished           5  18576 0.83630470
17      DNF           5   2585 0.11637853
18      DNS           5   1051 0.04731677
19 Finished           6  15538 0.83794424
20      DNF           6   2156 0.11627029
21      DNS           6    849 0.04578547
22 Finished           7  13300 0.84503463
23      DNF           7   1706 0.10839316
24      DNS           7    733 0.04657221
25 Finished           8  11809 0.86165633
26      DNF           8   1339 0.09770157
27      DNS           8    557 0.04064210
28 Finished           9  10852 0.81215387
29      DNF           9   1463 0.10948960
30      DNS           9   1047 0.07835653
31 Finished          10   7381 0.82047577
32      DNF          10    974 0.10827034
33      DNS          10    641 0.07125389

61 Finished          20    784 0.80575540
62      DNF          20     98 0.10071942
63      DNS          20     91 0.09352518

91 Finished          30     59 0.83098592
92      DNF          30      9 0.12676056
93      DNS          30      3 0.04225352
{{< /highlight >}}

The important information here is the proportion of DNF entries for each medal count. We can see that 11.8% (0.11860858) of runners DNF on the first time that they ran. Similarly, of those runners who had already completed the race once (so they had one medal in the bag), 11.7% (0.11739666) did not finish. Of those who ran again after just achieving a green number, 10.8% (0.10827034) were DNF. It will be easier to make sense of all this in a plot.

<img src="/img/2013/06/status-proportion-medal-count-corrected.png">

Wow! Now that is interesting. Just to be sure that everything is clear about this plot: every column reflects the proportions of finishers, DNFs and DNSs who **already had** a given number of medals. There are a number of intriguing things about these data:

1. all three proportions remain almost identical for runners who already had between 0 and 6 medals;
2. the proportion of finishers then starts to ramp up for those with 7 and 8 medals (the DNS proportion remains unchanged, the DNFs decrease);
3. there is a decrease in the proportion of finishers who already have 9 medals and a corresponding increase in the proportion of DNSs, while the DNFs remain unchanged;
4. the proportion of finishers then increases slightly for those who already have 10 medals.

What conclusions can we draw from this? The second point seems to indicate a growing level of determination: these athletes are really close to their green number and they are less likely to sacrifice their medal. The third point is interesting too: the proportion of DNFs stays roughly the same but the DNS percentage grows from 4.1% for those with 8 medals to 7.8% for those with 9 medals. Why would this be? Well, I am really not sure and I would welcome suggestions. One possibility is that these runners are determined to have a good race so they might overtrain and end up injured or ill.

Are the differences in the proportion of DNFs statistically significant?

{{< highlight r >}}
  31-sample test for equality of proportions without continuity correction

data:  medal.table[2, 1:31] out of colSums(medal.table[, 1:31])
X-squared = 139.4798, df = 30, p-value = 4.744e-16
alternative hypothesis: two.sided
sample estimates:
    prop 1     prop 2     prop 3     prop 4     prop 5     prop 6     prop 7     prop 8     prop 9    prop 10
0.11860858 0.11739666 0.11894617 0.11923865 0.11892326 0.11637853 0.11627029 0.10839316 0.09770157 0.10948960
   prop 11    prop 12    prop 13    prop 14    prop 15    prop 16    prop 17    prop 18    prop 19    prop 20
0.10827034 0.10204696 0.10013936 0.10500000 0.11237335 0.10784314 0.11079137 0.10659026 0.09327846 0.11298606
   prop 21    prop 22    prop 23    prop 24    prop 25    prop 26    prop 27    prop 28    prop 29    prop 30
0.10071942 0.10404624 0.09890110 0.09684685 0.14473684 0.10833333 0.14358974 0.07284768 0.14285714 0.16379310
   prop 31
0.12676056
{{< /highlight >}}

The miniscule p-value from the proportion test indicates that there definitely is a significant difference in the proportion of DNFs across the entire data set (for those with between 0 and 30 medals). But it does not tell us anything about which of the proportions are responsible for this difference. We can get some information about this from a pairwise proportion test. Here is the abridged output.

{{< highlight r >}}
  Pairwise comparisons using Pairwise comparison of proportions

data:  medal.table[2, 1:31] out of colSums(medal.table[, 1:31])

   0       1       2       3       4       5       6       7     8     9     10    11    12    13    14    15
1  1.000   -       -       -       -       -       -       -     -     -     -     -     -     -     -     -
2  1.000   1.000   -       -       -       -       -       -     -     -     -     -     -     -     -     -
3  1.000   1.000   1.000   -       -       -       -       -     -     -     -     -     -     -     -     -
4  1.000   1.000   1.000   1.000   -       -       -       -     -     -     -     -     -     -     -     -
5  1.000   1.000   1.000   1.000   1.000   -       -       -     -     -     -     -     -     -     -     -
6  1.000   1.000   1.000   1.000   1.000   1.000   -       -     -     -     -     -     -     -     -     -
7  0.107   0.734   0.179   0.205   0.457   1.000   1.000   -     -     -     -     -     -     -     -     -
8  4.8e-10 2.5e-08 3.8e-09 9.0e-09 6.4e-08 1.8e-05 5.8e-05 1.000 -     -     -     -     -     -     -     -
9  1.000   1.000   1.000   1.000   1.000   1.000   1.000   1.000 0.689 -     -     -     -     -     -     -
10 1.000   1.000   1.000   1.000   1.000   1.000   1.000   1.000 1.000 1.000 -     -     -     -     -     -
11 0.025   0.099   0.031   0.032   0.056   0.579   0.780   1.000 1.000 1.000 1.000 -     -     -     -     -
12 0.038   0.117   0.042   0.042   0.066   0.506   0.651   1.000 1.000 1.000 1.000 1.000 -     -     -     -
13 1.000   1.000   1.000   1.000   1.000   1.000   1.000   1.000 1.000 1.000 1.000 1.000 1.000 -     -     -
14 1.000   1.000   1.000   1.000   1.000   1.000   1.000   1.000 1.000 1.000 1.000 1.000 1.000 1.000 -     -
15 1.000   1.000   1.000   1.000   1.000   1.000   1.000   1.000 1.000 1.000 1.000 1.000 1.000 1.000 1.000 -
16 1.000   1.000   1.000   1.000   1.000   1.000   1.000   1.000 1.000 1.000 1.000 1.000 1.000 1.000 1.000 1.000
{{< /highlight >}}

For between 0 and 6 medals there is no significant difference (p-value is roughly 1). The DNF proportion for those with 7 medals does start to differ from those with 4 medals or fewer, but the p-values are not significant. When we get to athletes who have 8 medals there is a significant difference in the proportion of DNFs all the way from those with 0 medals to those with 6 medals. However, the proportion of DNFs for those with 9 medals is not significantly different from any of the other categories. Finally, the DNF proportion for those athletes who already have 10 medals does not differ significantly from the athletes with any number of fewer medals.

So, no, it does not seem that runners with green numbers are more likely to bail (a conclusion that makes me personally very happy!). And good luck to the anonymous runner: I hope that you will be back in 2014 and that you will crack your green number!

Oh, and one last thing: as I mentioned before, the analysis above is based on the period 1984 to 2013. There are some serious issues with the data in the earlier years. Here is a breakdown of the number of runners in each of the categories across the years:

{{< highlight r >}}
       Finished   DNF   DNS
  1984     7105     2     0
  1985     8192  1907     1
  1986     9654  1793     0
  1987     8376  2458     0
  1988    10363  1934     0
  1989    10505  3065     2
  1990    10272  1351     2
  1991    12082  2936     1
  1992    10695  2533     5
  1993    11322  2270     2
  1994    10274  2428     3
  1995    10541  2990     1
  1996    11269  2277     2
  1997    11365  2467     3
  1998    10496  2874     5
  1999    11291  2835     3
  2000    20030  4508     7
  2001    11090  4270     1
  2002     9027  2276   863
  2003    11416  1065   892
  2004    10123  1925     9
  2005    11729  2163     7
  2006     9846  1194  1025
  2007    10052  1084   868
  2008     8631  1745   813
  2009    10008  1501  1441
  2010    14339  2226  7000
  2011    11058  2023  6506
  2012    11889  1739  5916
  2013    10278  3643  5986
{{< /highlight >}}

Certainly something is deeply wrong in 1984! In the early years it does not make any sense to discriminate between DNF and DNS since there were no independent records kept: we simply know whether or not an athlete finished. The introduction of the ChampionChip timing devices improved the quality of the data dramatically. These chips have been used by all Comrades Marathon runners since 1997] although there is a delayed effect on the quality of the data.

Despite these issues, the conclusions of the analysis above remain essentially unchanged if you simply lump the DNF and DNS data together (because we cannot always make a meaningful divide between them!).
