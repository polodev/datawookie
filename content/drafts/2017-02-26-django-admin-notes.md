---
draft: true
title: 'Django: Admin Notes'
author: andrew
type: post
date: 2017-02-26T08:21:24+00:00
categories:
  - Django
tags:
  - Django

---
https://hackernoon.com/5-ways-to-make-django-admin-safer-eb7753698ac8

https://medium.com/@hakibenita/things-you-must-know-about-django-admin-as-your-app-gets-bigger-6be0b0ee9614#.7r86h1t50

If you visit <http://127.0.0.1:8000/admin/> you&#8217;ll be greeted by the login dialog for the Django Admin portal. This is probably one of the coolest features of Django.

<img src="http://162.243.184.248/wp-content/uploads/2017/01/django-admin-login.png" alt="The login dialog for the Django Admin portal." width="800" height="600" class="aligncenter size-full wp-image-4685" srcset="http://162.243.184.248/wp-content/uploads/2017/01/django-admin-login.png 800w, http://162.243.184.248/wp-content/uploads/2017/01/django-admin-login-300x225.png 300w, http://162.243.184.248/wp-content/uploads/2017/01/django-admin-login-768x576.png 768w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 984px) 61vw, (max-width: 1362px) 45vw, 600px" />

For the moment you&#8217;re going to want to gain access to the Admin portal. To do that we&#8217;ll create a superuser account.
  
[code language=&#8221;bash&#8221; gutter=&#8221;false&#8221;]
  
$ python manage.py createsuperuser
  

  
Answer the simple questions and you&#8217;ll be ready to administer your new site. Go ahead and login.

<img src="http://162.243.184.248/wp-content/uploads/2016/10/django-logo-negative.png" alt="django-logo-negative" width="100%" class="aligncenter size-full wp-image-4544" srcset="http://162.243.184.248/wp-content/uploads/2016/10/django-logo-negative.png 1200w, http://162.243.184.248/wp-content/uploads/2016/10/django-logo-negative-300x137.png 300w, http://162.243.184.248/wp-content/uploads/2016/10/django-logo-negative-768x349.png 768w, http://162.243.184.248/wp-content/uploads/2016/10/django-logo-negative-1024x466.png 1024w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 1362px) 62vw, 840px" />

These are some notes on working with the Django Admin interface. More information can be found in the comprehensive [official documentation][1].

[code language=&#8221;python&#8221; gutter=&#8221;false&#8221;]
  
from django.db import models

class Manufacturer(models.Model):
      
pass

class Car(models.Model):
      
manufacturer = models.ForeignKey(Manufacturer)
  


## Slow Edits

If your model has a `ForeignKey` field which links to a model with many records then it can cause loading of the change form to become very, very slow indeed. The reason for this appears to be that Django generates an `<option>` element for each of those records. This results in a bloated [DOM][2] and an inordinate number of queries (many of which appear to me to be redundant!). There are a few ways around this issue:

  1. Add the `ForeignKey` field to [`readonly_fields`][3].
  
    [code language=&#8221;python&#8221; gutter=&#8221;false&#8221;]
  
    class CarAdmin(admin.ModelAdmin):
      
    readonly_fields = (&#8216;manufacturer &#8216;,)
  
</p> 
      * Add the `ForeignKey` field to [`raw_id_fields`][4].
  
        [code language=&#8221;python&#8221; gutter=&#8221;false&#8221;]
  
        class CarAdmin(admin.ModelAdmin):
      
        raw\_id\_fields = (&#8216;manufacturer &#8216;,)
  
 </ol> 
        The second option is probably better since the offending field can still be edited.
        
        ## Enable Object Duplication
        
        To enable the creation of duplicate objects, simple add `save_as = True` to the corresponding `ModelAdmin`. This will change the &#8220;Save and add another&#8221; button into a &#8220;Save as new&#8221; button.
        
        ## Programmatic Interface
        
        It&#8217;s possible to override the `save_model()` method of the `admin.ModelAdmin` to ensure that additional actions are taken when an objects is created or edited via the Admin interface.
        
        [code language=&#8221;python&#8221; gutter=&#8221;false&#8221;]
  
        class ComponentCategoryAdmin(admin.ModelAdmin):
    
        def save_model(self, request, obj, form, change):
      
        obj.save()
        
        if not change:
        
        \# New object
        
        empty = ComponentSubCategory.objects.create(category = obj, name = None)
        
        empty.save()
      
        else:
        
        \# Existing object
        
        pass
  


 [1]: https://docs.djangoproject.com/en/1.8/ref/contrib/admin/
 [2]: https://en.wikipedia.org/wiki/Document_Object_Model
 [3]: https://docs.djangoproject.com/en/1.8/ref/contrib/admin/#django.contrib.admin.ModelAdmin.readonly_fields
 [4]: https://docs.djangoproject.com/en/1.8/ref/contrib/admin/#django.contrib.admin.InlineModelAdmin.raw_id_fields
