---
draft: true
title: Social Networks and the Friendship Paradox
author: andrew
type: post
date: 2017-02-26T08:23:22+00:00
categories:
  - Data Science
  - R
tags:
  - Barabási–Albert
  - Erdős–Rényi
  - friendship
  - graph
  - igraph
  - network
  - power-law
  - R
  - Small-World Network
  - sunflower plot
  - Watts-Strogatz

---
I have some bad news: you&#8217;re probably not as popular as you think. In fact, within your circle of friends, you are likely to be less popular than average. Don&#8217;t be discouraged though: the situation is not that dire. There are just a couple of your mates that are making you look bad.

## The Friendship Paradox

How many friends is _enough_? It is hard to answer this question in an absolute sense. For some people, ten friends might seem perfectly adequate, while for others even a few hundred friends might not feel sufficient. A reasonable yard stick might be to look at how many friends each of your friends has. If they generally have more friends than you, then perhaps you are relatively unpopular. On the other hand, if you have more friends than the majority of your friends then you are a bit of a friendship rock star. (Of course, a perfectly good question to ask is: &#8220;Should I care?&#8221; And the most reasonable answer would be: &#8220;No, probably not.&#8221; But it&#8217;s still interesting to think about.)

The [Friendship Paradox][1] suggests that on average most people have fewer friends than their friends have. The key phrase here is _on average_. Scott Feld [1] list these related phenomena:

  * the roads are relatively quiet on average, but many people perceive them as busy since _on average_ the majority travel in rush hour traffic; 
      * many students perceive class sizes to be larger than they actually are because _on average_ most of these students are sitting in the larger classes; 
          * most towns and cities are relatively small, but _on average_ most people live in large cities; 
              * public places are perceived to be crowded since _on average_ most people visit them during crowded times. </ul> 
                Despite reading Feld&#8217;s [1] explanatory paper, I needed to fiddle around with some data to get my ideas and intuitions straight on this. It also provided me with the opportunity to play with the excellent [igraph][2] package, which I have been meaning to do for quite some time.
                
                I wanted to attack the problem from a few different angles. However, before I could start I needed to generate some graphs which would bear a reasonable likeness to a real friendship network.
                
                ## A Simple Illustration
                
                Most people will have less friends than the average number of friends of friends. Fewer people, however, will have less friends than the average number of friends of individuals.
                
                Whew, that all sounds a little complicated.
                
                Let&#8217;s consider a simple example.
                
                [code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
                library(igraph)
  
                tiny.graph <- graph.formula(A-b:e:f:g:h:i:j:k, b-c, c-d, d-b)
  

                
                [<img src="http://162.243.184.248/wp-content/uploads/2014/08/graph-tiny-graph.png" alt="graph-tiny-graph" width="512" height="512" class="aligncenter size-full wp-image-954" srcset="http://162.243.184.248/wp-content/uploads/2014/08/graph-tiny-graph.png 512w, http://162.243.184.248/wp-content/uploads/2014/08/graph-tiny-graph-150x150.png 150w, http://162.243.184.248/wp-content/uploads/2014/08/graph-tiny-graph-300x300.png 300w" sizes="(max-width: 512px) 85vw, 512px" />][3]
                
                In the network above there are 11 individuals and 11 friendships. Individual A has 8 friends, while individual b has only 3 friends. Both c and d have 2 friends each. The remaining individuals only have one friend each. Now, if we focus our attention on individual b, we observe that he is friends with A, c and d. These individuals have 8, 2 and 2 friends respectively. The average number of friends of friends for b is then 4 (we simply average the number of friends for each of A, c and d).
                
                [code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
                > mean(c(8, 2, 2))
  
                [1] 4
  

                
                So we see that b has fewer friends (3) than the average number of friends of friends (4). Evidently comparing b to his immediate circle of friends makes him seem relatively lonely.
                
                If, however, we consider the network as a whole and calculate the average number of friends for all individuals, then we find that this is only 2.
                
                [code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
                > mean(c(8, 3, 2, 2, 1, 1, 1, 1, 1, 1, 1))
  
                [1] 2
  

                
                Relative to all the people in the network, b appears to be more popular. Feld [1] demonstrated that the mean number of friends of friends is always larger than the mean number of friends of individuals.
                
                These phenomena underly the Friendship Paradox: some people appear to be &#8220;below average&#8221; because they are friends with one (or a few) highly connected people. Popular people have lots of friends, causing most of these friends to seem _relatively_ unpopular. Less popular people, on the other hand, are friends with only a few people and so only these few gain from their relative popularity. To make this a little more concrete, consider a person who has 1000 friends. This person is also a friend for each of those 1000 people and consequently makes a large number of people feel relatively inferior. By contrast, a person with only a handful of friends will make only those few friends feel relatively superior.
                
                ## Playing Games with Graphs
                
                The simple friendship network above was carefully chosen to illustrate two particular points. If we are going to generalise these observations then we will need to look at larger networks (and many of them!). It&#8217;s easy enough to generate large random networks, but we also need to make these networks realistic: they should look something like real friendship networks. One of the characteristics of such networks is that the number of friendships follows a power-law distribution [3].
                
                Below is a selection of networks created using different algorithms (all of which are implemented in igraph). From left to right they are
                
                  1. an [Erdős–Rényi][4] graph; 
                      * a [Watts-Strogatz][5] graph; 
                          * a [Barabási–Albert][6] graph using default parameters; 
                              * a Barabási–Albert graph with a stipulated number of edges added in each step. </ol> 
                                [<img src="http://162.243.184.248/wp-content/uploads/2014/12/graph-types-graph.png" alt="graph-types-graph" width="1024" height="256" class="aligncenter size-full wp-image-1055" srcset="http://162.243.184.248/wp-content/uploads/2014/12/graph-types-graph.png 1024w, http://162.243.184.248/wp-content/uploads/2014/12/graph-types-graph-300x75.png 300w, http://162.243.184.248/wp-content/uploads/2014/12/graph-types-graph-768x192.png 768w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 1362px) 62vw, 840px" />][7]
                                
                                [<img src="http://162.243.184.248/wp-content/uploads/2014/12/graph-types-degree.png" alt="graph-types-degree" width="1024" height="256" class="aligncenter size-full wp-image-1056" srcset="http://162.243.184.248/wp-content/uploads/2014/12/graph-types-degree.png 1024w, http://162.243.184.248/wp-content/uploads/2014/12/graph-types-degree-300x75.png 300w, http://162.243.184.248/wp-content/uploads/2014/12/graph-types-degree-768x192.png 768w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 1362px) 62vw, 840px" />][8]
                                
                                Below each of the graphs is a histogram giving the distribution of node degrees (number of edges connected to each node). We are looking for graphs with something like a power-law distribution (lots of nodes with low degree and progressively fewer nodes with higher degrees). It&#8217;s evident that only the two Barabási–Albert graphs come close to this requirement (admittedly it&#8217;s hard to tell with such small graphs where the statistics are relatively poor). Note that for both of these graphs there is a single outlier node which has far more connections than any of the other nodes. Incidentally, the Watts-Strogatz graph is an example of a [Small-World Network][9], which achieve a compromise between high clustering and short path lengths. Clay Shirky [2] gives an engaging discussion of Small-World Networks in his book [Here Comes Everybody: The Power of Organizing Without Organizations][10]<img src="http://ir-na.amazon-adsystem.com/e/ir?t=exegetanalyt-20&#038;l=as2&#038;o=1&#038;a=0143114948" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />.
                                
                                ## A Quiver Full of Graphs
                                
                                To make our experiment more robust we are going to generate a large ensemble of graphs and then consider the statistics of the ensemble. The first 16 of these graphs are plotted below.
                                
                                [<img src="http://162.243.184.248/wp-content/uploads/2014/12/graph-grid.png" alt="graph-grid" width="1024" height="1024" class="aligncenter size-full wp-image-1058" srcset="http://162.243.184.248/wp-content/uploads/2014/12/graph-grid.png 1024w, http://162.243.184.248/wp-content/uploads/2014/12/graph-grid-150x150.png 150w, http://162.243.184.248/wp-content/uploads/2014/12/graph-grid-300x300.png 300w, http://162.243.184.248/wp-content/uploads/2014/12/graph-grid-768x768.png 768w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 1362px) 62vw, 840px" />][11]
                                
                                We will need a way to systematically analyse each graph in the ensemble. To do this, I wrote a function to extract the required information from each graph.
                                
                                [code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
                                > library(data.table)
  
                                >
  
                                > analyse.graph <- function(g) {
  
                                + neighbours <- neighborhood(g, order = 1)
  
                                + #
  
                                + friend.statistics = lapply(neighbours, function (n) {
  
                                + person <- n[1]
  
                                + friends <- n[-1]
  
                                + #
  
                                + # Find number of friends for each of this person&#8217;s friends
  
                                + #
  
                                + friends.friends = degree(g, friends)
  
                                + mean.friends.friends = ifelse(length(friends.friends) > 0, mean(friends.friends), 0)
  
                                + #
  
                                + data.frame(person, friends = length(friends), mean.friends.friends)
  
                                + })
  
                                + #
  
                                + rbindlist(friend.statistics)
  
                                + }
  

                                
                                So, for illustrative purposes, we get the following information for the first graph in the grid above:
                                
                                [code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
                                > analyse.graph(graphs[[1]])
      
                                person friends mean.friends.friends
   
                                1: 1 12 4.833333
   
                                2: 2 4 5.500000
   
                                3: 3 2 12.000000
   
                                4: 4 6 5.833333
   
                                5: 5 4 5.750000
   
                                6: 6 12 3.833333
   
                                7: 7 7 5.571429
   
                                8: 8 3 9.333333
   
                                9: 9 8 5.000000
  
                                10: 10 5 5.400000
  
                                11: 11 4 6.000000
  
                                12: 12 2 5.500000
  
                                13: 13 4 6.250000
  
                                14: 14 2 8.000000
  
                                15: 15 5 5.400000
  
                                16: 16 2 8.000000
  
                                17: 17 3 7.666667
  
                                18: 18 4 4.250000
  
                                19: 19 2 9.500000
  
                                20: 20 4 3.250000
  
                                21: 21 3 6.666667
  
                                22: 22 3 3.666667
  
                                23: 23 2 8.000000
  
                                24: 24 3 6.333333
  
                                25: 25 3 4.333333
  
                                26: 26 3 3.000000
  
                                27: 27 2 4.500000
  
                                28: 28 3 6.666667
  
                                29: 29 3 6.333333
  
                                30: 30 3 5.333333
  
                                31: 31 3 6.333333
  
                                32: 32 4 5.500000
      
                                person friends mean.friends.friends
  

                                
                                Skimming down this table it is easy to see that these data are consistent with the Friend Paradox: most of the nodes are less connected than their average neighbours.
                                
                                For each of the graphs in the ensemble I then gathered the following statistics:
                                
                                  * order (number of nodes), 
                                      * size (total number of edges), 
                                          * average degree (mean number of edges per node), 
                                              * minimum and maximum degree, and 
                                                  * the _global lonely fraction_, defined as the proportion of nodes with degree less than the average degree across the entire network and 
                                                      * the _local lonely fraction_, defined as the proportion of nodes with degree less than the average degree of their neighbour nodes. </ul> 
                                                        [<img src="http://162.243.184.248/wp-content/uploads/2015/01/histogram-lonely-local-global.png" alt="histogram-lonely-local-global" width="512" height="512" class="aligncenter size-full wp-image-1069" srcset="http://162.243.184.248/wp-content/uploads/2015/01/histogram-lonely-local-global.png 512w, http://162.243.184.248/wp-content/uploads/2015/01/histogram-lonely-local-global-150x150.png 150w, http://162.243.184.248/wp-content/uploads/2015/01/histogram-lonely-local-global-300x300.png 300w" sizes="(max-width: 512px) 85vw, 512px" />][12]
                                                        
                                                        [<img src="http://162.243.184.248/wp-content/uploads/2015/01/scatter-lonely-local-global.png" alt="scatter-lonely-local-global" width="512" height="512" class="aligncenter size-full wp-image-1070" srcset="http://162.243.184.248/wp-content/uploads/2015/01/scatter-lonely-local-global.png 512w, http://162.243.184.248/wp-content/uploads/2015/01/scatter-lonely-local-global-150x150.png 150w, http://162.243.184.248/wp-content/uploads/2015/01/scatter-lonely-local-global-300x300.png 300w" sizes="(max-width: 512px) 85vw, 512px" />][13]
                                                        
                                                        As indicated by the density (colour scale) there is a high degree of overplotting in the above figure. There are a number of ways of dealing with this situation. One of them is a sunflower plot.
                                                        
                                                        [<img src="http://162.243.184.248/wp-content/uploads/2015/01/sunflower-lonely-local-max-degree1.png" alt="sunflower-lonely-local-max-degree" width="512" height="512" class="aligncenter size-full wp-image-1086" srcset="http://162.243.184.248/wp-content/uploads/2015/01/sunflower-lonely-local-max-degree1.png 512w, http://162.243.184.248/wp-content/uploads/2015/01/sunflower-lonely-local-max-degree1-150x150.png 150w, http://162.243.184.248/wp-content/uploads/2015/01/sunflower-lonely-local-max-degree1-300x300.png 300w" sizes="(max-width: 512px) 85vw, 512px" />][14]
                                                        
                                                        ## A Single Large Network
                                                        
                                                        HIVE PLOT GOES HERE!
                                                        
                                                        ## Conclusion
                                                        
                                                        I have not addressed the issue of whether these are really friends or just acquaintances. It is probable that acquaintances inflate the effects of the Friendship Paradox.
                                                        
                                                        http://www.scientificamerican.com/article/why-youre-probably-less-popular/
                                                        
                                                        http://metro.co.uk/2014/03/22/and-the-most-popular-person-on-facebook-is-4673110/
                                                        
                                                        http://www.wolframalpha.com/facebook/ (this will give you the distribution of the number of friends for each of your friends)
                                                        
                                                        https://en.wikipedia.org/wiki/Power_law
                                                        
                                                        In fact, more likely to be a power law with an exponential cutoff since there are not many people on FB with zero or only a handful of friends.
                                                        
                                                        Another way of dealing with the hairball would have been to prune the graph.
                                                        
                                                        ## References
                                                        
                                                        [1] S. L. Feld, “Why Your Friends Have More Friends Than You Do,” Am. J. Sociol., vol. 96, no. 6, pp. 1464–1477, May 1991.
  
                                                        [2] C. Shirky, Here Comes Everybody: The Power of Organizing without Organizations. Allen Lane, 2008.
  
                                                        [3] L. Muchnik, S. Pei, L. C. Parra, S. D. S. Reis, J. S. Andrade, S. Havlin, and H. A. Makse, “Origins of power-law degree distribution in the heterogeneity of human activity in social networks.,” Sci. Rep., vol. 3, p. 1783, 2013. http://dx.doi.org/10.1038/srep01783.

 [1]: https://en.wikipedia.org/wiki/Friendship_paradox
 [2]: http://igraph.org/
 [3]: http://162.243.184.248/wp-content/uploads/2014/08/graph-tiny-graph.png
 [4]: http://en.wikipedia.org/wiki/Erd%C5%91s%E2%80%93R%C3%A9nyi_model
 [5]: http://en.wikipedia.org/wiki/Watts_and_Strogatz_model
 [6]: http://en.wikipedia.org/wiki/Barab%C3%A1si%E2%80%93Albert_model
 [7]: http://162.243.184.248/wp-content/uploads/2014/12/graph-types-graph.png
 [8]: http://162.243.184.248/wp-content/uploads/2014/12/graph-types-degree.png
 [9]: http://en.wikipedia.org/wiki/Small-world_network
 [10]: http://www.amazon.com/gp/product/0143114948/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=0143114948&linkCode=as2&tag=exegetanalyt-20&linkId=7UY3Q6ZZJXV7EAQU
 [11]: http://162.243.184.248/wp-content/uploads/2014/12/graph-grid.png
 [12]: http://162.243.184.248/wp-content/uploads/2015/01/histogram-lonely-local-global.png
 [13]: http://162.243.184.248/wp-content/uploads/2015/01/scatter-lonely-local-global.png
 [14]: http://162.243.184.248/wp-content/uploads/2015/01/sunflower-lonely-local-max-degree1.png
