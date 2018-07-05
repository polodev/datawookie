---
draft: true
title: '#MonthOfDjango Day 2: Project Template'
author: andrew
type: post
date: 2017-01-02T13:38:20+00:00
categories:
  - Django
tags:
  - Django

---
## Django Project Template

I&#8217;ve put together a repository which is my starting point for all new Django projects. You&#8217;ll find the code in the [django-project-template][1] on GitHub. There&#8217;s nothing very groundbreaking there, but it has a few minor tweaks that help me get started more quickly. Further enhancements will be added over time.

## The Normal Route

Of course it&#8217;s easy enough to just start a project using the tools provided by Django. For example, to create a new project called `TestProject` you&#8217;d simply execute:

{% highlight bash %}
$ django-admin startproject TestProject
  
{% endhighlight %}

That&#8217;ll do the following:

  * create a new folder for the project; 
      * create a `manage.py` file which will be used for most maintenance tasks on the project; 
          * create a Python package (with the same name as the project) containing three files: `settings.py`, `urls.py` and `wsgi.py`. </ul> 
            The `settings.py` and `urls.py` files will play a pivotal role in the initial development of the project, while `wsgi.py` becomes important when you are ready to deploy on a live system.
            
            As an alternative you could simply clone my template using

{% highlight bash %}
            $ git clone git@github.com:DataWookie/django-project-template.git
  
{% endhighlight %}
  
            Right now there&#8217;s not an awful lot to be gained by following this route, but I&#8217;ll be fleshing out the template over the next few weeks and by the end of the month it&#8217;ll hopefully be packed with useful things.
            
            ## Kicking It Off
            
            At this point you already have a working Django application. It doesn&#8217;t do anything interesting yet, but it&#8217;s a start.
            
            You start the development server using

{% highlight bash %}
            $ python manage.py runserver
  
{% endhighlight %}

 [1]: https://github.com/DataWookie/django-project-template
