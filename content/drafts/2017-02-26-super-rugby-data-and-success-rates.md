---
draft: true
title: 'Super Rugby: Data and Success Rates'
author: andrew
type: post
date: 2017-02-26T08:23:22+00:00
categories:
  - Uncategorized

---
I&#8217;ve recently read a number of analyses of sports data, covering a variety of sports. The most frequently considered sport was Baseball. I&#8217;m not quite sure why this is. I would have guessed a priori that Football would be the most often discussed. I would have been wrong. Somehow [Rugby][1] seems to have completely escaped the spotlight. Let&#8217;s put that right.

We&#8217;ll focus our attention on the [Super Rugby][2] tournament, which involves teams from South Africa, New Zealand and Australia. Historical Super Rugby data are available from [Australia Sports Betting][3].

The original data have a single record for each game (which makes complete sense!), with the teams allocated to either a _home_ or _away_ field. It turns out that this is not very convenient for analysis because it introduces an asymmetry between the teams. So I embarked on a small munging mission to get things into a more workable format. The resulting data looks like this:

[code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
> head(rugby)
    
year month date time team opponent team\_score opponent\_score home score_diff win draw
  
1 2015 6 2015-06-06 17.083 Stormers Lions 19 19 TRUE 0 FALSE TRUE
  
2 2015 6 2015-06-06 17.083 Lions Stormers 19 19 FALSE 0 FALSE TRUE
  
3 2015 6 2015-06-06 15.000 Cheetahs Waratahs 33 58 TRUE -25 FALSE FALSE
  
4 2015 6 2015-06-06 15.000 Waratahs Cheetahs 58 33 FALSE 25 TRUE FALSE
  
5 2015 6 2015-06-06 19.667 Reds Chiefs 3 24 TRUE -21 FALSE FALSE
  
6 2015 6 2015-06-06 19.667 Chiefs Reds 24 3 FALSE 21 TRUE FALSE
  
> tail(rugby)
       
year month date time team opponent team\_score opponent\_score home score_diff win draw
  
1595 2009 2 2009-02-13 19.167 Lions Cheetahs 34 28 TRUE 6 TRUE FALSE
  
1596 2009 2 2009-02-13 19.167 Cheetahs Lions 28 34 FALSE -6 FALSE FALSE
  
1597 2009 2 2009-02-13 19.750 Force Blues 19 25 TRUE -6 FALSE FALSE
  
1598 2009 2 2009-02-13 19.750 Blues Force 25 19 FALSE 6 TRUE FALSE
  
1599 2009 2 2009-02-13 19.583 Highlanders Brumbies 31 33 TRUE -2 FALSE FALSE
  
1600 2009 2 2009-02-13 19.583 Brumbies Highlanders 33 31 FALSE 2 TRUE FALSE
  


 [1]: http://en.wikipedia.org/wiki/Rugby_union
 [2]: http://en.wikipedia.org/wiki/Super_Rugby
 [3]: http://www.aussportsbetting.com/data/historical-super-rugby-results-and-odds-data/
