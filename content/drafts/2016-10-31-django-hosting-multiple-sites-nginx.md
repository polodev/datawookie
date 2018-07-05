---
draft: true
title: 'Django: Hosting Multiple Sites with NGINX'
author: andrew
type: post
date: 2016-10-31T15:00:53+00:00
categories:
  - Web Development
tags:
  - Django
  - NGINX

---
<!-- USE CONTENT FROM THIS!!! -->


  
<!-- USE CONTENT FROM THIS!!! -->


  
<!-- USE CONTENT FROM THIS!!! -->


  
<!-- USE CONTENT FROM THIS!!! -->


  
<!-- USE CONTENT FROM THIS!!! -->


  
<!-- USE CONTENT FROM THIS!!! -->


  
<!-- USE CONTENT FROM THIS!!! -->


  
<!-- USE CONTENT FROM THIS!!! -->


  
<!-- http://michal.karzynski.pl/blog/2013/06/09/django-nginx-gunicorn-virtualenv-supervisor/ -->

<!-- https://www.digitalocean.com/community/questions/how-can-i-have-multiple-django-projects-in-a-droplet -->


  
<!-- http://michal.karzynski.pl/blog/2013/10/29/serving-multiple-django-applications-with-nginx-gunicorn-supervisor/ -->

[<img src="http://www.exegetic.biz/blog/wp-content/uploads/2016/10/nginx-logo.svg" alt="nginx-logo" class="aligncenter size-large wp-image-4529" width="100%" />][1]

I have a droplet on [DigitalOcean][2] which I use to host a few projects in development. Since none of these projects are at a stage where I&#8217;ve registered individual domains, it makes sense to simply serve them via different ports on the same server.

Setting this kind of configuration up on [NGINX][3] turns out to be pretty simple. Edit the virtual host configuration file, which will probably be found in `/etc/nginx/sites-enabled/`.

## Upstream Modules

First construct two (or more!) [upstream modules][4].

{% highlight text %}
upstream app1 {
    server 127.0.0.1:9000 fail_timeout=0;
}
 
upstream app2 {
    server 127.0.0.1:9001 fail_timeout=0;
}
{% endhighlight %}

Above we&#8217;ve listed two upstream services which NGINX will be proxying. The first corresponds to a server which accepts requests on port 9000, while the second is listening on port 9001. In principle each of the upstream sections can include one or more `server` records. If there is more than one then requests will be assigned to servers in a round robin fashion.

To make this a little more concrete, you might have two separate Django projects, `app1` which is running on port 9000 and `app2` on port 9001.
  
{% highlight text %}
~/app1$ nohup python3 manage.py runserver localhost:9000 &
~/app2$ nohup python3 manage.py runserver localhost:9001 &
{% endhighlight %}

Since these projects are in development I&#8217;m still running the Django test server.

## Server Blocks

Now we need to construct [server blocks][5] for each of the upstream modules. These blocks determine how an external request is mapped to an internal service. Suppose, for example, that we wanted to expose `app1` on ports 80 and 8000. The mapping between the external port and the upstream service happens via the `proxy_pass` field.

{% highlight text %}
server {
    listen 80 default_server;
    listen 8000;
 
    client_max_body_size 4G;
    server_name _;
 
    keepalive_timeout 5;
 
    location /media  {
        alias /home/django/media;
    }
 
    location /static {
        alias /home/django/staticfiles; 
    }
 
    location / {
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_redirect off;
        proxy_pass http://app1;
    }
}
{% endhighlight %}

Note that only one server block can be designated as `default_server`.

We&#8217;d then have a second entry which, for example, exposes `app2` on port 81.

{% highlight text %}  
server {
    listen 81;
 
    server_name _;
 
    location / {
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_redirect off;
        proxy_pass http://app2;
    }
}
{% endhighlight %}

A similar configuration could be used to [host separate subdomains][6].

## Firewall Rules

You might find that you have problems connecting to ports other than 80. This might be due to firewall restrictions. You can easily allow access to other ports using `ufw`. For example, to open port 8000:

{% highlight text %}
# ufw allow 8000
Rule added
Rule added (v6)
# iptables -L | grep 8000
ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:8000
ACCEPT     udp  --  anywhere             anywhere             udp dpt:8000
{% endhighlight %}

## Conclusion

After making changes to the configuration file you&#8217;ll need to restart the server.
  
{% highlight bash %}  
# service nginx restart
{% endhighlight %}

If my server was located at 114.132.8.215 then I&#8217;d be able to access the two sites as http://114.132.8.215:80/ (or http://114.132.8.215:8000/) and http://114.132.8.215:81/ respectively.

I don&#8217;t for a moment pretend to be an expert with NGINX. Far from it, in fact. However, the above setup works for me in a testing environment. Once I&#8217;d figured out the plumbing it was pretty simple to implement. For more detailed background on the general principles behind using NGINX read [this][7].

## Various Other Settings

### Maximum Upload Size

NGINX will place a limit on the maximum upload size. By default this limit is 1 Mb. Larger files will generate a `413 Request Entity Too Large` error. You can, however, modify this limit via the configuration file.

{% highlight text %}  
server {
    listen 81;
    client_max_body_size 20M;
    server_name _;
}
{% endhighlight %}

Setting `client_max_body_size` to 0 will remove all constraints on upload size. This is probably not a terribly good idea.

 [1]: http://www.exegetic.biz/blog/wp-content/uploads/2016/10/nginx-logo.svg
 [2]: https://www.digitalocean.com/
 [3]: https://www.nginx.com/
 [4]: http://nginx.org/en/docs/http/ngx_http_upstream_module.html
 [5]: http://nginx.org/en/docs/http/server_names.html
 [6]: https://www.digitalocean.com/community/tutorials/how-to-set-up-nginx-server-blocks-virtual-hosts-on-ubuntu-14-04-lts
 [7]: https://www.digitalocean.com/community/tutorials/understanding-nginx-http-proxying-load-balancing-buffering-and-caching
