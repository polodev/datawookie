---
author: Andrew B. Collier
date: 2015-07-10T21:30:20Z
tags: ["Conference"]
title: Constructing a Word Cloud for ICML 2015
---

Word clouds have become a bit cliché, but I still think that they have a place in giving a high level overview of the content of a corpus. Here are the steps I took in putting together the word cloud for the International Conference on Machine Learning (2015).

<!--more-->

<img src="/img/2015/07/word-cloud.png">

1. Extract the hyperlinks to the PDFs of all of the papers from the [Conference Programme](http://icml.cc/2015/?page_id=825) web site using a pipeline of grep and uniq. 
2. In R, extract the text from each of these PDFs using the Rpoppler package. 
3. Split the text for each page into lines and remove the first line (corresponding to the running title) from every page except the first. 
4. Intelligently handle word breaks and then concatenate lines within each document. 
5. Transform text to lower case then remove punctuation, digits and stop words using the tm package. 
6. Compile the words for all of the documents into a single data.frame. 
7. Using the dplyr package count the number of times that each word occurs across the entire corpus as well as the number of documents which contain that word. This is what the top end of the resulting data.frame looks like:
{{< highlight r >}}
> head(word.counts)
       word count doc
1       can  6496 270
2  learning  5818 270
3 algorithm  5762 252
4      data  5687 254
5     model  4956 242
6       set  4040 269
{{< /highlight >}}
8. Finally, construct a word cloud with the tagcloud package using the word count to weight the word size and the document count to determine grey scale.

The first cloud above contains the top 300 words. The larger cloud below is the top 1000 words.

<img src="/img/2015/07/word-cloud-large.png" width="100%">
