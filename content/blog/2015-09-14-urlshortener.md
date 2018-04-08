---
author: Andrew B. Collier
date: 2015-09-14T17:00:34Z
tags: ["R"]
title: 'urlshorteneR: A package for shortening URLs'
---

This is a small package I put together quickly to satisfy an immediate need: generating abbreviated URLs in R. As it happens I require this functionality in a couple of projects, so it made sense to have a package to handle the details. It's not perfect but it does the job. The code is available from [github](https://github.com/DataWookie/urlshorteneR) along with vague usage information.

In essence the functionality is simple: first authenticate to shortening service ([goo.gl](https://goo.gl/) and [bitly](https://bitly.com/) are supported at present) then shorten or expand URLs as required. The [longurl](https://cran.r-project.org/web/packages/longurl/) package will perform the latter function too, possibly with greater efficiency.

So, for example, with goo.gl:

{{< highlight r >}}
shortener_authenticate("86368629146-2ag2qh1j4c26mf5dtm5p7gi85esn3i.apps.googleusercontent.com",
"55Y3NsWjiic5Uv8mT-YNMWlK")
> shorten.google("http://www.google.com")
[1] "http://goo.gl/MYyLu2"
> expand.google("http://goo.gl/MYyLu2")
[1] "http://www.google.com/"
{{< /highlight >}}

And then doing the same thing with bitly:

{{< highlight r >}}
> shortener_authenticate("692987373e98473p3fbed10e7c2ea15d6c56fd82",
"945d4fe36d8596zap73421090260pfp0d7cbc1a9", "bitly")
> shorten.bitly("http://www.google.com")
[1] "http://bit.ly/1Qho4Y5"
> expand.bitly("http://bit.ly/1Qho4Y5")
[1] "http://www.google.com/"
{{< /highlight >}}
