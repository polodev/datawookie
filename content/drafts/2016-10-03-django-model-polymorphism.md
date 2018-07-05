---
draft: true
title: 'Django: Model Polymorphism'
author: andrew
type: post
date: 2016-10-03T15:00:23+00:00
categories:
  - Django
  - Python
tags:
  - Django
  - Polymorphism

---
I was a little disappointed to learn that model polymorphism doesn&#8217;t work out of the box in Django. Given the intricacies of the [Object Relational Mapping][1] (ORM) though, I guess that this is not too surprising. Fortunately the django-polymorphic package provides the missing functionality.

Here&#8217;s what you need to get started:

  1. Install [django-polymorphic][2]. Consult the [documentation][3] for further details. 
      * Add `polymorphic` to `INSTALLED_APPS` directly before `django.contrib.contenttypes`. </ol> 
        You&#8217;re ready to roll.
        
        ## Control: Plain Django
        
        Suppose that you wanted to create a simple model hierarchy for bank accounts. This is how you might go about doing it in plain vanilla Django. First create the base model, `Account`.
        
        [code language=&#8221;python&#8221; gutter=&#8221;false&#8221;]
  
        from django.db import models
        
        class Account(models.Model):
    
        number = models.CharField(max_length = 24)
    
        balance = models.DecimalField(max\_digits = 12, decimal\_places = 2, default = 0)
  

  
        Then add in a few derived models.
  
        [code language=&#8221;python&#8221; gutter=&#8221;false&#8221;]
  
        class CreditCard(Account):
    
        limit = models.DecimalField(max\_digits = 12, decimal\_places = 2)
        
        class Current(Account):
    
        overdraft = models.BooleanField(default = False)
        
        class Savings(Account):
    
        notice = models.BooleanField(default = True)
  

  
        We can take this setup for a whirl from the Python console using `python3 manage.py shell`. We&#8217;ll create a few instances of the derived classes and then retrieve them using the base class.
  
        [code language=&#8221;python&#8221; gutter=&#8221;false&#8221;]
  
        In [2]: models.CreditCard.objects.create(number = "1001365279X3", limit = -10000.00)
     
        &#8230;: models.Current.objects.create(number = "1001278362X2")
     
        &#8230;: models.Savings.objects.create(number = "1001523843X1")
     
        &#8230;:
  
        Out[2]: <Savings: Savings object>
        
        In [3]: models.Account.objects.all()
  
        Out[3]: [<Account: Account object>, <Account: Account object>, <Account: Account object>]
  

  
        Note that all of the returned objects are of type `Account` (the base model). Not really what we want because this means that they will all behave like an `Account` rather than their respective derived type.
        
        ## Alternative: Django with PolymorphicModel
        
        Rather than building the the base model on top of `models.Model` we can use `PolymorphicModel`.
        
        [code language=&#8221;python&#8221; gutter=&#8221;false&#8221;]
  
        from polymorphic.models import PolymorphicModel
        
        class Account(PolymorphicModel):
    
        number = models.CharField(max_length = 24)
    
        balance = models.DecimalField(max\_digits = 12, decimal\_places = 2, default = 0)
  

  
        Creating the same set of test data we find that each is represented by the appropriate model. Nice!
  
        [code language=&#8221;python&#8221; gutter=&#8221;false&#8221;]
  
        In [3]: models.Account.objects.all()
  
        Out[3]: [<CreditCard: CreditCard object>, <Current: Current object>, <Savings: Savings object>]
  

        
        With [django-polymorphic][2] you&#8217;ll find that instances of derived models behave as you&#8217;d expect (and hope!) they would. This behaviour extends to access via ForeignKey, ManyToManyField or OneToOneField.

 [1]: https://en.wikipedia.org/wiki/Object-relational_mapping
 [2]: https://github.com/django-polymorphic/django-polymorphic
 [3]: https://django-polymorphic.readthedocs.io/en/stable/
