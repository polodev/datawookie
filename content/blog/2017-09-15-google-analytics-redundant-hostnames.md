---
author: Andrew B. Collier
date: 2017-09-15T09:00:00Z
tags: ["NGINX"]
title: Removing Redundant Hostnames with NGINX
url: /2017/09/15/google-analytics-redundant-hostnames/
---

<p>While poring over my Google Analytics data I noticed the notification below.</p>

![](/img/2017/09/google-analytics-redundant-hostnames.png)

<p>Obviously this is not a train smash, but it is compromising the quality of my data. And it also offends my OCD. This is what I did to fix the problem.</p>

<!--more-->

The web site in question is built with Django and lives behind NGINX. What I needed to do was either map `racently.com` to `www.racently.com` or the reverse. There are a number of really informative threads on StackOverflow and elsewhere addressing this issue. I found [this one](https://stackoverflow.com/questions/7947030/nginx-no-www-to-www-and-www-to-no-www) particularly enlightening.

I edited my NGINX configuration as follows:

{{< highlight text >}}
server {
	listen 80 default_server;
	listen [::]:80 default_server;
	server_name racently.com www.racently.com;
	return 301 https://www.racently.com$request_uri;
}

server {
	listen 443;
	listen [::]:443;
	server_name racently.com;
	return 301 https://www.racently.com$request_uri;
}

server {
	listen 443 ssl http2 default_server;
	listen [::]:443 ssl http2 default_server;
	server_name _;
	#
	# Rest of configuration goes here.
}
{{< /highlight >}}

This maps `http://racently.com` and `http://www.racently.com` (first `server` block) as well as `https://racently.com` (second `server` block) onto `https://www.racently.com`.

Let's do a quick test to check that it works as planned.

{{< highlight bash >}}
$ curl -I http://racently.com
HTTP/1.1 301 Moved Permanently
Server: nginx
Date: Fri, 15 Sep 2017 14:28:15 GMT
Content-Type: text/html
Content-Length: 178
Connection: keep-alive
Location: https://www.racently.com/
{{< /highlight >}}

{{< highlight bash >}}
$ curl -I http://www.racently.com
HTTP/1.1 301 Moved Permanently
Server: nginx
Date: Fri, 15 Sep 2017 14:28:17 GMT
Content-Type: text/html
Content-Length: 178
Connection: keep-alive
Location: https://www.racently.com/
{{< /highlight >}}

{{< highlight bash >}}
$ curl -I https://racently.com
HTTP/1.1 301 Moved Permanently
Server: nginx
Date: Fri, 15 Sep 2017 14:28:20 GMT
Content-Type: text/html
Content-Length: 178
Connection: keep-alive
Location: https://www.racently.com/
{{< /highlight >}}

In each case we're looking at the `Location` entry, which should be `https://www.racently.com/`. The [301 redirects](https://en.wikipedia.org/wiki/HTTP_301) all work fine. Finally check that `https://www.racently.com` still works.

{{< highlight bash >}}
$ curl -I https://www.racently.com
HTTP/1.1 200 OK
Server: nginx
Date: Fri, 15 Sep 2017 14:28:24 GMT
Content-Type: text/html; charset=utf-8
Connection: keep-alive
Vary: Accept-Encoding
X-Frame-Options: SAMEORIGIN
Vary: Cookie
Set-Cookie: csrftoken=QeEg7drRUxhyeMvxJ7o68UK6j3PIJOw5; expires=Fri, 14-Sep-2018 14:28:24 GMT; Max-Age=31449600; Path=/
Strict-Transport-Security: max-age=63072000; includeSubdomains
X-Frame-Options: DENY
X-Content-Type-Options: nosniff
{{< /highlight >}}

Yes! That all looks good. Minor problem resolved.