---
author: Andrew B. Collier
date: 2018-04-21T01:00:00Z
tags: ["R", "machine learning"]
title: "Classification: Get the Balance Right"
---

<!--
  Presentation on balancing data within caret. https://hanjostudy.github.io/Presentations/Class_of_its_own/Class_of_its_own.html
-->

<!-- Image: Depeche Mode 'Get the Balance Right' -->
![](/img/2018/04/get-the-balance-right.png)

For classification problems the positive class (which is what you're normally trying to predict) is often sparsely represented in the data. Unless you do something to address this imbalance then your classifier is likely to be rather underwhelming.

Achieving a reasonable balance in the proportions of the target classes is seldom emphasised. Perhaps it's not very sexy. But it can have a massive effect on a model. <!--more-->

You've got to get the balance right!

## The Data

To illustrate we'll use some medical appointment [no-show data](https://www.kaggle.com/joniarroba/noshowappointments).

First load some indispensable packages.

{{< highlight r >}}
library(dplyr)
library(stringr)
library(lubridate)
library(readr)
library(caret)
{{< /highlight >}}

Then grab the data.

{{< highlight r >}}
appointments <- read_csv("medical-appointments.csv") %>%
  # Normalise names.
  setNames(names(.) %>% str_to_lower() %>% str_replace("[.-]", "_")) %>%
  # Correct spelling.
  dplyr::rename(
    hypertension = hipertension,
    handicap = handcap
  )
{{< /highlight >}}

Convert a few features into factors.

{{< highlight r >}}
appointments <- appointments %>%
    mutate_at(vars(gender, neighbourhood:no_show), factor)
{{< /highlight >}}

Neither the `patientid` nor the `appointmentid` fields can have any predictive value, so remove them both. The `neighbourhood` feature has too many levels to be useful as a categorical feature, so remove it too.

{{< highlight r >}}
appointments <- appointments %>% select(-patientid, -appointmentid, -neighbourhood)
{{< /highlight >}}

Create some derived features from the date and time columns.

{{< highlight r >}}
appointments <- appointments %>% mutate(
    scheduleddow = wday(scheduledday) %>% factor(),
    hour = hour(scheduledday) + (minute(scheduledday) + second(scheduledday) / 60) / 60,
    appointmentdow = wday(appointmentday) %>% factor(),
    #
    # How long before the appointment was it scheduled?
    #
    advance = difftime(scheduledday, appointmentday, units = "hours") %>% as.numeric()
) %>% select(-scheduledday, -appointmentday)
{{< /highlight >}}

Finally change order of levels in the target variable. This is important because the `caret` package considers the first level to be the positive class.

{{< highlight r >}}
appointments <- appointments %>% mutate(
  no_show = relevel(no_show, "Yes")
) %>% select(no_show, everything())
{{< /highlight >}}

Let's take a look at the resulting data.

{{< highlight text >}}
# A tibble: 20 x 13
   no_show gender   age scholarship hypertension diabetes alcoholism handicap sms_received scheduleddow      hour appointmentdow    advance
    <fctr> <fctr> <int>      <fctr>       <fctr>   <fctr>     <fctr>   <fctr>       <fctr>       <fctr>     <dbl>         <fctr>      <dbl>
 1      No      F    62           0            1        0          0        0            0            6 18.635556              6  18.635556
 2      No      M    56           0            0        0          0        0            0            6 16.140833              6  16.140833
 3      No      F    62           0            0        0          0        0            0            6 16.317778              6  16.317778
 4      No      F     8           0            0        0          0        0            0            6 17.491944              6  17.491944
 5      No      F    56           0            1        1          0        0            0            6 16.123056              6  16.123056
 6      No      F    76           0            1        0          0        0            0            4  8.614167              6 -39.385833
 7     Yes      F    23           0            0        0          0        0            0            4 15.086667              6 -32.913333
 8     Yes      F    39           0            0        0          0        0            0            4 15.666111              6 -32.333889
 9      No      F    21           0            0        0          0        0            0            6  8.037778              6   8.037778
10      No      F    19           0            0        0          0        0            0            4 12.806944              6 -35.193056
11      No      F    30           0            0        0          0        0            0            4 14.969722              6 -33.030278
12     Yes      M    29           0            0        0          0        0            1            3  8.736667              6 -63.263333
13      No      F    22           1            0        0          0        0            0            5 11.564167              6 -12.435833
14      No      M    28           0            0        0          0        0            0            5 14.868611              6  -9.131389
15      No      F    54           0            0        0          0        0            0            5 10.106667              6 -13.893333
16      No      F    15           0            0        0          0        0            1            3  8.790833              6 -63.209167
17      No      M    50           0            0        0          0        0            0            5  8.863056              6 -15.136944
18     Yes      F    40           1            0        0          0        0            0            5  9.482500              6 -14.517500
19      No      F    30           1            0        0          0        0            1            3 10.905000              6 -61.095000
20      No      F    46           0            0        0          0        0            0            6 10.720556              6  10.720556
{{< /highlight >}}

## Classifier with Unbalanced Data

At this point it looks like we are ready to build a classifier. We'll partition the data into training and testing sets in 80:20 proportion.

{{< highlight r >}}
set.seed(13)
train_index <- createDataPartition(appointments$no_show, p = 0.8)[[1]]

train <- appointments[train_index,]
test  <- appointments[-train_index,]
{{< /highlight >}}

We will use the `caret` package to build the classifier. Set up some parameters for the model training process.

{{< highlight r >}}
control = trainControl(
  method = 'cv',
  number = 10,
  classProbs = TRUE,
  summaryFunction = twoClassSummary
)
{{< /highlight >}}

By default the classifier will be optimised to achieve maximal accuracy. This is not an ideal metric, especially if we are primarily interested in predicting no show events (the positive outcome). So instead we will aim to achieve optimal sensitivity.

{{< highlight r >}}
xgb <- train(no_show ~ .,
             data = train,
             method = "xgbTree",
             metric = "Sens",
             trControl = control
)
{{< /highlight >}}

Let's see how that performs on the test data.

{{< highlight r >}}
confusionMatrix(predict(xgb, test), test$no_show)
{{< /highlight >}}

{{< highlight text >}}
Confusion Matrix and Statistics

          Reference
Prediction   Yes    No
       Yes   194   215
       No   4269 17426
                                          
               Accuracy : 0.7971          
                 95% CI : (0.7918, 0.8024)
    No Information Rate : 0.7981          
    P-Value [Acc > NIR] : 0.6412          
                                          
                  Kappa : 0.0473          
 Mcnemar's Test P-Value : <2e-16          
                                          
            Sensitivity : 0.043469        
            Specificity : 0.987812        
         Pos Pred Value : 0.474328        
         Neg Pred Value : 0.803227        
             Prevalence : 0.201909        
         Detection Rate : 0.008777        
   Detection Prevalence : 0.018503        
      Balanced Accuracy : 0.515641        
                                          
       'Positive' Class : Yes
{{< /highlight >}}

Overall that looks pretty decent, with an accuracy of close to 80%. But if we look a little closer then we see that the classifier is good at predicting the negative class (with a specificity of nearly 99%), but not very effective at identifying the positive class (with a sensitivity of just over 4%).

## Balancing the Data

Let's investigate why the model performs so poorly.

{{< highlight r >}}
table(train$no_show)
{{< /highlight >}}
{{< highlight text >}}
  Yes    No 
17856 70567
{{< /highlight >}}

The data is strongly biased in favour of the negative class: only 20% of the records represent the situation we're actually trying to predict.

In the confusion matrix above we see that the vast majority of predictions are being assigned the negative class. Since the negative class is far more common in the data, this prediction is correct more often than not. The model naturally ends up being better at predicting the class that is most prevalent in the data.

There are a number of ways that one can address the class imbalance. We're going to use `SMOTE()` from the `DMwR` package. [SMOTE](https://jair.org/index.php/jair/article/view/10302) ("Synthetic Minority Over-sampling Technique") is an algorithm which generates balanced data by under-sampling the majority class and over-sampling the minority class. Under-sampling is easy. Over-sampling is more subtle. SMOTE uses nearest neighbour information to synthetically generate new (but representative!) data for the minority class.

{{< highlight r >}}
library(DMwR)

train_smote <- SMOTE(no_show ~ ., train, perc.over = 100, perc.under = 200)
{{< /highlight >}}

Unfortunately `SMOTE()` does not currently work with a `tibble`, so you need to convert the training data into a `data.frame` before running the above.

{{< highlight r >}}
table(train_smote$no_show)
{{< /highlight >}}
{{< highlight text >}}
  Yes    No 
35712 35712
{{< /highlight >}}

Overall there are fewer records, but the two outcome classes are now perfectly in balance.

## Classifier with Balanced Data

We'll train the same classifier but using the balanced data.

{{< highlight r >}}
xgb_smote <- train(no_show ~ .,
                   data = train_smote,
                   method = "xgbTree",
                   metric = "Sens",
                   trControl = control
)
{{< /highlight >}}

Let's see how well that performs on the test data.

{{< highlight r >}}
confusionMatrix(predict(xgb_smote, test), test$no_show)
{{< /highlight >}}

{{< highlight text >}}
Confusion Matrix and Statistics

          Reference
Prediction   Yes    No
       Yes  3128  6815
       No   1335 10826
                                          
               Accuracy : 0.6313          
                 95% CI : (0.6249, 0.6377)
    No Information Rate : 0.7981          
    P-Value [Acc > NIR] : 1               
                                          
                  Kappa : 0.2157          
 Mcnemar's Test P-Value : <2e-16          
                                          
            Sensitivity : 0.7009          
            Specificity : 0.6137          
         Pos Pred Value : 0.3146          
         Neg Pred Value : 0.8902          
             Prevalence : 0.2019          
         Detection Rate : 0.1415          
   Detection Prevalence : 0.4498          
      Balanced Accuracy : 0.6573          
                                          
       'Positive' Class : Yes
{{< /highlight >}}

Significantly better! The overall accuracy of the classifier has dropped, but the sensitivity has increased dramatically. The specificity has also declined, but that was inevitable: there's always going to be a compromise between sensitivity and specificity!

Moral: unbalanced data can yield sub-optimal models, but simple rebalancing can improve model performance appreciably.

<!--
<iframe width="560" height="315" src="https://www.youtube.com/embed/JtswlY4WflI" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>
-->
