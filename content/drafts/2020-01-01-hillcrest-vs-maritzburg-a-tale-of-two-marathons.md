---
draft: true
title: "Hillcrest versus 'Maritzburg: A Tale of Two Marathons"
author: Andrew B. Collier
layout: post
excerpt_separator: <!-- more -->
categories:
  - Running
  - Statistics
---

There are a number of Comrades Marathon qualifiers in the first quarter of the year. If you live in KwaZulu-Natal then it's likely that you'll be thinking about either the Hillcrest Marathon or the 'Maritzburg Marathon, which normally occur a couple of weeks apart during February.

<!-- more -->

<a href="http://www.racently.com"><img src="{{ site.baseurl }}/static/img/logo-racently.png"></a>

The general feeling is that Hillcrest is a tougher race and that if you are chasing a particular time to ensure a place in a Comrades starting bin then your chances are better at 'Maritzburg.

That's the conventional wisdom. Let's see what the data have to say.

But before we get our hands dirty with data, let's review some anecdotal evidence.

## Anecdotal Evidence

I polled a few experienced runners and got their take on the Hillcrest versus 'Maritzburg question.

### Yvette

Yvette identified the following factors in favour of Hillcrest:

- easy to get to, so no early start; *Presuming that you live in the Durban area.*
- double lapper (which you know I love); *Not sure if this is an ironic statement?*
- nice support on the route.

She also mentioned these factors which count against Hillcrest:

- hilly;
- the laps can be split into two distinct sections (downhill and then uphill);
- very little relief on the course for your legs;
- hard course to maintain a pace;
- I drink too much beer after this race. *I don't think we can hold the race accountable for that!*

Similar, factors in favour of 'Maritzburg:

- nice route, undulating with some climbs but all doable and spread around the course;
- double lapper;
- fast finish home in case you are chasing a time (except that stupid incline past the school);
- You can maintain a nice pace throughout the run.

And, finally, a few things counting against 'Maritzburg:

- can be hot as hell; *Won't argue with that, although Hillcrest can be steamy too!*
- very early start if you don’t stay up there;
- takes the whole weekend if you are staying up there;
- I always think the course is easy, but it's not.

For reference you can check out some of Yvette's results [here](https://www.racently.com/athlete/3f5fd223-d6bb-4213-96cd-b8d3409acf01/).

### Olly

Hi Andrew,
 
Flip, not sure exactly what to tell you, I’m a fan of both the Hillcrest and the Maritzburg Marathon and both have played a key part in my Comrades training. They are both double lappers which I like, knowing what to expect for the second loop. I have run a faster Maritzburg (3:16) versus a Hillcrest (around 3:28 I think?) but I really gave the Maritzburg Marathon a real crack back then – my running ambitions have somewhat lowered since then! The key difference between the two is the last 7 or so kilometres – the tougher finish up Old Main Road at the Hillcrest compared to a fast finish at the Maritzburg Marathon. So if I had to choose, I would say perhaps the Maritzburg Marathon would be more conducive to a faster marathon simply based on the positioning of the climbs and at what stage of the marathon they appear. Both events are brilliantly organised.
 
If my training goes well, the annual plan is to qualify at the Hillcrest with a “C-Batch” sub-3:40 (running even splits) and then run a “comfortable”sub-4 hour at the Maritzburg Marathon two weeks later (also even splits).
 
Cheers,
Olly

Examine Olly's running pedigree [here](https://www.racently.com/athlete/0a7c87f1-7e85-4bd5-835a-02fe0513892b/).

### Karl

I enjoy both marathons, they are both relatively close to home and both manageable marathons for a novice.

Personally Hillcrest is nicer because as a Pinetown resident there is less distance to travel for the marathon(unless I sleep in PMB) and slightly more sleeping time.

I would say though in my experience that Hillcrest is tougher, the last 10 km hilly climb back to the finish is probably the main reason.

That being said there is a lot that can be done with all the down in km’s 21 to 31.

If needed one can recover for the ups there after. If feeling strong one can make some very good time in this stretch too.

PMB is an undulating run with a few considerable hills, but most of these well over before the end of the race.

My faster time has been in PMB though, sub 4 mat to mat (4:01 gun to gun) as compared to 4:07 in Hillcrest.

Peruse Karl's results [here](https://www.racently.com/athlete/f67d193f-cd3d-4d22-be25-8a86789cef04/).

## Data Exploration

{% highlight r %}
> arrange(marathons, time) %>% head(10)
# A tibble: 10 × 5
                            athlete       race gender  year   time
                             <fctr>     <fctr>  <chr> <int>  <dbl>
