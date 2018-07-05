---
draft: true
title: 'Django: Getting a SSL Certificate'
author: andrew
type: post
date: 2017-02-26T08:21:24+00:00
categories:
  - Uncategorized

---

https://www.digitalocean.com/community/tutorials/how-to-set-up-let-s-encrypt-with-nginx-server-blocks-on-ubuntu-16-04

https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-debian-8

https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-in-ubuntu-16-04

https://www.digitalocean.com/community/tutorials/an-introduction-to-let-s-encrypt

READ THIS: https://www.bjornjohansen.no/redirect-to-https-with-nginx

http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/SSL-on-an-instance.html

location /static {
          
alias /home/django/racently/django/staticfiles;
      
}

location /.well-known {
          
alias /home/django/racently/django/staticfiles/.well-known;
      
}

NOW RESTART NGINX

letsencrypt certonly -a webroot &#8211;webroot-path=/home/django/racently/django/staticfiles -d racently.com -d www.racently.com

https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-16-04
  
http://stackoverflow.com/questions/35960929/letsencrypt-django-webroot





Make sure that both versions of site name mentioned in settings.py: ALLOWED_HOSTS = ['127.0.0.1', 'www.racently.com', 'racently.com']
