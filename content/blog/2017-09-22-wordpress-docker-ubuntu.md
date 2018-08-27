---
author: Andrew B. Collier
date: 2017-09-22T11:00:00Z
tags: ["Docker", "Wordpress", "Linux", "MySQL"]
title: Quick Wordpress Install with Docker
---

I've just put together a [Wordpress](https://wordpress.com/) site for my older daughter. It's hosted on [DigitalOcean](https://www.digitalocean.com/) and all of the infrastructure is handled with Docker. This post describes the steps in the (easy) install process.

<!--more-->

The first thing that you need to do is [install Docker]({{< relref "2017-09-14-installing-docker-ubuntu.md" >}}). With that in place it's a simple matter to instantiate a couple of images and the whole thing is up an running.

![](/img/logo/docker-logo.png)

## MySQL Docker Container

Wordpress stores content in a MySQL database. Since we want to persist that data beyond the lifespan of a Docker container we should store the data on the host.

First create a folder for the database data.

{{< highlight bash >}}
mkdir ~/mysql-data
{{< /highlight >}}

Next create a (temporary) environment variable to store the MySQL `root` user password. This is not really necessary, but it made my life easier.

{{< highlight bash >}}
export MYSQL_ROOT_PASSWORD="PercoreggIn2"
{{< /highlight >}}

Now launch an instance of the [MySQL Docker image](https://hub.docker.com/_/mysql/). Note that the folder created above is listed as a volume and linked to the folder `/var/lib/mysql` on the container.

{{< highlight bash >}}
docker run --name mysql \
  -v ~/mysql-data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD \
  -d mysql:5.7.22
{{< /highlight >}}

Check that the container is up and running.

{{< highlight bash >}}
$ docker ps
CONTAINER ID IMAGE            COMMAND                CREATED        STATUS        PORTS                NAMES
7937133554d9 mysql:latest     "docker-entrypoint..." 15 minutes ago Up 15 minutes 3306/tcp             mysql
{{< /highlight >}}

We see that it's listening on the (default) port 3306.

## Wordpress Docker Container

Wordpress also stores content (templates, media etc.) in a folder. Again we want to persist this on the host, so we create a folder for the Wordpress content.

{{< highlight bash >}}
mkdir ~/wp-content
{{< /highlight >}}

Then launch the [Wordpress Docker image](https://hub.docker.com/_/wordpress/). The folder created above is listed as a volume and linked to the folder `/var/www/html/wp-content` on the container. This container is also linked to the `mysql` container.

{{< highlight bash >}}
docker run --name wordpress \
  --link mysql:mysql \
  -p 8080:80 \
  -v ~/wp-content:/var/www/html/wp-content \
  -e WORDPRESS_DB_NAME=wordpress \
  -d --rm wordpress:latest
{{< /highlight >}}

Notes:

- It's not necessary to specify the `WORDPRESS_DB_NAME` environment variable, but handy to know what's possible. There are a few other useful environment variables too.

Again we check that the container is up and running.

{{< highlight bash >}}
$ docker ps
CONTAINER ID IMAGE            COMMAND                CREATED        STATUS        PORTS                NAMES
707fcaad12e4 wordpress:latest "docker-entrypoint..." 20 minutes ago Up 20 minutes 0.0.0.0:8080->80/tcp wordpress
7937133554d9 mysql:latest     "docker-entrypoint..." 25 minutes ago Up 25 minutes 3306/tcp             mysql
{{< /highlight >}}

Looks good. At this point we can do a local test on the host. Since the site is not yet visible from the outside world we'll use `lynx` to open it.

{{< highlight bash >}}
lynx http://localhost/
{{< /highlight >}}

If you get something that looks like a (text mode) web page then you are in business.

## An Easier Way

A simpler way to set this all up is to use `docker-compose`. You just need to create a YAML file which defines the services.

<script src="https://gist.github.com/DataWookie/22fbb485d6d9af1582c4a2add42f041f.js"></script>

## Configuring NGINX

![](/img/logo/logo-nginx.png)

Finally we need to expose the site to the outside world. If you are setting this up on an EC2 instance then you just need to make sure that port 8080 allows inbound connections (add a suitable security group) and you're ready to roll.

I don't pretend to be particularly competent with [NGINX](https://nginx.org/en/), but the configuration below worked for me, exposing the site on port 80.

{{< highlight text >}}
upstream wordpress {
        server 127.0.0.1:8080 fail_timeout=0;
}

server {
        listen 80;
        listen [::]:80;

        location / {
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header Host $http_host;
                proxy_redirect off;
                #
                # How long to wait [s] before giving a 504 error.
                #
                proxy_read_timeout 900;
                proxy_pass http://wordpress;
        }
}
{{< /highlight >}}

Restart NGINX and the site will be live.

### Separate Sub-Domain

I was so enthused by the ease of the above process (thank you, Docker!) that I decided to install a blog on another web site. In this case the main site is served on HTTPS. I didn't have the time to sort out SSL for the blog, so instead I put it on a separate sub-domain. All that was required was an extra entry in the NGINX `server` block.

{{< highlight text >}}
        server_name blog.example.com;
{{< /highlight >}}

## Conclusion

I'm once again astonished and thrilled by the ease with which things can be accomplished with Docker. Without it this install would probably have taken a couple of hours. However, I managed to research and implement all of this in less than an hour. And that's a reflection on the tool, not on me!