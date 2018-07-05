---
draft: true
title: Django Admin Themes
author: andrew
type: post
date: 2017-02-26T08:22:10+00:00
categories:
  - Uncategorized

---
<img src="http://162.243.184.248/wp-content/uploads/2016/09/django-admin-theme-default.png" alt="django-admin-theme-default" width="800" height="603" class="aligncenter size-large wp-image-4315" srcset="http://162.243.184.248/wp-content/uploads/2016/09/django-admin-theme-default.png 800w, http://162.243.184.248/wp-content/uploads/2016/09/django-admin-theme-default-300x226.png 300w, http://162.243.184.248/wp-content/uploads/2016/09/django-admin-theme-default-768x579.png 768w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 984px) 61vw, (max-width: 1362px) 45vw, 600px" />

Let&#8217;s look at some alternative wrappers for Django&#8217;s Admin interface.

## django-admin-bootstrapped

The [django-admin-bootstrapped][1] theme provides a convenient route to pimping your Admin interface.

<img src="http://162.243.184.248/wp-content/uploads/2016/09/django-admin-theme-bootstrapped.png" alt="django-admin-theme-bootstrapped" width="800" height="603" class="aligncenter size-large wp-image-4314" srcset="http://162.243.184.248/wp-content/uploads/2016/09/django-admin-theme-bootstrapped.png 800w, http://162.243.184.248/wp-content/uploads/2016/09/django-admin-theme-bootstrapped-300x226.png 300w, http://162.243.184.248/wp-content/uploads/2016/09/django-admin-theme-bootstrapped-768x579.png 768w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 984px) 61vw, (max-width: 1362px) 45vw, 600px" />

Installation is simple:

  1. Install the package:
  
    [code language=&#8221;bash&#8221; gutter=&#8221;false&#8221;]
  
    $ pip install django-admin-bootstrapped
  
</p> 
      * Add a new entry to `INSTALLED_APPS`:
  
        [code language=&#8221;python&#8221; gutter=&#8221;false&#8221; highlight=&#8221;2&#8243;]
  
        INSTALLED_APPS = (
      
        &#8216;django\_admin\_bootstrapped&#8217;,
      
        &#8216;django.contrib.admin&#8217;,
      
        &#8216;django.contrib.auth&#8217;,
      
        &#8216;django.contrib.contenttypes&#8217;,
      
        &#8216;django.contrib.sessions&#8217;,
      
        &#8216;django.contrib.messages&#8217;,
      
        &#8216;django.contrib.staticfiles&#8217;,
  
        )
  
 </ol> 
        ## django-suit
        
        [Django Suit][2] is another theme for the Admin interface. It&#8217;s also well documented and the source code is hosted on the project&#8217;s [GitHub page][3].
        
        <img src="http://162.243.184.248/wp-content/uploads/2016/09/django-admin-theme-suit.png" alt="django-admin-theme-suit" width="800" height="603" class="aligncenter size-large wp-image-4313" srcset="http://162.243.184.248/wp-content/uploads/2016/09/django-admin-theme-suit.png 800w, http://162.243.184.248/wp-content/uploads/2016/09/django-admin-theme-suit-300x226.png 300w, http://162.243.184.248/wp-content/uploads/2016/09/django-admin-theme-suit-768x579.png 768w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 984px) 61vw, (max-width: 1362px) 45vw, 600px" />
        
        Installation is simple:
        
          1. Install the package:
  
            [code language=&#8221;bash&#8221; gutter=&#8221;false&#8221;]
  
            $ pip install django-suit
  
</p> 
              * Some minor edits to `settings.py`:
  
                [code language=&#8221;python&#8221; gutter=&#8221;false&#8221; highlight=&#8221;2,11-15&#8243;]
  
                INSTALLED_APPS = (
      
                &#8216;suit&#8217;,
      
                &#8216;django.contrib.admin&#8217;,
      
                &#8216;django.contrib.auth&#8217;,
      
                &#8216;django.contrib.contenttypes&#8217;,
      
                &#8216;django.contrib.sessions&#8217;,
      
                &#8216;django.contrib.messages&#8217;,
      
                &#8216;django.contrib.staticfiles&#8217;,
  
                )</p> 
                from django.conf.global\_settings import TEMPLATE\_CONTEXT_PROCESSORS as TCP
                
                TEMPLATE\_CONTEXT\_PROCESSORS = TCP + (
      
                &#8216;django.core.context_processors.request&#8217;,
  
                )
  
 </ol> 
                
                Check out the [documentation][4] for details of the other features.
                
                ## django-grappelli
                
                The [Grapelli Project][5] provides a very attractive alternative skin. It&#8217;s more than that though: the project comes with a bunch of other handy features too.
                
                <img src="http://162.243.184.248/wp-content/uploads/2016/09/django-admin-theme-grappelli.png" alt="django-admin-theme-grappelli" width="800" height="603" class="aligncenter size-full wp-image-4312" srcset="http://162.243.184.248/wp-content/uploads/2016/09/django-admin-theme-grappelli.png 800w, http://162.243.184.248/wp-content/uploads/2016/09/django-admin-theme-grappelli-300x226.png 300w, http://162.243.184.248/wp-content/uploads/2016/09/django-admin-theme-grappelli-768x579.png 768w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 984px) 61vw, (max-width: 1362px) 45vw, 600px" />
                
                Installation is slightly more complicated than the other options, but certainly not onerous.
                
                There&#8217;s detailed [documentation][6] available and the latest source code can be found on the project&#8217;s [GitHub page][7].

 [1]: https://github.com/django-admin-bootstrapped/django-admin-bootstrapped
 [2]: http://djangosuit.com/
 [3]: https://github.com/darklow/django-suit
 [4]: http://django-suit.readthedocs.io/en/develop/
 [5]: http://grappelliproject.com/
 [6]: https://django-grappelli.readthedocs.io/en/latest/
 [7]: https://github.com/sehmaschine/django-grappelli
