---
author: Andrew B. Collier
date: 2016-08-10T15:00:59Z
tags: ["R", "Gambling"]
title: 'Sportsbook Betting (Part 2): Bookmakers'' Odds'
---

In the [first instalment](http://www.exegetic.biz/blog/2016/08/sportsbook-odds/) of this series we gained an understanding of the various types of odds used in Sportsbook betting and the link between those odds and implied probabilities. We noted that the implied probabilities for all possible outcomes in an event may sum to more than 100%. At first sight these seems a bit odd. It certainly appears to violate the basic principles of statistics. However, this anomaly is the mechanism by which bookmakers assure their profits. A similar principle applies in a casino.

## Casino House Edge

Because the true probabilities of each outcome in casino games are well defined, this is a good place to start. In a casino game a winning wager receives a payout which is not quite consistent with the game's true odds (how this is achieved varies from game to game). As a result, casino games are not "fair" from a gambler's perspective. If they were, then a casino would not be a very profitable enterprise! Instead every casino game is slightly biased in favour of the house. On each round a gambler still stands a chance of winning. However, over time, the effect of this bias accumulates and the gambler inevitably loses money.

Let's look at a couple of examples. We'll start with a super simple game.

### Example: Rolling a Dice

Consider a dice game in which the player wins if the dice lands on six. The odds for this game are 5/1 and the player would expect to receive 5 times his wager if he won.

{{< highlight r >}}
> odds.fractional = c(win = 5/1, lose = 1/5)
> (odds.decimal = odds.fractional + 1)
 win lose
 6.0  1.2
> (probability = 1 / odds.decimal)
     win    lose
 0.16667 0.83333
{{< /highlight >}}

The probability of winning is 1/6. Would a gambler expect to profit if he played this game many times?

{{< highlight r >}}
> payout = c(5, -1)
> sum(probability * payout)
[1] 0.00
{{< /highlight >}}

No! In the long run neither the gambler nor the casino would make money on a game like this. It's a fair game: neither the house nor the gambler has any statistical advantage or "edge".

If, however, the house paid out only 4 times the wager then the player's expected profit would become

{{< highlight r >}}
> payout = c(4, -1)
> sum(probability * payout)
[1] -0.16667
{{< /highlight >}}

Now the game is stacked in favour of the house, since on average the player would expect to lose around 17% of his stake. Of course, on any one game the gambler would either win 4 times his stake or lose the entire stake. However, if he played the game many times then on average he would lose 17% of his stake per game.

The game outlined above would not represent a very attractive proposition for a gambler. Obviously a casino could not afford to be this greedy and the usual house edge in any casino game is substantially smaller. Let's move on to a real casino game.

### Example: European Roulette

<!-- http://wizardofodds.com/gambling/house-edge/ -->

A European <a href="https://en.wikipedia.org/wiki/Roulette">Roulette</a> wheel has one zero and 36 non-zero numbers (18 odd and 18 even; 18 red and 18 black), making a total of 37 positions. Consider a wager on even numbers. The number of losing outcomes is 19 (the zero is treated as neither odd nor even: it's the "house number"!), while number of winning outcomes is 18. So the odds against are 19/18.

{{< highlight r >}}
> odds.fractional = c(win = 19/18, lose = 18/19)
> (odds.decimal = odds.fractional + 1)
    win   lose
 2.0556 1.9474
> (probability = 1 / odds.decimal)
     win    lose
 0.48649 0.51351
{{< /highlight >}}

The probability of winning is 18/(19+18) = 18/37 = 0.48649. So this is <em>almost</em> an even money game.

Based on a wager of 1 coin, a win would result in a net profit of 1 coin, while a loss would forfeit the stake. The player's expected outcome is then

{{< highlight r >}}
> payout = c(1, -1)
> sum(probability * payout)
[1] -0.027027
{{< /highlight >}}

The house edge is 2.70%. On average a gambler would lose 2.7% of his stake per game. Of course, on any one game he would either win or lose, but this is the <em>long term</em> expectation. Another way of looking at this is to say that the Return To Player (RTP) is 97.3%, which means that on average a gambler would get back 97.3% of his stake on every game.

Below are the results of a simulation of 100 gamblers betting on even numbers. Each starts with an initial capital of 100. The red line represents the average for the cohort. After 1000 games two gamblers have lost all of their money. Of the remaining 98 players, only 24 have made money while the rest have lost some portion of their initial capital.

<img src="/img/2016/08/roulette-odd-simulation.png" >

The code for this simulation is available <a href="https://github.com/DataWookie/gambleR/blob/master/scripts/simulate-roulette.R">here</a>.

## Over-round, Vigorish and Juice

A bookmaker will aim to achieve an overall profit regardless of the outcome of the event. The general approach to doing this is to offer odds which are less than the true odds. As a result the payout on a successful wager is less than what would be mathematically dictated by the true odds. Because of the reciprocal relationship between odds and implied probabilities, this means that the corresponding implied probabilities are inflated. The margin by which the implied probabilities exceed 100% is known as the "over-round" (also <a href="https://en.wikipedia.org/wiki/Vigorish">vigorish</a> or juice). The over-round determines the profit margin of the bookmaker. Bookmakers with a lower over-round also have a lower profit margin and hence offer a more equitable proposition to gamblers.

<blockquote>
Since sports betting involves humans, there is no deterministic edge to the house or the gambler.
</blockquote>

It's useful to consider what we mean by "true odds" in the context of Sportsbook. Clearly for a casino game these odds can be calculated precisely (though with various degrees of difficulty, depending on the game). However, in Sportsbook the actual odds of each outcome cannot be known with great precision. This is simply a consequence of the fact that the events involve humans, and we are notoriously unpredictable.

Do bookmakers even care about the true odds? Not really. They are mostly just interested in offering odds which will provide them with an assured overall profit on an event.

There are a <a href="http://stats.stackexchange.com/questions/29828/how-do-betting-houses-determine-betting-odds-for-sports">number of factors</a> which contribute to determining the odds used in Sportsbook. Obviously there's serious domain knowledge involved in deriving the <em>initial</em> odds on offer. But over time these odds should evolve to take into account the overall distribution of bets placed on the various outcomes (something like the <a href="https://en.wikipedia.org/wiki/Wisdom_of_the_crowd">wisdom of the crowd</a>). It has been suggested that, as a result, Sportsbook odds are similar to an <a href="https://en.wikipedia.org/wiki/Efficient-market_hypothesis">efficient market</a>. Specifically, the distribution of wagers affect the odds, with the odds on the favourite get smaller while those on the underdog(s) get larger. Eventually the odds will settle at values which reflect the market's perceived probability of the outcome of the event.

<!-- This seems to be used in a number of places. I copied it from 10.1111/j.1468-0297.2004.00207.x. Original source unknown. -->

<blockquote>
Rather, the odds are designed so that equal money is bet on both sides of the game. If more money is bet on one of the teams, the sports book runs the risk of losing money if that team were to win.
</blockquote>

### Example: Horse Racing a Round Book

A bookmaker is offering fractional odds of 4/1 (or 5 decimal odds) on each horse in a five horse race. The implied probability of each horse winning is 20%. If the bookmaker accepted the same volume of wagers on each horse then he would not make any money since the implied probabilities sum to 100%. This is known as a "round" book.

From a gambler's perspective, a wager of 10 on any one of the horses would have an expected return of zero. From the bookmaker's perspective, if he accepted 100 in wagers on each horse, then he would profit 400 on the losing horses and pay out 400 on the winning horse, yielding zero net profit.

Since the expected return is zero, this represents a fair game. However, such odds would never obtain in practice: the bookmaker always stands to make money. Enter the over-round.

### Example: Horse Racing with Over-Round

If the bookmaker offered fractional odds of 3/1 (or 4.0) on each horse, then the implied probabilities would change from 20% to 25%. Summing the implied probabilities gives 125%, which is 25% over-round.

Suppose that the bookmaker accepted 100 in wagers on each horse, then he would profit 400 on the losing horses and pay out only 300 on the winning horse, yielding a net profit of 100.

Enough hypothetical examples, let's look at something real.

### Example: Champions League

It's been suggested that football squad prices can influence Sportsbook odds. Often the richer the franchise, the more likely it is that a club will prevail in the sport. This is supposed to be particularly true in European club football. We'll try to validate this idea by scraping the <a href="https://en.wikipedia.org/wiki/Forbes%27_list_of_the_most_valuable_football_clubs">data provided by Forbes</a> for football club values.

{{< highlight r >}}
> library(rvest)
> library(dplyr)
> clubs <- read_html("http://bit.ly/2aDa3ad") %>%
+   html_nodes("table") %>% .[[1]] %>% html_table() %>% .[, c(2, 3, 4, 7)] %>%
+   setNames(c("team", "country", "value", "revenue")) %>%
+   mutate(
+     value = as.integer(sub(",", "", value)),
+     team = gsub("\\.", "", clubs$team)
+     )
> head(clubs)
               team country value revenue
1       Real Madrid   Spain  3650     694
2         Barcelona   Spain  3320     570
3 Manchester United England  3315     645
4     Bayern Munich Germany  2680     675
5           Arsenal England  2020     524
6   Manchester City England  1920     558
{{< /highlight >}}

Well, those tabular data are great, but a visualisation would be helpful to make complete sense of the relationship between team value and revenue.

<img src="/img/2016/07/football-club-values.png" >

It's apparent that Real Madrid, Barcelona, Manchester United and <a href="http://www.forbes.com/pictures/mli45fdkgi/11-bayern-munich/#6738eb7b2b4f">Bayern Munich</a> are the four most expensive teams. There's a general trend of increasing revenue with increasing value. Two conspicuous exceptions are Schalke 04 and Paris Saint-Germain, which produce revenues far higher than expected based on their values.

Although not reflected in the plot above, there's a relationship between the value of the team and its performance. With only a few exceptions the previously mentioned four teams have <a href="http://www.topendsports.com/sport/soccer/list-league-uefa.htm">dominated the Champions League in recent years</a>. Does this make sense? The richest teams are able to attract the most talented players. The resulting pool of talent increases their chances of winning. This in turn translates into revenue and the cycle is complete.

We'll grab the bookmakers' odds for the Champions League.

{{< highlight r >}}
> library(gambleR)
> champions.league = oddschecker("football/champions-league/winner")
> head(champions.league[, 11:18])
              Ladbrokes Coral William Hill Winner Betfair Sportsbook BetBright Unibet Bwin
Barcelona           3/1   3/1         10/3    3/1                3/1       7/2    3/1 10/3
Bayern Munich       4/1   5/1          4/1    4/1                4/1       4/1    9/2  4/1
Real Madrid         5/1   5/1          4/1    9/2                9/2       9/2    5/1  5/1
Man City           12/1  12/1         11/1   10/1               10/1      12/1   12/1 12/1
Juventus           12/1  14/1         12/1   12/1               10/1      14/1    8/1 12/1
PSG                14/1  14/1         14/1   14/1               14/1      14/1   12/1 14/1
{{< /highlight >}}

According to the selection of bookmakers above, Barcelona, Bayern Munich and Real Madrid are the major contenders in this competition. Betfair Sportsbook has <a href="https://www.betfair.com/exchange/football">Barcelona edging the current champions Real Madrid</a> as favourites to win the competition. Bayern Munich and Real Madrid have slightly higher odds, with Bayern Munich perceived as the second most likely winner.

The decimal odds on offer at Betfair Sportsbook are

{{< highlight r >}}
> champions.decimal[, 15]
        Barcelona     Bayern Munich       Real Madrid          Man City          Juventus 
              4.0               5.0               5.5              11.0              11.0 
              PSG   Atletico Madrid          Dortmund           Arsenal           Sevilla 
             15.0              17.0              26.0              26.0              51.0 
        Tottenham            Napoli         Leicester              Roma           Benfica 
             41.0              67.0              67.0             101.0             101.0 
            Porto  Bayer Leverkusen        Villarreal   Monchengladbach              Lyon 
            151.0              67.0             101.0             151.0             201.0 
              PSV   Sporting Lisbon       Dynamo Kiev          Besiktas             Basel 
            201.0             201.0             251.0             251.0             301.0 
      Club Brugge            Celtic     FC Copenhagen     PAOK Saloniki Red Star Belgrade 
            501.0             501.0                NA                NA                NA 
         Salzburg 
               NA 
{{< /highlight >}}

The corresponding implied probabilities are

{{< highlight r >}}
> champions.probability[, 15]
        Barcelona     Bayern Munich       Real Madrid          Man City          Juventus 
        0.2500000         0.2000000         0.1818182         0.0909091         0.0909091 
              PSG   Atletico Madrid          Dortmund           Arsenal           Sevilla 
        0.0666667         0.0588235         0.0384615         0.0384615         0.0196078 
        Tottenham            Napoli         Leicester              Roma           Benfica 
        0.0243902         0.0149254         0.0149254         0.0099010         0.0099010 
            Porto  Bayer Leverkusen        Villarreal   Monchengladbach              Lyon 
        0.0066225         0.0149254         0.0099010         0.0066225         0.0049751 
              PSV   Sporting Lisbon       Dynamo Kiev          Besiktas             Basel 
        0.0049751         0.0049751         0.0039841         0.0039841         0.0033223 
      Club Brugge            Celtic     FC Copenhagen     PAOK Saloniki Red Star Belgrade 
        0.0019960         0.0019960                NA                NA                NA 
         Salzburg 
               NA
{{< /highlight >}}

These sum to 1.178, giving an over-round of 17.8%.

Let's focus on a football game between Anderlecht and Rostov. These are not major contenders, but they faced off last Saturday (3 August 2016), so the data are readily available.

### Example: Anderlecht versus Rostov

The odds for the football match between Anderlecht and Rostov are shown below.

<img src="/img/2016/08/betfair-anderlecht-rostov.png" >

The match odds are 2.0 for a win by Anderlecht, 4.1 for a win by Rostov and 3.55 for a draw. Let's convert those to the corresponding implied probabilities:

{{< highlight r >}}
> decimal.odds = c(anderlecht = 2.0, rostov = 4.1, draw = 3.55)
> 1 / decimal.odds
anderlecht     rostov       draw 
   0.50000    0.24390    0.28169 
{{< /highlight >}}

According to those odds the implied probabilities of each of the outcomes are 50%, 24.4% and 28.2% respectively.

{{< highlight r >}}
> sum(1 / decimal.odds)
[1] 1.0256
{{< /highlight >}}

Summing those probabilities gives an over-round of 2.6%, which is very competitive. However, including the 5% commission levied by Betfair, this increases to 7.6%.

Although Anderlecht were the favourites to win this game, it turns out that Rostov had a convincing victory.

<img src="/img/2016/08/anderlecht-rostov-result.png" >

The same principles apply when there are many possible outcomes for an event.

### Example: Horse Racing (18:20 at Stratford)

<!-- http://www.oddschecker.com/horse-racing/stratford/18:20/winner -->

I scraped the odds for the 18:20 race at Stratford on 28 June 2016 from <a href="http://www.oddschecker.com/">oddschecker</a>. Here are the data for nine bookmakers.

{{< highlight r >}}
> odds[, 1:9]
                 Bet Victor Betway Marathon Bet Betdaq Bet 365 Ladbrokes Sky Bet 10Bet 188Bet
Deauville Dancer        6/4   13/8         13/8    7/5     6/4       6/4     6/4   6/4    6/4
Cest Notre Gris         7/4    7/4          7/4    7/4     7/4       7/4     7/4   7/4    7/4
Ross Kitty             15/2    7/1          7/1   41/5     7/1       7/1     7/1   7/1    7/1
Amber Spyglass         12/1   12/1         12/1   68/5    12/1      12/1    11/1  11/1   11/1
Venture Lagertha       20/1   22/1         20/1   89/5    16/1      20/1    20/1  20/1   20/1
Lucky Thirteen         22/1   22/1         20/1   21/1    22/1      20/1    22/1  20/1   20/1
Overrider              25/1   20/1         25/1   22/1    25/1      20/1    22/1  22/1   22/1
Kims Ocean             28/1   25/1         25/1   21/1    22/1      25/1    28/1  25/1   25/1
Rizal Park             80/1   66/1         50/1   82/1    80/1      66/1    50/1  66/1   66/1
Chitas Gamble         250/1  200/1        100/1  387/1   250/1     125/1   125/1 150/1  150/1
Irish Ranger          250/1  200/1        100/1  387/1   250/1     150/1   125/1 150/1  150/1
{{< /highlight >}}

The decimal odds on offer at Bet Victor are

{{< highlight r >}}
> decimal.odds[,1]
Deauville Dancer  Cest Notre Gris       Ross Kitty   Amber Spyglass Venture Lagertha 
            2.50             2.75             8.50            13.00            21.00 
  Lucky Thirteen        Overrider       Kims Ocean       Rizal Park    Chitas Gamble 
           23.00            26.00            29.00            81.00           251.00 
    Irish Ranger 
          251.00 
{{< /highlight >}}

The corresponding implied probabilities are

{{< highlight r >}}
> probability[,1]
Deauville Dancer  Cest Notre Gris       Ross Kitty   Amber Spyglass Venture Lagertha 
       0.4000000        0.3636364        0.1176471        0.0769231        0.0476190 
  Lucky Thirteen        Overrider       Kims Ocean       Rizal Park    Chitas Gamble 
       0.0434783        0.0384615        0.0344828        0.0123457        0.0039841 
    Irish Ranger 
       0.0039841 
{{< /highlight >}}

The total implied probability per bookmaker is

{{< highlight r >}}
> sort(colSums(probability))
       Bet Victor            Betway       Marathon Bet            Betdaq           Bet 365 
           1.1426            1.1444             1.1581            1.1623            1.1701 
        Ladbrokes           Sky Bet              10Bet            188Bet         Netbet UK 
           1.1764            1.1765             1.1773            1.1773            1.1773 
      Boylesports            Winner       William Hill        Stan James           Betfair 
           1.1797            1.1861             1.1890            1.1895            1.1935 
            Coral          RaceBets Betfair Sportsbook         BetBright       Sportingbet 
           1.1964            1.2003             1.2173            1.2229            1.2288 
          Betfred         Totesport          32Red Bet          888sport       Paddy Power 
           1.2303            1.2303             1.2392            1.2392            1.2636 
{{< /highlight >}}

It's obvious that there is a wide range of value being offered by various bookmakers, extending from the competitive Bet Victor and Betway with an over-round of around 14% to the substantial over-round of 26% at Paddy Power.

From a gambler's point of view, the best value is obtained by finding the bookmaker who is offering the largest odds for a particular outcome. It's probable that this bookmaker will also have a relatively low over-round. Sites like <a href="http://www.oddschecker.com/">oddschecker</a> make it a simple matter to check the odds on offer from a range of bookmakers. If you have the time and patience it might even be possible to engage in <a href="https://en.wikipedia.org/wiki/Arbitrage_betting">betting arbitrage</a>.
