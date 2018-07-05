
draft: true
<!--
All that remains is to create a user on the container so that you can login.

## Creating Users on the Container

Make a shell connection to the running container.

{% highlight bash %}
docker exec -t -i 03ca8788b0c8 /bin/bash
{% endhighlight %}

In order to use `mkpasswd` we'll need to install the `whois` package.

{% highlight bash %}
apt-get update && apt-get install -y whois
{% endhighlight %}

On the container create a `jupyter` user.

{% highlight bash %}
useradd jupyter -m -p `mkpasswd jupyter` -s /bin/bash
{% endhighlight %}


login to a Jupyter Notebook using the `jupyter` user and credentials as created above.




{% highlight text %}
{% endhighlight %}

{% highlight text %}
{% endhighlight %}

{% highlight text %}
{% endhighlight %}

{% highlight text %}
{% endhighlight %}

{% highlight text %}
{% endhighlight %}

https://stackoverflow.com/questions/35943625/serving-jupyter-notebook-from-within-docker-container-on-aws-not-working


INSTALL AND RUN DOCKER IMAGE

login as jupyter/jupyter

CONNECT TO DOCKER CONTAINER USING EXEC AND ADD OTHER USERS.



ALSO LOOK INTO SOMETHING LIKE THIS

docker volume create --name jupyterhub-data

USEFUL INFO AT END ON DATA BACKUP

https://github.com/jupyterhub/jupyterhub-deploy-docker
-->