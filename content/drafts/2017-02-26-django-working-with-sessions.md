---
draft: true
title: 'Django: Working with Sessions'
author: andrew
type: post
date: 2017-02-26T08:21:59+00:00
categories:
  - Uncategorized

---
## Get in a Pickle

By default Django will try to serialise session data into JSON. This often works well but there are some objects which just do not translate well into JSON. In this case you can resort to pickling to store these data. Just add the following into your `settings.py`:

[code language=&#8221;python&#8221; gutter=&#8221;false&#8221;]
  
SESSION_SERIALIZER = &#8216;django.contrib.sessions.serializers.PickleSerializer&#8217;
  


## Persisting Changes to Session Data

You might be astonished and annoyed to find that changes you make to session data during one request are not persisted into subsequent requests. Not a problem. Just add the following to your view after making those changes:

[code language=&#8221;python&#8221; gutter=&#8221;false&#8221;]
  
request.session.modified = True
  


Alternatively you can apply this behaviour globally by adding this to your `settings.py`:

[code language=&#8221;python&#8221; gutter=&#8221;false&#8221;]
  
SESSION\_SAVE\_EVERY_REQUEST=True
  

