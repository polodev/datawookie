---
draft: true
title: 'Django: Notes on Object-Relational Mappers'
author: andrew
type: post
date: 2017-02-26T08:21:59+00:00
categories:
  - Django
tags:
  - Django

---
## Duplicating an Object

Set the primary key for an existing object to `None` and then call it&#8217;s `save()` method to create a new object.

[code language=&#8221;python&#8221; gutter=&#8221;false&#8221;]
  
scenario = get\_object\_or\_404(Scenario, pk = scenario\_id)
  
scenario.pk = None
  
scenario.save()
  

