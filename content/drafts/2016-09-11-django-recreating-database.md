---
draft: true
title: 'Django: Recreating the Database'
author: andrew
type: post
date: 2016-09-11T07:56:58+00:00
categories:
  - Django
tags:
  - Database
  - Django

---
In the early stages of a project I have found that I break the database fairly often. Rather than figuring out just how to fix and rebuild, it makes more sense to just start again from scratch. There are a couple of ways to do this.

## Using django-extensions

There&#8217;s a `reset_db` command in [django-extensions][1] that will do the job in one simple step.

[code language=&#8221;bash&#8221; gutter=&#8221;false&#8221;]
  
$ python3 manage.py reset_db

## Direct Approach

If the above does not solve your problems then you&#8217;ll need to man up and interact with the database directly.

  1. Use `DROP DATABASE` to delete the entire database. If you do have any important data stashed in there then, for God&#8217;s sake, back it up first! 
      * Use `CREATE DATABASE` to recreate the database. 
          * Delete all numbered migration files. 
              * Do the `makemigrations` and `migrate` dance. </ol> 
                You should be sorted.

 [1]: http://django-extensions.readthedocs.io/en/latest/index.html
