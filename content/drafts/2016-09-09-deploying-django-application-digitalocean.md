---
draft: true
title: 'Django: Preparing a DigitalOcean Droplet for Django'
author: andrew
type: post
date: 2016-09-09T07:57:24+00:00
categories:
  - Cloud
  - Django
tags:
  - Digital Ocean
  - Django
  - Droplet

---
https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-16-04

FIX THIS

Do a [speed test][1] to determine which server is going to be best for your region. 

<img src="http://162.243.184.248/wp-content/uploads/2016/09/digitalocean-speed-test.png" alt="" width="899" height="622" class="aligncenter size-full wp-image-4759" srcset="http://162.243.184.248/wp-content/uploads/2016/09/digitalocean-speed-test.png 899w, http://162.243.184.248/wp-content/uploads/2016/09/digitalocean-speed-test-300x208.png 300w, http://162.243.184.248/wp-content/uploads/2016/09/digitalocean-speed-test-768x531.png 768w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 1362px) 62vw, 840px" />

FIX THIS

The process of deploying a Django application on a DigitalOcean instance is well documented [here][2]. There are also some useful details in the [Django documentation][3].

<!-- https://www.codementor.io/python/tutorial/how-to-deploy-a-django-application-on-digitalocean -->

https://www.digitalocean.com/community/tutorials/how-to-use-the-django-one-click-install-image

http://honza.ca/2011/05/deploying-django-with-nginx-and-gunicorn

FIX THIS<h2Create a Droplet</h2> 

From your [Digital Ocean home page][4] press the big green **Create Droplet** button.

## Choose an Image

Select an Operating System image. You have a couple of options:

  1. install a specific UNIX distribution; or
  
    <img src="http://162.243.184.248/wp-content/uploads/2016/09/digitalocean-choose-distribution.png" alt="" width="1024" height="245" class="aligncenter size-large wp-image-4668" srcset="http://162.243.184.248/wp-content/uploads/2016/09/digitalocean-choose-distribution.png 1024w, http://162.243.184.248/wp-content/uploads/2016/09/digitalocean-choose-distribution-300x72.png 300w, http://162.243.184.248/wp-content/uploads/2016/09/digitalocean-choose-distribution-768x184.png 768w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 1362px) 62vw, 840px" /></p> 
      * select the **One-click apps** tab and choose from a selection of application images.
  
        
