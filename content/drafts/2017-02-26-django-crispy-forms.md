---
draft: true
title: 'Django: Forms'
author: andrew
type: post
date: 2017-02-26T08:21:24+00:00
categories:
  - Django
  - Web Development
tags:
  - Crispy Forms
  - Django

---


https://www.pydanny.com/core-concepts-django-forms.html



[Crispy Forms][1] is an application which will transform the appearance of your Django forms. The full and detailed documentation can be found [here][2]. This article is just the bare essentials (and a memory jogger for me!).

## Enabling Crispy Forms

The first step to enabling Crispy Forms is to add it to your list of installed applications in `settings.py`:
  
[code language=&#8221;python&#8221; gutter=&#8221;false&#8221; highlight=&#8221;9&#8243;]
  
INSTALLED_APPS = (
      
&#8216;django\_admin\_bootstrapped&#8217;,
      
&#8216;django.contrib.admin&#8217;,
      
&#8216;django.contrib.auth&#8217;,
      
&#8216;django.contrib.contenttypes&#8217;,
      
&#8216;django.contrib.sessions&#8217;,
      
&#8216;django.contrib.messages&#8217;,
      
&#8216;django.contrib.staticfiles&#8217;,
      
&#8216;crispy_forms&#8217;,
  
)
  


If you&#8217;re using Bootstrap and you want to unleash the full bling then you&#8217;ll also need to include the following in your `settings.py`:
  
[code language=&#8221;python&#8221; gutter=&#8221;false&#8221;]
  
CRISPY\_TEMPLATE\_PACK = &#8216;bootstrap3&#8217;
  


Finally you need to include {% raw %}`{% load crispy_forms_tags %}`{% endraw %} at the top of your HTML templates.

## Using Crispy Forms

At this point you're essentially ready to go. 

### Tag
  


### You can convert your plain vanilla form into a crisy form by simply using the {% raw %}`{% crispy %}`{% endraw %} template tag.

### Filter
  


### An alternative approach is to use the `|crispy` filter.

## Changing Model Representation in Forms

THIS IS VERY HANDY WHEN YOU WANT TO HAVE SPECIFIC REPRESENTATION OF MODELS IN FORMS WHICH DIFFERS FROM NORMAL \_\_str\_\_ OUTPUT

http://stackoverflow.com/questions/20012533/how-to-choose-the-value-and-label-from-django-modelchoicefield-queryset

SEE SOLUTIONS TOWARDS BOTTOM OF PAGE INVOLVING label\_from\_instance

 [1]: https://github.com/django-crispy-forms/django-crispy-forms
 [2]: http://django-crispy-forms.readthedocs.io/en/latest/
