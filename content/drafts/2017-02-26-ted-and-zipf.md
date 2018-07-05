---
draft: true
title: TED and Zipf
author: andrew
type: post
date: 2017-02-26T08:23:33+00:00
categories:
  - Uncategorized

---
Zipf&#8217;s Law is a hyperbolic power law connecting word frequency ($f(r)$) to word rank ($r$):

\[ f(r) \approx \frac{1}{r \ln (1.78 R)}\]

where $R$ is the number of distinct words.

The 10 highest ranking words occupy what % of the text? (Should be in the order of 25%).

The essence of Zipf&#8217;s Law is that there are a few words which are used frequently (for example, &#8216;and&#8217; and &#8216;the&#8217;), while other words (like &#8216;veracity&#8217; and &#8216;wonderment&#8217;) which are only used infrequently. This can be compared with the distribution of earthquakes: minor earthquakes happen every day, but catastrophic events are rare. This relationship is described by the [Gutenberg-Richter law][1]. A similar law applies to the distribution of wealth within society (have a look at the [Pareto distribution][2]).

Some words are used thousands (???) of times, while others are only used once.

The problem with simply fitting a straight line to the data on the log-log plot is that there are few points on the upper left of the plot, while the majority of the points are clustered on the bottom right. As a result, a simple fit would result in a line with excessive slope. An alternative is to fit the data to the CDF rather than the PDF (DO WE DO THIS YET???).

## STUFF FROM ELSEWHERE

http://www.hpl.hp.com/research/idl/papers/ranking/ranking.html

At first, it appears that we have discovered two separate power laws, one produced by ranking the variables, the other by looking at the frequency distribution. Some papers even make the mistake of saying so [9]. But the key is to formulate the rank distribution in the proper way to see its direct relationship to the Pareto. The phrase &#8220;The r th largest city has n inhabitants&#8221; is equivalent to saying &#8220;r cities have n or more inhabitants&#8221;. This is exactly the definition of the Pareto distribution, except the x and y axes are flipped. Whereas for Zipf, r is on the x-axis and n is on the y-axis, for Pareto, r is on the y-axis and n is on the x-axis. Simply inverting the axes, we get that if the rank exponent is b, i.e.
  
n ~ r^(-b) in Zipf, (n = income, r = rank of person with income n)
  
then the Pareto exponent is 1/b so that
  
r ~ n^(-1/b) (n = income, r = number of people whose income is n or higher)
  
(See Appendix 2 for details).

Of course, since the power-law distribution is a direct derivative of Pareto&#8217;s Law, its exponent is given by (1+1/b). This also implies that any process generating an exact Zipf rank distribution must have a strictly power-law probability density function. As demonstrated with the AOL data, in the case b = 1, the power-law exponent a = 2.

Finally, instead of touting two separate power-laws, we have confirmed that they are different ways of looking at the same thing.

## References

[1] A. Clauset, C. R. Shalizi, and M. E. J. Newman, “Power-Law Distributions in Empirical Data,” SIAM Rev., vol. 51, no. 4, pp. 661–703, Nov. 2009.
  
[2] C. D. Manning and H. Schütze, Foundations of Statistical Natural Language Processing. The MIT Press, 2000.
  
[3] M. Schroeder, Fractals, Chaos, Power Laws: Minutes from an Infinite Paradise. W H Freeman & Company, 1991.

 [1]: https://en.wikipedia.org/wiki/Gutenberg%E2%80%93Richter_law
 [2]: https://en.wikipedia.org/wiki/Pareto_distribution
