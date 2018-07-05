---
draft: true
title: 'Thresholding a Classifier: How to ROC your AUC'
author: andrew
type: post
date: 2017-02-26T08:22:47+00:00
categories:
  - Data Science
  - R
tags:
  - AUC
  - Logistic Regression
  - ROC
  - Sensitivity
  - Specificity

---
http://www.r-bloggers.com/illustrated-guide-to-roc-and-auc/

> Also, AUC might be a better method to measure model effectiveness with class imbalance. AUC measures rank-ordering which isn&#8217;t sensitive to class imbalance (if I had an 0.05% response rate, assuming 100% of samples are response=0 would give me a good accuracy and poor AUC.)

Some classification models, for example Logistic Regression, deliver a class probability rather than the predicted class itself. It is up to the analyst to choose a threshold which will translate the probability into a categorical outcome. Choosing an appropriate threshold is not always a straightforward and naively selection 50% does not always yield the best results. I will illustrate the various considerations using the synthetic data set illustrated below.

The synthetic data consist of 5000 points which are loosely classified according to whether or not they lie above (labelled &#8220;Yes&#8221;) or below (labelled &#8220;No&#8221;) the curve $$y = 2x$$ . Note that there are some anomalous noisy points which do not conform to this simple rule. The data were partitioned into training and testing sets in a 3:1 proportion.

[<img src="http://162.243.184.248/wp-content/uploads/2015/07/scatter-label-train-test.png" alt="scatter-label-train-test" width="100%" class="aligncenter size-full wp-image-1738" />][1]

A Logistic Regression model was fit to the training data set using `glm()` with a Binomial family. The response of the model when applied to the entire data set is plotted below. The response varies between 0 and 1 and can be interpreted as the probability of the positive &#8220;Yes&#8221; label. It&#8217;s readily apparent that the model produces a result which is consistent with our expectations: a &#8220;Yes&#8221; label is probable for points in the upper left (response close to 1), while &#8220;No&#8221; is likely assigned to points on the lower right (response close to 0). There is a transition region in between where the response declines from 1 to 0. This represents a zone of uncertainty for the model. Where would we draw a line on the model response to best discriminate between the two classes?

[<img src="http://162.243.184.248/wp-content/uploads/2015/07/scatter-model-response.png" alt="scatter-model-response" width="100%" class="aligncenter size-full wp-image-1760" srcset="http://162.243.184.248/wp-content/uploads/2015/07/scatter-model-response.png 900w, http://162.243.184.248/wp-content/uploads/2015/07/scatter-model-response-300x200.png 300w, http://162.243.184.248/wp-content/uploads/2015/07/scatter-model-response-768x512.png 768w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 1362px) 62vw, 840px" />][2]

To better understand the question, let&#8217;s reconsider for a moment how a Logistic Regression model works. It first transforms the input features into a single real valued number (this is essentially the same as a normal Linear Regression model), which in turn is mapped onto the interval [0, 1] via a sigmoidal response function.

In the plot below the input and output of the response function are plotted for the testing data and the color scale indicates the reference class for each point (blue for &#8220;Yes&#8221; and red for &#8220;No&#8221;, just like in the first plot above). The response can be interpreted as the probability of the positive class in the classification model. Simply imposing a threshold at 0.5 would produce very satisfactory results since below 0.5 the majority of the points would be correctly classified as &#8220;No&#8221;, while above 0.5 &#8220;Yes&#8221; would generally be the correct classification. However, a careful look close to the threshold at 0.5 reveals a number of points which would not be correctly classified. These are the noisy points in the data. But, since there is no single threshold value which will result in all points being correctly classified, this leaves us open to selecting a threshold which will best achieve the objectives of the analysis.

[<img src="http://162.243.184.248/wp-content/uploads/2015/07/scatter-link-response.png" alt="scatter-link-response" width="100%" class="aligncenter size-full wp-image-1761" srcset="http://162.243.184.248/wp-content/uploads/2015/07/scatter-link-response.png 900w, http://162.243.184.248/wp-content/uploads/2015/07/scatter-link-response-300x200.png 300w, http://162.243.184.248/wp-content/uploads/2015/07/scatter-link-response-768x512.png 768w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 1362px) 62vw, 840px" />][3]

Before we think about modelling objectives, let&#8217;s briefly look at the various metrics available for model evaluation. Most of them are based on the information contained in the schematic contingency table below which relates the incidences of the class labels in the reference and predicted data.

<table style="width: auto;" align="center">
  <tr>
    <td colspan="2">
    </td>
    
    <th colspan="2" style="padding: 0px 15px;">
      Reference
    </th>
  </tr>
  
  <tr>
    <td colspan="2">
    </td>
    
    <td style="font-weight: bold;text-align:center">
      Yes
    </td>
    
    <td style="font-weight: bold;text-align:center">
      No
    </td>
  </tr>
  
  <tr>
    <th rowspan="2" style="padding: 0px 15px;vertical-align:middle">
      Predicted
    </th>
    
    <td style="padding: 0px 15px;font-weight: bold;text-align:center">
      Yes
    </td>
    
    <td style="text-align:center">
      TP
    </td>
    
    <td style="text-align:center">
      FP
    </td>
  </tr>
  
  <tr>
    <td style="font-weight: bold;text-align:center">
      No
    </td>
    
    <td style="text-align:center">
      FN
    </td>
    
    <td style="text-align:center">
      TN
    </td>
  </tr>
</table>

The four bins in the table are defined as

  * **TP (True Positive):** label is positive and the model predicts it as such; 
      * **FP (False Positive):** label is positive but the model predicts it as negative; 
          * **FN (False Negative):** label is negative but the model predicts it as positive; 
              * **TN (True Negative):** label is negative and the model predicts it as such. </ul> 
                The counts in each of these bins are directly determined by the selection of a cutoff threshold. In turn, the counts are used to construct a range of [measures][4] which characterise the performance of a classifier:
                
                  * Sensitivity or True Positive Rate (TPR) = TP / (TP + FN); 
                      * Specificity or True Negative Rate (TNR) = TN / (TN + FP); 
                          * Precision or Positive Predicted Value (PPV) = TP / (TP + FP); 
                              * Recall is the same as Sensitivity; 
                                  * False Positive Rate (FPR) = FP / (TN + FP) = 1 &#8211; Specificity, which corresponds to the frequency of Type 1 errors; 
                                      * False Negative Rate (FNR) = FN / (TP + FN) = 1 &#8211; Sensitivity, which corresponds to the frequency of Type 2 errors; 
                                          * Accuracy = (TP + TN) / (TP + TN + FP + FN). </ul> 
                                            ## Confusion Matrix
                                            
                                            Suppose that we set the cutoff at 0.5, then we can predict labels for each of the cases in the testing set. The predicted labels are then compared to the reference labels using a confusion matrix. The `caret` package exposes the `confusionMatrix()` function, which makes this easy. One thing to note when using this function is that it is important to specify the `positive` parameter to ensure that your labels are interpreted correctly.
                                            
                                            [code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
                                            Confusion Matrix and Statistics
                                            
                                            Reference
  
                                            Prediction No Yes
         
                                            No 854 33
         
                                            Yes 26 300
                                            
                                            Accuracy : 0.951
                   
                                            95% CI : (0.938, 0.963)
      
                                            No Information Rate : 0.725
      
                                            P-Value [Acc > NIR] : <2e-16 
                                            
                                            Kappa : 0.877
   
                                            Mcnemar&#8217;s Test P-Value : 0.435 
                                            
                                            Sensitivity : 0.901
              
                                            Specificity : 0.970
           
                                            Pos Pred Value : 0.920
           
                                            Neg Pred Value : 0.963
               
                                            Prevalence : 0.275
           
                                            Detection Rate : 0.247
     
                                            Detection Prevalence : 0.269
        
                                            Balanced Accuracy : 0.936 
                                            
                                            &#8216;Positive&#8217; Class : Yes
  

                                            
                                            The output from `confusionMatrix()` proves a complete assessment of a classifier in terms of the measures listed above. Accuracy represents the proportion of cases for which the classifier produced the correct label. However, [accuracy is not always a valid evaluation criterion][5].
                                            
                                            The measures above give a somewhat sterile reflection of how well the classifier works. We can get a better view via visualisation. The plot below was inspired by the [Illustrated Guide to ROC and AUC][6], but has been adapted to include both the training (bottom panel) and testing (top panel) data. As before, the cutoff has been set at 0.5 and the colours indicate the resulting predicted labels (blue for Yes and red for No). The correct labels are indicated by the category on the x-axis. It&#8217;s apparent that with this cutoff the majority of points are classified correctly, although there are still a significant number of false positives (blue points on the left) and false negatives (red points on the right).
                                            
                                            [<img src="http://162.243.184.248/wp-content/uploads/2015/07/scatter-violin.png" alt="scatter-violin" width="900" height="600" class="aligncenter size-full wp-image-1768" />][7]
                                            
                                            ## ROC Curve
                                            
                                            How would varying the cutoff affect the classifier? This question is addressed by the Receiver Operating Characteristic (ROC) curve, which gives an indication of the performance of a classifier as the cutoff is varied. Its rather obscure name arises from World War II when it was applied to the analysis of radar receivers. Constructing the curve is simple: plot the TPR against the FPR for a range of cutoff values (effectively this is the &#8220;hit rate&#8221; versus the &#8220;false alarm rate&#8221;). Although it&#8217;s a simple matter to generate the curve manually, there are a few R packages that will automate the process. For illustrative purposes we&#8217;ll use the ROCR package, which is described in [ROCR: visualizing classifier performance in R][8].
                                            
                                            > As you vary the threshold from very low to very high, you sweep out a curve in terms of sensitivity and false-positive rate&#8230;<cite><a href="http://shop.oreilly.com/product/0636920028529.do">Doing Data Science</a> (Cathy O&#8217;Neil, Rachel Schutt)</cite> 
                                            
                                            The ROC plot below gives the performance of our classifier as the cutoff is varied from 0 to 1 (indicated by the colour scale).
                                            
                                            [<img src="http://162.243.184.248/wp-content/uploads/2015/08/sensitivity-FPR-ROC-curve.png" alt="sensitivity-FPR-ROC-curve" width="100%" class="aligncenter size-full wp-image-1904" srcset="http://162.243.184.248/wp-content/uploads/2015/08/sensitivity-FPR-ROC-curve.png 900w, http://162.243.184.248/wp-content/uploads/2015/08/sensitivity-FPR-ROC-curve-300x200.png 300w, http://162.243.184.248/wp-content/uploads/2015/08/sensitivity-FPR-ROC-curve-768x512.png 768w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 1362px) 62vw, 840px" />][9]
                                            
                                            The four corners of the ROC plot have special significance:
                                            
                                              * **Top Left:** a perfect classifier (predictions for all data are correct); 
                                                  * **Bottom Right:** worst possible classifier (predictions for all data are incorrect); 
                                                      * **Top Right:** threshold of 0 giving an overly sensitive classifier (all data are assigned to the positive class); and 
                                                          * **Bottom Left:** threshold of 1 yielding an overly specific classifier (all data are assigned to the negative class). </ul> 
                                                            The diagonal dashed line corresponds to the &#8220;no information&#8221; model, where the likelihood of the model predicting either label is independent of the underlying data.
                                                            
                                                            The ROC curve is monotonically increasing, so decreasing the threshold will never result in a lower TPR. Conversely this has the consequence that increasing the FPR will always result in an elevated FPR. However, the rate of change of FPR with TPR varies: for large values of the cutoff (close to 1), appreciable improvements in TPF can be achieved with little impact on FPR. However, once you pass the &#8220;turn&#8221; in the curve, squeezing the FPR closer to 1 results in rapidly increasing FPR. Where you end up on the curve is going to be a compromise. The ideal location on the ROC plot is the top left corner where the TPR is 1 and the FPR is zero. Achieving this in practice is essentially impossible.
                                                            
                                                            Of course, the ROC curve plotted above was generated from a single set of test data. The curve will vary somewhat with different data sets. So, in order to get a robust estimate of the ROC curve it would be necessary to generate multiple curves. Cross-validation would be a good approach.
                                                            
                                                            ## TPR versus TNR
                                                            
                                                            Another view on the same data is achieved by plotting TPR and TNR as a function of cutoff. In the plot below the solid line gives TPR and the dashed line is TNR. It&#8217;s evident that when the cutoff is near to 0, the TPR is high (but this comes at the price of more False Positives, SO THE ??? IS LOW???!). At the opposite extreme, when the cutoff is near to 1, the TNR is high (but then we are not predicting too many positive cases, so THE ??? IS LOW???!).
                                                            
                                                            [<img src="http://162.243.184.248/wp-content/uploads/2015/07/TPR-TNR.png" alt="TPR-TNR" width="100%" class="aligncenter size-full wp-image-1775" srcset="http://162.243.184.248/wp-content/uploads/2015/07/TPR-TNR.png 900w, http://162.243.184.248/wp-content/uploads/2015/07/TPR-TNR-300x200.png 300w, http://162.243.184.248/wp-content/uploads/2015/07/TPR-TNR-768x512.png 768w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 1362px) 62vw, 840px" />][10]
                                                            
                                                            ## Accuracy and Precision
                                                            
                                                            [<img src="http://162.243.184.248/wp-content/uploads/2015/07/accuracy-precision.png" alt="accuracy-precision" width="100%" class="aligncenter size-full wp-image-1776" srcset="http://162.243.184.248/wp-content/uploads/2015/07/accuracy-precision.png 900w, http://162.243.184.248/wp-content/uploads/2015/07/accuracy-precision-300x200.png 300w, http://162.243.184.248/wp-content/uploads/2015/07/accuracy-precision-768x512.png 768w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 1362px) 62vw, 840px" />][11]
                                                            
                                                            One approach to selecting a cutoff would be to take the value which jointly maximises the Sensitivity and Specificity (IS THIS THE SAME AS THE ACCURACY/PRECISION PLOTTED ABOVE). As indicated in the plot above, this would correspond to a cutoff of XXX for our model.
                                                            
                                                            [<img src="http://162.243.184.248/wp-content/uploads/2015/07/calibration.png" alt="calibration" width="100%" class="aligncenter size-full wp-image-1777" srcset="http://162.243.184.248/wp-content/uploads/2015/07/calibration.png 900w, http://162.243.184.248/wp-content/uploads/2015/07/calibration-300x200.png 300w, http://162.243.184.248/wp-content/uploads/2015/07/calibration-768x512.png 768w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 1362px) 62vw, 840px" />][12]
                                                            
                                                            ## Sensitivity
                                                            
                                                            What happens if a high threshold is set?
                                                            
                                                            > There’s of course good news too, with low sensitivity, namely a zero false-positive rate.<cite><a href="http://shop.oreilly.com/product/0636920028529.do">Doing Data Science</a> (Cathy O&#8217;Neil, Rachel Schutt)</cite> 
                                                            
                                                            What about a very low threshold?
                                                            
                                                            > Then everything’s bad, and you have a 100% sensitivity but very high false-positive rate.<cite><a href="http://shop.oreilly.com/product/0636920028529.do">Doing Data Science</a> (Cathy O&#8217;Neil, Rachel Schutt)</cite> 
                                                            
                                                            ## Area Under Curve (AUC)
                                                            
                                                            The Area Under Curve (AUC) statistic corresponds to the area under the ROC curve. Evidently this is a number between 0 and 1. Larger values of AUC are better. If AUC = 1 then you have a perfect classifier since you achieve perfect TPR regardless of the cutoff threshold. The closer the ROC curve gets to the top left corner, the closer AUC will get to 1. If AUC = 0.5 then the classifier is no better than random. If AUC < 0.5 then the classifier is worse than random and something is seriously wrong!
                                                            
                                                            A more convex ROC is characteristic of a better classifier (and, as we shall see, translates into a higher AUC).
                                                            
                                                            > The overall “goodness” of such a curve is usually measured as the area under the curve (AUC): you want it to be one, and if your curve lies on diagonal, the area is 0.5. This is tantamount to guessing randomly. So if your area under the curve is less than 0.5, it means your model is perverse.<cite><a href="http://shop.oreilly.com/product/0636920028529.do">Doing Data Science</a> (Cathy O&#8217;Neil, Rachel Schutt)</cite> 
                                                            
                                                            This is the AUC estimate produced by the `pROC` package:
  
                                                            [code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
                                                            Area under the curve: 0.966
  

                                                            
                                                            The AUC index is directly related to the [Gini coefficient][13].
                                                            
                                                            ## Relative Risk
                                                            
                                                            The optimal threshold is likely to be determined by a cost function which will quantise the relative risk of false positive and false negative predictions. If the risk for false positives is higher then we will want to have ??? cutoff. Conversely, if false negatives are more costly then a ??? cutoff would be preferable.
                                                            
                                                            ## Conclusion
                                                            
                                                            The most rigorous approach to selecting a threshold would be to perform a cross-validation analysis.
                                                            
                                                            ### Reference
                                                            
                                                              1. P. Flach, J. Hernández-Orallo, and C. Ferri, “A Coherent Interpretation of AUC as a Measure of Aggregated Classification Performance,” in International Conference on Machine Learning, 2011. 
                                                                  * D. J. Hand, “Measuring classifier performance: A coherent alternative to the area under the ROC curve,” Machine Learning, vol. 77, no. 1, pp. 103–123, 2009. 
                                                                      * T. Fawcett, “An introduction to ROC analysis,” Pattern Recognition Letters, vol. 27, no. 8, pp. 861–874, 2006. </ol>

 [1]: http://162.243.184.248/wp-content/uploads/2015/07/scatter-label-train-test.png
 [2]: http://162.243.184.248/wp-content/uploads/2015/07/scatter-model-response.png
 [3]: http://162.243.184.248/wp-content/uploads/2015/07/scatter-link-response.png
 [4]: https://en.wikipedia.org/wiki/Sensitivity_and_specificity
 [5]: http://www.cs.cmu.edu/~elaw/papers/ICML2008.pdf
 [6]: http://www.joyofdata.de/blog/illustrated-guide-to-roc-and-auc/
 [7]: http://162.243.184.248/wp-content/uploads/2015/07/scatter-violin.png
 [8]: http://bioinformatics.oxfordjournals.org/content/21/20/3940.full.pdf+html
 [9]: http://162.243.184.248/wp-content/uploads/2015/08/sensitivity-FPR-ROC-curve.png
 [10]: http://162.243.184.248/wp-content/uploads/2015/07/TPR-TNR.png
 [11]: http://162.243.184.248/wp-content/uploads/2015/07/accuracy-precision.png
 [12]: http://162.243.184.248/wp-content/uploads/2015/07/calibration.png
 [13]: https://en.wikipedia.org/wiki/Gini_coefficient#Relation_to_other_statistical_measures
