---
draft: true
title: '#MonthOfDjango Day NNN: Backup and Restore'
author: andrew
type: post
date: 2017-02-26T08:21:59+00:00
categories:
  - Uncategorized

---
## Django Database Backup

[Django Database Backup][1]

[code language=&#8221;bash&#8221; gutter=&#8221;false&#8221;]
  
$ pip install django-dbbackup
  


Add `dbbackup` to your list of installed applications.

A backup can be initiated from within code too.

[code language=&#8221;python&#8221; gutter=&#8221;false&#8221;]
  
from django.core import management

management.call_command(&#8216;dbbackup&#8217;)
  


 [1]: http://django-dbbackup.readthedocs.io/en/stable/index.html
