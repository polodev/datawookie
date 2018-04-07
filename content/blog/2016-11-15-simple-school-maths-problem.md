---
author: Andrew B. Collier
date: 2016-11-15T13:21:02Z
title: Simple School Maths Problem
---

A simple problem sent through to me by one of my running friends:

> There are 6 red cards and 1 black card in a box. Busi and Khanha take turns to draw a card at random from the box, with Busi being the first one to draw. The first person who draws the black card will win the game (assume that the game can go on indefinitely). If the cards are drawn with replacement, determine the probability that Khanya will win, showing all working. 

The problem was posed to matric school pupils and allocated 7 marks (which translates into 7 minutes).

## Per Game Analysis

Every time somebody plays the game they have a 1 in 7 chance of winning. The fact that the cards are drawn with replacement means that every time the game is played the odds are precisely the same.

## Series of Games

Busi plays first. On her first try she has a 1/7 probability of winning.

Khanha plays next. Her probability of winning is 6/7 * 1/7, where 6/7 is the probability that Busi did not win perviously and 1/7 is the probability that Khanha wins on her first try.

The next time that Busi plays her probability of winning is 6/7 * 6/7 * 1/7, where the first 6/7 is the probability that she did not win on her first try and the second 6/7 is the probability that Khanha didn’t win on the previous round either.

The process continues…

In the end the probability that Busi wins is
  
{{< highlight text >}}
1/7 + (6/7 * 6/7) * 1/7 + (6/7 * 6/7)^2 * 1/7 + (6/7 * 6/7)^3 * 1/7 + …
{{< /highlight >}}
  
This is an infinite [geometric series](https://en.wikipedia.org/wiki/Geometric_series). We’ll simplify it a bit:
  
{{< highlight text >}}
1/7 * [1 + (6/7 * 6/7) + (6/7 * 6/7)^2 + (6/7 * 6/7)^3 + …]
= 1/7 * [1 + r + r^2 + r^3 + …]
= 1/7 * [1 / (1-r)]
= 1/7 * [49/13]
= 0.5384615
{{< /highlight >}}
  
where r = 6/7 * 6/7 = 36/49.

What about the probability that Khanha wins? By similar reasoning this is
  
{{< highlight text >}}
6/7 * 1/7 + (6/7 * 6/7) * 6/7 * 1/7 + (6/7 * 6/7)^2 * 6/7 * 1/7 + (6/7 * 6/7)^3 * 6/7 * 1/7 + …
= 6/7 * 1/7 * [1 + (6/7 * 6/7) + (6/7 * 6/7)^2 + (6/7 * 6/7)^3 + …]
= 6/49 * [49/13]
= 0.4615385
{{< /highlight >}}

Importantly those two probabilities sum to one: 0.5384615 + 0.4615385 = 1.

The required answer would be 0.4615385. The calculation for Busi would not be necessary, but I've included it for completeness.

## Conclusion

Although every time they play the game either player has the same chance of winning, because Busi plays first she has a greater chance of winning overall (simply by virtue of the fact that she plays _before_ her opponent). By the same token, Khanha playing second puts her at a slight disadvantage. If both players played at the same time (for example, each drawing from their own box) then the probability would be 0.5 for both of them. The sequence of play puts Khanha at a slight disadvantage.

Note that Busi's edge gets smaller as the number of red cards in the box increases. This is because her probability of winning on every game gets smaller and so the "first play" advantage weakens.

It seems like a fairly challenging problem for matric maths. Especially for only 7 marks. Having said that, the fact that they are attacking these sorts of problems in school maths is great. We never did anything this practical when I was at school.
