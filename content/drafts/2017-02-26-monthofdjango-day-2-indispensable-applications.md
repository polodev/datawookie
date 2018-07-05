---
draft: true
title: '#MonthOfDjango Day 2: Indispensable Applications'
author: andrew
type: post
date: 2017-02-26T08:21:24+00:00
categories:
  - Django
tags:
  - Django

---
Django can be augmented by an enormous array of plugin applications and packages. You could easily spend a few fruitful hours browsing through the list of published packages on [Django Packages][1]. I couldn&#8217;t hope to do justice to the full selection of packages, but I&#8217;ll pick out a few that I have found useful.

First we&#8217;ll start with package installation.

## Manual Install

There are a couple of routes to installing a Django package. The one I&#8217;ve used routinely is to simply invoke the Python package tool, [pip][2].

For example, to install the Django Debug Toolbar application:
  
[code language=&#8221;bash&#8221; gutter=&#8221;false&#8221;]
  
$ pip install django-debug-toolbar
  

  
That&#8217;ll download and install the required package along with any outstanding dependencies.

## Automated Install

It&#8217;s common practice to construct a small database of packages which are required for a Django application. The database is stored in a file called `requirements.txt` and might look something like this:
  
[code language=&#8221;text&#8221; gutter=&#8221;false&#8221;]
  
Django==1.8.7
  
django-extensions==1.5.9
  
django-admin-bootstrapped==2.5.7
  
django-crispy-forms==1.6.0
  
django-debug-toolbar==1.4
  

  
Each record lists the name of a package and the required version.

You can install all of the required packages with
  
[code language=&#8221;bash&#8221; gutter=&#8221;false&#8221;]
  
$ pip install -r requirements.txt
  

  
To create your own requirements database do
  
[code language=&#8221;bash&#8221; gutter=&#8221;false&#8221;]
  
$ pip freeze >requirements.txt
  

  
That will generate an exhaustive list of all installed packages. You can safely edit out any non-essentials.

## Hooking Up an Application

Although this varies from one package to another, you generally need to add an entry to `INSTALLED_APPS` in `settings.py`.

[code language=&#8221;python&#8221; gutter=&#8221;false&#8221; highlight=&#8221;8,9&#8243;]
  
INSTALLED_APPS = (
      
&#8216;django.contrib.admin&#8217;,
      
&#8216;django.contrib.auth&#8217;,
      
&#8216;django.contrib.contenttypes&#8217;,
      
&#8216;django.contrib.sessions&#8217;,
      
&#8216;django.contrib.messages&#8217;,
      
&#8216;django.contrib.staticfiles&#8217;,
      
&#8216;debug_toolbar&#8217;,
      
&#8216;django_extensions&#8217;,
  
)
  


In order for those changes to take effect you&#8217;ll need to restart the development server.

## Cool Packages and Applications

Django==1.8.7
  
PyMySQL==0.7.6
  
mysqlclient==1.3.9
  
sqlparse==0.1.18
  
fuzzywuzzy==0.14.0
  
python-Levenshtein==0.12.0
  
django-extensions==1.5.9
  
django-admin-bootstrapped==2.5.7
  
django-crispy-forms==1.6.0
  
django-debug-toolbar==1.4
  
django-countries==4.0
  
django-archive==0.1.5
  
python-social-auth==0.2.13
  
django-compressor==2.1
  
django-libsass==0.7
  
django-registration-redux==1.4
  
django-measurement==2.4.0
  
django-dbbackup==3.1.3
  
measurement==1.8.0

### debug_toolbar

### django_extensions

### django-colorfield

If you are wanting to add a colour field to a model then take a look at the [django-colorfield][3] application.

Another option is [django-colorful][4].

### Calendar

### django-formtools

https://django-formtools.readthedocs.io/en/latest/wizard.html

USED THIS TO SPLIT SINGLE FORM ACROSS MULTIPLE PAGES IN BRAND COLLECTIVE SITE.

### django-unfriendly

http://django-unfriendly.readthedocs.io/en/latest/

 [1]: https://djangopackages.org/
 [2]: https://pypi.python.org/pypi/pip
 [3]: https://github.com/jaredly/django-colorfield
 [4]: https://github.com/charettes/django-colorful
