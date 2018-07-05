---
draft: true
title: 'Sportsbook Betting (Part 3): Handicap'
author: andrew
type: post
date: 2017-02-26T08:22:25+00:00
categories:
  - Uncategorized

---
http://www.bettingon.com/rugby
  
http://blog.hollywoodbets.net/2012/03/rugby-handicap-betting-explanation-how.html

http://kenstange.com/psycsiteannex/GamblingAndPsychology/sports3.htm

handicap also known as points spread

<div class="example">
  <h3>
    Example: Scotland versus Japan
  </h3>
  
  <p>
    Suppose that a bookmaker was offering 4/1 odds for Japan to beat Scotland in Rugby. The same bookmaker is offering 1/4 odds for Scotland to beat Japan. The corresponding decimal odds are 5 and 1.25 respectively. The corresponding implied probabilities are 20% and 80%.
  </p>
  
  <p>
    Suppose that a gambler places a wager of 10 on Japan. If Scotland wins then he will forfeit his wager. If, however, Japan wins then he&#8217;ll receive a total payout of 50 (including the initial stake). There are thus two possible outcomes: a net loss of 10 or a net win of 40. Taking into account the implied relative probabilities of these two outcomes, the <i>expected</i> return on the wager is zero.
  </p>
  
  <p>
    [code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]<br /> > -10 * 0.8 + 40 * 0.2<br /> [1] 0<br /> [/code]
  </p>
  
  <p>
    Suppose, on the other hand, that the gambler places a wager of 10 on Scotland. If Japan wins then he will forfeit his wager. But, if Scotland wins then he&#8217;ll receive a total payout of 12.50 (including the initial stake). The two possible outcomes are then a net loss of 10 or a net win of 2.50. Again, the <i>expected</i> return on the wager is zero.
  </p>
  
  <p>
    [code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]<br /> > -10 * 0.2 + 2.50 * 0.8<br /> [1] 0<br /> [/code]
  </p>
</div>
