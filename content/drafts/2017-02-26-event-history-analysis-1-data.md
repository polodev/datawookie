---
draft: true
title: 'Event History Analysis: 1. Data'
author: andrew
type: post
date: 2017-02-26T08:23:22+00:00
categories:
  - R
tags:
  - Event History Analysis
  - genealogy
  - R

---
I&#8217;m busy reading [Event History Analysis with R][1] <img src="http://ir-na.amazon-adsystem.com/e/ir?t=exegetanalyt-20&#038;l=as2&#038;o=1&#038;a=1439831645" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />by Göran Broström. Much of the contents is new to me, so I am trying to work through the examples to reinforce my understanding. Although the book provides a number of worked examples, I thought that I would engage with the material most effectively if I was applying it to my own data.

But what data?

After a bit of thought it became obvious that the genealogical database I have been painstakingly compiling with [GRAMPS][2] would be close to perfect. I exported the database as CSV and I was ready to roll. Well, almost.

## Initial View

First let&#8217;s take a quick look at the data. The plots below show the birth date for each individual as a point. For those individuals with known death dates, a line segment indicates their life span.

[<img src="http://162.243.184.248/wp-content/uploads/2015/04/individuals-time-line.png" alt="individuals-time-line" width="100%" class="aligncenter size-full wp-image-1406" srcset="http://162.243.184.248/wp-content/uploads/2015/04/individuals-time-line.png 800w, http://162.243.184.248/wp-content/uploads/2015/04/individuals-time-line-240x300.png 240w, http://162.243.184.248/wp-content/uploads/2015/04/individuals-time-line-768x960.png 768w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 984px) 61vw, (max-width: 1362px) 45vw, 600px" />][3]

## Data Preparation

A subset of the data currently looks like this:
  
