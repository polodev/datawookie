---
draft: true
title: Bayesian Marathon Predictions
author: andrew
type: post
date: 2017-02-26T08:22:25+00:00
categories:
  - Data Science
  - R
  - Running
tags:
  - Bayesian Statistics
  - Marathon
  - R
  - Running

---
This model has been implemented as a Shiny application and is available [here][1].

LOOK AT THIS: http://www.theguardian.com/lifeandstyle/the-running-blog/2016/apr/21/sub-3-marathon-data-strava-london

There are a variety of ways to predict running times over the [standard marathon][2] distance (42.2 km). You could dust off your copy of The Lore of Running (Tim Noakes). My treasured Third Edition discusses predicting likely marathon times on p. 366, referring to tables published by other authors to actually make predictions. There&#8217;s also a variety of online services, for example:

  * Runners&#8217; World&#8217;s [Race Time Predictor][3] (based on Riegel&#8217;s Formula), 
      * Running for Fitness&#8217;s [Race Predictor][4], 
          * [Race Result Predictor][5] at http://www.marathonguide.com/ </ul> 
            Of these I particularly like the offering from Running for Fitness which produces a neatly tabulated set of predicted times over an extensive range of distances using a selection of techniques including [Riegel&#8217;s Formula][6] and [Cameron&#8217;s Model][7].
            
            While the sites listed above certainly provide useful predictions, I have a niggling feeling that they aren&#8217;t fully exploiting the large amount of data that we currently have available (both as individual athletes and as a global fraternity of runners). I&#8217;ve developed a relentless itch to provide a better solution. I wanted to do the following:
            
              * incorporate information for multiple measurements (other solutions just use a single time over another distance); 
                  * illustrate how the prediction is updated (and hopefully improved) by adding additional measurements; 
                      * provide an indication of uncertainty in the prediction. </ul> 
                        Using data accumulated from a number of races in South Africa I put together a Bayesian model for prediction marathon times. The likelihood function, which embodies the code data for the model, was constructed using `npcdensbw()` and `npcdens()` from the [np][8] package (nonparametric kernel smoothing methods for mixed data types).
                        
                        <table style="text-align: center;">
                          <tr>
                            <th>
                              Distance [km]
                            </th>
                            
                            <th>
                              Time [HH:MM]
                            </th>
                            
                            <th>
                              Marathon (Riegel&#8217;s Formula) [HH:MM]
                            </th>
                          </tr>
                          
                          <tr>
                            <td style="text-align: center;">
                              10.0
                            </td>
                            
                            <td style="text-align: center;">
                              00:38
                            </td>
                            
                            <td style="text-align: center;">
                              02:55
                            </td>
                          </tr>
                          
                          <tr>
                            <td style="text-align: center;">
                              21.1
                            </td>
                            
                            <td style="text-align: center;">
                              01:17
                            </td>
                            
                            <td style="text-align: center;">
                              02:40
                            </td>
                          </tr>
                          
                          <tr>
                            <td style="text-align: center;">
                              25.0
                            </td>
                            
                            <td style="text-align: center;">
                              01:34
                            </td>
                            
                            <td style="text-align: center;">
                              02:43
                            </td>
                          </tr>
                          
                          <tr>
                            <td style="text-align: center;">
                              32.0
                            </td>
                            
                            <td style="text-align: center;">
                              01:59
                            </td>
                            
                            <td style="text-align: center;">
                              02:40
                            </td>
                          </tr>
                        </table>
                        
                        The third column is the predicted marathon time using Riegel&#8217;s Formula on the time achieved over each distance.
                        
                        Actual marathon time for this runner is 2:42.
                        
                        But the mode of the posterior is at 170 minutes.
                        
                        > We start with a belief, called a prior. Then we obtain some data and use it to update our belief. The outcome is called a posterior. Should we obtain even more data, the old posterior becomes a new prior and the cycle repeats.
                        
                        Below is the default prior distribution constructed as the distribution of all marathon times in the data set. In the absence of further information regarding a particular runner, this is a reasonable guess for the distribution of possible marathon times. It represents our initial belief of what&#8217;s possible.
                        
                        <img src="http://162.243.184.248/wp-content/uploads/2016/03/marathon-prediction-0.png" alt="marathon-prediction-0" width="800" height="400" class="aligncenter size-large wp-image-3412" srcset="http://162.243.184.248/wp-content/uploads/2016/03/marathon-prediction-0.png 800w, http://162.243.184.248/wp-content/uploads/2016/03/marathon-prediction-0-300x150.png 300w, http://162.243.184.248/wp-content/uploads/2016/03/marathon-prediction-0-768x384.png 768w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 984px) 61vw, (max-width: 1362px) 45vw, 600px" />
                        
                        Based on the default prior the expected time for finishing a marathon is 04:19, with a 95% confidence interval that extends from 02:51 to 05:43.
                        
                        Once we have some data though, we are able to update the initial belief using [Bayes&#8217; Theorem][9] to generate a posterior distribution.
                        
                        <img src="http://162.243.184.248/wp-content/uploads/2016/03/marathon-prediction-1.png" alt="marathon-prediction-1" width="800" height="400" class="aligncenter size-large wp-image-3411" srcset="http://162.243.184.248/wp-content/uploads/2016/03/marathon-prediction-1.png 800w, http://162.243.184.248/wp-content/uploads/2016/03/marathon-prediction-1-300x150.png 300w, http://162.243.184.248/wp-content/uploads/2016/03/marathon-prediction-1-768x384.png 768w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 984px) 61vw, (max-width: 1362px) 45vw, 600px" />
                        
                        Having incorporated the 10 km finishing time, the expected marathon time drops to 03:24. Quite an improvement! The 95% confidence interval also narrows to between 02:38 and 04:07.
                        
                        When further information becomes available, the current posterior distribution becomes the prior for the next application of Bayes&#8217; Theorem. This cycle repeats itself with each new piece of information, the posterior progressively becoming a more accurate representation of the information captured in the measurements.
                        
                        <img src="http://162.243.184.248/wp-content/uploads/2016/03/marathon-prediction-2.png" alt="marathon-prediction-2" width="800" height="400" class="aligncenter size-large wp-image-3410" srcset="http://162.243.184.248/wp-content/uploads/2016/03/marathon-prediction-2.png 800w, http://162.243.184.248/wp-content/uploads/2016/03/marathon-prediction-2-300x150.png 300w, http://162.243.184.248/wp-content/uploads/2016/03/marathon-prediction-2-768x384.png 768w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 984px) 61vw, (max-width: 1362px) 45vw, 600px" />
                        
                        Adding a time of 01:17 over 21.1 km into the mix gives an expected marathon time of 03:13, slicing off another 11 minutes.
                        
                        <img src="http://162.243.184.248/wp-content/uploads/2016/03/marathon-prediction-3.png" alt="marathon-prediction-3" width="800" height="400" class="aligncenter size-large wp-image-3409" srcset="http://162.243.184.248/wp-content/uploads/2016/03/marathon-prediction-3.png 800w, http://162.243.184.248/wp-content/uploads/2016/03/marathon-prediction-3-300x150.png 300w, http://162.243.184.248/wp-content/uploads/2016/03/marathon-prediction-3-768x384.png 768w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 984px) 61vw, (max-width: 1362px) 45vw, 600px" />
                        
                        A time of 01:34 for 25 km gives the expected marathon time another boost to 03:07.
                        
                        <img src="http://162.243.184.248/wp-content/uploads/2016/03/marathon-prediction-4.png" alt="marathon-prediction-4" width="800" height="400" class="aligncenter size-full wp-image-3408" srcset="http://162.243.184.248/wp-content/uploads/2016/03/marathon-prediction-4.png 800w, http://162.243.184.248/wp-content/uploads/2016/03/marathon-prediction-4-300x150.png 300w, http://162.243.184.248/wp-content/uploads/2016/03/marathon-prediction-4-768x384.png 768w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 984px) 61vw, (max-width: 1362px) 45vw, 600px" />
                        
                        Finally, adding in a time of 01:59 for 32 km drops the anticipated marathon time down to 02:54, with a 95% confidence interval from 02:36 to 03:16.
                        
                        ## Comparison with Standard Models
                        
                        **Compare the results to those from the Running for Fitness site.**

 [1]: https://datawookie.shinyapps.io/Marathon-Time-Prediction/
 [2]: https://en.wikipedia.org/wiki/Marathon
 [3]: http://www.runnersworld.co.uk/general/rws-race-time-predictor/1681.html
 [4]: http://www.runningforfitness.org/calc/racepaces/rp
 [5]: http://www.marathonguide.com/fitnesscalcs/predictcalc.cfm
 [6]: https://en.wikipedia.org/wiki/Peter_Riegel
 [7]: http://www.cs.uml.edu/~phoffman/cammod.html
 [8]: https://cloud.r-project.org/web/packages/np/
 [9]: https://en.wikipedia.org/wiki/Bayes%27_theorem
