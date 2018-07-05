---
draft: true
title: 'PLOS Subject Keywords: Collaborative Filtering'
author: andrew
type: post
date: 2017-02-26T08:21:59+00:00
categories:
  - R
tags:
  - R
  - Association Rules
  - Collaborative Filtering
  - PLOS
  - recommenderlab
  - rplos

---
This post follows on from a [previous analysis][1] where I used Association Rules to examine the relationships between Subject Keywords for articles published in [PLOS journals][2]. This time we&#8217;ll be looking at the same set of data but applying Collaborative Filtering to generate recommendations. We&#8217;ll be using the [recommenderlab][3] package here but the the [recosystem][4] package is a compelling alternative, well worth investigating.

## Data Matrix

As in the previous instalment, the first step is to transform our data into a suitable matrix. There are a couple of differences though:

  * the matrix contains counts rather than binary values and 
      * rows represent articles and columns represent subjects. </ul> 
        Before we generate that matrix though we&#8217;re going to subset the data, retaining only those articles which were published in [PLOS Pathogens][5]. The reason for this is just to speed up execution time (and avoid my machine simply running out of memory!).
  
        [code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
        > library(dplyr)
  
        >
  
        > medicine.subjects <- subset(subjects, journal == "PLOS Pathogens") %>%
  
        + mutate(
  
        + doi = factor(doi),
  
        + subject = factor(subject)
  
        + )
  

  
        We can now transform the remaining data into a sparse matrix.
  
        [code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
        > library(Matrix)
  
        >
  
        > subjects.matrix <- with(medicine.subjects, sparseMatrix(j = as.integer(subject),
  
        + i = as.integer(doi),
  
        + x = count,
  
        + dimnames = list(levels(doi),
  
        + levels(subject))))
  
        >
  
        > class(subjects.matrix)
  
        [1] "dgCMatrix"
  
        attr(,"package")
  
        [1] "Matrix"
  

        
        The result is of class `dgCMatrix` which can immediately be transformed into a `realRatingMatrix`.
        
        [code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
        > library(recommenderlab)
  
        >
  
        > ratings <- new("realRatingMatrix", data = subjects.matrix)
  

        
        ## Exploration
        
        Let&#8217;s look at the number of subjects per article.
  
        [code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
        > table(rowCounts(ratings))
        
        1 3 6 7 8
   
        286 3 1 1 5088
  

  
        The vast majority of articles have eight subjects. We will not sacrifice too much data if we exclude those articles which have fewer than eight subjects.
  
        [code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
        > ratings = ratings[rowCounts(ratings) > 7,]
  

        
        It&#8217;s a simple matter to transform the rating matrix to a data frame or list. This makes it easier to view the ratings for individual articles. This view on the data is equivalent to what we started with before we built the matrix, so there&#8217;s really nothing new here.
        
        [code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
        > ratings.df <- as(ratings, "data.frame")
  
        >
  
        > subset(ratings.df, user == "10.1371/journal.ppat.0010003")
                                
        user item rating
  
        7023 10.1371/journal.ppat.0010003 Cloning 2
  
        14546 10.1371/journal.ppat.0010003 Glycosylation 2
  
        25969 10.1371/journal.ppat.0010003 Nucleotide sequencing 2
  
        27984 10.1371/journal.ppat.0010003 Phylogenetic analysis 2
  
        33210 10.1371/journal.ppat.0010003 Sequence analysis 2
  
        33343 10.1371/journal.ppat.0010003 Sequence motif analysis 2
  
        33844 10.1371/journal.ppat.0010003 SIV 8
  
        38860 10.1371/journal.ppat.0010003 Viral replication 1
  

        
        Alternatively we can look at individual rows from the ratings matrix.
  
        [code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
        > as(ratings[3,], "list")
  
        $\`10.1371/journal.ppat.0010003\`
                  
        Cloning Glycosylation Nucleotide sequencing Phylogenetic analysis
                        
        2 2 2 2
        
        Sequence analysis Sequence motif analysis SIV Viral replication
                        
        2 2 8 1
  

        
        ## Normalised Rating Matrix
        
        To avoid the potential for bias among the ratings we&#8217;ll normalise the rows by subtracting the mean rating per row. This is not a big issue for the PLOS data, but in general it&#8217;s an important step.
        
        [code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
        > ratings.norm <- normalize(ratings)
  

        
        By default `normalize()` will simply subtract off the mean from each row, however, it&#8217;s also possible to reduce each of the rows to z-scores.
        
        The histograms below compare the raw ratings (left) to those after normalisation (right).
        
        <img src="http://162.243.184.248/wp-content/uploads/2016/09/plot-ratings-histogram.png" alt="plot-ratings-histogram" width="800" height="400" class="aligncenter size-full wp-image-4402" srcset="http://162.243.184.248/wp-content/uploads/2016/09/plot-ratings-histogram.png 800w, http://162.243.184.248/wp-content/uploads/2016/09/plot-ratings-histogram-300x150.png 300w, http://162.243.184.248/wp-content/uploads/2016/09/plot-ratings-histogram-768x384.png 768w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 984px) 61vw, (max-width: 1362px) 45vw, 600px" />
        
        ## Binary Rating Matrix
        
        The matrix of real valued ratings can be transformed into a binary matrix by applying a threshold: items with a rating above the threshold will have a binary rating of 1 and the others will have a binary rating of 0. This effectively indicates whether or not an item was rated highly.
        
        [code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
        > ratings.binary <- binarize(ratings, minRating = 3)
  

        
        The resulting matrix only has entries (with values of 1) where the original rating is 3 or more.
        
        ## Building a Popular Recommender
        
        In the interests of good data hygiene, we&#8217;ll divide our data into training and testing sets. Furthermore we&#8217;ll ensure that the test article we&#8217;ve looked at a couple of times above (DOI 10.1371/journal.ppat.0010003) is located in the testing set.
  
        [code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
        > set.seed(5)
  
        > #
  
        > train.index <- sample(c(T, F), nrow(ratings), replace = TRUE, prob = c(0.8, 0.2))
  
        > #
  
        > train.index[3]
  
        [1] FALSE
  

        
        We&#8217;ll use these training data to build a recommender of type `POPULAR`.
  
        [code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
        recommend.popular <- Recommender(ratings[train.index,], method = "POPULAR")
  

  
        The result is an object of type `Recommender`. See `?Recommender` and `` ?`Recommender-class` `` for more details.
        
        What subjects does this recommend for our test article?
  
        [code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
        > predictions.popular <- predict(recommend.popular, ratings[3,], n = 5)
  
        > as(predictions.popular, "list")
  
        [[1]]
  
        [1] "HIV-1" "Antibodies" "HIV" "Cytokines" "T cells"
  

  
        Those don&#8217;t seem to tie in particularly well with the other subjects already assigned to that article. Let&#8217;s look at some other articles.
  
        [code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
        > as(predict(recommend.popular, ratings[2317,], n = 5), "list")
  
        [[1]]
  
        [1] "HIV-1" "Antibodies" "HIV" "Cytokines" "Macrophages"
        
        > as(predict(recommend.popular, ratings[3284,], n = 5), "list")
  
        [[1]]
  
        [1] "HIV-1" "Antibodies" "HIV" "Cytokines" "T cells" 
        
        > as(predict(recommend.popular, ratings[4965,], n = 5), "list")
  
        [[1]]
  
        [1] "HIV-1" "Antibodies" "HIV" "Cytokines" "T cells"
  

  
        The recommendations are essentially the same for each of these&#8230; Only the first one differs because the subject &#8220;T cells&#8221; was already present for that article. The reason for the consistency of recommendations is the type of the recommender: a `POPULAR` recommender simply suggests the subjects which are popular overall, irrespective of which subjects have already been assigned to a given article.
        
        This simple recommender can also provide predicted ratings for using particular subjects with an article. For example, below are the predicted ratings for a few subjects across the articles consider above. Again note that there is no prediction for &#8220;T cells&#8221; on the second article since this subject was already used.
  
        [code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
        > ratings.popular <- as(predict(recommend.popular, ratings[c(3, 2317, 3284, 4965)], type = "ratings"), "matrix")
  
        > ratings.popular[, c(1293, 137, 1292, 703, 2651, 1610)]
                                  
        HIV-1 Antibodies HIV Cytokines T cells Macrophages
  
        10.1371/journal.ppat.0010003 7.595725 3.917933 6.062898 4.21875 3.443336 5.389045
  
        10.1371/journal.ppat.1002699 7.595725 3.917933 6.062898 4.21875 NA 5.389045
  
        10.1371/journal.ppat.1003820 7.595725 3.917933 6.062898 4.21875 3.443336 5.389045
  
        10.1371/journal.ppat.1005675 7.595725 3.917933 6.062898 4.21875 3.443336 5.389045
  

        
        ## Evaluating a Recommender
        
        It&#8217;s time to consider more sophisticated options that the simple `POPULAR` recommender above.
        
        To get a robust indication of the relative performance of these recommenders we&#8217;ll use cross-validation (it&#8217;s also possible to use a simple train/test split or boostrap). Within the test data 3 subjects per article will be provided to the recommender and the rest will be used to evaluate the quality of the recommendations.
  
        [code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
        > scheme <- evaluationScheme(ratings, method = "cross", k = 5, given = 3, goodRating = 3)
  

  
        We can check the available types of recommendation engines for data of type `realRatingMatrix`.
  
        [code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
        > recommenderRegistry$get_entries(dataType = "realRatingMatrix") %>% names
  
        [1] "IBCF\_realRatingMatrix" "PCA\_realRatingMatrix" "POPULAR_realRatingMatrix"
  
        [4] "RANDOM\_realRatingMatrix" "SVD\_realRatingMatrix" "UBCF_realRatingMatrix"
  

  
        We&#8217;ll use four of those, including both user-based (UBCF) and item-based (IBCF) collaborative filtering. The latter technique is generally regarded as being most effective for larger data sets, giving more robust results and being more computationally efficient since most calculations can be done in advance. Whereas UBCF is based on similarities between users (which can be fairly dynamic, requiring regular calculation), IBCF is driven by similarities between items (and is thus effectively static or changing only slowly with time).
        
        [code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  

        
        [code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  

        
        [code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  

        
        ## Subject Recommendations
        
        ## Article Recommendations
        
        ## Conclusion
        
        **Discuss how same system can be used to generate both user and item recommendations.</h2>

 [1]: http://www.exegetic.biz/blog/2016/09/plos-subject-keywords-association-rules/
 [2]: https://www.plos.org/
 [3]: http://lyle.smu.edu/IDA/recommenderlab/
 [4]: https://cran.r-project.org/web/packages/recosystem/index.html
 [5]: http://journals.plos.org/plospathogens/
