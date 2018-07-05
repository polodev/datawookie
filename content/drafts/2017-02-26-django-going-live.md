---
draft: true
title: 'Django: Going Live'
author: andrew
type: post
date: 2017-02-26T08:21:59+00:00
categories:
  - Uncategorized

---
## Turning off DEBUG = True

You&#8217;ll need to set `DEBUG = False` in your `settings.py`.

To test whether everything still works with this configuration you can still run the test server, however you&#8217;ll need to use the `--insecure` flag to enable serving of static files.
