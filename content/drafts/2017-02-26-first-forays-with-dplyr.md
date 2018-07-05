---
draft: true
title: First Forays with dplyr
author: andrew
type: post
date: 2017-02-26T08:23:23+00:00
categories:
  - R
tags:
  - dplyr
  - plyr
  - R

---
Order of operations should be something like: filter -> group_by -> summarise -> arrange

http://rstudio-pubs-static.s3.amazonaws.com/11068_8bc42d6df61341b2bed45e9a9a3bf9f4.html

http://www.dataschool.io/dplyr-tutorial-for-faster-data-manipulation-in-r/

http://cran.r-project.org/web/packages/dplyr/vignettes/window-functions.html

[dplyr 0.4.0][1]

Having been an ardent user of the plyr package, I&#8217;ve been remarkably slack in trying out its new and improved successor, dplyr. I have been a fan of plyr because of the way that it eased made many complex data manipulations. This functionality has been retained in dplyr, with the addition of some more data manipulation tools as well as seriously improved speed.

I based my learning on the [Introduction to dplyr][2] tutorial, which appears to be kept up to date with new features as the package evolves. Since this evolution appears to still be happening quite briskly, I&#8217;ll point out that this article is based on dplyr version 0.4.1. There are a host of other good introductory articles on dplyr around too.

The functionality in dplyr is expressed as a number of appropriately chosen verbs. I&#8217;ll run through those in a slightly different order to the tutorial using the Motor Trend Car Road Tests (mtcars) data set for illustrative purposes.

Before we get started we&#8217;ll need to load the package.