[code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
> head(individuals, 20)
     
Person Gender Birth.date Death.date
  
1 I0862 female 1536 1600
  
2 I1038 female 1545 1609
  
3 I0863 male 1545 1606
  
4 I0864 female 1546 1626
  
5 I0865 female 1549 1582
  
6 I0431 male 1558 1639
  
7 I0776 female 1562 1648
  
8 I0295 male 1565 1607
  
9 I0296 male 1567 1615
  
10 I0275 female 1568 1582
  
11 I2404 male 1571 1651
  
12 I0938 male 1581 NA
  
13 I0359 male 1588 NA
  
14 I0350 female 1593 NA
  
15 I0336 male 1596 1662
  
16 I0850 male 1598 NA
  
17 I0337 female 1599 1679
  
18 I0284 male 1602 NA
  
19 I2210 female 1606 NA
  
20 I1922 male 1609 1673
  


We are going to be using functionality from the [eha (Event History Analysis) package][4]. To do this we&#8217;ll need to restructure our data somewhat. Two new fields, enter and exit, indicate the age at which each individual enters the study. Since we have not defined a study period, these correspond to age at birth (zero, obviously!) and age at death. We&#8217;ll also add an event column which indicates whether or not we have data for death date.

[code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
> individuals = within(individuals, {
  
+ enter = 0
  
+ exit = Death.date &#8211; Birth.date
  
+ event = ifelse(is.na(exit), 0, 1)
  
+ })
  
> #
  
> individuals = select(individuals, Person, enter, exit, event, Birth.date, Gender)
  
> #
  
> names(individuals)[c(1, 5, 6)] = c("id", "birthdate", "gender")
  
> head(individuals)
       
id enter exit event birthdate gender
  
1 I0862 0 64 1 1536 female
  
2 I1038 0 64 1 1545 female
  
3 I0863 0 61 1 1545 male
  
4 I0864 0 80 1 1546 female
  
5 I0865 0 33 1 1549 female
  
6 I0431 0 81 1 1558 male
  


We now need to select a period for our mock experiment. Obviously we&#8217;ll want to maximise the quantity of data available for the experiment. To do this I ran through a range of options for possible initial and final years. The results are plotted below. The contours pertain to the full data set while the shaded region indicates periods where the initial and final years differ by no more than 50 years.

[<img src="http://162.243.184.248/wp-content/uploads/2015/04/window-count.png" alt="window-count" width="100%" class="aligncenter size-full wp-image-1419" srcset="http://162.243.184.248/wp-content/uploads/2015/04/window-count.png 800w, http://162.243.184.248/wp-content/uploads/2015/04/window-count-150x150.png 150w, http://162.243.184.248/wp-content/uploads/2015/04/window-count-300x300.png 300w, http://162.243.184.248/wp-content/uploads/2015/04/window-count-768x768.png 768w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 984px) 61vw, (max-width: 1362px) 45vw, 600px" />][5]

The 50 year period between 1840 and 1890 appears to have the most individuals, so this is where we will fix the study.

[code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
> head(individual.ranges)
    
from until count
  
1 1840 1890 384
  
2 1860 1910 384
  
3 1850 1900 382
  
4 1870 1920 378
  
5 1850 1890 360
  
6 1830 1880 359
  


Unfortunately, before we apply a calendar window to the data we must first deal with the records which have missing death dates. From the perspective of an experiment these individuals will have reached the end of the experiment without dying (either they do indeed survive beyond the end of the experiment or we are not aware of when they died within the experiment). First let&#8217;s identify a group of individuals which we&#8217;ll use to discuss the windowing process.

[code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
> subset(individuals, id %in% c("I1258", "I1964", "I0565", "I1691", "I1956", "I0515"))
         
id enter exit event birthdate gender
  
240 I0565 0 27 1 1807 male
  
365 I1964 0 NA 0 1830 male
  
367 I0515 0 67 1 1830 male
  
459 I1258 0 NA 0 1850 female
  
460 I1691 0 56 1 1850 female
  
461 I1956 0 31 1 1850 female
  


Now, for the individuals with missing exit age, we&#8217;ll set exit so that it corresponds to the end of the experiment.

[code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
> individuals = transform(individuals,
  
+ exit = ifelse(is.na(exit), 1890 &#8211; birthdate, exit)
  
+ )
  
> #
  
> subset(individuals, id %in% c("I1258", "I1964", "I0565", "I1691", "I1956", "I0515"))
         
id enter exit event birthdate gender
  
240 I0565 0 27 1 1807 male
  
365 I1964 0 60 0 1830 male
  
367 I0515 0 67 1 1830 male
  
459 I1258 0 40 0 1850 female
  
460 I1691 0 56 1 1850 female
  
461 I1956 0 31 1 1850 female
  


Finally we can apply the calendar window for the experiment.

[code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
> individuals = cal.window(individuals, c(1840, 1890))
  
> #
  
> subset(individuals, id %in% c("I1258", "I1964", "I0565", "I1691", "I1956", "I0515"))
         
id enter exit event birthdate gender
  
365 I1964 10 60 0 1830 male
  
367 I0515 10 60 0 1830 male
  
459 I1258 0 40 0 1850 female
  
460 I1691 0 40 0 1850 female
  
461 I1956 0 31 1 1850 female
  


We want to extract a subset from the data which could conceivably have been gathered from an experiment. The free parameters are

  1. the start of the experiment; 
      * the end of the experiment; and 
          * the minimum age (at the start of the experiment) for inclusion. </ol> 
            Since we are constructing the data for illustration purposes alone, we are free to choose these parameters arbitrarily. Ideally we would want to retain as many records as possible. After some trial and error I found that the following parameters worked well, where INIT, FINI and MINAGE correspond to the list of parameters enumerated above.
            
            [code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  

            
            [code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  

            
            [code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  

            
            [code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  

            
            [code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  

            
            ## Windowing
            
            ## Truncated and Censored Data
            
            QUOTED TEXT: Of special interest is the triple (enter, exit, event), because it represents
  
            the response variable, or what can be seen of it. More specifically, the sampling
  
            frame is all persons observed to be alive and above 60 years of age between 1
  
            January 1860 and 31 December 1879. The start event for these individuals is
  
            their 60th anniversary, and the stop event is death. Clearly, many individuals
  
            in the data set did not die before 1 January 1880, so for them we do not know
  
            the full duration between the start and stop events; such individuals are said
  
            to be right censored (the exact meaning of which will be given soon). The third
  
            component in the survival object (enter, exit, event); that is, event is a
  
            logical variable taking the value TRUE if exit is the true duration (the interval
  
            ends with a death) and FALSE if the individual is still alive at the duration
  
            “last seen.”
  
            Individuals aged 60 or above between 1 January 1860 and 31 December
  
            1879 are included in the study. Those who are above 60 at this start date
  
            are included only if they did not die between the age of 60 and the age at
  
            1 January 1860. If this is not taken into account, a bias in the estimation of
  
            mortality will result. The proper way of dealing with this problem is to use
  
            left truncation, which is indicated by the variable enter. If we look at the first
  
            rows of oldmort, we see that the enter variable is very large; it is the age for
  
            each individual at 1 January 1860. The statistical implication (description) of left truncation is that its presence
  
            forces the analysis to be conditional on survival up to the age enter.
            
            When an individual is lost to follow-up, we say that she is right censored; see
  
            Figure 1.2. As indicated in Figure 1.2, the true age at death is T , but due to
  
            right censoring, the only information available is that death age T is larger
  
            than C. The number C is the age at which this individual was last seen. In
  
            ordinary, classical regression analysis, such data are difficult, if not impossible,
  
            to handle. Discarding such information may introduce bias. The modern
  
            theory of survival analysis offers simple ways to deal with right-censored data.
  
            A natural question to ask is: If there is right censoring, there should be
  
            something called left censoring, and if so, what is it? The answer to that is
  
            that yes, left censoring refers to a situation where the only thing known about
  
            a death age is that it is less than a certain value C. Note carefully that this
  
            is different from left truncation; see the next section.
            
            The concept of left truncation, or delayed entry, is well illustrated by the
  
            data set oldmort that was discussed in detail in Section 1.2. Please note the
  
            difference compared to left censoring. Unfortunately, you may still see articles
  
            where these two concepts are confused.
  
            It is illustrative to think of the construction of the data set oldmort as a
  
            statistical follow-up study, starting on 1 January 1860. At that day, all persons
  
            present in the parish and 60 years of age or above, are included in the study.
  
            It is decided that the study will end at 31 December 1879; that is, the study
  
            period (follow-up time) is 20 years. The interesting event in this study is death.
  
            This means that the start event is the sixtieth anniversary of birth, and the
  
            final event is death. Due to the calendar time constraints (and migration), all
  
            individuals will not be observed to die (especially those who live long), and
  
            moreover, some individuals will enter the study after the “starting” event, the
  
            sixtieth anniversary. A person who entered late—say he is 65 on January 1,
  
            1860—would not have been included had he died at age 63 (say). Therefore,
  
            in the analysis, we must condition on the fact that he was alive at 65. Another
  
            way of putting this is to say that this observation is left truncated at age 65.
  
            People being too young at the start date will be included from the day
  
            they reach 60, if that happens before the closing date, 31 December 1879.
  
            They are not left truncated, but will have a higher and higher probability of
  
            being right censored, the later they enter the study.
            
            [<img border="0" src="http://ws-na.amazon-adsystem.com/widgets/q?_encoding=UTF8&#038;ASIN=1439831645&#038;Format=_SL110_&#038;ID=AsinImage&#038;MarketPlace=US&#038;ServiceVersion=20070822&#038;WS=1&#038;tag=exegetanalyt-20" />][6]<img src="http://ir-na.amazon-adsystem.com/e/ir?t=exegetanalyt-20&#038;l=as2&#038;o=1&#038;a=1439831645" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />

 [1]: http://www.amazon.com/gp/product/1439831645/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=1439831645&linkCode=as2&tag=exegetanalyt-20&linkId=2TFHNRQ7SHCQT6HJ
 [2]: https://gramps-project.org/
 [3]: http://162.243.184.248/wp-content/uploads/2015/04/individuals-time-line.png
 [4]: http://cran.mirror.ac.za/web/packages/eha/index.html
 [5]: http://162.243.184.248/wp-content/uploads/2015/04/window-count.png
 [6]: http://www.amazon.com/gp/product/1439831645/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=1439831645&linkCode=as2&tag=exegetanalyt-20&linkId=DLKC4CJ2KMDI26UR
