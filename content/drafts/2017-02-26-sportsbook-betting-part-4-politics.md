---
draft: true
title: 'Sportsbook Betting (Part 4): Politics'
author: andrew
type: post
date: 2017-02-26T08:22:25+00:00
categories:
  - Uncategorized

---
https://www.predictit.org/

<div class="example">
  <h3>
    Example: US Presidential Election
  </h3>
  
  <p>
    Lets&#8217;s have a look at the odds on the <a href="http://www.oddschecker.com/politics/us-politics/us-presidential-election-2016/winner">US<br /> Presidential Election</a>.
  </p>
  
  <p>
    [code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]<br /> > elections[, 1:8]<br /> Stan James Sky Bet Bwin Sportingbet Paddy Power Bet Victor Bet 365 Boylesports<br /> Hillary Clinton 1/3 1/3 4/11 3/10 3/10 3/10 1/3 1/3<br /> Donald Trump 9/4 11/4 9/4 11/4 11/4 11/5 13/5 11/4<br /> Bernie Sanders 25/1 25/1 33/1 33/1 25/1 22/1 22/1<br /> Joe Biden 40/1 50/1 50/1 50/1 33/1 33/1<br /> Paul Ryan 150/1 100/1 100/1 66/1<br /> Gary Johnson 100/1 250/1 100/1 200/1 100/1<br /> John Kasich<br /> Mitt Romney 250/1 200/1 150/1<br /> [/code]
  </p>
  
  <p>
    [code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]<br /> > sort(colSums(probability, na.rm = TRUE))<br /> Stan James Sky Bet Bwin Sportingbet Paddy Power<br /> 1.0577 1.0894 1.0991 1.0995 1.1047<br /> Bet Victor Bet 365 Boylesports Ladbrokes 188Bet<br /> 1.1202 1.1205 1.1210 1.1225 1.1236<br /> Betfair Sportsbook Coral Marathon Bet 888sport 32Red Bet<br /> 1.1315 1.1328 1.1368 1.1381 1.1489<br /> Winner Totesport Betfred Betdaq William Hill<br /> 1.1503 1.1507 1.1507 1.1851 1.1875<br /> Matchbook<br /> 1.3176<br /> [/code]
  </p>
</div>
