---
author: Andrew B. Collier
categories:
- Web Scraping
date: 2016-09-19T15:00:38Z
guid: http://www.exegetic.biz/blog/?p=4272
id: 4272
tags:
- Chrome
- Developer Tools
- POST
- Web Scraping
title: View POST Data using Chrome Developer Tools
url: /2016/09/19/viewing-post-data/
---

When figuring out how to formulate the contents of a POST request it's often useful to see the "typical" fields submitted directly from a web form.

1. Open [Developer Tools](https://developer.chrome.com/devtools) in Chrome. Select the `Network` tab (at the top). 
2. Submit the form. Watch the magic happening in the Developer Tools console. <img src="/img/2016/09/Developer-Tools-Network-1.png">
3. Click on the first document listed in the Developer Tools console, then select the `Headers` tab. <img src="/img/2016/09/Developer-Tools-Network-2.png">

That's just scratching the surface of the wealth of information available on the `Network` tab. Read [this](https://developers.google.com/web/tools/chrome-devtools/profile/network-performance/resource-loading) to find out more.
