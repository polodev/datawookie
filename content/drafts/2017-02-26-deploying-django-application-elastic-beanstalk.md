---
draft: true
title: 'Django: Deploying Project on Elastic Beanstalk'
author: andrew
type: post
date: 2017-02-26T08:22:10+00:00
categories:
  - Uncategorized
tags:
  - Django

---
<!-- http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/create-deploy-python-django.html -->

<!-- https://realpython.com/blog/python/deploying-a-django-app-and-postgresql-to-aws-elastic-beanstalk/ -->


  
<!-- http://agiliq.com/blog/2014/08/deploying-a-django-app-on-amazon-ec2-instance/ -->

[code language=&#8221;bash&#8221; gutter=&#8221;false&#8221;]
  
$ sudo pip3 install awsebcli
  


[code language=&#8221;bash&#8221; gutter=&#8221;false&#8221;]
  
$ eb &#8211;version
  
EB CLI 3.7.8 (Python 3.5.2)
  


Login to AWS account.

Execute the following from the project folder. This will construct an environment on EB to host the application.

[code language=&#8221;bash&#8221; gutter=&#8221;false&#8221;]
  
$ eb init
  


[code language=&#8221;bash&#8221; gutter=&#8221;false&#8221;]
  


[code language=&#8221;bash&#8221; gutter=&#8221;false&#8221;]
  


[code language=&#8221;bash&#8221; gutter=&#8221;false&#8221;]
  


[code language=&#8221;bash&#8221; gutter=&#8221;false&#8221;]
  


[code language=&#8221;bash&#8221; gutter=&#8221;false&#8221;]
  