<img src="http://162.243.184.248/wp-content/uploads/2016/09/digitalocean-choose-application.png" alt="" width="1024" height="750" class="aligncenter size-full wp-image-4667" srcset="http://162.243.184.248/wp-content/uploads/2016/09/digitalocean-choose-application.png 1024w, http://162.243.184.248/wp-content/uploads/2016/09/digitalocean-choose-application-300x220.png 300w, http://162.243.184.248/wp-content/uploads/2016/09/digitalocean-choose-application-768x563.png 768w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 1362px) 62vw, 840px" /> </ol> 
        We&#8217;ll take the second approach and select the **Django on 14.04** option.
        
        ## Choose a Size
        
        Select a Droplet size which will satisfy your data volume and processing requirements.
        
        <img src="http://162.243.184.248/wp-content/uploads/2016/09/digitalocean-choose-size.png" alt="digitalocean-choose-size" width="1024" height="495" class="aligncenter size-full wp-image-4332" srcset="http://162.243.184.248/wp-content/uploads/2016/09/digitalocean-choose-size.png 1024w, http://162.243.184.248/wp-content/uploads/2016/09/digitalocean-choose-size-300x145.png 300w, http://162.243.184.248/wp-content/uploads/2016/09/digitalocean-choose-size-768x371.png 768w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 1362px) 62vw, 840px" />
        
        ## Choose a Datacenter Region
        
        Select a datacenter which is as close as possible to the majority of your users.
        
        ## Add Your SSH Keys
        
        Add a SSH key which will allow you to easily connect to your Droplet without having to provide a password every time.
        
        ## Finalize and Create
        
        Choose a descriptive hostname and press the big green **Create** button.
        
        ## Connecting as Root
        
        Back on your home page you will now see the new Droplet listed. Grab the associated IP address and connect as the `root` user.
        
        [code language=&#8221;bash&#8221; gutter=&#8221;false&#8221; highlight=&#8221;26-29&#8243;]
  
        $ ssh -l root 104.131.6.204
  
        Welcome to Ubuntu 14.04.4 LTS (GNU/Linux 3.13.0-79-generic x86_64)
        
        * Documentation: https://help.ubuntu.com/
        
        System information as of Thu Sep 22 05:50:46 EDT 2016
        
        System load: 0.06 Processes: 87
    
        Usage of /: 6.0% of 29.40GB Users logged in: 0
    
        Memory usage: 11% IP address for eth0: 104.131.6.204
    
        Swap usage: 0%
        
        Graph this data and manage this system at:
      
        https://landscape.canonical.com/
        
        0 packages can be updated.
  
        0 updates are security updates.
        
        New release &#8216;16.04.1 LTS&#8217; available.
  
        Run &#8216;do-release-upgrade&#8217; to upgrade to it.
        
        &#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;-
  
        Thank you for using DigitalOcean&#8217;s Django Application.
  
        We have created a default Django application that can be seen from http://104.131.6.204/
        
        You can use the following SFTP credentials to upload your files (using FileZilla/WinSCP/Rsync):
  
        Host: 104.131.6.204
  
        User: django
  
        Pass: AuQiskstTp
        
        You can use the following Postgres database credentials:
  
        DB: django
  
        User: django
  
        Pass: z5C7mmzpvQ
        
        Nginx listens on public IP (104.131.6.204) port 80 and forwards requests to Gunicorn on port 9000
  
        Nginx access log is in /var/log/nginx/access.log and error log is in /var/log/nginx/error.log
  
        Gunicorn is started using an Upstart script located at /etc/init/gunicorn.conf
  
        To restart your Django project, run : sudo service gunicorn restart
        
        You can find more information on using this image at: http://do.co/djangoapp
  
        &#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;-
  
        To delete this message of the day: rm -rf /etc/motd.tail
  
        Last login: Thu Sep 22 05:50:49 2016 from 196.8.122.192
  

        
        It&#8217;s a pretty voluminous [MOTD][5], but packed with useful information. I&#8217;ve highlighted the details of logging in as the `django` user.
        
        Next update and install some packages.
        
        [code language=&#8221;bash&#8221; gutter=&#8221;false&#8221;]
  
        \# apt-get update
  
        \# apt-get install mysql-server mysql-client libmysqlclient-dev
  
        \# apt-get install python3-pip git
  

        
        You&#8217;ll probably also want to get MySQL installed and configured.
        
        That&#8217;s everything that requires root access, so you can safely terminate your SSH connection.
        
        ## Update gunicorn
        
          1. Kill the existing `gunicorn` process. You&#8217;ll need to be `root` again to do this.
  
            [code language=&#8221;bash&#8221; gutter=&#8221;false&#8221;]
  
            \# service gunicorn stop
  
</p> 
              * Remove the `gunicorn` package.
  
                [code language=&#8221;bash&#8221; gutter=&#8221;false&#8221;]
  
                \# apt-get remove gunicorn
  
</p> 
                  * Install Python3 version of `gunicorn` and `tornado`.
  
                    [code language=&#8221;bash&#8221; gutter=&#8221;false&#8221;]
  
                    \# pip3 install gunicorn tornado
  
</p> 
                      * Since `gevent` doesn&#8217;t work with Python3 at present, replace with `tornado` in `/etc/gunicorn.d/gunicorn.py`, keeping a copy of the original.
  
                        [code language=&#8221;bash&#8221; gutter=&#8221;false&#8221;]
  
                        \# sed &#8216;s/worker\_class = &#8216;\&#8221;gevent&#8217;\&#8221;/worker\_class=&#8217;\&#8221;tornado&#8217;\&#8221;/&#8217; /etc/gunicorn.d/gunicorn.py -i.orig
  
 </ol> 
                        ## Install Your Project
                        
                        We&#8217;ll be installing a Django project from GitHub. The same procedure will apply for other repositories.
                        
                          1. Login as the `django` user.
  
                            [code language=&#8221;bash&#8221; gutter=&#8221;false&#8221;]
  
                            $ ssh django@104.131.6.204
  
</p> 
                              * Clone your project&#8217;s repository. 
                                  * Use `pip3` to install any requirements. </ol> 
                                    ## Quick and Dirty
                                    
                                    Okay, this is the quick and dirty way to get your project up and running. It&#8217;s by no means a suitable method for a production deployment. Caveat emptor!
                                    
                                      1. Sort out the database.
  
                                        [code language=&#8221;bash&#8221; gutter=&#8221;false&#8221;]
  
                                        $ python3 manage.py migrate
  
</p> 
                                          * Assemble static files.
  
                                            [code language=&#8221;bash&#8221; gutter=&#8221;false&#8221;]
  
                                            $ python3 manage.py collectstatic
  
</p> 
                                              * Load any fixtures. 
                                                  * Start the Django server.
  
                                                    [code language=&#8221;bash&#8221; gutter=&#8221;false&#8221;]
  
                                                    $ python3 manage.py runserver localhost:9000
  
 </ol> 
                                                    $ gunicorn -w4 -b0.0.0.0:9000 datatool.wsgi
                                                    
                                                    More information on gunicorn can be found in its [extensive documentation][6].
                                                    
                                                    NGINX CONFIG
                                                    
                                                    Remove the configuration files for other sites (like the default django site).
                                                    
                                                    IN ORDER TO GET REQUIREMENTS SORTED OUT HAD TO DO THIS: apt-get remove python3-six

 [1]: http://speedtest-ams2.digitalocean.com/
 [2]: https://www.digitalocean.com/community/tutorials/how-to-use-the-django-one-click-install-image
 [3]: https://docs.djangoproject.com/en/1.8/howto/deployment/
 [4]: https://cloud.digitalocean.com/droplets
 [5]: https://en.wikipedia.org/wiki/Motd_(Unix)
 [6]: http://gunicorn-docs.readthedocs.io/en/latest/index.html