1  5897a6e7f93741109987347b3344fa38 Maritzburg      M  2015 137.72
2  fc513a7b1c5244888a502230fd4b5df5 Maritzburg      M  2015 140.47
3  ab509ff148294283b577c6e135a1ee13 Maritzburg      M  2015 141.17
4  f384376d96e741ca99822fc2a5d07f98 Maritzburg      M  2013 142.07
5  b59e2b2ebd0d483dae00c98d60959f97 Maritzburg      M  2010 142.58
6  8c0ebd3bf83b411ba4fcc7f404140218  Hillcrest      M  2012 142.65
7  baf20768d8b24422b6a27fee6ef51b4f Maritzburg      M  2010 142.75
8  b59e2b2ebd0d483dae00c98d60959f97 Maritzburg      M  2013 144.13
9  e240884319444bf698428bf37b6236fe  Hillcrest      M  2010 144.60
10 66e59a4e54494e72ae70e2ec87de9774 Maritzburg      M  2017 145.00
{% endhighlight %}

{% highlight r %}
> # Average Times (long view).
> #
> (avg_time <- group_by(marathons, race, gender) %>%
+     summarise(avg_time = mean(time)))
Source: local data frame [6 x 3]
Groups: race [?]

        race gender avg_time
      <fctr>  <chr>    <dbl>
1  Hillcrest      F   271.07
2  Hillcrest      M   251.90
3  Hillcrest   NULL   259.51
4 Maritzburg      F   277.01
5 Maritzburg      M   251.63
6 Maritzburg   NULL   256.70
{% endhighlight %}

{% highlight r %}
> # Average Times (wide view).
> #
> library(tidyr)
> avg_time %>% spread(race, avg_time)
# A tibble: 3 × 3
  gender Hillcrest Maritzburg
*  <chr>     <dbl>      <dbl>
1      F    271.07     277.01
2      M    251.90     251.63
3   NULL    259.51     256.70
{% endhighlight %}

<img src="{{ site.baseurl }}/static/img/2017/03/racently-hillcrest-maritzburg-annual-density.png">
<img src="{{ site.baseurl }}/static/img/2017/03/racently-hillcrest-maritzburg-density.svg">

<img src="{{ site.baseurl }}/static/img/2017/03/racently-hillcrest-maritzburg-boxplot.png">

<img src="{{ site.baseurl }}/static/img/2017/03/racently-hillcrest-maritzburg-paired-scatter.png">

<img src="{{ site.baseurl }}/static/img/2017/03/racently-hillcrest-maritzburg-annual-difference-density.png">
<img src="{{ site.baseurl }}/static/img/2017/03/racently-hillcrest-maritzburg-difference-density.png">

{% highlight r %}
> lm(maritzburg ~ hillcrest, data = merged) %>% summary

Call:
lm(formula = maritzburg ~ hillcrest, data = merged)

Residuals:
    Min      1Q  Median      3Q     Max 
-156.54  -10.96   -1.82    8.89  128.40 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  30.4277     2.9711    10.2   <2e-16 ***
hillcrest     0.8697     0.0113    77.2   <2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 20.5 on 2649 degrees of freedom
Multiple R-squared:  0.692, Adjusted R-squared:  0.692 
F-statistic: 5.96e+03 on 1 and 2649 DF,  p-value: <2e-16
{% endhighlight %}

{% highlight r %}
> lm(maritzburg ~ hillcrest + 0, data = merged) %>% summary

Call:
lm(formula = maritzburg ~ hillcrest + 0, data = merged)

Residuals:
    Min      1Q  Median      3Q     Max 
-163.24   -9.51   -0.66    9.17  140.45 

Coefficients:
          Estimate Std. Error t value Pr(>|t|)    
hillcrest  0.98396    0.00154     639   <2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 20.9 on 2650 degrees of freedom
Multiple R-squared:  0.994, Adjusted R-squared:  0.994 
F-statistic: 4.09e+05 on 1 and 2650 DF,  p-value: <2e-16
{% endhighlight %}

Let's do a quick two sample t-test.

{% highlight r %}
> t.test(maritzburg$time, hillcrest$time)

	Welch Two Sample t-test

data:  maritzburg$time and hillcrest$time
t = 2.12, df = 14800, p-value = 0.034
alternative hypothesis: true difference in means is not equal to 0
95 percent confidence interval:
 0.086866 2.183169
sample estimates:
mean of x mean of y 
   257.55    256.42
{% endhighlight %}

The result is significant. But what's this? It indicates that times at Hillcrest are significantly (statistically!) faster than 'Maritzburg. That flies in the face of all expectations!

{% highlight r %}
> t.test(merged$maritzburg, merged$hillcrest, paired = TRUE)

	Paired t-test

data:  merged$maritzburg and merged$hillcrest
t = -8.94, df = 2650, p-value <2e-16
alternative hypothesis: true difference in means is not equal to 0
95 percent confidence interval:
 -4.4480 -2.8474
sample estimates:
mean of the differences 
                -3.6477
{% endhighlight %}

We can go further and conduct one tailed tests...

{% highlight r %}
{% endhighlight %}

{% highlight r %}
{% endhighlight %}

{% highlight r %}
{% endhighlight %}
