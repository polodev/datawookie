---
draft: true
title: 'MongoDB: Installing on Ubuntu'
author: andrew
type: post
date: 2017-02-26T08:21:59+00:00
categories:
  - Uncategorized

---
These instructions pertain to Ubuntu 16.04.

[code language=&#8221;bash&#8221; gutter=&#8221;false&#8221;]
  
$ sudo apt install mongodb mongodb-server mongodb-clients
  


The system should have been started during the installation process. You can easily check that the service is running:

[code language=&#8221;bash&#8221; gutter=&#8221;false&#8221;]
  
$ service mongodb status
  

