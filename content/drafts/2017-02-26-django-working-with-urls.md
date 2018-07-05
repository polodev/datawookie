---
draft: true
title: 'Django: Working with URLs'
author: andrew
type: post
date: 2017-02-26T08:22:10+00:00
categories:
  - Uncategorized

---
## From a Template

Suppose that you want to generate the URL for the `image` view in the `banner` namespace.

[code language=&#8221;html&#8221; gutter=&#8221;false&#8221;]

{% raw %}  
{% url &#8216;banner:image&#8217; width=50 height=50 %}
{% endraw %}


## From Code

[code language=&#8221;python&#8221; gutter=&#8221;false&#8221;]
  
from django.core.urlresolvers import reverse

reverse(&#8216;banner:image&#8217;, kwargs={&#8216;width&#8217;: 50, &#8216;height&#8217;:50})
  

