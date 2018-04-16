---
author: Andrew B. Collier
date: 2013-11-24T12:18:47Z
tags: ["R"]
title: Implementing a Queue as a Reference Class
---

I am working on a simulation for an [Automatic Repeat-reQuest (ARQ)](https://en.wikipedia.org/wiki/Automatic_repeat_request) algorithm. After trying various options, I concluded that I would need an implementation of a [queue](https://en.wikipedia.org/wiki/Queue_(abstract_data_type)) to make this problem tractable. R does not have a native queue data structure, so this seemed like a good opportunity to implement one and learn something about Reference Classes in the process.

# The Implementation

We use setRefClass() to create a generator function which will create objects of the Queue class.

{{< highlight r >}}
Queue <- setRefClass(Class = "Queue",
                     fields = list(
                       name = "character",
                       data = "list"
                     ),
                     methods = list(
                       size = function() {
                         'Returns the number of items in the queue.'
                         return(length(data))
                       },
                       #
                       push = function(item) {
                         'Inserts element at back of the queue.'
                         data[[size()+1]] <<- item
                       },
                       #
                       pop = function() {
                         'Removes and returns head of queue (or raises error if queue is empty).'
                         if (size() == 0) stop("queue is empty!")
                         value <- data[[1]]
                         data[[1]] <<- NULL
                         value
                       },
                       #
                       poll = function() {
                         'Removes and returns head of queue (or NULL if queue is empty).'
                         if (size() == 0) return(NULL)
                         else pop()
                       },
                       #
                       peek = function(pos = c(1)) {
                         'Returns (but does not remove) specified positions in queue (or NULL if any one of them is not available).'
                         if (size() < max(pos)) return(NULL)
                         #
                         if (length(pos) == 1) return(data[[pos]])
                         else return(data[pos])
                       },
                       initialize=function(...) {
                         callSuper(...)
                         #
                         # Initialise fields here (place holder)...
                         #
                         .self
                       }
                     )
)
{{< /highlight >}}

# Methods of the Generator Function

Let's look at some of the methods for the generator function. The first of these is new(), which will create a fresh instance of the class. We will return to more examples of this later.

{{< highlight r >}}
> Queue$new()
Reference class object of class "Queue"
Field "name":
character(0)
Field "data":
list()
{{< /highlight >}}

Next we have methods() and fields() which, not surprisingly, return vectors of the names of the class's methods and data fields respectively.

{{< highlight r >}}
> Queue$methods()
 [1] "callSuper"    "copy"         "export"       "field"        "getClass"     "getName"      "getRefClass" 
 [8] "import"       "initFields"   "initialize"   "peek"         "poll"         "pop"          "push"        
[15] "setName"      "show"         "size"         "trace"        "untrace"      "usingMethods"
> Queue$fields()
       name        data 
"character"      "list" 
{{< /highlight >}}

Lastly the help() method which, by default, returns some general information about the class.

{{< highlight r >}}
> Queue$help()
Usage:  $help(topic) where topic is the name of a method (quoted or not)
The definition of class Queue follows.
Reference Class "Queue":

Class fields:
                          
Name:       name      data
Class: character      list

 Class Methods:  
    "callSuper", "copy", "export", "field", "getClass", "getName", "getRefClass", "import", "initFields", "initialize", 
"peek", "poll", "pop", "push", "setName", "show", "size", "trace", "untrace", "usingMethods"


 Reference Superclasses:  
    "envRefClass"
{{< /highlight >}}

However, if provided with a method name as an argument, it will provide a help string for the specifed method. These help strings are embedded in the class definition using a syntax which will be familiar to Python programmers.

{{< highlight r >}}
> Queue$help(push)
Call:
$push(item)


Inserts element at back of the queue.
{{< /highlight >}}

# Creating Objects (and some Reference Class Features)

Each Queue object can be assigned a name. I am not sure whether this will be required, but it seemed like a handy feature to have. This can be done after the object has been created...

{{< highlight r >}}
> q1 <- Queue$new()
> q1$name <- "test queue"
> q1$name
[1] "test queue"
> 
> q1
Reference class object of class "Queue"
Field "name":
[1] "test queue"
Field "data":
list()
{{< /highlight >}}

... or during the creation process.

{{< highlight r >}}
> q2 <- Queue$new(name = "another test") > q2$name
[1] "another test"
{{< /highlight >}}

We have seen that the name field can be accessed using the dollar operator. We can also use the accessors() method for the generator function to create methods for reading and writing to the name field.

{{< highlight r >}}
> Queue$accessors("name")
>
> q2$getName()
[1] "another test"
> q2$setName("a new name")
> q2$getName()
[1] "a new name"
{{< /highlight >}}

# Standard Queue Functionality

Let's get down to the actual queue functionality. First we add elements to the queue using the push() method.

{{< highlight r >}}
> q2$push("item number one")
> q2$push(2)
> q2$push("third item")
> q2$size()
[1] 3
{{< /highlight >}}

The queue now contains three items (two strings and a number). The items are stored in the data field. Ideally this should not be directly accessible, but the Reference Class implementation does not provide for private data. So you can access the items directly (but this defeats the object of a queue!).

{{< highlight r >}}
> q2$data
[[1]]
[1] "item number one"
[[2]]
[1] 2
[[3]]
[1] "third item"
{{< /highlight >}}

Next we can start to access and remove items from the queue. The first way to do this uses pop(), which returns the item at the head of the queue and at the same time removes it from the queue.

{{< highlight r >}}
> q2$pop()
[1] "item number one"
> q2$pop()
[1] 2
> q2$size()
[1] 1
{{< /highlight >}}

What if we just want to have a look at the first item in the queue but not remove it? Use peek().

{{< highlight r >}}
> q2$peek()
[1] "third item"
> q2$size()
[1] 1

{{< /highlight >}}

Next we have poll(), which is very much like pop() in that it removes the first item from the queue. But, as we will see in a moment, it behaves differently when the queue is empty.

{{< highlight r >}}
> q2$poll()
[1] "third item"
> q2$size()
[1] 0
{{< /highlight >}}

So we have ejected all three items from the queue and we should expect the behaviour of these functions to be a little different now. pop() generates an error message: obviously we cannot remove an item from the queue if it is empty!

{{< highlight r >}}
> try(q2$pop())
Error in q2$pop() : queue is empty!
{{< /highlight >}}

This might not be the best behaviour for harmonious code, so peek() and poll() more elegantly indicate that that the queue is exhausted by returning NULL.

{{< highlight r >}}
> q2$peek()
NULL
> q2$poll()
NULL
{{< /highlight >}}

## Non-Standard Queue Functionality

I am going to need to be able to take a look at multiple items in the queue, so the peek() method accepts an argument which specifies item locations. To illustrate, first let's push a number of items onto a queue.

{{< highlight r >}}
> q3 <- Queue$new(name = "letter queue") >
> sapply(letters, function(n) {q3$push(n)})
a b c d e f g h i j k l m n o p q r s t u v w x y z
"a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"
>
> q3$size()
[1] 26
{{< /highlight >}}

As we have already seen, the default peek() behaviour is just to take a look at the item at the head of the queue.

{{< highlight r >}}
> q3$peek()
[1] "a"
{{< /highlight >}}

But we can also choose items further down the queue as well as ranges of items.

{{< highlight r >}}
> q3$peek(2)
[1] "b"
> q3$peek(4:7)
[[1]]
[1] "d"
[[2]]
[1] "e"
[[3]]
[1] "f"
[[4]]
[1] "g"
{{< /highlight >}}

If the requested range of locations extends beyond the end of the queue then the method returns NULL as before.

{{< highlight r >}}
> q3$peek(24:28)
NULL
{{< /highlight >}}

# Conclusion

That is all the infrastructure I will need for my ARQ project. Well, almost. I would actually prefer a [Priority Queue](https://en.wikipedia.org/wiki/Priority_queue). I'll be back with the implementation of that in a day or two. In the meantime though, if anyone has any ideas for additional functionality or has suggestions for how this code might be improved, I would be very pleased to hear them.

This code is now published in the [liqueueR](https://github.com/DataWookie/liqueueR) package.
