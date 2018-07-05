---
draft: true
title: Flipping a Shiny Coin
author: andrew
type: post
date: 2017-02-26T08:23:22+00:00
categories:
  - R
tags:
  - Bayesian Statistics
  - ggplot2
  - R
  - Shiny

---
I&#8217;m busy reading [Doing Bayesian Data Analysis: A Tutorial with R and BUGS][1] <img src="http://ir-na.amazon-adsystem.com/e/ir?t=exegetanalyt-20&#038;l=as2&#038;o=1&#038;a=0123814855" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />by John K. Kruschke.

I&#8217;ve just finished the chapter which discusses updating a beta prior using observations of a Bernoulli Process. To entrench my understanding I thought it would be helpful to have an interactive interface to experiment with these ideas. And Shiny seemed like the right tool for the job.

[code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  


[<img src="http://162.243.184.248/wp-content/uploads/2015/06/coin-flipping-beta.png" alt="coin-flipping-beta" width="783" height="600" class="aligncenter size-full wp-image-1539" srcset="http://162.243.184.248/wp-content/uploads/2015/06/coin-flipping-beta.png 783w, http://162.243.184.248/wp-content/uploads/2015/06/coin-flipping-beta-300x230.png 300w, http://162.243.184.248/wp-content/uploads/2015/06/coin-flipping-beta-768x589.png 768w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 984px) 61vw, (max-width: 1362px) 45vw, 600px" />][2]

WHERE HAS THE APPLICATION BEEN PUBLISHED??????????????????????????????????????

There are some things that would make this little project better.

I need to add some sanity checks into the server code to ensure that everything makes sense. For example, the number of successes should be less than the number of experiments. And both quantities should be greater than 0. And we should probably also make sure that they are both integers.

Getting those working will require me to address another problem though: what should happen in renderPlot() if we are unable to produce a new plot with the current parameters? I first encountered this when I deleted the numbers in either of the prior parameter fields. Suddenly my renderPlot() broke. So I have put checks in place to identify this situation and at least avoid an error. But what I would prefer to do would be to keep the current plot (is there a way of caching it?) and display an informative error message explaining why a given combination of parameters is not admissible. If anybody has ideas for a way to do this, please let me know.

Incidentally, I see that there is now a [second edition][3] <img src="http://ir-na.amazon-adsystem.com/e/ir?t=exegetanalyt-20&#038;l=as2&#038;o=1&#038;a=0124058884" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />of Kruschke&#8217;s book available, which also covers [Stan][4].

[<img border="0" src="http://ws-na.amazon-adsystem.com/widgets/q?_encoding=UTF8&#038;ASIN=0123814855&#038;Format=_SL110_&#038;ID=AsinImage&#038;MarketPlace=US&#038;ServiceVersion=20070822&#038;WS=1&#038;tag=exegetanalyt-20" />][5]<img src="http://ir-na.amazon-adsystem.com/e/ir?t=exegetanalyt-20&#038;l=as2&#038;o=1&#038;a=0123814855" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />[<img border="0" src="http://ws-na.amazon-adsystem.com/widgets/q?_encoding=UTF8&#038;ASIN=0124058884&#038;Format=_SL110_&#038;ID=AsinImage&#038;MarketPlace=US&#038;ServiceVersion=20070822&#038;WS=1&#038;tag=exegetanalyt-20" />][6]<img src="http://ir-na.amazon-adsystem.com/e/ir?t=exegetanalyt-20&#038;l=as2&#038;o=1&#038;a=0124058884" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />

 [1]: http://www.amazon.com/gp/product/0123814855/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=0123814855&linkCode=as2&tag=exegetanalyt-20&linkId=MSWSW7BWFOJY2QY5
 [2]: http://162.243.184.248/wp-content/uploads/2015/06/coin-flipping-beta.png
 [3]: http://www.amazon.com/gp/product/0124058884/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=0124058884&linkCode=as2&tag=exegetanalyt-20&linkId=XNDZJXCF2SIZVSQ4
 [4]: http://mc-stan.org/
 [5]: http://www.amazon.com/gp/product/0123814855/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=0123814855&linkCode=as2&tag=exegetanalyt-20&linkId=QAACFWXHWXF6DKXW
 [6]: http://www.amazon.com/gp/product/0124058884/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=0124058884&linkCode=as2&tag=exegetanalyt-20&linkId=QLI54XFSNXN744UC
