---
title: '#MonthOfDjango Day KKK: Using virtualenvwrapper with Python 3'
author: andrew
type: post
date: 2016-09-12T15:00:57+00:00
categories:
  - Python
tags:
  - Python
  - virtualenv
  - virtualenvwrapper

---
<!-- SURVEY FOR CONTENT!!! -->


  
<!-- SURVEY FOR CONTENT!!! -->


  
<!-- SURVEY FOR CONTENT!!! -->


  
<!-- SURVEY FOR CONTENT!!! -->


  
<!-- SURVEY FOR CONTENT!!! -->


  
<!-- SURVEY FOR CONTENT!!! -->


  
<!-- http://michal.karzynski.pl/blog/2013/06/09/django-nginx-gunicorn-virtualenv-supervisor/ -->

By default the version of `virtualenvwrapper` on my machine uses Python 2. Not terribly useful since I'm focusing on using Python 3. A few small tweaks were required.

## Install

First install `virtualenvwrapper`.

{% highlight bash %}  
$ sudo pip3 install virtualenvwrapper
{% endhighlight %}

This will install as the root user. If you don't have root privileges, just omit the `sudo`.

## Configure

Add the following content to your `.bashrc`:
  
{% highlight bash %}
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
export WORKON_HOME=$HOME/.virtualenv
source /usr/local/bin/virtualenvwrapper.sh
{% endhighlight %}

These commands will do the following:

  1. tell `virtualenvwrapper` to use the Python 3 interpreter by default; 
      * select a folder in which virtual environments will be stored; and 
          * load a bunch of shell functions. </ol> 
            If you didn't install `virtualenvwrapper` as the root user then you'd source `$HOME/.local/bin/virtualenvwrapper.sh` instead.
            
            These changes will only take effect when you open a new shell.
            
            **Note:** I ran into a situation where, even with the configuration above, my virtual environments were still being created with Python 2. In this case you can make an alias.

{% highlight bash %}  
alias mkvirtualenv="mkvirtualenv -p /usr/bin/python3"
{% endhighlight %}
            
            ## Use
            
            ### Creating a Virtual Environment
            
            To create a new virtual environment, do the following:
  
{% highlight bash %}  
$ mkvirtualenv test
{% endhighlight %}
            
            You'll find the interpreter in the resulting environment will automatically be Python 3, as required.
  
{% highlight bash %} 
(test) $ python
Python 3.5.2 (default, Nov 17 2016, 17:05:23)
[GCC 5.4.0 20160609] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>>
{% endhighlight %}  
 
            Any packages installed while this environment is active will be encapsulated within the environment.
            
            ### Attaching and Detaching the Virtual Environment
            
            To enter that environment in the future, do
  
            [code language=&#8221;bash&#8221; gutter=&#8221;false&#8221;]
  
            $ workon test
  

  
            To exit the environment, simply do
  
            [code language=&#8221;bash&#8221; gutter=&#8221;false&#8221;]
  
            (test) $ deactivate
  

            
            If you no longer require the environment then remove it with
  
            [code language=&#8221;bash&#8221; gutter=&#8221;false&#8221;]
  
            $ rmvirtualenv test
  

            
            ## Conclusion
            
            I'd been working away fine without running into any package conflicts. Fine until&#8230; wham! Everything broke. Now I'm a believer: virtual environments are the future.
            
            A full reference to `virtualenvwrapper` functionality can be found [here][1]. Well worth a read if you are interested in using all of the (many) bells and whistles.

 [1]: https://virtualenvwrapper.readthedocs.io/en/latest/