[code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
> library(dplyr)
  


And we&#8217;ll have a quick look at the data.

[code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
> head(mtcars)
                     
mpg cyl disp hp drat wt qsec vs am gear carb
  
Mazda RX4 21.0 6 160 110 3.90 2.620 16.46 0 1 4 4
  
Mazda RX4 Wag 21.0 6 160 110 3.90 2.875 17.02 0 1 4 4
  
Datsun 710 22.8 4 108 93 3.85 2.320 18.61 1 1 4 1
  
Hornet 4 Drive 21.4 6 258 110 3.08 3.215 19.44 1 0 3 1
  
Hornet Sportabout 18.7 8 360 175 3.15 3.440 17.02 0 0 3 2
  
Valiant 18.1 6 225 105 2.76 3.460 20.22 1 0 3 1
  
> dim(mtcars)
  
[1] 32 11
  


## Taking a Glimpse

[code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
> glimpse(mtcars)
  
Observations: 32
  
Variables:
  
$ mpg (dbl) 21.0, 21.0, 22.8, 21.4, 18.7, 18.1, 14.3, 24.4, 22.8, 19.2, 17.8, 16.4, 17.3, 15.2, 10.4, 10.4, &#8230;
  
$ cyl (dbl) 6, 6, 4, 6, 8, 6, 8, 4, 4, 6, 6, 8, 8, 8, 8, 8, 8, 4, 4, 4, 4, 8, 8, 8, 8, 4, 4, 4, 8, 6, 8, 4
  
$ disp (dbl) 160.0, 160.0, 108.0, 258.0, 360.0, 225.0, 360.0, 146.7, 140.8, 167.6, 167.6, 275.8, 275.8, 275.8&#8230;
  
$ hp (dbl) 110, 110, 93, 110, 175, 105, 245, 62, 95, 123, 123, 180, 180, 180, 205, 215, 230, 66, 52, 65, 97&#8230;
  
$ drat (dbl) 3.90, 3.90, 3.85, 3.08, 3.15, 2.76, 3.21, 3.69, 3.92, 3.92, 3.92, 3.07, 3.07, 3.07, 2.93, 3.00, &#8230;
  
$ wt (dbl) 2.620, 2.875, 2.320, 3.215, 3.440, 3.460, 3.570, 3.190, 3.150, 3.440, 3.440, 4.070, 3.730, 3.780&#8230;
  
$ qsec (dbl) 16.46, 17.02, 18.61, 19.44, 17.02, 20.22, 15.84, 20.00, 22.90, 18.30, 18.90, 17.40, 17.60, 18.00&#8230;
  
$ vs (dbl) 0, 0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1
  
$ am (dbl) 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1
  
$ gear (dbl) 4, 4, 4, 3, 3, 3, 3, 4, 4, 4, 4, 3, 3, 3, 3, 3, 3, 4, 4, 4, 3, 3, 3, 3, 3, 4, 5, 5, 5, 5, 5, 4
  
$ carb (dbl) 4, 4, 1, 1, 2, 1, 4, 2, 2, 4, 4, 3, 3, 3, 4, 4, 4, 1, 2, 1, 1, 2, 2, 4, 2, 1, 2, 2, 4, 6, 8, 2
  


[code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
> str(mtcars)
  
&#8216;data.frame&#8217;: 32 obs. of 11 variables:
   
$ mpg : num 21 21 22.8 21.4 18.7 18.1 14.3 24.4 22.8 19.2 &#8230;
   
$ cyl : num 6 6 4 6 8 6 8 4 4 6 &#8230;
   
$ disp: num 160 160 108 258 360 &#8230;
   
$ hp : num 110 110 93 110 175 105 245 62 95 123 &#8230;
   
$ drat: num 3.9 3.9 3.85 3.08 3.15 2.76 3.21 3.69 3.92 3.92 &#8230;
   
$ wt : num 2.62 2.88 2.32 3.21 3.44 &#8230;
   
$ qsec: num 16.5 17 18.6 19.4 17 &#8230;
   
$ vs : num 0 0 1 1 0 1 0 1 1 1 &#8230;
   
$ am : num 1 1 1 0 0 0 0 0 0 0 &#8230;
   
$ gear: num 4 4 4 3 3 3 3 4 4 4 &#8230;
   
$ carb: num 4 4 1 1 2 1 4 2 2 4 &#8230;
  


## Filtering

[code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
> filter(mtcars, am == 1)
      
mpg cyl disp hp drat wt qsec vs am gear carb
  
1 21.0 6 160.0 110 3.90 2.620 16.46 0 1 4 4
  
2 21.0 6 160.0 110 3.90 2.875 17.02 0 1 4 4
  
3 22.8 4 108.0 93 3.85 2.320 18.61 1 1 4 1
  
4 32.4 4 78.7 66 4.08 2.200 19.47 1 1 4 1
  
5 30.4 4 75.7 52 4.93 1.615 18.52 1 1 4 2
  
6 33.9 4 71.1 65 4.22 1.835 19.90 1 1 4 1
  
7 27.3 4 79.0 66 4.08 1.935 18.90 1 1 4 1
  
8 26.0 4 120.3 91 4.43 2.140 16.70 0 1 5 2
  
9 30.4 4 95.1 113 3.77 1.513 16.90 1 1 5 2
  
10 15.8 8 351.0 264 4.22 3.170 14.50 0 1 5 4
  
11 19.7 6 145.0 175 3.62 2.770 15.50 0 1 5 6
  
12 15.0 8 301.0 335 3.54 3.570 14.60 0 1 5 8
  
13 21.4 4 121.0 109 4.11 2.780 18.60 1 1 4 2
  


The first thing you&#8217;ll notice there is that the row names have disappeared. This is apparently by design. We&#8217;ll probably want to hang onto those names though since they will make the analysis more meaningful. To do this we just create a column with the row names.

[code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
mtcars$name <- rownames(mtcars)
  


[code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
> filter(mtcars, gear == 4 & carb == 4)
     
mpg cyl disp hp drat wt qsec vs am gear carb name
  
1 21.0 6 160.0 110 3.90 2.620 16.46 0 1 4 4 Mazda RX4
  
2 21.0 6 160.0 110 3.90 2.875 17.02 0 1 4 4 Mazda RX4 Wag
  
3 19.2 6 167.6 123 3.92 3.440 18.30 1 0 4 4 Merc 280
  
4 17.8 6 167.6 123 3.92 3.440 18.90 1 0 4 4 Merc 280C
  
>
  
> filter(mtcars, hp >250 | disp < 100)
     
mpg cyl disp hp drat wt qsec vs am gear carb name
  
1 32.4 4 78.7 66 4.08 2.200 19.47 1 1 4 1 Fiat 128
  
2 30.4 4 75.7 52 4.93 1.615 18.52 1 1 4 2 Honda Civic
  
3 33.9 4 71.1 65 4.22 1.835 19.90 1 1 4 1 Toyota Corolla
  
4 27.3 4 79.0 66 4.08 1.935 18.90 1 1 4 1 Fiat X1-9
  
5 30.4 4 95.1 113 3.77 1.513 16.90 1 1 5 2 Lotus Europa
  
6 15.8 8 351.0 264 4.22 3.170 14.50 0 1 5 4 Ford Pantera L
  
7 15.0 8 301.0 335 3.54 3.570 14.60 0 1 5 8 Maserati Bora
  


## Sorting

[code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
> head(arrange(mtcars, cyl))
     
mpg cyl disp hp drat wt qsec vs am gear carb name
  
1 22.8 4 108.0 93 3.85 2.320 18.61 1 1 4 1 Datsun 710
  
2 24.4 4 146.7 62 3.69 3.190 20.00 1 0 4 2 Merc 240D
  
3 22.8 4 140.8 95 3.92 3.150 22.90 1 0 4 2 Merc 230
  
4 32.4 4 78.7 66 4.08 2.200 19.47 1 1 4 1 Fiat 128
  
5 30.4 4 75.7 52 4.93 1.615 18.52 1 1 4 2 Honda Civic
  
6 33.9 4 71.1 65 4.22 1.835 19.90 1 1 4 1 Toyota Corolla
  


Additional arguments can be used to break ties.

[code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
> head(arrange(mtcars, cyl, desc(wt)))
     
mpg cyl disp hp drat wt qsec vs am gear carb name
  
1 24.4 4 146.7 62 3.69 3.190 20.00 1 0 4 2 Merc 240D
  
2 22.8 4 140.8 95 3.92 3.150 22.90 1 0 4 2 Merc 230
  
3 21.4 4 121.0 109 4.11 2.780 18.60 1 1 4 2 Volvo 142E
  
4 21.5 4 120.1 97 3.70 2.465 20.01 1 0 3 1 Toyota Corona
  
5 22.8 4 108.0 93 3.85 2.320 18.61 1 1 4 1 Datsun 710
  
6 32.4 4 78.7 66 4.08 2.200 19.47 1 1 4 1 Fiat 128
  


## Selecting (Distinct) Records

[code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
> slice(select(mtcars, cyl, gear), 1:10)
     
cyl gear
  
1 6 4
  
2 6 4
  
3 4 4
  
4 6 3
  
5 8 3
  
6 6 3
  
7 8 3
  
8 4 4
  
9 4 4
  
10 6 4
  


Lots of replication there. No problem though, we can easily retain only the distinct records.

[code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
> distinct(select(mtcars, cyl, gear))
    
cyl gear
  
1 6 4
  
2 4 4
  
3 6 3
  
4 8 3
  
5 4 3
  
6 4 5
  
7 8 5
  
8 6 5
  


## 

[code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  


## 

[code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  


 [1]: http://blog.rstudio.org/2015/01/09/dplyr-0-4-0/
 [2]: http://cran.r-project.org/web/packages/dplyr/vignettes/introduction.html
