---
draft: true
title: '#MonthOfDjango Day MMM: Management'
author: andrew
type: post
date: 2017-02-26T08:21:59+00:00
categories:
  - Uncategorized

---
Management commands can be executed from within code too.

[code language=&#8221;python&#8221; gutter=&#8221;false&#8221;]
  
from django.core import management

management.call_command(&#8216;migrate&#8217;)
  

