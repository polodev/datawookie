---
draft: true
title: 'Django: ForeignKey Reverse Lookup'
author: andrew
type: post
date: 2017-02-26T08:22:10+00:00
categories:
  - Uncategorized

---
## Simple Approach

parent = models.ForeignKey(&#8216;self&#8217;, blank = True, null = True)

parent_set.all()

But that&#8217;s a little ugly.

## Using Related Name</h2 parent = models.ForeignKey('self', blank = True, null = True, related_name = 'children') Now you can use children.all() </p>
