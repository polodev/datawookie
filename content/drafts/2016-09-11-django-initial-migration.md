---
draft: true
title: 'Django: Foreign Keys and Initial Migration'
author: andrew
type: post
date: 2016-09-11T07:25:53+00:00
categories:
  - Django
tags:
  - Database
  - Django

---
If you run into a `Cannot add foreign key constraint` error when applying your initial Django migrations then it&#8217;s probably because of the order in which they are being applied. It&#8217;s important that the migrations for `auth` are done before you start creating tables for other applications.

This issue appears to be most common when you are [rebuilding your database from scratch][1].

Give this a try:
  
[code language=&#8221;bash&#8221; gutter=&#8221;false&#8221;]
  
$ python3 manage.py makemigrations
  
$ python3 manage.py migrate auth
  
$ python3 manage.py migrate

 [1]: http://www.exegetic.biz/blog/2016/09/django-recreating-database/
