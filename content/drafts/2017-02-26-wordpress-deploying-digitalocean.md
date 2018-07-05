---
draft: true
title: 'WordPress: Deploying on DigitalOcean'
author: andrew
type: post
date: 2017-02-26T08:22:10+00:00
categories:
  - Uncategorized

---
<!-- https://www.digitalocean.com/community/tutorials/how-to-use-the-wordpress-one-click-install-on-digitalocean -->

From your [Digital Ocean home page][1] press the big green **Create Droplet** button.

## Create a Droplet

  1. Select the **One-click apps** tab and choose the WordPress option.
  
    <img src="http://162.243.184.248/wp-content/uploads/2016/09/digitalocean-choose-application.png" alt="digitalocean-choose-application" width="1024" height="799" class="aligncenter size-full wp-image-4329" /></p> 
      * Select a Droplet size which will satisfy your data volume and processing requirements. 
          * Add a SSH key which will allow you to easily connect to your Droplet without having to provide a password every time. 
              * Choose a descriptive hostname and press the big green **Create** button. </ol> 
                ## Configure WordPress
                
                If you point your browser at your new Droplet you&#8217;ll be greeted by a placeholder site.
                
                <img src="http://162.243.184.248/wp-content/uploads/2016/09/wordpress-placeholder.png" alt="wordpress-placeholder" width="800" height="399" class="aligncenter size-full wp-image-4398" srcset="http://162.243.184.248/wp-content/uploads/2016/09/wordpress-placeholder.png 800w, http://162.243.184.248/wp-content/uploads/2016/09/wordpress-placeholder-300x150.png 300w, http://162.243.184.248/wp-content/uploads/2016/09/wordpress-placeholder-768x383.png 768w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 984px) 61vw, (max-width: 1362px) 45vw, 600px" />
                
                To initialise WordPress you&#8217;ll need to connect to the Droplet via SSH as the `root` user. Visit the site again and you should be greeted by a language selection screen. (You&#8217;ll need to refresh your cache if you still see the placeholder site.) Fill in the configuration details, create a user and you&#8217;re ready to blog!

 [1]: https://cloud.digitalocean.com/droplets
