---
draft: true
title: Local WordPress on Ubuntu
author: andrew
type: post
date: 2017-02-26T08:22:10+00:00
categories:
  - Web Development
tags:
  - Wordpress

---
<!-- https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-with-lamp-on-ubuntu-16-04 -->


  
<!-- https://www.howtoforge.com/tutorial/how-to-install-wordpress-on-ubuntu-16.04-lamp/ -->

To facilitate easy local installation of themes add this line to `wp-config.php`:
  
[code gutter=&#8221;false&#8221;]
  
define(&#8216;FS_METHOD&#8217;, &#8216;direct&#8217;);
  


Your themes will be installed under /var/lib/wordpress/wp-content/themes/ with ownership www-data.

## Sorting Out Folders

  1. Go to `/var/www/html/wordpress/wp-content/themes` and move the `twentysixteen` folder to `/var/lib/wordpress/wp-content/themes/`. 
      * Move up one level to `/var/www/html/wordpress/wp-content/` and remove the (empty) `themes` folder. 
          * Create a link to `/var/lib/wordpress/wp-content/themes/`. </ol> 
            You&#8217;ll also need to link /var/lib/wordpress/wp-content/uploads/ into /var/www/html/wordpress/wp-content/. It might make more sense to simply link in /var/lib/wordpress/wp-content/.
            
            ## Size Limit on Uploads
            
            If you run into trouble with the limit on file upload sizes (for example, large images) then make the following changes to `/etc/php/7.0/apache2/php.ini`:
  
            [code gutter=&#8221;false&#8221;]
  
            upload\_max\_filesize = 32M
  
            post\_max\_size = 32M
  

            
            <img src="http://162.243.184.248/wp-content/uploads/2016/09/wordpress-file-upload-size.png" alt="wordpress-file-upload-size" width="800" height="246" class="aligncenter size-full wp-image-4352" srcset="http://162.243.184.248/wp-content/uploads/2016/09/wordpress-file-upload-size.png 800w, http://162.243.184.248/wp-content/uploads/2016/09/wordpress-file-upload-size-300x92.png 300w, http://162.243.184.248/wp-content/uploads/2016/09/wordpress-file-upload-size-768x236.png 768w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 984px) 61vw, (max-width: 1362px) 45vw, 600px" />
