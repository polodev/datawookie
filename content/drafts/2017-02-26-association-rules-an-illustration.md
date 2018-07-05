---
draft: true
title: 'Association Rules: An Illustration'
author: andrew
type: post
date: 2017-02-26T08:23:33+00:00
categories:
  - Uncategorized

---
[code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
> purchases <- read.csv(file.path("data", "purchases.csv"), stringsAsFactors = FALSE)
  
>
  
> head(purchases[, 1:10])
          
date bread butter jam milk sausage bacon eggs cereal cheese
  
1 2014/10/01 1 NA NA 1 NA NA NA NA NA
  
2 2014/10/04 NA NA NA 1 NA NA NA 1 NA
  
3 2014/10/08 1 NA NA NA NA NA NA NA 1
  
4 2014/10/12 NA NA NA NA 1 NA NA NA NA
  
5 2014/10/12 NA NA NA NA NA NA NA NA NA
  
6 2014/10/13 NA NA 1 NA NA NA NA NA NA
  


The next few steps involved removing the date column, converting the NA fields to zeros and finally transforming the binary data into logical values.

[code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
> purchases <- purchases[, -1]
  
> purchases[is.na(purchases)] <- 0
  
> purchases <- purchases == 1
  
>
  
> head(purchases[, 1:10])
       
bread butter jam milk sausage bacon eggs cereal cheese pasta
  
[1,] TRUE FALSE FALSE TRUE FALSE FALSE FALSE FALSE FALSE FALSE
  
[2,] FALSE FALSE FALSE TRUE FALSE FALSE FALSE TRUE FALSE FALSE
  
[3,] TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE TRUE FALSE
  
[4,] FALSE FALSE FALSE FALSE TRUE FALSE FALSE FALSE FALSE FALSE
  
[5,] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
  
[6,] FALSE FALSE TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
  


The final preparatory step is converting the data into a [Binary Incidence Matrix][1], which is the transaction class used for mining the rules.

[code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
> purchases <- as(purchases, "transactions")
  


A high level summary gives an indication of the number of transactions, variety of items purchased and the most frequently purchased items.

[code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
> summary(purchases)
  
transactions as itemMatrix in sparse format with
   
38 rows (elements/itemsets/transactions) and
   
20 columns (items) and a density of 0.15 

most frequent items:
    
bread steak sausage eggs wors (Other)
       
13 8 7 7 7 72 

element (itemset/transaction) length distribution:
  
sizes
   
2 3 4 5 6
  
12 20 2 2 2 

Min. 1st Qu. Median Mean 3rd Qu. Max.
        
2 2 3 3 3 6 

includes extended item information &#8211; examples:
    
labels
  
1 bread
  
2 butter
  
3 jam
  


We&#8217;ll have a quick look at the distribution of purchases. That&#8217;s quite a lot of bread. But I do like my sandwiches.

[code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
itemFrequencyPlot(purchases)
  


[<img src="http://162.243.184.248/wp-content/uploads/2015/01/item-frequency-plot.png" alt="item-frequency-plot" width="800" height="400" class="aligncenter size-full wp-image-1135" srcset="http://162.243.184.248/wp-content/uploads/2015/01/item-frequency-plot.png 800w, http://162.243.184.248/wp-content/uploads/2015/01/item-frequency-plot-300x150.png 300w, http://162.243.184.248/wp-content/uploads/2015/01/item-frequency-plot-768x384.png 768w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 984px) 61vw, (max-width: 1362px) 45vw, 600px" />][2]

## Mining Rules with Apriori

[code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
> rules <- apriori(purchases, parameter = list(support = 0.1, confidence = 0.5))

Parameter specification:
   
confidence minval smax arem aval originalSupport support minlen maxlen target ext
          
0.5 0.1 1 none FALSE TRUE 0.1 1 10 rules FALSE

Algorithmic control:
   
filter tree heap memopt load sort verbose
      
0.1 TRUE TRUE FALSE TRUE 2 TRUE

apriori &#8211; find association rules with the apriori algorithm
  
version 4.21 (2004.05.09) (c) 1996-2004 Christian Borgelt
  
set item appearances &#8230;[0 item(s)] done [0.00s].
  
set transactions &#8230;[20 item(s), 38 transaction(s)] done [0.00s].
  
sorting and recoding items &#8230; [18 item(s)] done [0.00s].
  
creating transaction tree &#8230; done [0.00s].
  
checking subsets of size 1 2 3 done [0.00s].
  
writing &#8230; [30 rule(s)] done [0.00s].
  
creating S4 object &#8230; done [0.00s].
  


[code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
> summary(rules)
  
set of 30 rules

rule length distribution (lhs + rhs):sizes
   
2 3
  
21 9 

Min. 1st Qu. Median Mean 3rd Qu. Max.
      
2.0 2.0 2.0 2.3 3.0 3.0 

summary of quality measures:
      
support confidence lift
   
Min. :0.105 Min. :0.500 Min. :1.95
   
1st Qu.:0.105 1st Qu.:0.800 1st Qu.:3.80
   
Median :0.105 Median :1.000 Median :5.43
   
Mean :0.130 Mean :0.871 Mean :5.22
   
3rd Qu.:0.184 3rd Qu.:1.000 3rd Qu.:6.08
   
Max. :0.184 Max. :1.000 Max. :9.50 

mining info:
        
data ntransactions support confidence
   
purchases 38 0.1 0.5
  


[code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
> inspect(head(sort(rules, by = "confidence")))
    
lhs rhs support confidence lift
  
1 {pasta} => {tomatoes} 0.10526 1 9.5000
  
2 {tomatoes} => {pasta} 0.10526 1 9.5000
  
3 {butter} => {bread} 0.13158 1 2.9231
  
4 {wood} => {matches} 0.18421 1 5.4286
  
5 {matches} => {wood} 0.18421 1 5.4286
  
6 {wood} => {wors} 0.18421 1 5.4286
  
> inspect(tail(sort(rules, by = "confidence")))
    
lhs rhs support confidence lift
  
1 {bread,
     
butter} => {jam} 0.10526 0.80000 6.0800
  
2 {milk} => {bread} 0.10526 0.66667 1.9487
  
3 {eggs} => {steak} 0.10526 0.57143 2.7143
  
4 {steak} => {spinach} 0.10526 0.50000 3.8000
  
5 {steak} => {potatoes} 0.10526 0.50000 3.8000
  
6 {steak} => {eggs} 0.10526 0.50000 2.7143
  


[code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
> inspect(head(sort(rules, by = "support")))
    
lhs rhs support confidence lift
  
1 {wood} => {matches} 0.18421 1 5.4286
  
2 {matches} => {wood} 0.18421 1 5.4286
  
3 {wood} => {wors} 0.18421 1 5.4286
  
4 {wors} => {wood} 0.18421 1 5.4286
  
5 {matches} => {wors} 0.18421 1 5.4286
  
6 {wors} => {matches} 0.18421 1 5.4286
  
> inspect(tail(sort(rules, by = "support")))
    
lhs rhs support confidence lift
  
1 {potatoes,
     
spinach} => {steak} 0.10526 1.0 4.7500
  
2 {steak,
     
spinach} => {potatoes} 0.10526 1.0 7.6000
  
3 {steak,
     
potatoes} => {spinach} 0.10526 1.0 7.6000
  
4 {butter,
     
jam} => {bread} 0.10526 1.0 2.9231
  
5 {bread,
     
butter} => {jam} 0.10526 0.8 6.0800
  
6 {bread,
     
jam} => {butter} 0.10526 1.0 7.6000
  


[code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
> inspect(head(sort(rules, by = "lift")))
    
lhs rhs support confidence lift
  
1 {pasta} => {tomatoes} 0.10526 1.0 9.50
  
2 {tomatoes} => {pasta} 0.10526 1.0 9.50
  
3 {steak,
     
spinach} => {potatoes} 0.10526 1.0 7.60
  
4 {steak,
     
potatoes} => {spinach} 0.10526 1.0 7.60
  
5 {bread,
     
jam} => {butter} 0.10526 1.0 7.60
  
6 {spinach} => {potatoes} 0.10526 0.8 6.08
  
> inspect(tail(sort(rules, by = "lift")))
    
lhs rhs support confidence lift
  
1 {butter} => {bread} 0.13158 1.00000 2.9231
  
2 {butter,
     
jam} => {bread} 0.10526 1.00000 2.9231
  
3 {steak} => {eggs} 0.10526 0.50000 2.7143
  
4 {eggs} => {steak} 0.10526 0.57143 2.7143
  
5 {jam} => {bread} 0.10526 0.80000 2.3385
  
6 {milk} => {bread} 0.10526 0.66667 1.9487
  


## Mining Rules with Eclat

[code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  


[code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  


[code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  


[code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  


[code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  


 [1]: http://en.wikipedia.org/wiki/Incidence_matrix
 [2]: http://162.243.184.248/wp-content/uploads/2015/01/item-frequency-plot.png
