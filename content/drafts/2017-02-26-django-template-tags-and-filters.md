---
draft: true
title: 'Django: Template Tags and Filters'
author: andrew
type: post
date: 2017-02-26T08:21:59+00:00
categories:
  - Django
tags:
  - Django
  - filter
  - template

---
https://docs.djangoproject.com/en/1.10/ref/templates/builtins/

### regroup

### dictsort

### default

[code language=&#8221;html&#8221; gutter=&#8221;false&#8221;]
  
|default
  


### date

[code language=&#8221;html&#8221; gutter=&#8221;false&#8221;]
  
|date:"H:i:s"
  


### pluralize

{% raw %}
> {% with total=business.employees.count %}
      
> {{ total }} employee{{ total|pluralize }}
  
> {% endwith %} 
{% endraw %}

### linebreaksbr and linebreaks

[code language=&#8221;html&#8221; gutter=&#8221;false&#8221;]
  
|linebreaksbr
  

  
[code language=&#8221;html&#8221; gutter=&#8221;false&#8221;]
  

  
[code language=&#8221;html&#8221; gutter=&#8221;false&#8221;]
  

  
[code language=&#8221;html&#8221; gutter=&#8221;false&#8221;]
  

  
[code language=&#8221;html&#8221; gutter=&#8221;false&#8221;]
  

  
[code language=&#8221;html&#8221; gutter=&#8221;false&#8221;]
  


## Maths

### divisibleby
