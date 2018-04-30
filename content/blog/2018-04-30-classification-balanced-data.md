---
author: Andrew B. Collier
date: 2018-04-21T01:00:00Z
tags: ["talk: standard"]
title: "Classification: Get the Balance Right"
draft: true
---

<!-- Image: Depeche Mode 'Get the Balance Right' -->
![](/img/2018/04/get-the-balance-right.png)

For classification problems the positive class (which is what you are generally trying to predict) is often sparsely represented in the data. Unless you do something to address this imbalance then your classifier is likely to be rather underwhelming.

You need to get the balance right!

## The Data

To illustrate we'll use some medical appointment [no-show data](https://www.kaggle.com/joniarroba/noshowappointments).

First load some indispensable packages.

{{< highlight r >}}
library(dplyr)
library(stringr)
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
appointments$no_show = relevel(appointments$no_show, "Yes")
{{< /highlight >}}

## Classifier with Unbalanced Data

{{< highlight r >}}
set.seed(13)
train_index <- createDataPartition(appointments$no_show, p = 0.8)[[1]]

train <- appointments[train_index,]
test  <- appointments[-train_index,]
{{< /highlight >}}

{{< highlight r >}}
control = trainControl(
  method = 'cv', number = 10,
  classProbs = TRUE,
  summaryFunction = twoClassSummary
  )
{{< /highlight >}}

{{< highlight r >}}
xgb <- train(no_show ~ .,
             data = train,
             method = "xgbTree",
             metric = "Sens",
             trControl = control
)
{{< /highlight >}}

{{< highlight r >}}
confusionMatrix(predict(xgb, test), test$no_show)
{{< /highlight >}}

## Balancing the Data

{{< highlight r >}}
table(train$no_show)
{{< /highlight >}}

{{< highlight r >}}
train_smote <- SMOTE(no_show ~ ., train, perc.over = 100, perc.under=200)
{{< /highlight >}}

{{< highlight r >}}
table(train_smote$no_show)
{{< /highlight >}}

## Classifier with Balanced Data

{{< highlight r >}}xgb_smote <- train(no_show ~ .,
                   data = train_smote,
                   method = "xgbTree",
                   metric = "Sens",
                   trControl = control
)

xgb_smote
{{< /highlight >}}

{{< highlight r >}}
confusionMatrix(predict(xgb_smote, test), test$no_show)
{{< /highlight >}}

{{< highlight r >}}
{{< /highlight >}}

{{< highlight r >}}
{{< /highlight >}}

{{< highlight r >}}
{{< /highlight >}}

<iframe width="560" height="315" src="https://www.youtube.com/embed/JtswlY4WflI" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>
