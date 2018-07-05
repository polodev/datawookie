---
draft: true
title: 'Review: Learn Julia (Csefalvay)'
author: andrew
type: post
date: 2017-02-26T08:23:04+00:00
categories:
  - Book Review
  - Review
---
Original review request was from slaven.sekuljica@yahoo.com.

I was asked to review an early access version of [Learn Julia][1] by Chris von Csefalvay (soon to be published by Manning Publications).

[<img src="http://162.243.184.248/wp-content/uploads/2015/09/Learn_Julia_meap_large-816x1024.png" alt="Learn_Julia_meap_large" width="100%" class="aligncenter size-large wp-image-2047" srcset="http://162.243.184.248/wp-content/uploads/2015/09/Learn_Julia_meap_large.png 816w, http://162.243.184.248/wp-content/uploads/2015/09/Learn_Julia_meap_large-239x300.png 239w, http://162.243.184.248/wp-content/uploads/2015/09/Learn_Julia_meap_large-768x964.png 768w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 984px) 61vw, (max-width: 1362px) 45vw, 600px" />][2]

#### Introduction

This chapter ably answers the question &#8220;Why you should care about Julia?&#8221;, giving four concrete reasons why you should be interested: speed, aesthetics, ecosystem and good language design. To be fair it also points out a couple of negative aspects, but these are IMHO really small potatoes. The chapter ends with a overview of the structure of the book.

#### First Steps: Installing Julia

First things first: you need to install Julia. Well, as it turns out, you don&#8217;t actually need to install it because you can run an interactive session with an IJulia notebook through the [juliabox][3] website. But installing Julia on your local machine is definitely a good idea, especially if you are going to be using it routinely. This chapter gives details of various ways to install Julia (either from source, a package manager or in a Docker container). It also gives an introduction to literate programming (which in my mind is, or should be, just a synonym for reproducible research), which is definitely something that you should be interested in if you are going to be sharing your code and results.

#### Julia Meets Mathematics

This chapter introduces the way that Julia handles variables and specifically looks at integer, real and rational data types. Since these are going to be the bread and butter of any numerical work done with Julia, this is a good place to start. At this point it&#8217;s worth noting that the book is based on the new and improved Julia version 0.4. I&#8217;ve been running Julia version 0.3.10 and this chapter made me of some small changes in syntax. These are handy to know because some time soon I will be transitioning to version 0.4.

#### 4. STRINGS

4.1. The anatomy of a string in Julia
  
4.2. To bigger (and better) strings!
  
4.3. String manipulation
  
4.4. Reading and writing strings
  
4.5. Putting it all together: Who speaks in Hamlet?
  
4.6. Summary

#### 5. INDEXABLE COLLECTIONS

5.1. Exploring arrays and tuples
  
5.2. Creating arrays using comprehensions
  
5.3. Accessing elements of an indexable collection
  
5.4. Unpacking collections for fun and profit
  
5.5. Retrieving elements from indexable collections
  
5.6. Filtering indexable collections
  
5.7. Putting it all together: A far too elaborate way to manage your shopping lists

#### 6. ASSOCIATIVE AND SET-LIKE COLLECTIONS

6.1. Introducing dicts
  
6.2. Accessing elements of an associative collection
  
6.3. Sorting and merging associative collections
  
6.4. Introducing sets
  
6.5. Set theory operations
  
6.6. Putting it all together: Shopping list management, redux

#### 7. MATRICES

7.1. Creating matrix literals
  
7.2. Using matrix comprehensions
  
7.3. Special matrices
  
7.4. Some important matrix operations
  
7.5. Creating and using sparse matrices
  
7.6. Special representation of matrices: DataFrames and DataArrays
  
7.7. Putting it all together: statistical operations over DataFrames

#### 8. CONTROL FLOW AND ITERATION

8.1. Iteration (for)
  
8.2. Conditional (if…​then and while)
  
8.3. Compound expressions
  
8.4. A shorter route: short-circuit evaluation
  
8.5. When things go wrong: exception handling
  
8.6. Putting it all together: writing FizzBuzz in Julia

#### 9. FUNCTIONS AND METHODS

9.1. Your first function
  
9.2. Functions and methods
  
9.3. Arguments and splats
  
9.4. Understanding function scope
  
9.5. Higher order functions
  
9.6. Putting it all together: what you need to know about Julia before selling ice cream

#### 10. TYPES, CONVERSION AND PROMOTION

10.1. The concept of types
  
10.2. Creating composite types
  
10.3. Exploring the type hierarchy
  
10.4. Understanding function polymorphism
  
10.5. Putting it all together: simulating the Therac-25 machine

#### 11. I/O AND FILE SYSTEM MANAGEMENT

11.1. Reading and writing text files
  
11.2. Reading and writing JSON
  
11.3. Importing and exporting comma-separated values (CSV)
  
11.4. Putting it all together: fun with the Census

#### 12. PARALLEL PROGRAMMING

12.1. Understanding parallelism and its relevance
  
12.2. Tasks
  
12.3. Parallel data types
  
12.4. Writing functions and algorithms for parallel execution
  
12.5. Putting it all together: the Julia set in Julia

#### 13. METAPROGRAMMING, REFLECTION AND INTROSPECTION

13.1. Quoting and evaluating expressions
  
13.2. Macros
  
13.3. Reflection and introspection
  
13.4. Putting it all together: writing your own function profiler

#### 14. PACKAGES, MODULES AND PACKAGE MANAGEMENT

14.1. Organising Julia code
  
14.2. Importing packages
  
14.3. Writing packages
  
14.4. Putting it all together: your first Julia package

#### 15. EPILOGUE: ONTO BIGGER AND BETTER THINGS

v
  
APPENDIXES

#### APPENDIX A: TESTING AND PROFILING

A.1. Unit testing Julia code
  
A.2. Profiling Julia code and analyzing memory allocation

#### APPENDIX B: INVOKING NON-JULIA CODE

 [1]: https://www.manning.com/books/learn-julia
 [2]: http://162.243.184.248/wp-content/uploads/2015/09/Learn_Julia_meap_large.png
 [3]: https://www.juliabox.org/
